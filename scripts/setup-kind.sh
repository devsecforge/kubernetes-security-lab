#!/usr/bin/env bash
# setup-kind.sh — spin up a local kind cluster and apply the hardened manifests,
# so you can watch PSA reject the insecure pod live.
# Requires: docker, kind, kubectl.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLUSTER="k8s-security-lab"

for t in docker kind kubectl; do
  command -v "$t" >/dev/null 2>&1 || { echo "Missing required tool: $t"; exit 1; }
done

echo "[*] Creating kind cluster '$CLUSTER'..."
kind get clusters | grep -qx "$CLUSTER" || kind create cluster --name "$CLUSTER"

echo "[*] Applying hardened manifests..."
kubectl apply -f "$ROOT_DIR/manifests/00-namespace.yaml"
kubectl apply -f "$ROOT_DIR/manifests/01-rbac.yaml"
kubectl apply -f "$ROOT_DIR/manifests/02-network-policy.yaml"
kubectl apply -f "$ROOT_DIR/manifests/03-deployment-hardened.yaml"

echo
echo "[*] Now try the INSECURE manifest — PSA should REJECT it:"
echo "    kubectl apply -f manifests/insecure/vulnerable-deployment.yaml"
echo
echo "[*] Inspect: kubectl -n secure-demo get pods,netpol,role,rolebinding"
echo "[*] Teardown: kind delete cluster --name $CLUSTER"
