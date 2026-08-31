# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 2.7.x   | :white_check_mark: |
| < 2.7   | :x:                |

Only the latest stable release is actively supported. Please upgrade before reporting.

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

1. **Do not** open a public issue.
2. Email the maintainer via the contact listed on the [GitHub profile](https://github.com/KikiManjaro) or open a [private security advisory](https://github.com/KikiManjaro/KikAis/security/advisories/new).
3. Include a description, steps to reproduce, and potential impact.

You will receive an initial response within 7 days. Once the issue is confirmed, a fix will be prioritized and a new release published.

## Scope

- NMEA parsing and forwarding — malformed input must not crash the app.
- Network feeds (UDP/TCP) and RTL-SDR input handling.
- Dependency supply chain (`pubspec.yaml` / `pubspec.lock`).

CI includes a [gitleaks](https://github.com/gitleaks/gitleaks) secrets scan on every push and pull request.
