#!/bin/sh

# 🔐 Bobbis Systems — sudo.sh
# Installs sudo, adds user to wheel group, optionally enables NOPASSWD

UX=true
USER=""
NOPASSWD=false

# === 🔧 Parse Flags ===
for arg in "$@"; do
  case $arg in
    --user=*) USER="${arg#*=}" ;;
    --no-ux) UX=false ;;
    --nopasswd) NOPASSWD=true ;;
  esac
done

# === 🖼️ UX Banner ===
print_banner() {
  echo "╔═════════════════════════════════════╗"
  echo "║ 🔐 Bobbis Systems — Sudo Setup     ║"
  echo "╚═════════════════════════════════════╝"
}

# === 📖 Load user from config if not provided ===
if [ -z "$USER" ] && [ -f /etc/bobbis-user.conf ]; then
  . /etc/bobbis-user.conf
  USER="$DEFAULT_USER"
fi

if [ -z "$USER" ]; then
  echo "❌ No user provided. Use --user=username or create user first."
  exit 1
fi

# === 🛠️ Install sudo ===
install_sudo() {
  if ! command -v sudo >/dev/null 2>&1; then
    apk add --no-cache sudo
    echo "✅ Installed sudo"
  else
    echo "✔️  Sudo already installed"
  fi
}

# === 👥 Add user to wheel ===
add_to_wheel() {
  addgroup wheel 2>/dev/null
  adduser "$USER" wheel
  echo "✅ Added '$USER' to wheel group"
}

# === 📝 Enable NOPASSWD ===
enable_nopasswd() {
  if ! grep -q '%wheel ALL=(ALL) NOPASSWD: ALL' /etc/sudoers; then
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
    echo "✅ Enabled passwordless sudo for wheel group"
  else
    echo "✔️  NOPASSWD already configured"
  fi
}

# === 🚀 Run Logic ===
if [ "$UX" = true ]; then
  print_banner
  echo "Detected user: $USER"
  echo "Install sudo and add '$USER' to wheel group? [Y/n]"
  read -r CONFIRM
  if [ "$CONFIRM" != "n" ] && [ "$CONFIRM" != "N" ]; then
    install_sudo
    add_to_wheel
    echo "Enable passwordless sudo for this user? [y/N]"
    read -r PWDLESS
    if [ "$PWDLESS" = "y" ] || [ "$PWDLESS" = "Y" ]; then
      enable_nopasswd
    else
      echo "ℹ️  Password required for sudo (default behavior)"
    fi
  else
    echo "❌ Sudo setup skipped."
    exit 0
  fi
else
  install_sudo
  add_to_wheel
  [ "$NOPASSWD" = true ] && enable_nopasswd || echo "ℹ️  Password required for sudo (default behavior)"
fi
