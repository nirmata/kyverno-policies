# Validating Base Image Tag in Dockerfile

Ensuring the use of version tags and digests instead of the latest image tag in a Dockerfile is crucial for maintaining control, reproducibility, and stability in containerized environments. This policy aims to validate whether the base image tag is appropriately defined to promote reliable container deployment practices.

## Policy Details:

- **Policy Name:** validate-base-image-tag
- **Check Description:** This policy checks whether the base image tag is defined with a specific version or digest in the Dockerfile.
- **Policy Category:** Dockerfile Best Practices for Stability and Reproducibility

## How It Works:

### Validation Criteria:

**Key**: Image

- **Condition:** If the base image tag is set to `latest` or doesn't have `:`
  - **Result:** FAIL

- **Condition:** If the base image tag is set to a specific version or digest with a `:` or `scratch` or `base`
  - **Result:** PASS

### Policy Validation Testing Instructions

To evaluate and test the policy ensuring Dockerfile compliance:

Follow these steps:

1. **Extract JSON equivalent of the Dockerfile:**
    ```bash
    nctl scan dockerfile -r test/good-test/Dockerfile --show-json | jq > payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno-json scan --payload payload.json --policy validate-base-image-tag.yaml
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno-json scan --policy validate-base-image-tag.yaml --payload test/good-test/good-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-base-image-tag / validate-base-image-tag /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```bash
    kyverno-json scan --policy validate-base-image-tag.yaml --payload test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - validate-base-image-tag / validate-base-image-tag /  FAILED: Base Image is missing version tags/digests: any[0].check.~.(Stages[].From.Image)[0].(contains(@, ':')): Invalid value: false: Expected value: true
    Done
    ```

---

By adhering to this policy, you promote stability and reproducibility in your Dockerized applications, mitigating the risk of unexpected changes and ensuring consistent behavior across deployments.