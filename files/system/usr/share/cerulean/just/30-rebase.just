# vim: set ft=make :

# Rebase to Cerulean base image (unsigned)
rebase-base-unsigned:
    #!/usr/bin/bash
    set -euo pipefail
    source /usr/share/cerulean/just/colors.sh

    echo -e "${BLUE}Rebasing to Cerulean base image (unsigned)...${NC}"
    echo -e "Image: ${GREEN}ghcr.io/washkinazy/cerulean:latest${NC}"
    echo ""
    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/washkinazy/cerulean:latest
    echo ""
    echo -e "${GREEN}Rebase complete!${NC}"
    echo -e "${YELLOW}Reboot required to apply changes: systemctl reboot${NC}"

# Rebase to Cerulean base image (signed)
rebase-base:
    #!/usr/bin/bash
    set -euo pipefail
    source /usr/share/cerulean/just/colors.sh

    echo -e "${BLUE}Rebasing to Cerulean base image (signed)...${NC}"
    echo -e "Image: ${GREEN}ghcr.io/washkinazy/cerulean:latest${NC}"
    echo ""
    sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/washkinazy/cerulean:latest
    echo ""
    echo -e "${GREEN}Rebase complete!${NC}"
    echo -e "${YELLOW}Reboot required to apply changes: systemctl reboot${NC}"

# Rebase to Cerulean NVIDIA image (unsigned)
rebase-nvidia-unsigned:
    #!/usr/bin/bash
    set -euo pipefail
    source /usr/share/cerulean/just/colors.sh

    echo -e "${BLUE}Rebasing to Cerulean NVIDIA image (unsigned)...${NC}"
    echo -e "Image: ${GREEN}ghcr.io/washkinazy/cerulean-nvidia:latest${NC}"
    echo ""
    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/washkinazy/cerulean-nvidia:latest
    echo ""
    echo -e "${GREEN}Rebase complete!${NC}"
    echo -e "${YELLOW}Reboot required to apply changes: systemctl reboot${NC}"

# Rebase to Cerulean NVIDIA image (signed)
rebase-nvidia:
    #!/usr/bin/bash
    set -euo pipefail
    source /usr/share/cerulean/just/colors.sh

    echo -e "${BLUE}Rebasing to Cerulean NVIDIA image (signed)...${NC}"
    echo -e "Image: ${GREEN}ghcr.io/washkinazy/cerulean-nvidia:latest${NC}"
    echo ""
    sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/washkinazy/cerulean-nvidia:latest
    echo ""
    echo -e "${GREEN}Rebase complete!${NC}"
    echo -e "${YELLOW}Reboot required to apply changes: systemctl reboot${NC}"
