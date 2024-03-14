Generally, the Dockerfile should not allow to use the `--allow-untrusted` flag.

Using the `--allow-untrusted` flag in a Dockerfile is generally not recommended. Allowing untrusted packages can introduce security risks, as it means that the authenticity and integrity of the packages cannot be guaranteed.

This policy checks if the Dockerfile contains the `--allow-untrusted` flag and gives Failing check if it contains the `--allow-untrusted` flag.

**In order to test this policy:**

Run the kyverno-json scan command for the `good-payload.json` file that is present in the `test/good-test` directory.
```
    kyverno-json scan --payload test/good-test/good-payload.json --policy 
    check-untrust-flag.yaml
```
Since the Dockerfile doesn't contain the `--allow-untrusted` flag, it'll give you passing checks. In order to test this policy for failing scenario, run the same command for `bad-payload.json` present in `test/bad-test` directory.
