The `NPM_CONFIG_STRICT_SSL` environment variable in npm is used to control the strictness of SSL certificate validation during npm operations, such as installing packages or accessing remote resources over HTTPS. When set to true, it enforces strict SSL certificate validation, meaning npm will only communicate with servers whose SSL certificates are valid and trusted according to the system's certificate authority (CA) store.

Let's say you're building a Docker image for a Node.js application that relies on npm to install dependencies from npmjs.com. By default, npm performs SSL certificate validation to ensure the security and integrity of the connections. However, in some cases, such as development environments behind firewalls or proxies with self-signed certificates, SSL certificate validation might fail, causing npm operations to abort.

To address this, you can use the NPM_CONFIG_STRICT_SSL environment variable to customize npm's SSL certificate validation behavior. Setting it to false would disable strict SSL certificate validation, allowing npm to communicate with servers even if their SSL certificates are invalid or self-signed. However, this introduces security risks, as it opens the door to potential man-in-the-middle attacks or data tampering.

Conversely, setting NPM_CONFIG_STRICT_SSL to true (or leaving it unset, as it defaults to true) enforces strict SSL certificate validation. npm will only communicate with servers whose SSL certificates are valid and trusted, according to the system's CA store. This ensures the security and integrity of npm operations, protecting against potential security vulnerabilities or attacks.

This policy checks whether the `NPM_CONFIG_STRICT_SSL` envrionment variable is set to *true*. If it is, the policy will give you passing checks (default to true) else if the value is set to *false*, the policy will give you failing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno-json` installed on the machine
- Make sure you have [nctl `v3.4.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl scan dockerfile -r test/good-test/Dockerfile --show-json > payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno-json scan --payload payload.json --policy check-npm-config-strict-ssl.yaml
    ```
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy check-npm-config-strict-ssl.yaml --payload test/good-test/good-payload.json
    ```

    This produces the output:

    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
   - check-npm-config-strict-ssl / check-npm-config-strict-ssl /  PASSED
    Done
    ```
    b. **Test Policy against Invalid Payload:**
    ```bash
    kyverno-json scan --policy check-npm-config-strict-ssl.yaml --payload test/bad-test/bad-payload.json
    ```
    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
   - check-npm-config-strict-ssl / check-npm-config-strict-ssl /  FAILED: Ensure certificate validation is enabled by setting `NODE_TLS_REJECT_UNAUTHORIZED` env with value set to `true`: any[0].check.(Stages[].Commands[].Env[?Key=='NPM_CONFIG_STRICT_SSL' && Value=='true'][] | length(@) > `0`): Invalid value: false: Expected value: true
    Done
    ```
