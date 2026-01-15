#!/usr/bin/env bash

set -e

get_sudo() {
	SUDO=""

	if [[ $EUID -ne 0 ]]; then
		if command -v sudo &> /dev/null; then
			SUDO="sudo"
		else
			echo "⚠️ Not root and sudo not found. Trying to install without privileges..." >&2
		fi
	fi

	echo "$SUDO"
}

echo "🧹 Cleaning up environment..."

clean_docker() {
    if ! command -v docker &> /dev/null; then
		echo "✅ Docker is already installed."
		return 0
	fi
	echo "🗑️  Uninstalling Docker and cleaning up all data..."
    SUDO=$(get_sudo)

    $SUDO systemctl stop docker.socket || true
    $SUDO systemctl stop docker || true

    $SUDO apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

    $SUDO apt-get autoremove -y
    $SUDO apt-get autoclean

    echo "Purging Docker directories (/var/lib/docker, /etc/docker)..."
    $SUDO rm -rf /var/lib/docker
    $SUDO rm -rf /var/lib/containerd
    $SUDO rm -rf /etc/docker

    if getent group docker > /dev/null; then
        $SUDO groupdel docker
    fi

    $SUDO rm -f /etc/apt/keyrings/docker.asc
    $SUDO rm -f /etc/apt/sources.list.d/docker.sources

    echo "✨ Docker has been completely removed."
}

clean_GNS3() {
    echo "🗑️  Cleaning up GNS3..."
    SUDO=$(get_sudo)
    $SUDO pipx uninstall gns3-server
    $SUDO pipx uninstall gns3-gui
    echo "Removing GNS3 configuration and project directories..."
    $SUDO apt purge python3-pip pipx python3-pyqt5 python3-pyqt5.qtwebsockets python3-pyqt5.qtsvg qemu-kvm qemu-utils libvirt-clients libvirt-daemon-system virtinst gnupg2 -y
    $SUDO apt autoremove -y
    $SUDO apt autoclean
    
    rm -rf "$HOME/.config/GNS3"
    rm -rf "$HOME/GNS3"

    echo "✨ GNS3 cleanup complete!"
}

# clean_docker
clean_GNS3

echo "✅ Environment cleaned up!"