<!--
Document : README.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.4.0
Date : 2026-04-25 13:10
-->
# friture-kali

## Purpose

This repository provides operational Kali Linux scripts to install and run **Friture** in a dedicated Python virtual environment, with runtime checks for a Blue Yeti microphone.

## Fixed Installation Policy

- Installation root is fixed to:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali`
- Dedicated virtual environment path is fixed to:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/venv/friture`

## Installation strategy (no-dead-end)

`install.sh --exec` now uses this order:

1. prefer a compatible Python interpreter `< 3.13` when available
2. create/recreate the venv if incompatible
3. prefer system package install: `apt install friture`
4. fallback to `pip install friture` when compatible
5. if Python 3.13+ blocks standard pip fallback, try git fallback:
   - `pip install git+https://github.com/tlecomte/friture.git`

## Main Scripts

- `install.sh`: installs prerequisites, creates fixed venv, and installs `friture` with layered fallback logic.
- `run.sh`: verifies prerequisites and launches `friture` from fixed venv/system path.

## Quick Start

```bash
cd /mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali
./install.sh --install
./install.sh --exec
./run.sh --exec
```
