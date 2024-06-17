# Check Last User

The last USER instruction in the Dockerfile is what determines the default user for the container when it starts. This policy validates that the last USER is not root. Running containers as non-root users significantly limits the potential damage that attackers can inflict if they manage to compromise a container.

## Policy Details:

- **Policy Name:** check-last-user
- **Check Description:** This policy checks whether the last USER is not root in the Dockerfile.
- **Policy Category:** Dockerfile Best Practices for Security

## How It Works:

### Validation Criteria:

**Key**: USER

- **Condition:** If last `USER` instruction is set to root
  - **Result:** FAIL

- **Condition:** If last `USER` instruction is not root
  - **Result:** PASS

### Policy Validation Testing Instructions

To evaluate and test the policy ensuring Dockerfile compliance:

Follow these steps:

1. **Extract JSON equivalent of the Dockerfile:**
    ```bash
    nctl scan dockerfile -r test/good-test/Dockerfile --show-json > payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno-json scan --payload payload.json --policy check-last-user.yaml
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy check-last-user.yaml --payload test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-last-user / check-last-user /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy check-last-user.yaml --payload test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-last-user / check-last-user /  FAILED: Last USER should not be root: any[0].check.(Stages[].Commands[?Name=='USER'][]).(@)->array.(subtract(length($array), `1`))->want.~index.($array)[0].(to_number($index) != $want || !(starts_with(User, '0:') || ends_with(User, ':0') || User == 'root' || User == '0' ) ): Invalid value: false: Expected value: true
    Done
    ```

---

Adhering to this policy strengthens overall Docker container security.
