# Compliance Bundles

Kustomize-based compliance bundles for deploying Kyverno policies by security standard. Each bundle installs a curated set of policies in a single `kubectl apply -k` command.

## Quick Start

```bash
# CIS Amazon EKS Benchmark v1.7.0
kubectl apply -k compliance/cis/eks/

# CIS Kubernetes Benchmark v1.8.0
kubectl apply -k compliance/cis/kubernetes/

# CIS AKS Benchmark
kubectl apply -k compliance/cis/aks/

# CIS GKE Benchmark
kubectl apply -k compliance/cis/gke/

# SOC 2 Type II
kubectl apply -k compliance/soc2/

# ISO/IEC 27001:2022
kubectl apply -k compliance/iso27001/

# NSA/CISA Kubernetes Hardening Guide v1.2
kubectl apply -k compliance/nsa-cisa/

# NIST SP 800-53 Rev 5
kubectl apply -k compliance/nist-800-53/

# PCI DSS v3.2.1 / v4.0 (6 policies, composable)
kubectl apply -k compliance/pci-dss/
# PCI DSS standalone with all 7 policies (including require-network-policy)
kubectl apply -k pci-dss/
```

## Directory Structure

```
compliance/
├── cis/
│   ├── kustomization.yaml        # CIS common policies only (6 policies)
│   ├── common/                   # 6 CIS policies shared across all distributions
│   │   ├── restrict-cluster-admin-binding/
│   │   ├── restrict-secret-role-access/
│   │   ├── restrict-pod-creation-access/
│   │   ├── require-network-policy/
│   │   ├── require-pss-labels/
│   │   └── require-ingress-tls/
│   ├── eks/                      # CIS EKS Benchmark v1.7.0 (40 policies)
│   │   └── restrict-secrets-as-env-vars/
│   ├── aks/                      # CIS AKS Benchmark (39 policies)
│   ├── gke/                      # CIS GKE Benchmark (39 policies)
│   └── kubernetes/               # CIS Kubernetes Benchmark v1.8.0 (39 policies)
├── soc2/                         # SOC 2 Type II (35 policies)
├── iso27001/                     # ISO/IEC 27001:2022 (39 policies)
├── nsa-cisa/                     # NSA/CISA Kubernetes Hardening Guide v1.2 (39 policies)
├── nist-800-53/                  # NIST SP 800-53 Rev 5 (39 policies)
├── pci-dss/                      # PCI DSS v3.2.1 / v4.0 (6 policies; 7 standalone)
└── mappings.yaml                 # Machine-queryable control ID → policy mapping
```

## Bundle Contents

Each platform bundle composes policies from shared libraries. No policy files are duplicated.

| Bundle | CIS common | Platform-specific | pod-security | rbac | best-practices | pci-dss |
|--------|:----------:|:-----------------:|:------------:|:----:|:--------------:|:-------:|
| `cis/eks` | 6 | 1 | 17 | 6 | 10 | — |
| `cis/aks` | 6 | — | 17 | 6 | 10 | — |
| `cis/gke` | 6 | — | 17 | 6 | 10 | — |
| `cis/kubernetes` | 6 | — | 17 | 6 | 10 | — |
| `soc2` | 6 | — | 17 | 6 | — | 6 |
| `iso27001` | 6 | — | 17 | 6 | 10 | — |
| `nsa-cisa` | 6 | — | 17 | 6 | 10 | — |
| `nist-800-53` | 6 | — | 17 | 6 | 10 | — |
| `pci-dss` | — | — | — | — | — | 6 |

> `pod-security` count includes both `baseline` (11) and `restricted` (6) policies.
> `pod-security/restricted` references `pod-security/baseline` — only `restricted` is listed in each bundle to avoid duplication.

## CIS Controls Coverage

### Policies in `cis/common/` (all distributions)

| Policy | CIS EKS | CIS K8s |
|--------|---------|---------|
| `restrict-cluster-admin-binding` | 4.1.1 | 5.1.1 |
| `restrict-secret-role-access` | 4.1.2 | 5.1.2 |
| `restrict-pod-creation-access` | 4.1.4 | 5.1.4 |
| `require-network-policy` | 4.3.1 | 5.3.2 |
| `require-pss-labels` | 4.4.2 | 5.7.1 |
| `require-ingress-tls` | 5.4.5 | 5.7.5 |

### Policies in `cis/eks/` (EKS only)

| Policy | CIS EKS | Notes |
|--------|---------|-------|
| `restrict-secrets-as-env-vars` | 5.x | Recommends IRSA over env var secrets |

### Controls requiring `aws` CLI or node access (not enforceable via Kyverno)

CIS EKS sections 2.x (control plane config), 3.x (worker node config), and 5.3–5.5 (networking/storage) require AWS API or SSH access. These are assessed by the `cis-benchmark-scan` skill in the Nirmata skills repository.

## Control ID → Policy Mapping

`mappings.yaml` is the authoritative machine-queryable source of truth mapping every policy to its control IDs across all supported standards:

```bash
# Find all policies covering a CIS EKS control
grep -A5 'cis-eks:.*"4.1' compliance/mappings.yaml

# List all policies mapped to SOC 2
grep -B3 'soc2' compliance/mappings.yaml | grep 'path:'

# List all NSA/CISA Section 1 (Pod Security) controls
grep -A1 'nsa-cisa:' compliance/mappings.yaml | grep 'Sec\.1'

# List all NIST AC-family controls
grep 'nist-800-53:' compliance/mappings.yaml | grep '"AC-'
```

Human-readable annotations are also present on every policy YAML:

```yaml
annotations:
  policies.kyverno.io/standards: "cis-eks,cis-kubernetes,cis-aks,cis-gke,soc2,iso27001,nsa-cisa,nist-800-53"
  policies.nirmata.io/cis-eks-control: "4.1.1"
  policies.nirmata.io/pci-dss-control: "1.3"
  policies.nirmata.io/nsa-cisa-control: "Sec.3.1"
  policies.nirmata.io/nist-800-53-control: "AC-2,AC-6"
```

## PCI DSS v3.2.1 / v4.0

The `pci-dss` bundle targets payment card and network security requirements. `compliance/pci-dss/` provides 6 composable policies; `pci-dss/` (the top-level directory) provides all 7 for standalone use. It is also composed into the `soc2` bundle.

| Policy | PCI Requirement | Description |
|--------|----------------|-------------|
| `add-annotations` | 12.x | Asset management — enforce resource annotations |
| `deny-loadbalancer-creation` | 1.3 | Network access controls — block public LoadBalancer services |
| `deny-ingress-creation` | 1.3 | Network access controls — block Ingress resources |
| `require-network-policy` | 1.3 | Network access controls — require NetworkPolicy per Deployment |
| `require-clamav-enabled` | 5.1 | Anti-malware — require ClamAV sidecar |
| `restrict-basic-auth-secret` | 8.2 | Identity management — disallow basic-auth Secrets |
| `disallow-default-serviceaccount` | 7.1 | Access control — prohibit use of default ServiceAccount |

> **Note:** `require-network-policy` in `pci-dss/` is a separate policy from the one in `compliance/cis/common/`. The standalone `compliance/pci-dss/` bundle includes both; the composite `soc2` bundle uses only the CIS common version to avoid name conflicts.

## NSA/CISA Kubernetes Hardening Guide

The `nsa-cisa` bundle covers the [NSA/CISA Kubernetes Hardening Guide v1.2](https://media.defense.gov/2022/Aug/29/2003066362/-1/-1/0/CTR_KUBERNETES_HARDENING_GUIDANCE_1.2_20220829.PDF) sections enforceable via admission control:

| Section | Topic | Policies |
|---------|-------|---------|
| Sec.1.1 | Non-root containers | `require-pss-labels`, `require-run-as-non-root-user`, `require-run-as-nonroot` |
| Sec.1.2 | Immutable container filesystems | `require-ro-rootfs` |
| Sec.1.3 | Building secure container images | `disallow-privileged-containers`, `disallow-host-namespaces`, `disallow-host-path`, `disallow-host-process`, `restrict-volume-types` |
| Sec.1.4 | Pod Security | `disallow-capabilities`, `disallow-proc-mount`, `disallow-selinux`, `restrict-apparmor-profiles`, `restrict-seccomp`, `restrict-sysctls`, `disallow-capabilities-strict`, `restrict-seccomp-strict` |
| Sec.1.5 | Privilege escalation | `disallow-privilege-escalation` |
| Sec.1.6 | Secret protection | `restrict-secret-role-access`, `restrict-secrets-as-env-vars` |
| Sec.2.1 | Network policy | `require-network-policy`, `disallow-host-ports`, `restrict-node-port` |
| Sec.2.2 | TLS and ingress | `require-ingress-tls`, `disallow-empty-ingress-host` |
| Sec.3.1 | RBAC | `restrict-cluster-admin-binding`, `restrict-pod-creation-access`, `restrict-binding-system-groups`, `restrict-clusterrole-nodesproxy`, `restrict-escalation-verbs-roles`, `restrict-wildcard-resources`, `disallow-default-namespace` |
| Sec.3.2 | Service account tokens | `disable-automount-sa-token`, `restrict-automount-sa-token` |
| Sec.5.1 | Image hygiene | `disallow-latest-tag` |

## NIST SP 800-53 Rev 5

The `nist-800-53` bundle maps policies to [NIST SP 800-53 Rev 5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) controls. Control families covered:

| Family | Controls | Policies |
|--------|---------|---------|
| AC — Access Control | AC-2, AC-3, AC-6, AC-17 | RBAC, secret access, privilege restrictions |
| CM — Configuration Mgmt | CM-6, CM-7, CM-8, CM-11 | Pod security, namespace restrictions, image policies |
| IA — Identification & Auth | IA-5 | Service account token controls, secret handling |
| SC — System/Comms Protection | SC-6, SC-7, SC-8, SC-28, SC-39 | Network policies, TLS, resource limits, namespace isolation |
| SI — System & Info Integrity | SI-2, SI-3, SI-7 | Probes, seccomp, image integrity |

## Audit Mode

All policies deploy in `Audit` mode by default — they report violations without blocking workloads. To switch a bundle to `Enforce`:

```bash
kubectl apply -k compliance/cis/eks/
kubectl get clusterpolicy -o name | xargs -I{} kubectl patch {} \
  --type=merge -p '{"spec":{"validationFailureAction":"Enforce"}}'
```

## Shared Policy Libraries

The bundles reference these top-level policy sets without moving or duplicating files:

| Library | Path | Controls |
|---------|------|---------|
| Pod Security Standards (Baseline) | `pod-security/baseline/` | CIS 5.2.x |
| Pod Security Standards (Restricted) | `pod-security/restricted/` | CIS 5.2.x, 5.7.x |
| RBAC Best Practices | `rbac-best-practices/` | CIS 4.1.x / 5.1.x |
| Kubernetes Best Practices | `best-practices-k8s/` | CIS 4.5.x, 5.x |
| PCI-DSS | `pci-dss/` | PCI 1.x, 4.x, 7.x, 8.x |

## Planned Standards

### EU Compliance Bundles

Four EU regulatory frameworks are planned as the next set of compliance bundles. All map predominantly to the 40 policies already in this library — the primary work is control-ID annotations and kustomization bundles.

| Standard | Applicability | Control ID format | Existing coverage | New policies needed |
|----------|--------------|-------------------|:-----------------:|---------------------|
| [GDPR](https://gdpr-info.eu/art-32-gdpr/) Art. 32 | All orgs processing EU personal data | `Art.32(1)(a)` | ~28 / 40 | Secret encryption, audit webhook |
| [NIS2](https://www.nis-2-directive.com/NIS_2_Directive_Article_21.html) Art. 21 | Essential & important entities (EU) | `Art.21(2)(a)` | ~28 / 40 | Image signing, supply chain |
| [DORA](https://www.digital-operational-resilience-act.com/) Art. 9 | Financial sector (EU, from Jan 2025) | `Art.9`, `Art.28` | ~25 / 40 | None (probes/limits already covered) |
| [BSI IT-Grundschutz](https://www.bsi.bund.de/dok/SYS.1.6) SYS.1.6 / APP.4.4 | German gov & critical infrastructure | `SYS.1.6.A3` | ~35 / 40 | Image source restriction |

#### GDPR — Art. 32 Security of Processing

Maps to: TLS on Ingress (`Art.32(1)(a)` — encryption in transit), NetworkPolicy (`Art.32(1)(b)` — confidentiality/integrity), pod security (`Art.32(1)(b)` — availability), RBAC (`Art.32(1)(b)` — access control), resource limits and probes (`Art.32(1)(b)` — resilience).

**Not enforceable via admission control:** encryption at rest (etcd/PV), backup/recovery, incident response procedures, audit trail completeness.

#### NIS2 — Art. 21 Cybersecurity Measures

Maps to: RBAC (`Art.21(2)(i)` — access control), NetworkPolicy + TLS (`Art.21(2)(g)/(h)` — network security/cryptography), pod security (`Art.21(2)(g)` — cyber hygiene), image policies (`Art.21(2)(d)/(e)` — supply chain/secure acquisition).

**Not enforceable via admission control:** risk analysis documentation, business continuity/backup, incident detection/reporting (requires runtime tooling such as Falco + SIEM), personnel vetting.

**New policy needed:** image signing verification (`Art.21(2)(d)` supply chain — requires cosign/Sigstore support).

#### DORA — Digital Operational Resilience Act

Maps to: RBAC (`Art.9` — ICT system protection), TLS + secret controls (`Art.9` — encryption), probes and rolling update strategy (`Art.9` — resilience), resource limits (`Art.9` — availability), NetworkPolicy (`Art.9` — network segmentation).

Best existing fit is the `best-practices-k8s` library — `require-pod-probes`, `require-requests-limits`, `require-rolling-update-strategy`, and `require-pod-antiaffinity` directly address DORA's operational resilience requirements.

**Not enforceable via admission control:** ICT risk management framework, operational resilience testing (TLPT), third-party monitoring, incident classification/reporting.

#### BSI IT-Grundschutz — SYS.1.6 / APP.4.4

Most prescriptive of the four — has dedicated container (`SYS.1.6`) and Kubernetes (`APP.4.4`) modules with explicit control IDs. Strong overlap with CIS Kubernetes Benchmark.

Maps to: pod security (`SYS.1.6.A2` — container isolation), RBAC (`APP.4.4.A3` — identity and authorization), NetworkPolicy (`SYS.1.6.A6` — network segmentation), image restrictions (`SYS.1.6.A3`), read-only rootfs (`SYS.1.6.A4`), secrets-as-env-vars (`SYS.1.6.A5`), resource limits (`SYS.1.6.A10`).

**New policy needed:** restrict container image registries to approved sources (`SYS.1.6.A3`).

### Implementation Notes

Policies that cannot be enforced at admission time across all four standards:

| Gap area | Tooling required |
|----------|-----------------|
| Encryption at rest (etcd, PV) | Cloud KMS, etcd encryption config |
| Runtime threat detection | Falco, eBPF-based tooling |
| Incident detection & SIEM reporting | Audit webhook + log aggregation |
| Backup & disaster recovery | Velero, cloud-native backup |
| Image vulnerability scanning | Trivy, Grype (out-of-band or admission scan) |
| Image signing verification | Kyverno + Sigstore/cosign (new policy) |
