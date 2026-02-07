# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |

## Reporting a Vulnerability

Report security issues via [GitHub Issues](../../issues) with the label `security`.

For critical vulnerabilities, use GitHub's private vulnerability reporting feature.

## Security Measures

- Charts scanned with [Kubescape](https://kubescape.io/) on every build
- Artifacts signed with [Cosign](https://docs.sigstore.dev/cosign/overview/)
- Non-root containers (UID 1001)
- Automated dependency updates via Renovate
