# Kubernetes workload Best Practices

## Installing the policies
Use [kustomize](https://github.com/kubernetes-sigs/kustomize) to apply the policies
```sh
kubectl apply -k .
```

## Running kyverno cli tests
To install the kyverno cli, refer to the [official documentation](https://kyverno.io/docs/kyverno-cli/)
```sh
kyverno test .
```