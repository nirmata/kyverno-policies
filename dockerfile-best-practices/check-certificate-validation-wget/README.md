When you use the *--no-check-certificate* option with wget, you're instructing wget to ignore SSL certificate verification while making HTTPS connections. This option allows wget to download files from HTTPS URLs without validating the SSL certificate presented by the server.

Here's what happens when you use *--no-check-certificate* with wget:

SSL Certificate Verification Bypassed: Normally, wget checks the SSL certificate presented by the server against a list of trusted certificate authorities to ensure the server's identity. If the certificate verification fails, wget returns an error. However, when you use *--no-check-certificate*, wget ignores any SSL certificate verification errors.

Potential Security Risk: By bypassing SSL certificate verification, you're opening yourself up to potential security risks. This includes the risk of connecting to a server that is not who it claims to be, potentially exposing sensitive information or becoming vulnerable to man-in-the-middle attacks.

Thi policy checks whether you've disabled the certificate validation when using the *wget* command, using the `--no-check-certificate` option. If you have provided the `--no-check-certificate` option in the *wget*, the Policy will give you failing checks else Passing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno` installed on the machine
- Make sure you have [nctl `v4.3.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl transform -r test/bad-test/Dockerfile -o test/bad-test/bad-payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno apply check-certificate-validation-wget.yaml --json test/bad-test/bad-payload.json
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply check-certificate-validation-wget.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans check-certificate-validation-wget % kyverno apply check-certificate-validation-wget.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply check-certificate-validation-wget.yaml --json test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans check-certificate-validation-wget % kyverno apply check-certificate-validation-wget.yaml --json test/bad-test/bad-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy check-certificate-validation-wget -> resource JSON payload failed:
    1 -  Ensure certificate validation is enabled by not using `--no-check-certificate` option


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0
    ```
    