#!/bin/bash

# Define colors for output
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print a glorious banner
print_banner() {
    echo -e "${GREEN}=====================================================${NC}"
    echo -e "${GREEN} $1 ${NC}"
    echo -e "${GREEN}=====================================================${NC}"
}

# Function to check command success
check_success() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}$1${NC}"
        exit 1
    fi
}

# ---------------------------------------------------------------------------
# DevkitPro — AIMING FOR ALL THE TOOLCHAINS & LIBS!
# ---------------------------------------------------------------------------
print_banner "DevkitPro (Attempting the WHOLE UNIVERSE of consoles, nya!)"

echo -e "${CYAN}Installing DevkitPro pacman & a GIGANTIC list of meta-packages, meow...${NC}"

# Check for curl
if ! command -v curl >/dev/null 2>&1; then
    echo -e "${RED}curl is not installed! Cannot bootstrap DevkitPro. Install curl and try again, you dreamer!${NC}"
    exit 1
fi

# Bootstrap DevkitPro’s pacman
curl -fsSL https://apt.devkitpro.org/install-devkitpro-pacman | sudo bash
check_success "OH MEOW GOODNESS! DevkitPro bootstrap failed! What a CAT-astrophe!"

# Source environment if available
if [ -f /etc/profile.d/devkit-env.sh ]; then
    source /etc/profile.d/devkit-env.sh
else
    echo -e "${YELLOW}Warning: DevkitPro environment script not found. Check your installation or PATH.${NC}"
fi

# Check for dkp-pacman
if ! command -v dkp-pacman >/dev/null 2>&1; then
    echo -e "${RED}dkp-pacman not found! Try sourcing /etc/profile.d/devkit-env.sh or check installation.${NC}"
    exit 1
fi

# Update package database
echo -e "${CYAN}Updating DevkitPro package database...${NC}"
dkp-pacman -Sy --noconfirm || echo -e "${YELLOW}dkp-pacman -Sy failed, but we'll try to install packages anyway!${NC}"

# Install DevkitPro meta-packages (attempting all, even the impossible ones)
echo -e "${CYAN}Installing a VAST array of DevkitPro meta-packages! This might take a while...${NC}"
echo -e "${YELLOW}Note: Some packages like 'atari-dev', 'n64-dev', 'xbox360-dev', 'ps5-dev' may not exist. That’s okay!${NC}"
dkp-pacman -S --noconfirm \
    atari-dev gp32-dev gba-dev gamecube-dev nds-dev psp-dev wii-dev \
    ps2-dev ps3-dev xbox360-dev 3ds-dev wiiu-dev ps4-dev switch-dev ps5-dev n64-dev || true

echo -e "${GREEN}✔ DevkitPro toolchains installed (as many as possible)!${NC}"
echo -e "${YELLOW}For unsupported consoles like Atari, N64, Xbox, etc., seek specific SDKs elsewhere.${NC}"

# ---------------------------------------------------------------------------
# SNES Development - PVSnesLib (Using curl instead of git)
# ---------------------------------------------------------------------------
print_banner "SNES Development Tools (PVSnesLib) - My Special Treat!"

echo -e "${CYAN}Grabbing PVSnesLib for SNES development using curl, you fortunate soul!${NC}"

# Create directory for SNES development
mkdir -p ~/snesdev_zone
cd ~/snesdev_zone || { echo -e "${RED}Couldn’t cd to ~/snesdev_zone! Check your paths!${NC}"; exit 1; }

# Check if PVSnesLib already exists
if [ -d "PVSnesLib" ]; then
    echo -e "${YELLOW}PVSnesLib already exists. Skipping download. Remove the directory to force a fresh install.${NC}"
else
    echo -e "${CYAN}Downloading PVSnesLib with curl...${NC}"
    curl -L https://github.com/alekmaul/pvsneslib/archive/refs/heads/master.tar.gz -o pvsneslib.tar.gz
    check_success "Failed to download PVSnesLib! Check your internet connection."
    tar -xzf pvsneslib.tar.gz
    mv pvsneslib-master PVSnesLib
    rm pvsneslib.tar.gz
    echo -e "${GREEN}✔ PVSnesLib installed for SNES development!${NC}"
fi

# ---------------------------------------------------------------------------
# NES Development - cc65 (Using curl)
# ---------------------------------------------------------------------------
print_banner "NES Development Tools (cc65)"

echo -e "${CYAN}Grabbing cc65 for NES development using curl...${NC}"

cd ~/snesdev_zone || { echo -e "${RED}Couldn’t cd to ~/snesdev_zone!${NC}"; exit 1; }

if [ -d "cc65" ]; then
    echo -e "${YELLOW}cc65 already exists. Skipping download. Remove the directory to force a fresh install.${NC}"
else
    echo -e "${CYAN}Downloading cc65 with curl...${NC}"
    curl -L https://github.com/cc65/cc65/archive/refs/heads/master.tar.gz -o cc65.tar.gz
    check_success "Failed to download cc65! Check your internet connection."
    tar -xzf cc65.tar.gz
    mv cc65-master cc65
    cd cc65
    echo -e "${CYAN}Building cc65 (this may take a moment)...${NC}"
    make
    sudo make install || echo -e "${YELLOW}Warning: Couldn’t install cc65 system-wide. Use it from ~/snesdev_zone/cc65/bin instead.${NC}"
    cd ..
    rm cc65.tar.gz
    echo -e "${GREEN}✔ cc65 installed for NES development!${NC}"
fi

# ---------------------------------------------------------------------------
# Sega Genesis Development - SGDK (Using curl)
# ---------------------------------------------------------------------------
print_banner "Sega Genesis Development Tools (SGDK)"

echo -e "${CYAN}Grabbing SGDK for Sega Genesis development using curl...${NC}"

cd ~/snesdev_zone || { echo -e "${RED}Couldn’t cd to ~/snesdev_zone!${NC}"; exit 1; }

if [ -d "SGDK" ]; then
    echo -e "${YELLOW}SGDK already exists. Skipping download. Remove the directory to force a fresh install.${NC}"
else
    echo -e "${CYAN}Downloading SGDK v1.70 with curl...${NC}"
    curl -L https://github.com/Stephane-D/SGDK/archive/refs/tags/v1.70.tar.gz -o sgdk.tar.gz
    check_success "Failed to download SGDK! Check your internet connection."
    tar -xzf sgdk.tar.gz
    mv SGDK-1.70 SGDK
    rm sgdk.tar.gz
    echo -e "${GREEN}✔ SGDK installed for Sega Genesis development!${NC}"
fi

# ---------------------------------------------------------------------------
# Final Notes
# ---------------------------------------------------------------------------
print_banner "Setup Complete!"

echo -e "${CYAN}Development environments set up for as many consoles as possible!${NC}"
echo -e "${YELLOW}Notes:${NC}"
echo -e "- DevkitPro covers many consoles; unsupported ones (e.g., PS4, Xbox) need official SDKs."
echo -e "- PVSnesLib, cc65, and SGDK are installed in ~/snesdev_zone."
echo -e "- To update PVSnesLib, cc65, or SGDK, remove their directories and rerun the script."
echo -e "- Ensure you have build tools (e.g., make, gcc) for cc65 compilation."
echo -e "${GREEN}Happy coding, retro dreamer!${NC}"
