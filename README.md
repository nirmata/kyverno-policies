<img referrerpolicy="no-referrer-when-downgrade" src="https://static.scarf.sh/a.png?x-pxid=5b0e6ae5-31f7-455c-8938-de55b61d7607" />

# Kyverno Policies

This repository contains a set of Kyverno policies curated and managed by the Nirmata team for use as policy groups within [Nirmata Enterprise for Kyverno](https://nirmata.com/nirmata-enterprise-for-kyverno/?utm_source=github&utm_medium=readme&utm_campaign=kyverno-policies), and [Nirmata Control Hub](https://nirmata.com/nirmata-control-hub/?utm_source=github&utm_medium=readme&utm_campaign=kyverno-policies).

For more information, visit our website at [nirmata.com](https://nirmata.com/?utm_source=github&utm_medium=readme&utm_campaign=kyverno-policies).

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

## Enterprise support

These policy sets are maintained by [Nirmata](https://nirmata.com/?utm_source=github&utm_medium=readme&utm_campaign=kyverno-policies), the creators of Kyverno.
For hardened, CVE-patched Kyverno builds with enterprise support, see
[Nirmata Enterprise for Kyverno](https://nirmata.com/nirmata-enterprise-for-kyverno/?utm_source=github&utm_medium=readme&utm_campaign=kyverno-policies) and the
[Kyverno CVE tracker](https://nirmata.com/kyverno-cve-tracker/?utm_source=github&utm_medium=readme&utm_campaign=kyverno-policies), or [talk to us](https://nirmata.com/request-a-demo/?utm_source=github&utm_medium=readme&utm_campaign=kyverno-policies).
