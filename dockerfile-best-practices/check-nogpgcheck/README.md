GPG signature checking is a crucial security measure in package managers like dnf, tdnf, and yum. Here's how it works:

**Without GPG signature checking:**

- Each package comes with a digital signature attached, similar to a unique fingerprint.
  
- This signature is created by the trusted source (e.g., a distribution repository) using their private key.
  
- When you install a package, the package manager doesn't check for the presence or validity of the signature. This means malicious actors could:
    - Replace a legitimate package with a modified one (malware, backdoor).
    - Create fake packages that appear legitimate but could harm your system.
    - Modify package contents after they've been downloaded.
    - With GPG signature checking:

- The package manager checks for the GPG signature associated with the package. It then uses the public key of the trusted source to verify the signature. If the signature is valid, it means the package hasn't been tampered with and comes from the trusted source. If the signature is invalid, the package manager refuses to install the package, alerting you to a potential security risk.

**nogpgcheck flag:**

- This flag tells the package manager to ignore GPG signature checks.
  
- Disabling this check is strongly discouraged as it exposes your system to the vulnerabilities mentioned earlier.
  
- Only disable it under exceptional circumstances and with full understanding of the risks involved.

This policy checks whether you've disabled the GPG check when using the command `yum`,`dnf`, `tdnf` using the `--nogpgcheck` flag. If you've disabled, the Policy will give you failing checks else Passing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno-json` installed on the machine
- Make sure you have [nctl `v3.4.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl scan dockerfile -r test/good-test/Dockerfile --show-json > payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno-json scan --payload payload.json --policy check-nogpgcheck.yaml
    ```
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy dockerfile/check-nogpgcheck/check-nogpgcheck.yaml --payload dockerfile/check-nogpgcheck/test/good-test/01-yum/good-payload.json 
    ```

    This produces the output:

    ```
   Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
   - check-nogpgcheck / check-nogpgcheck /  PASSED
    Done
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy dockerfile/check-nogpgcheck/check-nogpgcheck.yaml --payload dockerfile/check-nogpgcheck/test/bad-test/01-yum/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
   - check-nogpgcheck / check-nogpgcheck /  FAILED: Enable GPG signature checking with yum by not using `--nogpgcheck` flag: all[0].check.~.(Stages[].Commands[?Name=='RUN'].CmdLine[][])[0].((starts_with(@, 'yum ') || contains(@, ' yum '))  && contains(@, ' --nogpgcheck')): Invalid value: true: Expected value: false
    Done
    ```