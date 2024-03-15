# Cluster Policy - Require Namespace Quota

## Policy Overview
This Kubernetes ClusterPolicy, named `require-namespace-quota`, ensures that essential resource quotas (CPU, ephemeral storage, and memory) are properly configured for tenant namespaces. It operates by validating the presence and configuration of ResourceQuota specifically for these critical resources within each namespace.

**Importance**

The importance of this policy lies in its contribution to efficient resource management and maintaining cluster stability. By enforcing proper configuration of resource quotas for essential resources, it helps prevent resource overconsumption, which could lead to performance issues or even cluster failures. Additionally, it promotes better resource allocation practices, ensuring fair usage among tenant namespaces and enhancing overall cluster security.

**Key Annotations:**
- **Title:** Require ResourceQuota for Essential Resources in Tenant Namespace
- **Category:** Resource Management
- **Severity:** Medium
- **Subject:** ResourceQuota
- **Kyverno Version:** 1.8.0
- **Kubernetes Version:** 1.24

**Policy Configuration:**
- **Validation Failure Action:** Audit (Log violations)
- **Rules:**
  - **Name:** ensure-essential-resource-quotas
  - **Match Conditions:** Applies to ResourceQuota creation operations
  - **Validation Message:** "Resource quotas for essential resources (CPU, ephemeral storage, and memory) are not properly configured for the tenant namespace"
  - **Validation Pattern:**
    - Ensures that quotas are defined for CPU, ephemeral storage, and memory within each tenant namespace.

**Usage**

To apply this policy, deploy it as a Kubernetes ClusterPolicy, specifying the desired validation rules and failure actions. Once applied, the policy will automatically enforce the proper configuration of ResourceQuota for essential resources within tenant namespaces, thereby enhancing resource governance and cluster stability.

## Finding Violations

To identify violations of the `require-namespace-quota` policy, follow these steps:

1. **Check Policy Status:**
   - Use the following command to view the READY status of Kyverno policies in your cluster:
     ```bash
     kubectl get cpol
     ```
   - Look for the status of the `require-namespace-quota` policy. If READY status shows `True` or the MESSAGE shows `Ready`, your policy is up and running!

2. **Check Policy Report:**
   - Use the following command to view the violations if any:
     ```bash
     kubectl get cpolr
     ```
   - Look for the status of the `require-namespace-quota` policy. If it shows any violations, note the namespace(s) where the violations occurred.

3. **Inspect ResourceQuotas:**
   - Use the following command to list ResourceQuotas in the namespaces where violations were detected:
     ```bash
     kubectl get resourcequota -n <namespace>
     ```
   - Review the ResourceQuotas to ensure quotas are properly configured for CPU, ephemeral storage, and memory.

## How to Fix It

To fix violations of the `require-namespace-quota` policy, follow these steps:

1. **Create or Update ResourceQuotas:**
   - Use Kubernetes manifest format to create or update ResourceQuotas in the affected namespaces. Ensure that ResourceQuotas include configurations for CPU, ephemeral storage, and memory.
   
2. **Sample ResourceQuota Manifest:**
   ```yaml
   apiVersion: v1
   kind: ResourceQuota
   metadata:
     name: example-resourcequota
   spec:
     hard:
       cpu: "2"
       ephemeral-storage: "1Gi"
       memory: "2Gi"
   ```

3. **Apply ResourceQuota Changes:**
   - Save the ResourceQuota manifest to a file (e.g., `resourcequota.yaml`) and apply the changes to the cluster using the following command:
     ```bash
     kubectl apply -f resourcequota.yaml -n <namespace>
     ```

4. **Verify Compliance:**
   - After applying the changes, verify that the ResourceQuotas are correctly enforced for CPU, ephemeral storage, and memory in the namespace using the `kubectl describe resourcequota` command.

5. **References:**
   - For more information on creating and managing ResourceQuotas, refer to the official Kubernetes documentation on [Resource Quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/).
   - Find more information about this policy [here]().
