<!--
Document : CHANGELOG.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.3.0
Date : 2026-04-25 12:45
-->
# CHANGELOG

## v1.3.0 — 2026-04-25 12:45 — Bruno DELNOZ

### Added
- Added compatible interpreter detection in `install.sh` to require Python `< 3.13` for venv creation.
- Added optional `python3.12` + `python3.12-venv` installation attempt in `install.sh --install` when no compatible interpreter is detected.

### Changed
- Updated `install.sh` to `v1.3.0`:
  - venv creation now uses detected compatible interpreter (`python3.12`, `python3.11`, ...).
  - pip fallback is now blocked on Python 3.13+ with explicit guidance.
  - pip operations run through `${VENV_DIR}/bin/python -m pip` for deterministic interpreter usage.
- Updated `README.md`, `INSTALL.md`, `WHY.md`, `SPECIFICATIONS.md`, and `SPECIFICATIONS_FR.md` to document compatibility behavior.

### Removed
- None.

## v1.2.0 — 2026-04-25 12:15 — Bruno DELNOZ

### Added
- Added Python 3.13 compatibility strategy in `install.sh --exec` (apt-first installation for `friture`).
- Added runtime acceptance in `run.sh` for system-installed `friture` command when venv binary is absent.

### Changed
- Updated `install.sh` to `v1.2.0`:
  - changed Friture installation flow to prefer `apt install friture`.
  - kept `pip install friture` as fallback only when apt package is unavailable.
- Updated `run.sh` to `v1.2.0`:
  - runtime prerequisite check now accepts either `${INSTALL_ROOT}/venv/friture/bin/friture` or system `friture` in `PATH`.
- Updated `README.md`, `INSTALL.md`, `WHY.md`, `SPECIFICATIONS.md`, and `SPECIFICATIONS_FR.md` with the apt-first compatibility policy.

### Removed
- None.

## v1.1.0 — 2026-04-25 10:30 — Bruno DELNOZ

### Added
- Created `SPECIFICATIONS_FR.md` as mandatory French companion file.
- Added fixed installation root and fixed venv policy in scripts and documentation.
- Added companion documents `INSTALL.md` and `WHY.md`.

### Changed
- Updated `install.sh` to use fixed root `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali`.
- Updated `install.sh` venv path to `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/venv/friture`.
- Updated `run.sh` to use the same fixed root and venv path.
- Updated script internal versions/date/changelog to `v1.1.0`.
- Updated `README.md` metadata and language to English repository standard.
- Updated `SPECIFICATIONS.md` to synchronize with current repository behavior.

### Removed
- None.

## v1.0.0 — 2026-04-25 01:55 — Bruno DELNOZ

### Added
- Initial repository scripts and baseline project documentation.
