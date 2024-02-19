# Detect if there are any multiple instructions in a single line

This policy is implemented to ensure that container images are built with minimal cached layers. It specifically focuses on detecting and preventing the use of multiple instructions in a single line within Dockerfiles. An example of such a scenario is using '&&' to combine two commands.

## Policy Details:

- **Policy Name:** detect-multiple-instructions
- **Check Description:** This policy ensures that Dockerfile Container Image Should Be Built with Minimal Cached Layers
- **Policy Category:** Dockerfile Best Practices

## How It Works:

### Validation Criteria:

**Key** : CmdLine[0]
**Valid Values** : executables of the command
**Type** : string

- **Condition:** `CmdLine[0]` contains ` && `
  - **Result:** FAIL
  - **Reason:** Multiple instructions in a single line detected.


- **Condition:** `CmdLine[0]` doesn't contains ` && `
  - **Result:** PASS
  - **Reason:** Single instruction per line, complying with best practices.

### Policy Validation Testing Instructions

To evaluate and test the policy ensuring dockerfile meets poliy requirements:

For testing this policy you will need to:
- Make sure you have `kyverno-json` installed on the machine
- Make sure you have [nctl `v3.4.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl scan dockerfile -r test/good-test/Dockerfile --show-json > payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno-json scan --payload payload.json --policy detect-multiple-instructions.yaml
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy detect-multiple-instructions.yaml --payload test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - detect-multiple-instructions / detect-multiple-instructions /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy detect-multiple-instructions.yaml --payload test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - detect-multiple-instructions / detect-multiple-instructions /  FAILED: Found multiple instructions in a single line: any[0].check.~.(Stages[].Commands[].CmdLine[0].contains(@, ' && '))[0]: Invalid value: true: Expected value: false
    Done
    ```

---

This way you can ensure that your dockerfile adhere to policy.