# Cerulean Atomic - Local Development Commands
# Requires: just, bluebuild CLI, podman/docker

# Image name
image_name := "cerulean"

# Available versions
version_42 := "recipe.yml"
version_rawhide := "recipe-rawhide.yml"

# Default recipe to use
default_recipe := version_42

# Show available commands
default:
    @just --list

# Validate recipe syntax
[group('Development')]
check RECIPE=default_recipe:
    @echo "Checking recipe syntax: {{ RECIPE }}"
    bluebuild validate recipes/{{ RECIPE }}

# Build image locally
[group('Development')]
build RECIPE=default_recipe:
    @echo "Building image from recipes/{{ RECIPE }}"
    bluebuild build recipes/{{ RECIPE }}

# Build Fedora 42 variant
[group('Development')]
build-42:
    @just build {{ version_42 }}

# Build Fedora Rawhide variant
[group('Development')]
build-rawhide:
    @just build {{ version_rawhide }}

# Generate bootable ISO for testing
[group('Development')]
iso RECIPE=default_recipe OUTPUT="cerulean.iso":
    @echo "Generating ISO: {{ OUTPUT }}"
    @echo "From recipe: recipes/{{ RECIPE }}"
    bluebuild generate-iso --iso-name {{ OUTPUT }} recipe recipes/{{ RECIPE }}
    @echo "ISO created: {{ OUTPUT }}"
    @echo "Use with: virt-install or dd to USB"

# Generate ISO for Fedora 42
[group('Development')]
iso-42:
    @just iso {{ version_42 }} cerulean-42.iso

# Generate ISO for Fedora Rawhide
[group('Development')]
iso-rawhide:
    @just iso {{ version_rawhide }} cerulean-rawhide.iso

# Clean build artifacts
[group('Development')]
clean:
    @echo "Cleaning build artifacts..."
    rm -f *.iso
    rm -rf .bluebuild-cache
    @echo "Clean complete"

# Format Justfile
[group('Development')]
fmt:
    @just --fmt --unstable
