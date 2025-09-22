Using sudo within a Dockerfile is generally not preferred due to several reasons, primarily to avoid potential security risks associated with privilege escalations.
Using sudo within a Dockerfile grants additional privileges to the execution context. If an attacker gains control over the container and manages to execute commands with sudo, they might escalate their privileges to root within the container, potentially compromising the entire system. Docker images should ideally be built in a consistent and reproducible manner. Introducing sudo commands can lead to inconsistencies in the build process, especially if the Dockerfile is executed in different environments where sudo behaves differently or is not available.

This Policy checks whether you've used the sudo operation within the Dockerfile or not. If you've used the sudo operation within your Dockerfile, the policy will give you failing checks whereas if you've not used any sudo operation in your Dockerfile, you'll get Passing checks.

**In order to test this policy, use the following commands:**

- Make sure you have `kyverno` installed on the machine
- Make sure you have [nctl `v4.3.0`](https://downloads.nirmata.io/nctl/downloads/) or above.


1. **Extract JSON equivalent of the dockerfile:**
    ```bash
    nctl transform -r test/bad-test/Dockerfile -o test/bad-test/bad-payload.json
    ```

2. **Test the Policy with Kyverno:**
    ```bash
    kyverno apply disallow-sudo-operations.yaml --json test/bad-test/bad-payload.json
    ```
    a. **Test Policy Against Valid Payload:**
    ```bash
    kyverno apply disallow-sudo-operations.yaml --json test/good-test/good-payload.json
    ```

    This produces the output:

    ```
    mastersans@mastersans disallow-sudo-operations % kyverno apply disallow-sudo-operations.yaml --json test/good-test/good-payload.json

    Applying 1 policy rule(s) to 1 resource(s)...

    pass: 1, fail: 0, warn: 0, error: 0, skip: 0 
    ```

    b. **Test Policy Against Invalid Payload:**
    ```bash
    kyverno apply disallow-sudo-operations.yaml --json test/bad-test/bad-payload.json
    ```

    This produces the output:
    ```
   mastersans@mastersans disallow-sudo-operations % kyverno apply disallow-sudo-operations.yaml --json test/bad-test/bad-payload.json

   Applying 1 policy rule(s) to 1 resource(s)...
   policy disallow-sudo-operations -> resource JSON payload failed:
   1 -  Dockerfile contains the 'sudo' operation which is not preferred


   pass: 0, fail: 1, warn: 0, error: 0, skip: 0 
    ```