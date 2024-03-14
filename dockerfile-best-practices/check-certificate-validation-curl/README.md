When you use the `--insecure` option with the curl command, you're essentially telling curl to bypass SSL certificate verification. SSL certificate verification is a security feature that ensures the authenticity of the server you are connecting to by verifying its SSL certificate against a trusted certificate authority.

**Here's what happens when you use `--insecure`:**

Normally, curl checks the SSL certificate presented by the server against a list of trusted certificate authorities to ensure the server's identity. If the certificate verification fails, curl returns an error. However, when you use --insecure, curl ignores any SSL certificate verification errors. 

By bypassing SSL certificate verification, you're opening yourself up to potential security risks. This includes the risk of connecting to a server that is not who it claims to be, potentially exposing sensitive information or becoming vulnerable to man-in-the-middle attacks.

Thi policy checks whether you've disabled the certificate validation when using the *curl* command, using the `--insecure` option. If you have provided the `--insecure` option in the *curl*, the Policy will give you failing checks else Passing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno-json` installed on the machine
- Make sure you have [nctl `v3.4.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl scan dockerfile -r test/good-test/Dockerfile --show-json > payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno-json scan --payload payload.json --policy check-certificate-validation-curl.yaml
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy check-certificate-validation-curl.yaml --payload test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
   -        check-certificate-validation-curl / check-certificate-validation-curl /  PASSED
   Done
    ```

     b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy check-certificate-validation-curl.yaml --payload test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-certificate-validation-curl / check-certificate-validation-curl /  FAILED: Ensure certificate validation is enabled by not using `--insecure` option: any[0].check.~.(Stages[].Commands[?Name=='RUN'].CmdLine[][])[1].(contains(@, 'curl') && (contains(@
    ```
    