Imagine you're setting up a Docker image for a web server using Ubuntu as the base image. You want to install the Apache web server and PHP to run your website. Here's a simplified Dockerfile without the `--force-yes` option:

```
FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    php
```

In this Dockerfile, we're updating the package index with apt-get update. We're then installing Apache (apache2) and PHP (php) using `apt-get install -y`, which automatically answers "yes" to any prompts.

Now, let's say you encounter a situation where you want to install a package that requires additional confirmation or conflicts with existing packages. For instance, you decide to install a package called 'example-package' that requires manual confirmation:

```
FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    php \
    example-package
```
Upon running the `docker build`, you might encounter a prompt asking for confirmation to install 'example-package'. This is where the `--force-yes` option comes into play. It allows you to bypass such prompts and force the installation without user confirmation.

However, using `--force-yes` can lead to unforeseen consequences. For instance, 'example-package' might conflict with another package already installed on the system. Without proper validation, `--force-yes` could potentially downgrade or overwrite critical packages, resulting in system instability or unexpected behavior.

This policy checks whether you're using the `--force-yes` option with the `apt-get` command. If you're using the option with `apt-get`, the policy will give you failing checks else passing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno-json` installed on the machine
- Make sure you have [nctl `v3.4.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl scan dockerfile -r test/good-test/Dockerfile --show-json > payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno-json scan --payload payload.json --policy check-apt-command-force-yes.yaml
    ```
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy check-apt-command-force-yes.yaml --payload test/good-test/good-payload.json
    ```

    This produces the output:

    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
   - check-apt-command-force-yes / check-apt-command-force-yes /  PASSED
    Done
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy check-at-command-force-yes.yaml --payload test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
   - check-apt-command-force-yes / check-apt-command-force-yes /  FAILED: refrain from using the '--force-yes' option with `apt-get` as it bypasses important package validation checks and can potentially compromise the stability and security of your system.: all[0].check.~.(Stages[].Commands[?Name=='RUN'].CmdLine[][])[0].((starts_with(@, 'apt-get ') || contains(@, ' apt-get '))  && contains(@, ' --force-yes')): Invalid value: true: Expected value: false
    Done
    ```