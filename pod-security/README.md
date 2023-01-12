# Pod Security Standards


These are collections of policies which implement the various levels of Kubernetes [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/).

The `Baseline/Default` profile is minimally restrictive and denies the most common vulnerabilities while the `Restricted` profile is more heavily restrictive but follows many more of the common security best practices for Pods.


NOTE: the `proc-mount` pod may execute as non-default values for `securityContext.procMount` require the `ProcMountType` feature flag to be enabled.

## Installing the Pod Security Standard policies
Use kustomize to install the baseline or restricted profiles.

Install baseline policies
```sh
kubectl apply -k baseline/
```

Install both baseline and restricted policies
```sh
kubectl apply -k .
```

Install restricted profile in enforce mode
```sh
kubectl apply -k enforce/
```