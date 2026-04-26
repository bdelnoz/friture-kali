<!--
Document : README.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.4.0
Date : 2026-04-26 00:00
-->
# friture-kali

## Purpose

This repository provides operational Kali Linux scripts to install and run **Friture** with a pipenv-managed local environment (`.venv`), with runtime checks for a Blue Yeti microphone.

## Fixed Installation Policy

- Installation root is fixed to:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali`
- Pipenv local virtual environment is expected at:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/.venv`

## Installation strategy (pipenv workflow)

`install.sh --exec` now uses this workflow:

1. install prerequisites (`pipenv`, `python3-pyqt5`, `python3-pyqt5.qtopengl`, `git`)
2. create local pipenv environment (`.venv`) from project root
3. install Friture from upstream source:
   - `pipenv run pip install git+https://github.com/tlecomte/friture.git@master`

## Main Scripts

- `install.sh`: installs prerequisites, creates/uses pipenv `.venv`, installs `friture` from upstream.
- `run.sh`: verifies runtime candidates and launches `friture` via `.venv`, `pipenv`, or system fallback.

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
