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
- Make sure you have `kyverno` installed on the machine
- Make sure you have [nctl `v4.3.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl transform -r test/bad-test/Dockerfile -o test/bad-test/bad-payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno apply prefer-copy-over-add.yaml --json test/bad-test/bad-payload.json
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply prefer-copy-over-add.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans prefer-copy-over-add % kyverno apply prefer-copy-over-add.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply prefer-copy-over-add.yaml --json test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    mastersans@mastersans prefer-copy-over-add % kyverno apply prefer-copy-over-add.yaml --json test/bad-test/bad-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy prefer-copy-over-add -> resource JSON payload failed:
    1 -  Avoid the use of ADD instructions in Dockerfiles


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0 
    ```

---

By following this policy, you can ensure that your Dockerfile adopts a more straightforward and transparent approach to file copying, promoting better image building practices.