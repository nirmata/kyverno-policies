This policy checks if the signature options are missing when using the *rpm* command in the Dockerfile. 

`–nodigest`, `–nosignature`, `–noverify`, `–nofiledigest` options: These are flags you can use with the rpm command to alter its behavior during installation. Each flag has a specific effect:

- *–nodigest*: Skips verifying the package digest (like MD5 or SHA1), which serves as a checksum to ensure file integrity.
  
- *–nosignature*: Ignores package signatures completely, rendering any signature verification useless.
  
- *–noverify*: Disables all verification checks, including digests, signatures, and file attributes.
  
- *–nofiledigest*: Specifically skips verification of individual file digests within the package.

If you're using either of the above flags with the *rpm* command, the policy will give you failing checks else passing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno` installed on the machine
- Make sure you have [nctl `v4.3.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl transform -r test/bad-test/Dockerfile -o test/bad-test/bad-payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno apply check-missing-signature-options.yaml --json test/bad-test/bad-payload.json
    ```
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply check-missing-signature-options.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:

    ```
    mastersans@mastersans check-missing-signature-options % kyverno apply check-missing-signature-options.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0 
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply check-missing-signature-options.yaml --json test/bad-test/01-digest/bad-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans check-missing-signature-options % kyverno apply check-missing-signature-options.yaml --json test/bad-test/01-digest/bad-payload.json 

    Applying 1 policy rule(s) to 1 resource(s)...
    policy check-missing-signature-options -> resource JSON payload failed:
    1 -  Ensure that packages with untrusted or missing signatures are not used by rpm via `--nodigest` flag


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0 
    ```
    