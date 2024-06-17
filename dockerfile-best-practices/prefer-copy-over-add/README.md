# Prefer COPY over ADD Instructions in Dockerfile

This policy ensures that container images are built using commands that result in known outcomes. Specifically, it advocates for the preference of using the `COPY` instruction over `ADD` in Dockerfiles. By adhering to this policy, you enhance the predictability and transparency of the image-building process.

## Policy Details:

- **Policy Name:** prefer-copy-over-add
- **Check Description:** This policy checks whether Dockerfiles use the ADD instructions for copying files into the container image.
- **Policy Category:** Dockerfile Best Practices

## How It Works:

### Validation Criteria:

**Key** : ADD

- **Condition:** If `ADD` exists
  - **Result:** FAIL
  - **Reason:**  Using `ADD` can introduce unnecessary complexity and ambiguity, potentially leading to unintended consequences. The policy recommends preferring COPY for explicit file copying.

- **Condition:**  If `ADD` doesn't exist
  - **Result:** PASS
  - **Reason:** This indicates compliance with the policy, as the absence of ADD aligns with the best practice of using COPY for file operations.

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
    kyverno-json scan --payload payload.json --policy prefer-copy-over-add.yaml
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy prefer-copy-over-add.yaml --payload test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - prefer-copy-over-add / prefer-copy-over-add /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy prefer-copy-over-add.yaml --payload test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - prefer-copy-over-add / prefer-copy-over-add /  FAILED: Avoid the use of ADD instructions in Dockerfiles: any[0].check.(Stages[].Commands[?Name=='ADD'].Link[] | length(@) > `0`): Invalid value: true: Expected value: false
    Done
    ```

---

By following this policy, you can ensure that your Dockerfile adopts a more straightforward and transparent approach to file copying, promoting better image building practices.