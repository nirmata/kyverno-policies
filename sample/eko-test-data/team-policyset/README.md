## Team (namespace-scoped) PolicySet fixtures

Test data for the `enterprise-kyverno-operator` chainsaw e2e tests (`test/e2e/chainsaw/policyset/*`). All policies are `Audit` mode.

- `scope/`: namespace scope. `cluster-policy.yaml` (ClusterPolicy) must be rejected in a namespace-scoped set; `valid-policy.yaml` (`team-a`) must be applied; `foreign-policy.yaml` (`team-x`) must be skipped because team-x is not targeted.
- `collision-a/`, `collision-b/`: ownership conflict. Both hold `Policy` `e2e-shared` in `team-b`, differing only in the message ("owned by set A" / "owned by set B"); two sets must not both own it.

**Warning:** the operator e2e tests reference these folder and file names, kind, names and namespaces by path. Do not rename or move them, or change their names or namespaces, without updating those tests.
