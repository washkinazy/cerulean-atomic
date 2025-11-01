# vim: set ft=make :

alias upgrade := update

# Update system and flatpaks
update:
    #!/usr/bin/bash
    set -euo pipefail

    # Check if automatic updates are running
    if systemctl is-active --quiet rpm-ostreed-automatic.service; then
        echo "Automatic updates are currently running"
        echo "Use \`journalctl -fexu rpm-ostreed-automatic.service\` to see logs"
        exit 1
    fi

    echo "Updating ostree system..."
    rpm-ostree upgrade

    # Update system flatpaks
    if flatpak remotes --system 2>/dev/null | grep -q flathub; then
        echo "Updating system flatpaks..."
        flatpak update --system -y
    fi

    # Update user flatpaks
    if flatpak remotes --user 2>/dev/null | grep -q flathub; then
        echo "Updating user flatpaks..."
        flatpak update --user -y
    fi

    echo "Update complete! Reboot to apply system updates."

alias auto-update := toggle-updates

# Toggle automatic updates on or off
toggle-updates ACTION="prompt":
    #!/usr/bin/bash
    CURRENT_STATE="Disabled"
    if systemctl is-enabled -q rpm-ostreed-automatic.timer 2>/dev/null; then
        CURRENT_STATE="Enabled"
    fi

    OPTION="{{ ACTION }}"

    if [ "$OPTION" == "prompt" ]; then
        echo "Automatic updates are currently: $CURRENT_STATE"
        echo ""
        echo "Choose an option:"
        echo "  1) Enable"
        echo "  2) Disable"
        read -p "Selection: " choice
        case $choice in
            1) OPTION="enable" ;;
            2) OPTION="disable" ;;
            *) echo "Invalid choice"; exit 1 ;;
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
        echo "Automatic updates enabled"
    elif [ "${OPTION,,}" == "disable" ]; then
        sudo systemctl disable rpm-ostreed-automatic.timer
        echo "Automatic updates disabled"
    fi

# Show the changelog
changelogs:
    rpm-ostree db diff --changelogs
