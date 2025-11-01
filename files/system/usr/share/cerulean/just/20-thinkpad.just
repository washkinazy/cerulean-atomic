# vim: set ft=make :

# Apply ThinkPad-specific hardware optimizations
thinkpad-setup:
    #!/usr/bin/bash
    set -euo pipefail
    source /usr/share/cerulean/just/colors.sh

    echo -e "${BLUE}Applying ThinkPad hardware optimizations...${NC}"
    echo ""

    # Kernel arguments
    echo -e "${BLUE}Adding kernel argument: acpi.ec_no_wakeup=1${NC}"
    echo "   (Reduces suspend power usage)"
    if rpm-ostree kargs | grep -q "acpi.ec_no_wakeup=1"; then
        echo -e "   ${GREEN}Already present${NC}"
    else
        rpm-ostree kargs --append="acpi.ec_no_wakeup=1"
        echo -e "   ${GREEN}Added${NC}"
    fi

    echo ""

    # WiFi workaround
    echo -e "${BLUE}Installing WiFi module reset script...${NC}"
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
    echo -e "   ${GREEN}Installed to /etc/systemd/system-sleep/reset-wifi-module.sh${NC}"

    echo ""
    echo -e "${GREEN}ThinkPad optimizations applied!${NC}"
    echo -e "${YELLOW}Reboot required to activate kernel arguments${NC}"
    echo ""
    echo "To undo kernel arguments later:"
    echo '   rpm-ostree kargs --delete="acpi.ec_no_wakeup=1"'

# Remove ThinkPad-specific optimizations
thinkpad-remove:
    #!/usr/bin/bash
    set -euo pipefail
    source /usr/share/cerulean/just/colors.sh

    echo -e "${BLUE}Removing ThinkPad hardware optimizations...${NC}"
    echo ""

    # Remove kernel arguments
    echo -e "${BLUE}Removing kernel argument: acpi.ec_no_wakeup=1${NC}"
    if rpm-ostree kargs | grep -q "acpi.ec_no_wakeup=1"; then
        rpm-ostree kargs --delete="acpi.ec_no_wakeup=1"
        echo -e "   ${GREEN}Removed${NC}"
    else
        echo -e "   ${CYAN}Not present${NC}"
    fi

    echo ""

    # Remove WiFi workaround
    echo -e "${BLUE}Removing WiFi module reset script...${NC}"
    if [ -f /etc/systemd/system-sleep/reset-wifi-module.sh ]; then
        sudo rm /etc/systemd/system-sleep/reset-wifi-module.sh
        echo -e "   ${GREEN}Removed${NC}"
    else
        echo -e "   ${CYAN}Not present${NC}"
    fi

    echo ""
    echo -e "${GREEN}ThinkPad optimizations removed!${NC}"
    echo -e "${YELLOW}Reboot required to activate changes${NC}"
