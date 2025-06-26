#!/bin/sh

# 🐳 Bobbis Systems — setup_docker.sh
# Installs Docker, docker-compose, configures groups, and sets up Docker home directory.

UX=true
USER=""
DOCKER_HOME="/opt/docker"

# === 🔧 Parse Flags ===
for arg in "$@"; do
  case $arg in
    --user=*) USER="${arg#*=}" ;;
    --set-folder=*) DOCKER_HOME="${arg#*=}" ;;
    --no-ux) UX=false ;;
    --install) ;;  # Reserved for future --install-only logic
  esac
done

# === 🖼️ UX Banner ===
print_banner() {
  echo "╔═══════════════════════════════════════════╗"
  echo "║ 🐳 Bobbis Systems — Docker Setup Wizard  ║"
  echo "╚═══════════════════════════════════════════╝"
}

# === 📖 Load user from config if not provided ===
if [ -z "$USER" ] && [ -f /etc/bobbis.conf ]; then
  . /etc/bobbis.conf
  USER="$DEFAULT_USER"
fi

if [ -z "$USER" ]; then
  echo "❌ No user provided. Use --user=username or create user first."
  exit 1
fi

# === 🧩 Ensure community repo is enabled ===
if ! apk search docker >/dev/null 2>&1; then
  sed -i '/^#.*community/ s/^#//' /etc/apk/repositories
  apk update
fi

# === 🐳 Install Docker ===
install_docker() {
  apk add --no-cache docker docker-cli-compose
  rc-update add docker boot
  service docker start
  echo "✅ Docker and docker-compose installed and running"
}

# === 👥 Create docker group and add user ===
setup_docker_group() {
  getent group docker >/dev/null 2>&1 || addgroup docker
  adduser "$USER" docker
  echo "✅ Added '$USER' to docker group"
}

# === 📁 Create Docker Home Directory ===
create_docker_home() {
  mkdir -p "$DOCKER_HOME"/{containers,volumes,config}
  chown -R "$USER":"$USER" "$DOCKER_HOME"
  echo "✅ Docker folders created at $DOCKER_HOME"
}

# === 📝 Write Unified Config ===
write_config() {
  echo "ROLE="docker"" > /etc/bobbis.conf
  echo "LABEL="Docker Host"" >> /etc/bobbis.conf
  echo "DOCKER_HOME="$DOCKER_HOME"" >> /etc/bobbis.conf
  echo "DEFAULT_USER="$USER"" >> /etc/bobbis.conf
  echo "ℹ️  Config saved to /etc/bobbis.conf"
}

# === 🚀 Run Logic ===
if [ "$UX" = true ]; then
  print_banner
  echo "Detected user: $USER"
  echo "Default Docker folder: [$DOCKER_HOME]"
  echo "Press [Enter] to accept, or enter custom path:"
  read -r PATH_INPUT
  [ -n "$PATH_INPUT" ] && DOCKER_HOME="$PATH_INPUT"
fi

install_docker
setup_docker_group
create_docker_home
write_config
