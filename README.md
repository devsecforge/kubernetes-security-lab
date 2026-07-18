<div align="center">

# ☸️ Kubernetes Security Lab

**A hands-on, five-layer defense-in-depth demo for Kubernetes workloads — hardened manifests, least-privilege RBAC, zero-trust networking, and runtime detection, all enforced in CI.**

[![K8s Security](https://github.com/devsecforge/kubernetes-security-lab/actions/workflows/k8s-security.yml/badge.svg)](https://github.com/devsecforge/kubernetes-security-lab/actions/workflows/k8s-security.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)
![Falco](https://img.shields.io/badge/Falco-00AEC7?logo=falco&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-1904DA?logo=aqua&logoColor=white)

</div>

---

## 📖 Overview

Securing Kubernetes isn't one setting — it's **layers**, each catching what the others miss. This
lab implements five independent controls around a simple web workload, gives you an
**intentionally-insecure counter-example** to see what "bad" looks like, and **enforces the whole
thing in CI**. Spin it up locally on `kind` and watch Pod Security Admission reject an insecure pod
in real time.

## ✨ Features

- 🛡️ **Layer 1 — Admission:** namespace with Pod Security Admission `restricted`.
- 🌐 **Layer 2 — Network:** default-deny ingress **and** egress NetworkPolicies + scoped allows.
- 🔒 **Layer 3 — Pod hardening:** non-root, read-only FS, drop `ALL` caps, seccomp, resource limits.
- 🪪 **Layer 4 — Identity:** dedicated ServiceAccount, least-privilege RBAC, no auto-mounted token.
- 👁️ **Layer 5 — Runtime:** custom Falco rules (shell spawn, unexpected writes, egress).
- ⚠️ **Insecure counter-example** — documented, scanner-flagged, PSA-rejected.
- 🤖 **CI-enforced** — kubeconform + kube-linter + Trivy → SARIF to the Security tab.

## 🖼️ Screenshots

> _Placeholder — capture these when you run it:_
> - `docs/img/psa-reject.png` — PSA rejecting the insecure pod
> - `docs/img/ci-green.png` — the K8s Security workflow passing

## 🏛️ Architecture

Full diagram in **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)**.

```
PSA restricted namespace  →  NetworkPolicy (default-deny)  →  Hardened Deployment
        (admission)                (network)                    (non-root, RO-FS, no caps)
                     ↘ least-priv RBAC (no token) ↙   +   Falco runtime rules
```

## ⚙️ Installation

**Prerequisites:** `docker`, `kind`, `kubectl` (for the live demo); `trivy`, `kube-linter`,
`kubeconform` (for local scans).

```bash
git clone https://github.com/devsecforge/kubernetes-security-lab.git
cd kubernetes-security-lab
```

## 🚀 Usage

```bash
make up         # create a kind cluster + apply the hardened manifests
make insecure   # try the insecure pod — Pod Security Admission REJECTS it (that's the lesson)
make scan       # run local security scans (mirrors CI)
make down       # tear down the cluster
```

Inspect what's running:
```bash
kubectl -n secure-demo get pods,netpol,role,rolebinding,sa
```

## 📁 Folder Structure

```
kubernetes-security-lab/
├── manifests/
│   ├── 00-namespace.yaml            # PSA restricted
│   ├── 01-rbac.yaml                 # least-privilege SA + Role
│   ├── 02-network-policy.yaml       # default-deny + allows
│   ├── 03-deployment-hardened.yaml  # the secure workload
│   └── insecure/
│       └── vulnerable-deployment.yaml  # ⚠️ intentionally insecure
├── policies/falco/custom-rules.yaml # runtime detection
├── scripts/
│   ├── scan-manifests.sh            # local scan (mirrors CI)
│   └── setup-kind.sh                # local cluster demo
├── docs/
│   ├── ARCHITECTURE.md · THREAT_MODEL.md · HARDENING-CHECKLIST.md
├── .github/workflows/k8s-security.yml
├── .kube-linter.yaml · Makefile
└── SECURITY · CONTRIBUTING · CODE_OF_CONDUCT · CHANGELOG · LICENSE
```

## 🧰 Technology Stack

`Kubernetes` · `Pod Security Admission` · `NetworkPolicy` · `RBAC` · `Falco` · `Trivy` ·
`kube-linter` · `kubeconform` · `kind` · `GitHub Actions`

## 🔐 Security & Threat Model

Reporting: **[SECURITY.md](SECURITY.md)**. STRIDE analysis + blocked attack paths:
**[docs/THREAT_MODEL.md](docs/THREAT_MODEL.md)**. Reusable checklist:
**[docs/HARDENING-CHECKLIST.md](docs/HARDENING-CHECKLIST.md)**.

## 🗺️ Roadmap

- [ ] Image signing/verification (Cosign)
- [ ] Policy engine examples (Kyverno / OPA Gatekeeper)
- [ ] kube-bench (CIS Benchmark) node hardening
- [ ] Helm chart packaging

## ❓ FAQ

<details><summary><b>Why does the insecure pod get rejected?</b></summary>
The <code>secure-demo</code> namespace is labelled with Pod Security Admission
<code>enforce: restricted</code>, so the API server refuses to admit privileged/root/host-namespace
pods. That rejection is the demonstration.</details>

<details><summary><b>Do I need a real cluster?</b></summary>
No — <code>make up</code> uses <a href="https://kind.sigs.k8s.io/">kind</a> (Kubernetes in Docker),
so everything runs locally.</details>

## 🤝 Contributing

See **[CONTRIBUTING.md](CONTRIBUTING.md)** and the **[Code of Conduct](CODE_OF_CONDUCT.md)**.

## 📄 License

[MIT](LICENSE) © 2026 devsecforge

---

<div align="center"><sub>Part of an open DevSecOps portfolio. ⭐ Star it if it's useful.</sub></div>
