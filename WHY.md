<!--
Document : WHY.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.1.0
Date : 2026-04-25 10:30
-->
# WHY

## Why this repository exists

`friture-kali` exists to provide a reliable and repeatable way to run Friture on Kali Linux with a dedicated venv and explicit operational scripts.

## Why a fixed installation root

A fixed installation root improves reproducibility on the target machine and avoids path drift between installations.

## Why a dedicated venv

Kali environments can be sensitive to system Python package management. A dedicated project venv isolates package installation while still allowing required system Qt packages through `--system-site-packages`.

## Why explicit shell scripts

The scripts provide:

- deterministic CLI behavior,
- prerequisite checks,
- dry-run (`--simulate`) support,
- logs and execution traceability,
- ready-to-use operational commands.
