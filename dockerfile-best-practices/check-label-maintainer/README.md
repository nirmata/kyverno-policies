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

**In order to test this Policy, you can use the following commands:**

 Run the `kyverno-json scan` command for the `good-payload.json` file that is present in the `test/good-test` directory.
   ```
   kyverno-json scan --payload test/good-test/good-payload.json --policy check-label-maintainer.yaml
   ```
   Since the Dockerfile contain the LABEL instruction followed by MAINTAINER, it'll give you passing checks. In order to test this policy for failing scenario, run the same command for `bad-payload.json` present in `test/bad-test` directory.