
In Node.js, when making HTTPS requests, the TLS (Transport Layer Security) library is responsible for handling secure connections. The `NODE_TLS_REJECT_UNAUTHORIZED` environment variable is used to control the behavior of certificate verification within the TLS library.

When this environment variable is set to 0, it instructs Node.js to disable certificate verification. In other words, Node.js will accept any certificate, regardless of whether it is valid or trusted. This can be useful in development or testing environments where you may have self-signed certificates or when connecting to servers with invalid or expired certificates.

However, it's crucial to understand that setting `NODE_TLS_REJECT_UNAUTHORIZED` to `0` effectively disables one of the fundamental security features of HTTPS, leaving your application vulnerable to man-in-the-middle attacks and other security risks. Therefore, it's strongly recommended to only use this option when absolutely necessary and to avoid using it in production environments.

By default, if `NODE_TLS_REJECT_UNAUTHORIZED` is not explicitly set or is set to any value other than 0, Node.js will perform certificate verification. This means it will check whether the server's certificate is valid and trusted according to the certificate authorities installed on the system. If the certificate is invalid or untrusted, Node.js will reject the connection.

This policy checks whether the `NODE_TLS_REJECT_UNAUTHORIZED` env variable is set to value 1. If it is set to value 1 (certification validation enabled), the policy will return you passing checks else failing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno-json` installed on the machine
- Make sure you have [nctl `v3.4.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl scan dockerfile -r test/good-test/Dockerfile --show-json > payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno-json scan --payload payload.json --policy check-certificate-validation-nodejs-env-var.yaml
    ```
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy check-certificate-validation-nodejs-env-var.yaml --payload test/good-test/good-payload.json
    ```

    This produces the output:

    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
   - check-certificate-validation-nodejs-env-var / check-certificate-validation-nodejs-env-var /  PASSED
    Done 
    ```
    b. **Test Policy against Invalid Payload:**
    ```bash
    kyverno-json scan --policy check-certificate-validation-nodejs-env-var.yaml --payload test/bad-test/bad-payload.json
    ```
    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
   - check-certificate-validation-nodejs-env-var / check-certificate-validation-nodejs-env-var /  FAILED: Ensure certificate validation is enabled by using `NODE_TLS_REJECT_UNAUTHORIZED` env with value set to `1`: any[0].check.(Stages[].Commands[].Env[?Key=='NODE_TLS_REJECT_UNAUTHORIZED' && Value=='1'][] | length(@) > `0`): Invalid value: false: Expected value: true
    Done
    ```