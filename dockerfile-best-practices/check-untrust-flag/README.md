Generally, the Dockerfile should not allow to use the `--allow-untrusted` flag.

Using the `--allow-untrusted` flag in a Dockerfile is generally not recommended. Allowing untrusted packages can introduce security risks, as it means that the authenticity and integrity of the packages cannot be guaranteed.

This policy checks if the Dockerfile contains the `--allow-untrusted` flag and gives Failing check if it contains the `--allow-untrusted` flag.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno` installed on the machine
- Make sure you have [nctl `v4.3.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl transform -r test/bad-test/Dockerfile -o test/bad-test/bad-payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno apply check-allow-untrusted-flag.yaml --json test/bad-test/bad-payload.json
    ```
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply check-allow-untrusted-flag.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:

    ```
    mastersans@mastersans check-untrust-flag % kyverno apply check-allow-untrusted-flag.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply check-allow-untrusted-flag.yaml --json test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans check-untrust-flag % kyverno apply check-allow-untrusted-flag.yaml --json test/bad-test/bad-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy detect-untrusted-flag -> resource JSON payload failed:
    1 -  Dockerfile contains the '--allow-untrusted' which is not preferred


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0 
    ```
