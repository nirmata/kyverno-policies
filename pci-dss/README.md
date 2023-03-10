# PCI DSS Compliance Policy Set

## Installing Policies

**Clone Repository:**

Clone the `kyverno-policies` repository

```console
git clone https://github.com/nirmata/kyverno-policies.git
```

**Install Policies:**

To install PCI DSS Compliance policy


```console
cd kyverno-policies
kubectl apply -f pci-dss
```

Once policies are installed, you can check if they are ready using the command:

```console
kubectl get cpol
