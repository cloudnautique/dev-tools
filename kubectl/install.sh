#!/bin/bash

# Define the installation directory
INSTALL_DIR="${GPTSCRIPT_TOOL_DIR}/bin"
KUBECTL_PATH="$INSTALL_DIR/kubectl"

# Check if kubectl is already installed
if [ -f "$KUBECTL_PATH" ]; then
    echo "kubectl is already installed at $KUBECTL_PATH"
    exit 0
fi

# Determine the operating system and architecture
OS_TYPE=$(uname | tr '[:upper:]' '[:lower:]')
MACHINE_TYPE=$(uname -m)

# Map machine type to kubectl download URL
case "$MACHINE_TYPE" in
    x86_64)
        ARCH="amd64"
        ;;
    armv8*|aarch64*|arm64)
        ARCH="arm64"
        ;;
    armv7*)
        ARCH="arm"
        ;;
    *)
        echo "Unsupported machine type: $MACHINE_TYPE"
        exit 1
        ;;
esac

# Handle different OS types
case "$OS_TYPE" in
    linux)
        ;;
    darwin)
        OS_TYPE="darwin"
        ;;
    *)
        echo "Unsupported OS type: $OS_TYPE"
        echo "For Windows, consider using WSL or a compatible shell like Git Bash."
        exit 1
        ;;
esac

# Download the latest version of kubectl
KUBECTL_URL="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/$OS_TYPE/$ARCH/kubectl"

# Create the installation directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Download and install kubectl
curl -Lo "$KUBECTL_PATH" "$KUBECTL_URL"
chmod +x "$KUBECTL_PATH"

echo "kubectl has been installed at $KUBECTL_PATH"
