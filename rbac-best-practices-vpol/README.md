# RBAC Best Practices


These are collections of policies which implement RBAC Best Practices as recommended in the Kubernetes documentation - https://kubernetes.io/docs/concepts/security/rbac-good-practices/


## Installing the RBAC Best Practices policies
Use kustomize to install the policies.

```sh
kubectl apply -k .
```

Verify if policies are installed
```sh
kubectl get cpol
NAME                              BACKGROUND   VALIDATE ACTION   READY
disable-automount-sa-token        true         audit             true
restrict-automount-sa-token       true         audit             true
restrict-binding-system-groups    true         audit             true
restrict-clusterrole-nodesproxy   true         audit             true
restrict-escalation-verbs-roles   true         audit             true
restrict-wildcard-resources       true         audit             true
```