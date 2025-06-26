#!/bin/sh

# ╔══════════════════════════════════════╗
# ║ 🧊 Bobbis Systems Alpine Bootstrap  ║
# ╚══════════════════════════════════════╝

# === 🔐 Root Check ===
if [ "$(id -u)" -ne 0 ]; then
  echo "❌ This script must be run as root. Try: sudo su"
  exit 1
fi

# === 🧠 OS Detection ===
if grep -qi "alpine" /etc/os-release; then
  echo "✅ Detected Alpine Linux"
elif grep -qi "ubuntu" /etc/os-release; then
  echo "🚫 This script is for Alpine. Try: https://github.com/bobbis-systems/setup-ubuntu"
  exit 1
else
  echo "❌ Unsupported OS. This bootstrap is for Alpine Linux only."
  exit 1
fi

# === 📦 Install Required Tools ===
apk update
apk add --no-cache git curl nano

# === 📁 Clone Repo ===
INSTALL_DIR="/opt/setup-alpine"
if [ ! -d "$INSTALL_DIR" ]; then
  git clone https://github.com/bobbis-systems/setup-alpine.git "$INSTALL_DIR"
else
  echo "📁 Repo already cloned at $INSTALL_DIR"
fi

# === 🎛️ Prompt for Role ===
echo
echo "╔══════════════════════════════════════╗"
echo "║ 🧊 Bobbis Systems Alpine Bootstrap  ║"
echo "╚══════════════════════════════════════╝"
echo
echo "Detected: Clean Alpine VM"
echo "Default role: [docker]"
echo "Press [Enter] to continue as Docker host"
echo "Or enter another type (e.g. proxy, db):"
read -r TYPE_INPUT
TYPE=${TYPE_INPUT:-docker}

# === 👤 Prompt for Username ===
echo
echo "Default user: [dockerdev]"
echo "Press [Enter] to continue with dockerdev"
echo "Or enter a different username:"
read -r USER_INPUT
USER=${USER_INPUT:-dockerdev}

# === 🧪 Dry-run mode support ===
if [ "$1" = "--dry-run" ]; then
  echo "🧪 Dry run enabled. Would execute:"
  echo "sh $INSTALL_DIR/scripts/setup_alpine.sh --type=$TYPE --user=$USER --no-ux"
  exit 0
fi

# === 🚀 Run Setup ===
sh "$INSTALL_DIR/scripts/setup_alpine.sh" --type="$TYPE" --user="$USER" --no-ux

# === 📝 Optional Logging ===
mkdir -p /opt/logs
echo "[$(date)] Bootstrap complete: role=$TYPE, user=$USER" >> /opt/logs/bobbis-setup.log
