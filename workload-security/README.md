## Installing Policies

**Clone Repository:**

Clone the kyverno-policies repository.

```console
git clone https://github.com/nirmata/kyverno-policies.git
```

**Install Workload Security Policies:**

To install Workload Security Compliance policy


```console
cd kyverno-policies
kubectl apply -f workload-security
```

Once policies are installed, you can check if they are ready using the command:

```console
kubectl get cpol
```
