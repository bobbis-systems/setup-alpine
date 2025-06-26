#!/bin/sh

# 🖥️ Bobbis Systems — motd.sh
# ========================================
# Sets a login MOTD banner based on /etc/bobbis.conf
# Can be run interactively OR silently to regenerate MOTD
#
# 🔧 USAGE:
#
# 🧑 Interactive mode:
#   Run without flags to launch the full UX wizard:
#     sudo sh motd.sh
#
# 🔁 Refresh from saved config:
#   Use --refresh to regenerate MOTD from /etc/bobbis.conf silently:
#     sudo sh motd.sh --refresh
#
# ⚙️ Manual override:
#   You can pass flags to override default behavior:
#     sudo sh motd.sh --role=proxy --label="Proxy Gateway" --user=admin --append="🧠 Dev Mode" --no-ux
#
# ✨ Common Flags:
#   --no-ux         Skip prompts, no interaction
#   --refresh       Force regeneration using config only
#   --role=xxx      Set role override (e.g. docker, proxy)
#   --label="text"  Set display label
#   --user=xxx      Override managed user
#   --append="..."  Add extra line to bottom of MOTD
#
# 📍 MOTD file path: /etc/motd
# ========================================

UX=true
ROLE=""
LABEL=""
USER=""
DOCKER_HOME=""
APPEND_LINE=""
REFRESH=false

# === 📦 Load Config ===
load_config() {
  [ -f /etc/bobbis.conf ] && . /etc/bobbis.conf
  ROLE="${ROLE:-$ROLE}"
  LABEL="${LABEL:-$LABEL}"
  USER="${DEFAULT_USER:-$USER}"
  DOCKER_HOME="${DOCKER_HOME:-$DOCKER_HOME}"
}

# === 📤 Write MOTD ===
write_motd() {
  {
    echo "👑 Welcome to Bobbis Systems"
    [ -n "$LABEL" ] && echo "🧱 Role: $LABEL"
    [ "$ROLE" = "docker" ] && [ -n "$DOCKER_HOME" ] && echo "🐳 Docker Home: $DOCKER_HOME"
    [ -n "$USER" ] && echo "👤 Managed by: $USER"
    [ -n "$APPEND_LINE" ] && echo "$APPEND_LINE"
  } > /etc/motd
  echo "✅ MOTD updated at /etc/motd"
}

# === 🖼️ UX Banner ===
print_banner() {
  echo "╔══════════════════════════════════════╗"
  echo "║ 🖥️ Bobbis Systems — MOTD Generator  ║"
  echo "╚══════════════════════════════════════╝"
}

# === 🔧 Parse Flags ===
for arg in "$@"; do
  case $arg in
    --no-ux) UX=false ;;
    --refresh) REFRESH=true; UX=false ;;
    --role=*) ROLE="${arg#*=}" ;;
    --label=*) LABEL="${arg#*=}" ;;
    --user=*) USER="${arg#*=}" ;;
    --append=*) APPEND_LINE="${arg#*=}" ;;
  esac
done

# === 🚀 Run Logic ===
load_config

if [ "$UX" = true ]; then
  print_banner
  echo "Current role: [$ROLE]  label: [$LABEL]"
  echo "Docker home (if any): [$DOCKER_HOME]"
  echo "User: [$USER]"
  echo "Enter additional line to append (or leave empty):"
  read -r APPEND_LINE
fi

write_motd
