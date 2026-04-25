<!--
Document : WHY.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.4.0
Date : 2026-04-25 13:10
-->
# WHY

## Why this repository exists

`friture-kali` exists to provide a reliable and repeatable way to run Friture on Kali Linux with a dedicated venv and explicit operational scripts.

## Why layered fallbacks are required

Kali rolling environments can expose Python/runtime compatibility gaps. A single install method can fail depending on package availability and Python minor version.

The installer therefore uses a layered strategy:
- compatible interpreter when available,
- apt-first package install,
- guarded pip fallback,
- git fallback when needed.
