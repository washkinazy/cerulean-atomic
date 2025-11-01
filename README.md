# Cerulean Atomic

[![bluebuild build badge](https://github.com/washkinazy/cerulean-atomic/actions/workflows/build.yml/badge.svg)](https://github.com/washkinazy/cerulean-atomic/actions/workflows/build.yml)

A minimal Fedora Atomic image with COSMIC desktop, latest kernel, and container-first development workflow.

## Installation

To rebase an existing Fedora Atomic installation to Cerulean:

First rebase to the unsigned image to install signing keys and policies:
```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/washkinazy/cerulean:latest
systemctl reboot
```

Then rebase to the signed image:
```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/washkinazy/cerulean:latest
systemctl reboot
```

## Available Images

- `cerulean:latest` - Fedora 43
- `cerulean-nvidia:latest` - Fedora 42 with NVIDIA Open drivers (F43 repos not yet mature)

## ISO Installation

Generate a bootable ISO locally:
```bash
just iso-43      # Fedora 43
just iso-nvidia  # Fedora 43 with NVIDIA
```

After installing from the ISO, you must rebase to the container image:
```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/washkinazy/cerulean:latest
systemctl reboot
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/washkinazy/cerulean:latest
systemctl reboot
```

## Verification

Images are signed with cosign. Verify the signature:

```bash
cosign verify --key cosign.pub ghcr.io/washkinazy/cerulean:latest
```

## Development

Build locally:
```bash
just build-43     # Build Fedora 43
just build-nvidia # Build Fedora 43 with NVIDIA
```
