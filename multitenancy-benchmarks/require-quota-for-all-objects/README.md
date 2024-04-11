# Cluster Policy - Require Quota for All Objects

## Policy Overview
This Kubernetes ClusterPolicy, named `require-quota-for-all-objects` ensures that a ResourceQuota is defined for all 9 objects within a namespace. It operates by validating the presence of ResourceQuota for various Kubernetes resources, including pods, services, replication controllers, secrets, config maps, persistent volume claims, and more.

**Importance**

The importance of this policy lies in its contribution to effective resource management and ensuring fair resource allocation within a Kubernetes cluster. By enforcing ResourceQuota for all objects, it prevents potential resource abuses, such as overconsumption of compute resources or storage, which could lead to performance degradation or cluster instability. Additionally, it aids in enforcing multitenancy best practices by ensuring that each namespace adheres to resource usage limits, promoting a more secure and predictable environment for all users.

**Key Annotations:**
- **Title:** Require ResourceQuota for all 9 Objects present in the Namespace
- **Category:** Multitenancy Benchmark
- **Severity:** Medium
- **Subject:** ResourceQuota
- **Kyverno Version:** 1.8.0
- **Kubernetes Version:** 1.24

**Policy Configuration:**
- **Validation Failure Action:** Audit (Enforce rejection on failure)
- **Rules:**
  - **Name:** require-quota-for-all-objects
  - **Match Conditions:** Applies to ResourceQuota creation operations
  - **Validation Message:** "ResourceQuota must define quotas for all objects in the namespace"
  - **Validation Pattern:**
    - Ensures that quotas are defined for various Kubernetes resources within the namespace, including pods, services, replication controllers, secrets, config maps, persistent volume claims, and more.

**Usage**

To apply this policy, deploy it as a Kubernetes ClusterPolicy, specifying the desired validation rules and failure actions. Once applied, the policy will automatically enforce the presence of ResourceQuota for all objects within the designated namespaces, thereby enhancing resource governance and cluster stability.

## Finding Violations

To identify violations of the "require-quota-for-all-objects" policy, follow these steps:

1. **Check Policy Status:**
   - Use the following command to view the READY status of Kyverno policies in your cluster:
     ```bash
     kubectl get cpol
     ```
   - Look for the status of the "require-quota-for-all-objects" policy. If READY status shows `True` or the MESSAGE shows `Ready` your policy is up and running!

2. **Check Policy Report:**
   - Use the following command to view the violations if any:
     ```bash
     kubectl get cpolr
     ```
   - Look for the status of the "require-quota-for-all-objects" policy. If it shows any violations, note the namespace(s) where the violations occurred.

3. **Inspect ResourceQuotas:**
   - Use the following command to list ResourceQuotas in the namespaces where violations were detected:
     ```bash
     kubectl get resourcequota -n <namespace>
     ```
   - Review the ResourceQuotas to identify any missing quotas for objects such as Pods, Services, Secrets, ConfigMaps, etc., listed in the policy.

## How to Fix It

To fix violations of the "require-quota-for-all-objects" policy, follow these steps:

1. **Create or Update ResourceQuotas:**
   - Use the Kubernetes manifest format to create or update ResourceQuotas in the affected namespaces. Ensure that the ResourceQuotas cover all the objects specified in the policy description.

2. **Sample ResourceQuota Manifest:**
   ```yaml
   apiVersion: v1
   kind: ResourceQuota
   metadata:
     name: example-resourcequota
   spec:
     hard:
       pods: "1"
       services: "1"
       replicationcontrollers: "1"
       secrets: "1"
       configmaps: "1"
       persistentvolumeclaims: "1"
       # Add quotas for other missing objects
   ```

3. **Apply ResourceQuota Changes:**
   - Save the ResourceQuota manifest to a file (e.g., `resourcequota.yaml`) and apply the changes to the cluster using the following command:
     ```bash
     kubectl apply -f resourcequota.yaml -n <namespace>
     ```

4. **Verify Compliance:**
   - After applying the changes, verify that the ResourceQuotas are correctly enforced for all objects in the namespace using the `kubectl describe resourcequota` command.

5. **References:**
   - For more information on creating and managing ResourceQuotas, refer to the official Kubernetes documentation on [Resource Quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/).
   - Find more information about this policy here.