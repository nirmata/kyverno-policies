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

- Make sure you have `kyverno` installed on the machine
- Make sure you have [nctl `v4.3.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl transform -r test/bad-test/Dockerfile -o test/bad-test/bad-payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno apply check-apt-command-force-yes.yaml --json payload.json
    ```
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply check-apt-command-force-yes.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:

    ```
    mastersans@mastersans check-apt-command-force-yes % kyverno apply check-apt-command-force-yes.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply check-at-command-force-yes.yaml --json test/bad-test/bad-payload.json 
    ```

    This produces the output:
    ```
    mastersans@mastersans check-apt-command-force-yes % kyverno apply check-apt-command-force-yes.yaml --json test/bad-test/bad-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy check-apt-command-force-yes -> resource JSON payload failed:
    1 -  Refrain from using the '--force-yes' option with `apt-get` as it bypasses important package validation checks and can potentially compromise the stability and security of your system.


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0
    ```