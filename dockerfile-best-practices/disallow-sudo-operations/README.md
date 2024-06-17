Using sudo within a Dockerfile is generally not preferred due to several reasons, primarily to avoid potential security risks associated with privilege escalations.
Using sudo within a Dockerfile grants additional privileges to the execution context. If an attacker gains control over the container and manages to execute commands with sudo, they might escalate their privileges to root within the container, potentially compromising the entire system. Docker images should ideally be built in a consistent and reproducible manner. Introducing sudo commands can lead to inconsistencies in the build process, especially if the Dockerfile is executed in different environments where sudo behaves differently or is not available.

This Policy checks whether you've used the sudo operation within the Dockerfile or not. If you've used the sudo operation within your Dockerfile, the policy will give you failing checks whereas if you've not used any sudo operation in your Dockerfile, you'll get Passing checks.

**In order to test this policy, use the following commands:**

Run the `kyverno-json scan` command for the `good-payload.json` file that is present in the `test/good-test` directory.
   ```
   kyverno-json scan --payload test/good-test/good-payload.json --policy disallow-sudo-operations.yaml
   ```
   Since the Dockerfile don't contain the `sudo` operation, it'll give you passing checks. In order to test this policy for failing scenario, run the same command for `bad-payload.json` present in `test/bad-test` directory.