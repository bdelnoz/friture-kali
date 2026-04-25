<!--
Document : INSTALL.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.4.0
Date : 2026-04-25 13:10
-->
# INSTALL

## Target Platform

- Kali Linux

## Installation Root

All operations are aligned to this fixed path:

`/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali`

## Steps

1. `cd /mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali`
2. `./install.sh --install`
3. `./install.sh --exec`
4. `./run.sh --exec`

## Installer behavior

`--exec` applies layered fallback:
- compatible Python `< 3.13` when available,
- apt-first install (`apt install friture`),
- standard pip fallback when compatible,
- git-based pip fallback on Python 3.13+ environments if needed.
