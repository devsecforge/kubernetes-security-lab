# Kubernetes Workload Hardening Checklist

A practical, reusable checklist distilled from this lab. Each item maps to a concrete control you
can copy from `manifests/`. Aligned with the CIS Kubernetes Benchmark and Pod Security Standards.

## Pod / container
- [ ] `runAsNonRoot: true` + explicit non-zero `runAsUser`/`runAsGroup`
- [ ] `allowPrivilegeEscalation: false`
- [ ] `privileged: false`
- [ ] `readOnlyRootFilesystem: true` (+ `emptyDir` mounts for writable paths)
- [ ] `capabilities.drop: ["ALL"]` (add back only what's required)
- [ ] `seccompProfile.type: RuntimeDefault`
- [ ] CPU & memory `requests` and `limits` set
- [ ] Liveness & readiness probes defined
- [ ] Image pinned by digest (not `latest`)

## Identity / RBAC
- [ ] Dedicated ServiceAccount per workload
- [ ] `automountServiceAccountToken: false` unless the API is actually needed
- [ ] Namespaced Role with least-privilege verbs (no `*`, no cluster-admin)
- [ ] No wildcard `resources`/`verbs`

## Namespace / admission
- [ ] Pod Security Admission `enforce: restricted` label on the namespace
- [ ] Workloads isolated in their own namespace

## Network
- [ ] Default-deny ingress **and** egress NetworkPolicy
- [ ] Explicit allow rules scoped to required sources/ports
- [ ] DNS egress explicitly allowed (or apps break silently)

## Runtime & supply chain
- [ ] Runtime detection deployed (Falco) with custom rules
- [ ] Image vulnerability scanning in CI (Trivy) — gate on HIGH/CRITICAL
- [ ] Manifest misconfig scanning in CI (kube-linter, trivy config)
- [ ] (Roadmap) Image signing/verification (Cosign), policy engine (Kyverno/OPA)

## Verify it works
```bash
./scripts/setup-kind.sh                                   # apply hardened manifests
kubectl apply -f manifests/insecure/vulnerable-deployment.yaml  # should be REJECTED by PSA
./scripts/scan-manifests.sh                               # local scan, mirrors CI
```
