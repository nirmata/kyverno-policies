# Cluster Policy - Restrict Resource Quota Changes Policy

## Policy Overview
The `restrict-resource-quota-changes` policy ensures that tenants within Kubernetes namespaces cannot perform actions such as creating, updating, patching, deleting, or bulk-deleting operations on resource quotas. This restriction serves as a security measure to maintain control over resource management and prevent tenants from inadvertently exceeding their allocated resources or interfering with cluster stability.

**Importance**

This policy holds significance in enhancing the security and stability of Kubernetes clusters, particularly in multitenant environments. By limiting the ability to modify resource quotas, it helps maintain isolation between tenants and promotes fair resource usage, thereby mitigating the risk of resource exhaustion and ensuring consistent performance for all users.

**Key Annotations:**
- **Title:** Restrict Resource Quota Changes
- **Category:** Multitenancy Benchmarks
- **Severity:** High
- **Subject:** ResourceQuota

**Policy Configuration:**
- **Validation Failure Action:** Audit (Enforce rejection on failure)
- **Rules:**
  - **Name:** restrict-resource-quota-changes
  - **Match Conditions:** Applicable to resource quota modification operations within namespaces
  - **Validation Message:** "ResourceQuota changes are restricted"
  - **Validation Pattern:**
    - Enforces restrictions on actions such as creation, updating, patching, deletion, or bulk-deletion operations on resource quotas within namespaces.

## Finding Violations

To identify violations of the `restrict-resource-quota-changes` policy, follow these steps:

1. **Check Policy Status:**
   - Use the following command to view the READY status of Kyverno policies in your cluster:
     ```bash
     kubectl get cpol
     ```
   - Look for the status of the `restrict-resource-quota-changes` policy. If READY status shows `True` or the MESSAGE shows `Ready` your policy is up and running!

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

## Chainsaw Test

To apply chainsaw test, run the following command
   ```bash
   chainsaw test .
   ```

## How to Fix It

To address violations of the `restrict-resource-quota-changes` policy, take the following corrective actions:

1. **Revoke Unauthorized Permissions:**
   - Adjust Kubernetes RBAC (Role-Based Access Control) settings to revoke permissions that allow tenants to modify resource quotas within namespaces.

2. **References:**
   - Refer to the Kubernetes documentation on [Role-Based Access Control (RBAC)](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) for guidance on configuring permissions.
   - Explore additional [security best practices for Kubernetes clusters](https://github.com/kubernetes-retired/multi-tenancy/tree/master/benchmarks/kubectl-mtb/test/benchmarks/block_ns_quota) to enhance overall governance and compliance.
