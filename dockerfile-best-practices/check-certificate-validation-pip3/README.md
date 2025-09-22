In pip3, the --trusted-host flag allows you to mark a specific host as trusted, even if it's not included in the list of trusted hosts specified in the configuration files. This is typically used when you're installing packages from custom repositories or when accessing repositories over insecure connections.

Thi policy checks whether you've disabled the certificate validation when using the *pip3* or *pip* command, using the `--trusted-host` option. If you have provided the `--trusted-host` option in the *pip3* or *pip* command, the Policy will give you failing checks else Passing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno` installed on the machine
- Make sure you have [nctl `v4.3.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl transform -r test/bad-test/Dockerfile -o test/bad-test/bad-payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno apply check-certificate-validation-pip3.yaml --json test/bad-test/bad-payload.json
    ```
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply check-certificate-validation-pip3.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:

    ```
    mastersans@mastersans check-certificate-validation-pip3 % kyverno apply check-certificate-validation-pip3.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply check-certificate-validation-pip3.yaml --json test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans check-certificate-validation-pip3 % kyverno apply check-certificate-validation-pip3.yaml --json test/bad-test/bad-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy check-certificate-validation-pip3 -> resource JSON payload failed:
    1 -  Ensure certificate validation is enabled by not using `--trusted-host` option with pip3


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0 
    ```
