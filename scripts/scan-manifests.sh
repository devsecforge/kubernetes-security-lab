#!/usr/bin/env bash
# scan-manifests.sh — run the same security checks locally as CI does.
# Usage: ./scripts/scan-manifests.sh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

blue() { printf '\033[0;34m%s\033[0m\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

blue "== 1/3 Schema validation (kubeconform) =="
if have kubeconform; then
  kubeconform -strict -summary -ignore-missing-schemas manifests/
else echo "  skip: kubeconform not installed"; fi

blue "== 2/3 Security lint (kube-linter) =="
if have kube-linter; then
  kube-linter lint --config .kube-linter.yaml manifests/ || true
else echo "  skip: kube-linter not installed"; fi

blue "== 3/3 Misconfiguration scan (trivy config) =="
if have trivy; then
  trivy config --severity HIGH,CRITICAL manifests/
else echo "  skip: trivy not installed"; fi

blue "Done. (The insecure sample under manifests/insecure/ is expected to flag findings.)"
