# Running Chainsaw Tests for Tetrate Policies Locally

## 1. Create a Kind Cluster
Use the following command to create a local Kind cluster:

```sh
kind create cluster --name tetrate-chainsaw-test
```

(Optional) Switch your Kubernetes context to the newly created cluster:

```sh
kubectx tetrate-chainsaw-test
```

---

## 2. Install Kyverno
Install Kyverno using Helm. For more details, refer to [Kyverno Installation Docs](https://kyverno.io/docs/installation/methods/#standalone-installation).

```sh
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno -n kyverno --create-namespace
```

Verify that Kyverno pods are running:

```sh
kubectl get pods -n kyverno
```

---

## 3. Install Istio
To apply Istio-specific resources in the cluster, install Istio using Helm. Alternatively, you can apply the required CRDs directly from [istio-resources.yaml](https://github.com/kyverno/policies/blob/main/.chainsaw/crds/istio-resources.yaml).

```sh
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
helm install istio-base istio/base -n istio-system --set defaultRevision=default --create-namespace
```

---

## 4. Running Chainsaw Tests
Navigate to the `tetrate` directory from the root of your repository:

```sh
cd tetrate
```

Run the Chainsaw tests, ensuring that the `--parallel` flag is set to `1` to avoid interference between tests:

```sh
chainsaw test . --parallel 1
```

---

## 5. Understanding Tetrate Policy Structure
All resource manifests related to the policy tests can be found in the `e2e` directory.  
Additionally, required Kubernetes API permissions (ClusterRole and ClusterRoleBinding) are defined in `rbac.yaml`.

### Example Directory Structure:
```sh
mastersans@sanskar-vivobook:~/nirmata/kyverno-policies/tetrate$ tree TIS0303 -L 2
TIS0303
├── check-duplicate-certificate-gateway.yaml
└── e2e
    ├── bad-resource.yaml
    ├── chainsaw-test.yaml
    ├── gateway-resource.yaml
    ├── good-resource.yaml
    ├── policy-assert.yaml
    └── rbac.yaml
```

This structure ensures that policies, test cases, and required Kubernetes resources are properly organized for Chainsaw testing.



