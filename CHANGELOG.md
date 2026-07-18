# Changelog

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]
### Planned
- Image signing & verification (Cosign)
- Policy engine examples (Kyverno / OPA Gatekeeper)
- kube-bench (CIS Benchmark) node hardening
- Helm chart packaging of the hardened workload

## [1.0.0] - 2026-07-18
### Added
- Five-layer defense-in-depth demo: PSA restricted namespace, least-priv RBAC,
  default-deny NetworkPolicies, a fully hardened Deployment, and Falco runtime rules.
- Intentionally-insecure sample for contrast (excluded from gating scans).
- CI: kubeconform + kube-linter + Trivy config with SARIF upload.
- Local scripts: `scan-manifests.sh` and `setup-kind.sh` (kind cluster demo).
- Docs: architecture, STRIDE threat model, reusable hardening checklist.
- Governance: SECURITY, CONTRIBUTING, CODE_OF_CONDUCT, MIT license.
