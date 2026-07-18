# Kubernetes Security Lab — entrypoints.
.DEFAULT_GOAL := help
SHELL := /bin/bash

.PHONY: help scan up down insecure

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

scan: ## Run local security scans (kubeconform + kube-linter + trivy)
	@bash scripts/scan-manifests.sh

up: ## Create kind cluster and apply hardened manifests
	@bash scripts/setup-kind.sh

insecure: ## Try to apply the insecure sample (PSA should reject it)
	@kubectl apply -f manifests/insecure/vulnerable-deployment.yaml

down: ## Delete the kind cluster
	@kind delete cluster --name k8s-security-lab
