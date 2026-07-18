# Threat Model — Kubernetes Workload

STRIDE analysis for a workload running in the `secure-demo` namespace.

## Assets
- The application pods and their data
- The service account token / cluster identity
- Neighbouring workloads in the cluster
- The node / host the pod runs on

## Trust boundaries
1. External client → Ingress → pod
2. Pod → Kubernetes API server
3. Pod → other pods / namespaces
4. Container → node/host kernel

## STRIDE

| Threat | Scenario | Control in this lab |
|--------|----------|---------------------|
| **S**poofing | Stolen SA token used against the API | No auto-mounted token; least-priv Role (configmaps read-only) |
| **T**ampering | Attacker writes a webshell to the container FS | `readOnlyRootFilesystem`; Falco "unexpected write" rule |
| **R**epudiation | No record of runtime intrusion | Falco alerts with user/proc/container context |
| **I**nfo disclosure | Pod reaches out to exfiltrate data | Default-deny egress NetworkPolicy (DNS only); Falco egress rule |
| **D**enial of service | Noisy-neighbour exhausts node CPU/mem | CPU/memory `limits` on every container |
| **E**levation of privilege | Container breakout to host | Non-root, drop ALL caps, seccomp RuntimeDefault, no privileged, PSA `restricted` |

## Attack paths blocked (walkthrough)
1. **Deploy a privileged pod** → rejected by PSA at admission (Layer 1).
2. **Compromise the running container** → read-only FS + dropped caps limit what's possible (Layer 3).
3. **Pivot to another service** → default-deny NetworkPolicy blocks it (Layer 2).
4. **Use the SA token to query the API** → token isn't mounted; even if it were, RBAC allows almost nothing (Layer 4).
5. **Persist / act on-host** → Falco fires on shell spawn and unexpected writes (Layer 5).

## Residual risks
- Node-level and control-plane hardening are out of scope for this lab (CIS Benchmark, kube-bench).
- Image provenance/signing (Cosign) and admission policy (Kyverno/OPA Gatekeeper) are roadmap items.
