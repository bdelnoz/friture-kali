<!--
Document : WHY.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.4.0
Date : 2026-04-26 00:00
-->
# WHY

## Why this repository exists

`friture-kali` exists to provide a reliable and repeatable way to run Friture on Kali Linux with a dedicated venv and explicit operational scripts.

## Why a fixed installation root

A fixed installation root improves reproducibility on the target machine and avoids path drift between installations.

## Why a dedicated local pipenv environment

Kali environments can be sensitive to system Python package management. A pipenv-managed project environment (`.venv`) isolates package installation while keeping operational behavior reproducible.

## Why upstream install through pipenv

Using `pipenv run pip install git+https://github.com/tlecomte/friture.git@master` aligns installation with the current maintained upstream source strategy used by `install.sh`.

## Why explicit shell scripts

The scripts provide:

- deterministic CLI behavior,
- prerequisite checks,
- dry-run (`--simulate`) support,
- logs and execution traceability,
- ready-to-use operational commands.
