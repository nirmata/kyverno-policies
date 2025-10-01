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
- Make sure you have `kyverno` installed on the machine
- Make sure you have [nctl `v4.3.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl transform -r test/bad-test/Dockerfile -o test/bad-test/bad-payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno apply detect-multiple-instructions.yaml --json test/bad-test/bad-payload.json
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply detect-multiple-instructions.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    mastersansp@mastersans detect-multiple-instructions % kyverno apply detect-multiple-instructions.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0 
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply detect-multiple-instructions.yaml --json test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans detect-multiple-instructions % kyverno apply detect-multiple-instructions.yaml --json test/bad-test/bad-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy detect-multiple-instructions -> resource JSON payload failed:
    1 -  Found multiple instructions in a single line


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0 
    ```

---

This way you can ensure that your dockerfile adhere to policy.