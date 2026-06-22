# Contributing

Thanks for your interest in improving these Docker images!

## How to Contribute

### Request a New Extension
1. Open an issue with the title `Extension request: <name>`
2. Check that the extension is [supported upstream](https://github.com/mlocati/docker-php-extension-installer/blob/master/data/supported-extensions)
3. Mention which PHP versions and variants (fpm/cli) you need it for

### Report a Bug
1. Open an issue with details: image tag, variant, error message, steps to reproduce
2. If the bug is about a missing extension, include `php -m` output

### Submit a Pull Request
1. Fork the repo and create a feature branch
2. Make your changes — keep them focused and minimal
3. Test locally:
   ```bash
   docker build --build-arg PHP_VERSION=8.4 --build-arg IMAGE_TYPE=fpm -t test-php .
   docker run --rm test-php php -m
   ```
4. Open a PR against `master` with a clear description

## Project Structure

```
.
├── Dockerfile                    # Main image definition
├── data/
│   ├── installable-extensions    # Extensions we want to install
│   └── supported-extensions      # Upstream compatibility matrix (synced in CI)
├── scripts/
│   └── install-extensions.sh     # Extension filtering and install script
├── php.ini                       # Example hardened PHP config (for mounting)
├── www.conf                      # Example FPM pool config (for mounting)
└── .github/workflows/            # CI/CD pipeline
```

## Code Style
- Keep the Dockerfile readable with clear section headers
- Shell scripts use `#!/bin/bash` with `set -e`
- Extensions in `installable-extensions` are one per line, alphabetized
