# Cerulean Atomic

[![bluebuild build badge](https://github.com/washkinazy/cerulean-atomic/actions/workflows/build.yml/badge.svg)](https://github.com/washkinazy/cerulean-atomic/actions/workflows/build.yml)

A minimal Fedora Atomic image with COSMIC desktop, latest kernel, and container-first development workflow.

## Installation

To rebase an existing Fedora Atomic installation to Cerulean:

First rebase to the unsigned image to install signing keys and policies:
```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/washkinazy/cerulean:42
systemctl reboot
```

Then rebase to the signed image:
```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/washkinazy/cerulean:42
systemctl reboot
```

## Available Images

- `cerulean:43` - Fedora 42 stable
- `cerulean:rawhide` - Fedora Rawhide (bleeding edge)

## ISO Installation

Generate a bootable ISO locally:
```bash
just iso-43        # Fedora 43
just iso-rawhide   # Fedora Rawhide
```

After installing from the ISO, you must rebase to the container image:
```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/washkinazy/cerulean:42
systemctl reboot
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/washkinazy/cerulean:42
systemctl reboot
```

## Verification

Images are signed with cosign. Verify the signature:

```bash
cosign verify --key cosign.pub ghcr.io/washkinazy/cerulean:42
```

## Development

Build locally:
```bash
just build-43      # Build Fedora 42 image
just build-rawhide # Build Fedora Rawhide image
```
