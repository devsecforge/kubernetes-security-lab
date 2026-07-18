# Security Policy

## Reporting a Vulnerability

Found a security issue in these manifests, rules, or CI config?

1. **Do not** open a public issue.
2. Use GitHub **[Private vulnerability reporting](https://github.com/devsecforge/kubernetes-security-lab/security/advisories/new)** (Security tab → "Report a vulnerability").
3. Include the affected file, the misconfiguration, and its impact.

Acknowledgement within **72 hours**; remediation timeline after triage.

## Note on the insecure sample

`manifests/insecure/vulnerable-deployment.yaml` is **intentionally insecure** for training and is
excluded from the gating scan. Its issues are documented, not vulnerabilities to report.
