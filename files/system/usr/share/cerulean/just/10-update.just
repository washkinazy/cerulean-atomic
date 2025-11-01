# vim: set ft=make :

alias upgrade := update

# Update system and flatpaks
update:
    #!/usr/bin/bash
    set -euo pipefail
    source /usr/share/cerulean/just/colors.sh

    # Check if automatic updates are running
    if systemctl is-active --quiet rpm-ostreed-automatic.service; then
        echo -e "${YELLOW}Automatic updates are currently running${NC}"
        echo -e "Use \`journalctl -fexu rpm-ostreed-automatic.service\` to see logs"
        exit 1
    fi

    echo -e "${BLUE}Updating ostree system...${NC}"
    rpm-ostree upgrade

    # Update system flatpaks
    if flatpak remotes --system 2>/dev/null | grep -q flathub; then
        echo -e "${BLUE}Updating system flatpaks...${NC}"
        flatpak update --system -y
    fi

    # Update user flatpaks
    if flatpak remotes --user 2>/dev/null | grep -q flathub; then
        echo -e "${BLUE}Updating user flatpaks...${NC}"
        flatpak update --user -y
    fi

    echo -e "${GREEN}Update complete!${NC} ${YELLOW}Reboot to apply system updates.${NC}"

alias auto-update := toggle-updates

# Toggle automatic updates on or off
toggle-updates ACTION="prompt":
    #!/usr/bin/bash
    source /usr/share/cerulean/just/colors.sh

    CURRENT_STATE="Disabled"
    if systemctl is-enabled -q rpm-ostreed-automatic.timer 2>/dev/null; then
        CURRENT_STATE="Enabled"
    fi

    OPTION="{{ ACTION }}"

    if [ "$OPTION" == "prompt" ]; then
        echo -e "Automatic updates are currently: ${CYAN}$CURRENT_STATE${NC}"
        echo ""
        echo "Choose an option:"
        echo "  1) Enable"
        echo "  2) Disable"
        read -p "Selection: " choice
        case $choice in
            1) OPTION="enable" ;;
            2) OPTION="disable" ;;
            *) echo -e "${RED}Invalid choice${NC}"; exit 1 ;;
        esac
    elif [ "$OPTION" == "help" ]; then
        echo "Usage: cjust toggle-updates <option>"
        echo "  <option>: Specify 'enable' or 'disable'"
        echo "  Use 'enable' to enable automatic updates"
        echo "  Use 'disable' to disable automatic updates"
        exit 0
    fi

    if [ "${OPTION,,}" == "enable" ]; then
        sudo systemctl enable rpm-ostreed-automatic.timer
        echo -e "${GREEN}Automatic updates enabled${NC}"
    elif [ "${OPTION,,}" == "disable" ]; then
        sudo systemctl disable rpm-ostreed-automatic.timer
        echo -e "${GREEN}Automatic updates disabled${NC}"
    fi

# Show the changelog
changelogs:
    rpm-ostree db diff --changelogs
