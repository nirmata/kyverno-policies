# Kyverno Policies

This repository contains a set of Kyverno policies curated and managed by the Nirmata team for use as policy groups within Nirmata Policy Manager, Nirmata DevSecOps Platform and Nirmata Enterprise Subscription (https://nirmata.io).


## Installing Policies

**Clone Repository:**

Clone the kyverno-policies repository.

```console
git clone https://github.com/nirmata/kyverno-policies.git
```

**Install Policies:**

Install the policiies based on your requirements.

```console
cd kyverno-policies
kubectl apply -f pod-security
kubectl apply -f multitenancy
kubectl apply -f best-practices
```

Once policies are installed, you can check if they are ready using the command:

```console
kubectl get cpol
```

