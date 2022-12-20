# pod-security-standard-policies

A Helm chart for apply pod security best practices

![Version: v0.1.0](https://img.shields.io/badge/Version-v0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.8.4](https://img.shields.io/badge/AppVersion-v1.8.4-informational?style=flat-square)

## About

This chart contains Enterprise Kyverno's implementation of the Kubernetes Pod Security Standards (PSS) as documented at https://kubernetes.io/docs/concepts/security/pod-security-standards/ and are a Helm packaged version of those found at https://github.com/kyverno/policies/tree/main/pod-security. The goal of the PSS controls is to provide a good starting point for general Kubernetes cluster operational security. These controls are broken down into two categories, Baseline and Restricted. Baseline policies implement the most basic of Pod security controls while Restricted implements more strict controls. Restricted is cumulative and encompasses those listed in Baseline.

The following policies are included in each profile.

**Baseline**

* disallow-adding-capabilities
* disallow-host-namespaces
* disallow-host-path
* disallow-host-ports
* disallow-host-process
* disallow-privileged-containers
* disallow-proc-mount
* disallow-selinux
* restrict-apparmor-profiles
* restrict-sysctls

**Restricted**

* deny-privilege-escalation
* require-run-as-nonroot
* restrict-seccomp
* restrict-volume-types

## Installing the Chart

These PSS policies presently have a minimum requirement of Enterprise Kyverno 1.6.0.

```console
## Add the Enterprise Kyverno Helm repository
$ helm repo add nirmata https://nirmata.github.io/kyverno-charts/

## Install the Pod Security Standards Helm chart
$ helm install pss-policies --namespace nirmata-kyverno --create-namespace nirmata/pod-security-standard-policies
```

## Uninstalling the Chart

To uninstall/delete the `pss-policies` chart:

```console
$ helm delete -n nirmata-kyverno pss-policies
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Requirements

Kubernetes: `>=1.16.0-0`

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Nirmata |  | <https://nirmata.com/> |

