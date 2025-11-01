#!/usr/bin/env bash

set -oue pipefail

echo "NVIDIA Post-Install Configuration"
echo "=================================="

# 1. Install SELinux policy for nvidia-container-toolkit
echo "Installing NVIDIA container toolkit SELinux policy..."
semodule --verbose --install /usr/share/selinux/packages/nvidia-container.pp

# 2. Configure DRM kernel modesetting for Wayland support
echo "Configuring NVIDIA DRM modesetting (required for Wayland/COSMIC)..."
cat > /usr/lib/modprobe.d/nvidia-modeset.conf <<'EOF'

# Nvidia modesetting support. Set to 0 or comment to disable kernel modesetting
# support. This must be disabled in case of SLI Mosaic.

options nvidia-drm modeset=1 fbdev=1

EOF

cp /usr/lib/modprobe.d/nvidia-modeset.conf /etc/modprobe.d/nvidia-modeset.conf

# 3. Configure early driver loading for boot reliability
echo "Configuring early NVIDIA driver loading..."
sed -i 's@omit_drivers@force_drivers@g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf
sed -i 's@ nvidia @ i915 amdgpu nvidia @g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf

# 4. Remove third-party repos for security
echo "Removing third-party NVIDIA repositories..."
rm -f /etc/yum.repos.d/negativo17-fedora-nvidia.repo
rm -f /etc/yum.repos.d/nvidia-container-toolkit.repo

echo "NVIDIA post-install configuration complete!"
