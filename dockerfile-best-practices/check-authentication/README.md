Generally, the Dockerfile should not allow to use the `--allow-unauthenticated` flag.

Using the `--allow-unauthenticated` flag in a Dockerfile is generally not recommended because it disables the validation of package signatures. This flag is specific to certain package managers (like APT for Debian-based systems) and allows the installation of packages without checking their cryptographic signatures.

This policy checks if the Dockerfile contains the `--allow-unauthenticated` flag and gives Failing check if it contains the `--allow-unauthenticated` flag.

**In order to test this policy:**

 Run the `kyverno-json scan` command for the `good-payload.json` file that is present in the `test/good-test` directory.
   ```
   kyverno-json scan --payload test/good-test/good-payload.json --policy check-unauthentication-install.yaml
   ```
   Since the Dockerfile don't contain the `--allow-unauthenticated` flag, it'll give you passing checks. In order to test this policy for failing scenario, run the same command for `bad-payload.json` present in `test/bad-test` directory.