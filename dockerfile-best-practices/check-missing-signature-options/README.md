This policy checks if the signature options are missing when using the *rpm* command in the Dockerfile. 

`–nodigest`, `–nosignature`, `–noverify`, `–nofiledigest` options: These are flags you can use with the rpm command to alter its behavior during installation. Each flag has a specific effect:

- *–nodigest*: Skips verifying the package digest (like MD5 or SHA1), which serves as a checksum to ensure file integrity.
  
- *–nosignature*: Ignores package signatures completely, rendering any signature verification useless.
  
- *–noverify*: Disables all verification checks, including digests, signatures, and file attributes.
  
- *–nofiledigest*: Specifically skips verification of individual file digests within the package.

If you're using either of the above flags with the *rpm* command, the policy will give you failing checks else passing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno-json` installed on the machine
- Make sure you have [nctl `v3.4.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl scan dockerfile -r test/good-test/Dockerfile --show-json > payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno-json scan --payload payload.json --policy check-missing-signature-options.yaml
    ```
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy dockerfile/check-nogpgcheck/check-missing-signature-options.yaml --payload dockerfile/check-missing-signature-options/test/good-test/good-payload.json 
    ```

    This produces the output:

    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
   - check-missing-signature-options / check-missing-signature-options /  PASSED
    Done
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy dockerfile/check-nogpgcheck/check-nogpgcheck.yaml --payload dockerfile/check-nogpgcheck/test/bad-test/01-digest/bad-payload.json 
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
   - check-missing-signature-options / check-missing-signature-options /  FAILED: Ensure that packages with untrusted or missing signatures are not used by rpm via `--nodigest` flag: all[3].check.~.(Stages[].Commands[?Name=='RUN'].CmdLine[][])[1].((starts_with(@, 'rpm ') || contains(@, ' rpm '))  && contains(@, ' --nodigest')): Invalid value: true: Expected value: false
    Done
    ```
    