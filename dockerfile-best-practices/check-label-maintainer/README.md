The MAINTAINER instruction was historically used in Dockerfiles to specify the name and contact details of the person or team responsible for maintaining the Docker image. It was typically placed at the beginning of the Dockerfile. For example:

```
MAINTAINER John Doe <john.doe@example.com>
```

However, starting from Docker 19.03, the MAINTAINER instruction has been deprecated. Although it still functions, its use is discouraged in favor of the more flexible and powerful LABEL instruction.

The LABEL instruction allows you to add metadata to an image, including details about the maintainer, version, description, and more. The LABEL instruction can be used to define multiple key-value pairs, making it versatile for annotating images with various metadata. For example:

```
LABEL maintainer="John Doe <john.doe@example.com>"
```

This line achieves the same purpose as the MAINTAINER instruction, but it leverages the more general-purpose LABEL instruction. This change aligns with Docker's efforts to standardize and enhance the Dockerfile syntax.

Using LABEL for the maintainer information also makes it consistent with other metadata annotations that you might want to add to your Docker image, such as version numbers, descriptions, and licensing information. It provides a more structured and extensible approach to defining metadata for Docker images.

This policy checks if the LABEL instruction has been used followed up by maintainer/author/owner. If you've not used the LABEL instruction, this policy will give you failing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno` installed on the machine
- Make sure you have [nctl `v4.3.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl transform -r test/bad-test-01/Dockerfile -o test/bad-test-01/bad-payload-01.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno apply check-label-maintainer.yaml --json test/bad-test-01/bad-payload-01.json
    ```
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply check-label-maintainer.yaml --json test/bad-test-01/bad-payload-01.json
    ```

    This produces the output:

    ```
    mastersans@mastersans check-label-maintainer % kyverno apply check-label-maintainer.yaml --json test/bad-test-01/bad-payload-01.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy check-label-maintainer -> resource JSON payload failed:
    1 -  MAINTAINER instruction is deprecated, use LABELS instruction to mention maintainer name


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0 
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply check-label-maintainer.yaml --json test/bad-test-02/bad-payload-02.json
    ```

    This produces the output:
    ```
    mastersans@mastersans check-label-maintainer % kyverno apply check-label-maintainer.yaml --json test/bad-test-02/bad-payload-02.json

    Applying 1 policy rule(s) to 1 resource(s)...
    policy check-label-maintainer -> resource JSON payload failed:
    1 -  Use the LABELS instruction to set the MAINTAINER name


    pass: 0, fail: 1, warn: 0, error: 0, skip: 0 
    ```