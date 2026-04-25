<!--
Document : README.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.2.0
Date : 2026-04-25 12:15
-->
# friture-kali

## Purpose

This repository provides operational Kali Linux scripts to install and run **Friture** in a dedicated Python virtual environment, with runtime checks for a Blue Yeti microphone.

## Fixed Installation Policy

- Installation root is fixed to:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali`
- Dedicated virtual environment path is fixed to:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/venv/friture`

## Installation strategy (Python 3.13 compatible)

`install.sh --exec` now uses this order:

1. prefer system package install: `apt install friture`
2. fallback to `pip install friture` only if apt package is unavailable

This avoids common build failures on Python 3.13 with legacy `numpy` build chains.

## Main Scripts

- `install.sh`: installs system prerequisites, creates fixed venv, installs `friture` (apt preferred).
- `run.sh`: verifies prerequisites and launches `friture` from fixed venv/system path.

## Quick Start

```bash
cd /mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali
./install.sh --prerequis
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
