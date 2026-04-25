<!--
Document : README.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.1.0
Date : 2026-04-25 10:30
-->
# friture-kali

## Purpose

This repository provides operational Kali Linux scripts to install and run **Friture** in a dedicated Python virtual environment, with runtime checks for a Blue Yeti microphone.

## Fixed Installation Policy

- Installation root is fixed to:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali`
- Dedicated virtual environment path is fixed to:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/venv/friture`

## Main Scripts

- `install.sh`: installs system prerequisites, creates the fixed venv, installs `friture`.
- `run.sh`: verifies prerequisites and launches `friture` from the fixed venv.

## Quick Start

```bash
cd /mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali
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
