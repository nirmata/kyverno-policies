# AI Security Policies — Planning Document

This document outlines the comprehensive set of AI security policies for this repository.
Policies are organized by category. Some will be new, others will reference existing policies
via kustomize.

---

## Category 1: AI Infrastructure (Kubernetes-level)

Policies that apply to pods/deployments running AI workloads (model serving, training jobs, agents).
All are **new policies** to be created.

| Policy | Action | Notes |
|--------|--------|-------|
| Require AI namespace labels | `require` | Enforce `ai-workload: "true"` label for namespace-level controls |
| Require resource limits for AI pods | `require` | GPU/CPU/memory — critical for cost & DoS prevention |
| Restrict GPU workload privileges | `restrict` | GPU often needs elevated caps; constrain to minimum |
| Require non-root for model serving | `require` | Enforce non-root execution for inference containers |
| Require network policy for AI namespaces | `require` | Isolate model endpoints |
| Restrict model serving service types | `restrict` | No NodePort/LoadBalancer without explicit annotation |
| Require AI workload pod disruption budget | `require` | Availability control for serving |

---

## Category 2: AI Supply Chain

Policies to secure the model and container supply chain.

| Policy | Action | Source |
|--------|--------|--------|
| Verify model container images | `verify` | Reference → `VerifyImage/` |
| Restrict model registry sources | `restrict` | New: allowlist of approved registries for AI images |
| Require immutable image tags | `require` | Reference → `best-practices-k8s/disallow-latest-tag` |
| Disallow latest tag on model images | `disallow` | Reference → existing |
| Require model metadata annotations | `require` | New: model name, version, provider, license on pods |

---

## Category 3: Access Control for AI

Policies to enforce least-privilege access for AI workloads.

| Policy | Action | Source |
|--------|--------|--------|
| Restrict secret access for AI namespaces | `restrict` | Reference → `rbac-best-practices/restrict-secret-role-access` |
| Disallow auto-mount SA tokens in AI pods | `disallow` | Reference → `rbac-best-practices/disable-automount-sa-token` |
| Restrict wildcard RBAC in AI namespaces | `restrict` | Reference → `rbac-best-practices/restrict-wildcard-resources` |
| Require dedicated service accounts | `require` | New: no default SA for AI workloads |
| Restrict AI API key secrets format | `audit` | New: detect plain-text API keys in secrets |

---

## Category 4: AI Data & Privacy

Policies to protect data processed by AI pipelines.
All are **new policies** to be created.

| Policy | Action | Notes |
|--------|--------|-------|
| Disallow PII in environment variables | `disallow` | AI pipelines often pass data via env vars |
| Require data classification labels | `require` | Namespace/pod-level data sensitivity labels |
| Audit volume mounts to sensitive paths | `audit` | `/data`, `/datasets`, `/models` access controls |
| Restrict external data endpoints | `restrict` | Network egress to known/approved data sources only |

---

## Category 5: MCP Server Security

Policies to secure Model Context Protocol (MCP) servers running in Kubernetes.
All are **new policies** to be created.

| Policy | Action | Notes |
|--------|--------|-------|
| Require MCP server authentication config | `require` | MCP servers must declare an auth method |
| Restrict MCP tool permissions | `restrict` | Limit tool scope in MCP server manifests |
| Disallow unauthenticated MCP endpoints | `disallow` | No open/public MCP server services |
| Audit MCP server network exposure | `audit` | Flag MCP servers exposed outside the cluster |

---

## Category 6: LLM / Agent Security

These policies **already exist** in this repository.

| Sub-category | Location | Count |
|-------------|----------|-------|
| Prompt security (injection, jailbreak, PII, obfuscation, etc.) | `ai/prompt/` | 23 policies |
| Agent skill security (exfiltration, privilege escalation, exec, etc.) | `ai/skills/` | 50 policies |
| MCP tool reference auditing | `ai/skills/audit-mcp-tool-references*.yaml` | 2 policies |

See `ai/prompt/` and `ai/skills/` for full policy listings.

---

## Category 7: AI Compliance & Governance

Policies to meet emerging AI regulatory and governance frameworks.
All are **new policies** to be created.

| Policy | Action | Framework |
|--------|--------|-----------|
| Require model card annotation | `require` | EU AI Act / NIST AI RMF |
| Require AI risk classification label | `require` | EU AI Act (minimal / limited / high risk) |
| Audit high-risk AI workloads | `audit` | EU AI Act Art. 9 — flag high-risk systems |
| Require human oversight annotation | `require` | NIST AI RMF GOVERN function |
| Require AI workload logging | `require` | SOC2 / ISO27001 — log all inference requests |

---

## Summary

| Category | New | Reference Existing | Total |
|----------|-----|--------------------|-------|
| 1. AI Infrastructure | 7 | 0 | 7 |
| 2. AI Supply Chain | 3 | 2 | 5 |
| 3. Access Control | 2 | 3 | 5 |
| 4. Data & Privacy | 4 | 0 | 4 |
| 5. MCP Server Security | 4 | 0 | 4 |
| 6. LLM / Agent Security | 0 | 73 (existing) | 73 |
| 7. AI Compliance & Governance | 5 | 0 | 5 |
| **Total** | **25 new** | **5 references** | **103** |

---

## Open Questions

1. **Scope**: Target a specific AI platform (KubeFlow, Ray, vLLM, OpenAI-compatible serving) or stay generic?
2. **MCP policies**: Are these for Claude Code MCP servers in K8s, or a different deployment context?
3. **EU AI Act**: Include compliance/governance category now, or focus on pure security first?
4. **Priority**: Which category to tackle first?
