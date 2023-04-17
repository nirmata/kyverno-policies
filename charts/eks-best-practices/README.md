# eks-best-practices-policies

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

EKS Best Practices policy set

## Description

These are collections of policies which implement EKS Best Practices.

## Installation

1. Add the Helm repository:

```console
helm repo add kyverno-policies https://nirmata.github.io/kyverno-policies/
helm repo update kyverno-policies
```

2. Install the Helm Chart:

```console
helm install eks-best-practices kyverno-policies/eks-best-practices --namespace eks-best-practices --create-namespace
```

3. Verify the installation:

```console
kubectl get cpol
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Nirmata |  | <https://nirmata.com/> |
