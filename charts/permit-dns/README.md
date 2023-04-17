# permit-dns-policies

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Permit dns policy set

## Description

This policy generates a NetworkPolicy that allows DNS access for a Namespace.

## Installation

1. Add the Helm repository:

```console
helm repo add kyverno-policies https://nirmata.github.io/kyverno-policies/
helm repo update kyverno-policies
```

2. Install the Helm Chart:

```console
helm install permit-dns kyverno-policies/permit-dns --namespace permit-dns --create-namespace
```

3. Verify the installation:

```console
kubectl get cpol
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Nirmata |  | <https://nirmata.com/> |
