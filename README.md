# Kyverno Policies

This repository contains a set of Kyverno policies curated and managed by the Nirmata team for use as policy groups within [Nirmata Enterprise for Kyverno](https://nirmata.com/kyverno-enterprise/), and [Nirmata Policy Manager](https://nirmata.com/nirmata-cloud-native-policy-manager/).

For more information, visit our website at [https://nirmata.com/](https://nirmata.com/).

Sign-up for a free trial today at [https://try.nirmata.io/](https://try.nirmata.io/)


## Installing Policies

**Clone Repository:**

Clone the kyverno-policies repository.

```console
git clone https://github.com/nirmata/kyverno-policies.git
```

**Install Policies:**

To install Pod Security Standard policies, refer to [pod-security/README.md](pod-security/README.md)

To install Kubernetes Best Practices policies, refer to [best-practices/README.md](best-practices/README.md)

To install PCI-DSS Best Practices policies, refer to [pci-dss/README.md](pci-dss/README.md)

To install Multitenancy and EKS Best Practices

```console
cd kyverno-policies
kubectl apply -f multitenancy
```

Once policies are installed, you can check if they are ready using the command:

```console
kubectl get cpol
```
