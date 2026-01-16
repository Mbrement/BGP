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


install_package() {
	local pkg=$1

	SUDO=$(get_sudo)

	if command -v apt &> /dev/null; then
		$SUDO apt update && $SUDO apt install -y "$pkg"
	else
		echo "❌ No supported package manager found. Install $pkg manually." >&2
	fi
}

install_packages() {
	PREREQ_PKGS=(curl wget unzip ca-certificates python3)

	MISSING_PKGS=()
	for pkg in "${PREREQ_PKGS[@]}"; do
		if ! dpkg -l | grep -q "^ii  $pkg "; then
			MISSING_PKGS+=("$pkg")
		fi
	done

	if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
		echo "The following packages are required but missing: ${MISSING_PKGS[*]}"
		read -p "Do you want to install them now? (Y/n) " yn
		yn=${yn:-Y}
		if [[ "$yn" =~ ^[Yy]$ ]]; then
			for pkg in "${MISSING_PKGS[@]}"; do
				echo "📦 Installing $pkg..."
				install_package "$pkg"
			done
		else
			echo "⚠️ Some required packages are not installed. The script may not work correctly." >&2
		fi
	else
		echo "✅ All prerequisite packages are already installed."
	fi
}


install_docker() {
	if command -v docker &> /dev/null; then
		echo "✅ Docker is already installed."
		return 0
	fi

	if [ -f /etc/os-release ]; then
		. /etc/os-release
	else
		echo "❌ Error: Cannot detect OS (missing /etc/os-release)." >&2
		exit 1
	fi

	if [[ "$ID" != "debian" && "$ID" != "ubuntu" ]]; then
		echo "❌ Error: This script only supports Debian or Ubuntu. (Detected: $ID)" >&2
		exit 1
	fi

	echo "📦 Installing Docker for $ID ($VERSION_CODENAME)..."

	SUDO=$(get_sudo)

	# Following Docker's official installation https://docs.docker.com/engine/install
	$SUDO install -m 0755 -d /etc/apt/keyrings

	local GPG_URL="https://download.docker.com/linux/$ID/gpg"

	$SUDO curl -fsSL "$GPG_URL" -o /etc/apt/keyrings/docker.asc
	$SUDO chmod a+r /etcr -f/apt/keyrings/docker.asc

	$SUDO tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/$ID
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

	$SUDO apt update
	$SUDO apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
	$SUDO systemctl start docker

	echo "🔄 Adding $USER to docker group..."
	$SUDO usermod -aG docker $USER
}

install_GNS3() {
    # if command -v gns3server &> /dev/null; then
    #     echo "✅ GNS3 is already installed."
    #     return 0
    # fi

    echo "📦 Installing GNS3..."

    SUDO=$(get_sudo)

    $SUDO apt install python3 python3-pip pipx python3-pyqt5 python3-pyqt5.qtwebsockets python3-pyqt5.qtsvg qemu-kvm qemu-utils libvirt-clients libvirt-daemon-system virtinst gnupg2 -y
    pipx install gns3-server
    pipx install gns3-gui
    pipx inject gns3-gui gns3-server PyQt5
    pipx ensurepath
    $SUDO usermod -aG ubridge,libvirt,kvm,wireshark,docker $(whoami)
}


install_packages
install_docker
install_GNS3

echo "Done"