#!/bin/sh

# 🧑‍💻 Bobbis Systems — setup_user.sh
# Creates a system user, optionally sets password, and writes to /etc/bobbis-user.conf

UX=true
USER="dockerdev"

# === 🔧 Parse Flags ===
for arg in "$@"; do
  case $arg in
    --user=*) USER="${arg#*=}" ;;
    --no-ux) UX=false ;;
  esac
done

# === 🖼️ UX Banner ===
print_banner() {
  echo "╔════════════════════════════════════════╗"
  echo "║ 👤 Bobbis Systems — User Setup Wizard ║"
  echo "╚════════════════════════════════════════╝"
}

# === ✅ Create User ===
create_user() {
  if id "$USER" >/dev/null 2>&1; then
    [ "$UX" = true ] && echo "ℹ️  User '$USER' already exists."
  else
    adduser -D "$USER"
    echo "✅ User '$USER' created."
  fi
}

# === 🔐 Set Password (optional) ===
set_password_prompt() {
  echo "🔐 Do you want to set a password for '$USER'? [Y/n]"
  read -r SET_PWD
  if [ "$SET_PWD" = "Y" ] || [ "$SET_PWD" = "y" ] || [ -z "$SET_PWD" ]; then
    passwd "$USER"
  fi
}

# === 📝 Write config ===
write_config() {
  echo "DEFAULT_USER="$USER"" > /etc/bobbis-user.conf
  echo "ℹ️  Saved user to /etc/bobbis-user.conf"
}

# === 🚀 Run Logic ===
if [ "$UX" = true ]; then
  print_banner
  echo "Default user: [$USER]"
  echo "Press [Enter] to use, or type a different username:"
  read -r USER_INPUT
  [ -n "$USER_INPUT" ] && USER="$USER_INPUT"
fi

create_user
[ "$UX" = true ] && set_password_prompt
write_config
