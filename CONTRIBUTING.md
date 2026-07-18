# Contributing

Thanks for helping improve the Kubernetes Security Lab!

## Ground rules
- New manifests must pass `kubeconform`, `kube-linter`, and `trivy config` (CI enforces this).
- Hardened examples go in `manifests/`; intentionally-insecure teaching examples go in
  `manifests/insecure/` and must carry a clear warning comment.
- Every control you add should map to a line in `docs/HARDENING-CHECKLIST.md`.
- Run `./scripts/scan-manifests.sh` before opening a PR.

## Commit convention
[Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, `ci:`.

## PRs
Fill out the template, keep changes focused, ensure CI is green. Contributions are MIT-licensed.
