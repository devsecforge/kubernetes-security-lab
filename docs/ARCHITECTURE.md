# Architecture

This lab demonstrates **defense in depth** for Kubernetes workloads: five independent controls,
each of which would stop or contain a different attack, layered so no single failure is fatal.

```
                        ┌───────────────────────────────────────────┐
                        │              secure-demo namespace          │
                        │   (Pod Security Admission: restricted)      │  ← Layer 1: admission
                        │                                             │
   ingress-nginx ──▶ NetworkPolicy ──▶  ┌──────────────────────┐     │  ← Layer 2: network
   (only :8080)     (default-deny)      │  web Deployment       │     │
                                        │  · runAsNonRoot       │     │  ← Layer 3: pod hardening
                                        │  · readOnlyRootFS     │     │
                                        │  · drop ALL caps      │     │
                                        │  · resource limits    │     │
                                        └──────────┬───────────┘     │
                                                   │                 │
                              web-sa (least-priv RBAC, no token) ─────┼─ ← Layer 4: identity
                                                   │                 │
                        Falco runtime rules  ──────┴─────────────────┘  ← Layer 5: runtime detection
```

## The five layers

| # | Layer | Control | Attack it stops |
|---|-------|---------|-----------------|
| 1 | Admission | Pod Security Admission `restricted` | Privileged/root/host-namespace pods rejected at creation |
| 2 | Network | Default-deny NetworkPolicy + explicit allow | Lateral movement, unexpected egress/exfiltration |
| 3 | Pod | non-root, read-only FS, drop ALL caps, seccomp, limits | Container breakout, privilege escalation, DoS |
| 4 | Identity | Dedicated SA, least-priv Role, no auto-mounted token | Stolen-token → cluster access |
| 5 | Runtime | Falco custom rules | Live intrusion (shell spawn, unexpected writes) |

## CI enforcement
Every change runs `kubeconform` (schema), `kube-linter` (security lint), and `trivy config`
(misconfig → SARIF to the Security tab). The hardened manifests pass; the insecure sample is
excluded from gating and exists purely to demonstrate what "bad" looks like.
