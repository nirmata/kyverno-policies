When you use the *--no-check-certificate* option with wget, you're instructing wget to ignore SSL certificate verification while making HTTPS connections. This option allows wget to download files from HTTPS URLs without validating the SSL certificate presented by the server.

Here's what happens when you use *--no-check-certificate* with wget:

SSL Certificate Verification Bypassed: Normally, wget checks the SSL certificate presented by the server against a list of trusted certificate authorities to ensure the server's identity. If the certificate verification fails, wget returns an error. However, when you use *--no-check-certificate*, wget ignores any SSL certificate verification errors.

Potential Security Risk: By bypassing SSL certificate verification, you're opening yourself up to potential security risks. This includes the risk of connecting to a server that is not who it claims to be, potentially exposing sensitive information or becoming vulnerable to man-in-the-middle attacks.

Thi policy checks whether you've disabled the certificate validation when using the *wget* command, using the `--no-check-certificate` option. If you have provided the `--no-check-certificate` option in the *wget*, the Policy will give you failing checks else Passing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno-json` installed on the machine
- Make sure you have [nctl `v3.4.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl scan dockerfile -r test/good-test/Dockerfile --show-json > payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno-json scan --payload payload.json --policy check-certificate-validation-wget.yaml
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy check-certificate-validation-wget.yaml --payload test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-certificate-validation-wget / check-certificate-validation-wget /  PASSED
    Done
    ```

     b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy check-certificate-validation-wget.yaml --payload test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
   - check-certificate-validation-wget / check-certificate-validation-wget /  FAILED: Ensure certificate validation is enabled by not using `--no-check-certificate` option: any[0].check.~.(Stages[].Commands[?Name=='RUN'].CmdLine[][])[1].(contains(@, 'wget') && (contains(@, '--no-check-certificate'))): Invalid value: true: Expected value: false
    Done
    ```
    