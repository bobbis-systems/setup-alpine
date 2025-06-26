
# 🧊 setup-alpine

**Bobbis Systems Alpine Setup Kit** — UX-first, modular setup tools for provisioning Alpine Linux hosts with roles like Docker.

---

## ✅ Supported Systems

| OS            | Init System | Shell  | Tested Versions     |
|---------------|-------------|--------|---------------------|
| Alpine Linux  | OpenRC      | Busybox| 3.18, 3.19, 3.20+   |

- Requires: `apk`, `git`, `curl`, `nano`
- Root access required for setup

---

## 📦 Repo Purpose

This repository provides a **modular provisioning system** for Alpine-based VMs or servers.

- Scripts are **fully interactive** by default  
- Each script supports **flag-based automation**  
- Designed for **real infrastructure**, not just dev boxes

---

## 🧱 File Structure

```plaintext
setup-alpine/
├── bootstrap.sh               # Entry-point script (wget/curl safe)
├── scripts/
│   ├── setup_alpine.sh        # Master conductor script
│   ├── setup_docker.sh        # Installs + configures Docker
│   ├── setup_user.sh          # Creates login user
│   ├── sudo.sh                # Enables passwordless sudo
│   ├── motd.sh                # Dynamic MOTD setup + branding
│   └── utils.sh               # Shared UX/log/prompt functions
├── assets/
│   └── update-motd/           # Modular login message builders
├── .env.example
├── README.md
└── LICENSE
```

---

## 🚀 Installation Options

### 🧪 1. Manual

```sh
apk add git curl nano
git clone https://github.com/bobbis-systems/setup-alpine.git /opt/setup-alpine
cd /opt/setup-alpine/scripts
sh setup_alpine.sh
```

### ⚡ 2. Bootstrap (Recommended)

```sh
wget -O - https://raw.githubusercontent.com/bobbis-systems/setup-alpine/main/bootstrap.sh | sh
```

This:
- Installs tools
- Clones the repo
- Prompts you to choose a role (e.g. Docker host)

---

## 🎛️ Example Roles

```sh
sh setup_alpine.sh --type=docker --user=dockerdev --no-ux
```

| Type     | Purpose                                           |
|----------|----------------------------------------------------|
| `docker` | Installs Docker engine, sets up folders, MOTD      |
| *(more coming)* | proxy, db, minimal, etc.                  |

---

## ⚙️ Flag System

All scripts support:

| Flag          | Description                            |
|---------------|----------------------------------------|
| `--install`   | Performs install actions               |
| `--no-ux`     | Skips interactive prompts              |
| `--user=xxx`  | Specify system user to operate on      |
| `--type=xxx`  | Specify host role (docker, etc.)       |
| `--dry-run`   | Shows planned actions only             |

Example:

```sh
sh setup_docker.sh --install --user=bobbis --no-ux
```

---

## 🔐 Security Model

- All scripts run as **root**
- `sudo.sh` enables NOPASSWD for wheel group
- No sudo used until setup is complete

---

## 🏷️ Generated Configs

| File Path                  | Purpose                         |
|----------------------------|----------------------------------|
| `/etc/bobbis-user.conf`    | Stores primary system user       |
| `/etc/bobbis-role.conf`    | Stores role type (e.g. docker)   |
| `/etc/bobbis-motd.conf`    | Optional MOTD label override     |
| `/opt/logs/bobbis-setup.log` | Full install log (optional)    |

---

## 🎨 UX Example (MOTD)

```text
👑 Welcome to Bobbis Systems
🧱 Role: Docker Host
🐳 Docker: Running
📦 Managed by setup-alpine
```

---

## ✨ Philosophy

> **Every script is a complete tool.**  
> Run them independently with full UX, or call them with flags in orchestration.

---

## 📜 License

MIT — Use freely. Fork proudly. Root responsibly.
