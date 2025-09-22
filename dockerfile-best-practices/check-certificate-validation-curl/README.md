When you use the `--insecure` option with the curl command, you're essentially telling curl to bypass SSL certificate verification. SSL certificate verification is a security feature that ensures the authenticity of the server you are connecting to by verifying its SSL certificate against a trusted certificate authority.

**Here's what happens when you use `--insecure`:**

Normally, curl checks the SSL certificate presented by the server against a list of trusted certificate authorities to ensure the server's identity. If the certificate verification fails, curl returns an error. However, when you use --insecure, curl ignores any SSL certificate verification errors. 

By bypassing SSL certificate verification, you're opening yourself up to potential security risks. This includes the risk of connecting to a server that is not who it claims to be, potentially exposing sensitive information or becoming vulnerable to man-in-the-middle attacks.

Thi policy checks whether you've disabled the certificate validation when using the *curl* command, using the `--insecure` option. If you have provided the `--insecure` option in the *curl*, the Policy will give you failing checks else Passing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno` installed on the machine
- Make sure you have [nctl `v4.3.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl transform -r test/bad-test/Dockerfile -o test/bad-test/bad-payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno apply check-certificate-validation-curl.yaml --json test/bad-test/bad-payload.json
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply check-certificate-validation-curl.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:

    ```
    mastersans@mastersans check-certificate-validation-curl % kyverno apply check-certificate-validation-curl.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0 
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply check-certificate-validation-curl.yaml --json test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans check-certificate-validation-curl % kyverno apply check-certificate-validation-curl.yaml --json test/bad-test/bad-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy check-certificate-validation-curl -> resource JSON payload failed:
    1 -  Ensure certificate validation is enabled by not using `--insecure` option


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0 
    ```
    