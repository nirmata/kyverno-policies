In pip3, the --trusted-host flag allows you to mark a specific host as trusted, even if it's not included in the list of trusted hosts specified in the configuration files. This is typically used when you're installing packages from custom repositories or when accessing repositories over insecure connections.

Thi policy checks whether you've disabled the certificate validation when using the *pip3* or *pip* command, using the `--trusted-host` option. If you have provided the `--trusted-host` option in the *pip3* or *pip* command, the Policy will give you failing checks else Passing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno-json` installed on the machine
- Make sure you have [nctl `v3.4.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl scan dockerfile -r test/good-test/Dockerfile --show-json > payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno-json scan --payload payload.json --policy check-certificate-validation-pip3.yaml
    ```
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy check-certificate-validation-pip3.yaml --payload test/good-test/good-payload.json
    ```

    This produces the output:

    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
   - check-certificate-validation-pip3 / check-certificate-validation-pip3 /  PASSED
    Done
    ```
    
    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy check-certificate-validation-pip3.yaml --payload test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-certificate-validation-pip3 / check-certificate-validation-pip3 /  FAILED: Ensure certificate validation is enabled by not using `--trusted-host` option: any[0].check.~.(Stages[].Commands[?Name=='RUN'].CmdLine[][])[0].((contains(@, 'pip3') || contains(@, 'pip')) && (contains(@, '--trusted-host'))): Invalid value: true: Expected value: false
    Done
    ```
