#!/usr/bin/env bash

# Syntax: ./install-packages.sh [upgrade packages]

UPGRADE_PACKAGES=${1:-"true"}

set -e

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# Function to run apt-get if needed
apt-get-update-if-needed()
{
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update
    else
        echo "Skipping apt-get update."
    fi
}

# Install package list(s)
PACKAGE_LIST="apt-utils \
    curl \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    supervisor \
    iputils-ping \
    nodejs \
    wget \
    unzip \
    vim \
    git \
    jq \
    zlib1g-dev \
    gettext \
    build-essential \
    libssl-dev
    liblttng-ust0 \
    libffi-dev \
    libcurl4-openssl-dev \
    openssh-client \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    sudo"

apt-get-update-if-needed

echo "Packages to verify are installed: ${PACKAGE_LIST}"
apt-get -y install --no-install-recommends ${PACKAGE_LIST} 2> >( grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2 )

# Install apt-transport-https, curl, lsb-release, gpg if missing
if ! dpkg -s apt-transport-https curl ca-certificates lsb-release > /dev/null 2>&1 || ! type gpg > /dev/null 2>&1; then
    apt-get-update-if-needed
    apt-get -y install --no-install-recommends apt-transport-https curl ca-certificates lsb-release gnupg2 
fi

# Get to latest versions of all packages
if [ "${UPGRADE_PACKAGES}" = "true" ]; then
    apt-get-update-if-needed
    apt-get -y upgrade --no-install-recommends
    apt-get autoremove -y
fi

# Install Powershell
if type pwsh > /dev/null 2>&1; then
    echo "Powershell already installed."
else
    DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
    DISTRO_VERSION=10
    curl -L -O "https://packages.microsoft.com/config/${DISTRO}/${DISTRO_VERSION}/packages-microsoft-prod.deb"
    sudo dpkg -i packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install -y powershell

    rm -rf packages-microsoft-prod.deb
fi

# Install Azure CLI
if type az > /dev/null 2>&1; then
    echo "Azure CLI already installed."
else 
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi

# Install Azure Az Powershell module
pwsh -Command "Install-Module -Name 'Az' -AllowClobber -Force"

echo "Done!"