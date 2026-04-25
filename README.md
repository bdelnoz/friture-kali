<!--
Document : README.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.3.0
Date : 2026-04-25 12:45
-->
# friture-kali

## Purpose

This repository provides operational Kali Linux scripts to install and run **Friture** in a dedicated Python virtual environment, with runtime checks for a Blue Yeti microphone.

## Fixed Installation Policy

- Installation root is fixed to:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali`
- Dedicated virtual environment path is fixed to:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/venv/friture`

## Installation strategy (Python 3.13 hardened)

`install.sh --exec` now uses this order:

1. create venv with a **compatible interpreter < 3.13** (`python3.12`, `python3.11`, ...)
2. prefer system package install: `apt install friture`
3. fallback to `pip install friture` only when apt package is unavailable **and** venv Python is < 3.13

If only Python 3.13+ is available, pip fallback is blocked with an explicit error because known backend dependencies fail on 3.13.

## Main Scripts

- `install.sh`: installs prerequisites, detects compatible Python, creates fixed venv, installs `friture`.
- `run.sh`: verifies prerequisites and launches `friture` from fixed venv/system path.

## Quick Start

```bash
cd /mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali
./install.sh --install
./install.sh --exec
./run.sh --exec
```

## Common Commands

```bash
./install.sh --help
./install.sh --prerequis
./install.sh --install
./install.sh --exec

./run.sh --help
./run.sh --prerequis
./run.sh --exec
./run.sh --stop
```

## Runtime Artifacts

- Logs: `./logs/log.<script_name>.<full_timestamp>.<script_version>.log`
- Results: `./results/`

## Author

Bruno DELNOZ — bruno.delnoz@protonmail.com
