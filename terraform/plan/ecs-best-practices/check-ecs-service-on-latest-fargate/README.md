# Check ECS Service on Latest FARGATE
AWS Fargate platform versions are used to refer to a specific runtime environment for Fargate task infrastructure. 
It is a combination of the kernel and container runtime versions. You select a platform version when you run a task or when you create a service to maintain a number of identical tasks. New revisions of platform versions are released as the runtime environment evolves, for example, if there are kernel or operating system updates, new features, bug fixes, or security updates. A Fargate platform version is updated by making a new platform version revision. Each task runs on one platform version revision during its lifecycle. 
If you want to use the latest platform version revision, then you must start a new task. A new task that runs on Fargate always runs on the latest revision of a platform version, this ensures that tasks are always started on secure and patched infrastructure.
This policy ensures the AWS ECS services are running on the latest Fargate platform version

### Policy Validation Testing Instructions

For testing this policy you will need to:
- Make sure you have `kyverno-json` installed on the machine 
- Properly authenticate with AWS

1. **Initialize Terraform:**
    ```bash
    terraform init
    ```

2. **Create Binary Terraform Plan:**
    ```bash
    terraform plan -out tfplan.binary
    ```

3. **Convert Binary to JSON Payload:**
    ```bash
    terraform show -json tfplan.binary | jq > payload.json
    ```

4. **Test the Policy with Kyverno:**
    ```
    kyverno-json scan --payload payload.json --policy policy.yaml
    ```
    
    a. **Test Policy Against Valid Payload:**
    ```
    kyverno-json scan --policy check-ecs-service-on-latest-fargate.yaml --payload test/good-test/good-payload-01.json --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-ecs-service-on-latest-fargate / check-ecs-service-on-latest-fargate /  PASSED
    Done
    ```

    b. **Test Against Invalid Payload:**
    ```
    kyverno-json scan --policy check-ecs-service-on-latest-fargate.yaml --payload test/bad-test/bad-payload-01.json --bindings test/binding.yaml
    ```

    This produces the output:
    ```
    Loading policies ...
    Loading bindings ...
    - analyzer -> map[resource:map[type:terraform-plan]]
    Loading payload ...
    Pre processing ...
    Running ( evaluating 1 resource against 1 policy ) ...
    - check-ecs-service-on-latest-fargate / check-ecs-service-on-latest-fargate /  FAILED
    -> ECS services must run on the latest Fargate platform version
    -> all[0].check.~.(planned_values.root_module.resources[?type=='aws_ecs_service'])[0].values.(platform_version == null || platform_version == 'LATEST'): Invalid value: false: Expected value: true
    Done
    ```

---
