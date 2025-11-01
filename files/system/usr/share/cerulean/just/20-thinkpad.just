# vim: set ft=make :

# Apply ThinkPad-specific hardware optimizations
thinkpad-setup:
    #!/usr/bin/bash
    set -euo pipefail

    echo "🔧 Applying ThinkPad hardware optimizations..."
    echo ""

    # Kernel arguments
    echo "📝 Adding kernel argument: acpi.ec_no_wakeup=1"
    echo "   (Reduces suspend power usage)"
    if rpm-ostree kargs | grep -q "acpi.ec_no_wakeup=1"; then
        echo "   ✅ Already present"
    else
        rpm-ostree kargs --append="acpi.ec_no_wakeup=1"
        echo "   ✅ Added"
    fi

    echo ""

    # WiFi workaround
    echo "📡 Installing WiFi module reset script..."
    echo "   (Fixes Qualcomm ath11k_pci suspend/resume issues)"

    sudo tee /etc/systemd/system-sleep/reset-wifi-module.sh > /dev/null <<'EOF'
#!/bin/bash
# WiFi module reset workaround for Qualcomm ath11k_pci
# Unloads module before suspend, reloads after resume

case "$1" in
    pre)
        logger "Reset-WiFi-Module: Unloading ath11k_pci before suspend"
        modprobe -r ath11k_pci
        ;;
    post)
        logger "Reset-WiFi-Module: Reloading ath11k_pci after resume"
        modprobe ath11k_pci
        ;;
esac
EOF

    sudo chmod +x /etc/systemd/system-sleep/reset-wifi-module.sh
    echo "   ✅ Installed to /etc/systemd/system-sleep/reset-wifi-module.sh"

    echo ""
    echo "✅ ThinkPad optimizations applied!"
    echo "⚠️  Reboot required to activate kernel arguments"
    echo ""
    echo "To undo kernel arguments later:"
    echo '   rpm-ostree kargs --delete="acpi.ec_no_wakeup=1"'

# Remove ThinkPad-specific optimizations
thinkpad-remove:
    #!/usr/bin/bash
    set -euo pipefail

    echo "🔧 Removing ThinkPad hardware optimizations..."
    echo ""

    # Remove kernel arguments
    echo "📝 Removing kernel argument: acpi.ec_no_wakeup=1"
    if rpm-ostree kargs | grep -q "acpi.ec_no_wakeup=1"; then
        rpm-ostree kargs --delete="acpi.ec_no_wakeup=1"
        echo "   ✅ Removed"
    else
        echo "   ℹ️  Not present"
    fi

    echo ""

    # Remove WiFi workaround
    echo "📡 Removing WiFi module reset script..."
    if [ -f /etc/systemd/system-sleep/reset-wifi-module.sh ]; then
        sudo rm /etc/systemd/system-sleep/reset-wifi-module.sh
        echo "   ✅ Removed"
    else
        echo "   ℹ️  Not present"
    fi

    echo ""
    echo "✅ ThinkPad optimizations removed!"
    echo "⚠️  Reboot required to activate changes"
