# pod-security-policies

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Pod Security policy set

## Description

These are collections of policies which implement the various levels of Kubernetes [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/).

The `Baseline/Default` profile is minimally restrictive and denies the most common vulnerabilities while the `Restricted` profile is more heavily restrictive but follows many more of the common security best practices for Pods.


NOTE: the `proc-mount` pod may execute as non-default values for `securityContext.procMount` require the `ProcMountType` feature flag to be enabled.

## Installation

1. Add the Helm repository:

```console
helm repo add kyverno-policies https://nirmata.github.io/kyverno-policies/
helm repo update kyverno-policies
```

2. Install the Helm Chart:

```console
helm install pod-security kyverno-policies/pod-security --namespace pod-security --create-namespace
```

3. Verify the installation:

```console
kubectl get cpol
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Nirmata |  | <https://nirmata.com/> |
