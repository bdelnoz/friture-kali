<!--
Document : CHANGELOG.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.4.0
Date : 2026-04-25 13:10
-->
# CHANGELOG

## v1.4.0 — 2026-04-25 13:10 — Bruno DELNOZ

### Added
- Added no-dead-end install path in `install.sh` for Python 3.13-only systems.
- Added git-based fallback install attempt: `pip install git+https://github.com/tlecomte/friture.git`.
- Added `git` to prerequisite packages.

### Changed
- Updated `install.sh` to `v1.4.0`:
  - removed hard-stop when no Python `< 3.13` is available,
  - continues with `python3` and guarded fallback logic,
  - keeps apt-first and compatible-interpreter preference.
- Updated `README.md`, `INSTALL.md`, `WHY.md`, `SPECIFICATIONS.md`, and `SPECIFICATIONS_FR.md` to reflect layered fallback behavior.

### Removed
- None.

## v1.3.0 — 2026-04-25 12:45 — Bruno DELNOZ

### Added
- Added compatible interpreter detection in `install.sh` to require Python `< 3.13` for venv creation.
- Added optional `python3.12` + `python3.12-venv` installation attempt in `install.sh --install` when no compatible interpreter is detected.

### Changed
- Updated `install.sh` to `v1.3.0`:
  - venv creation now uses detected compatible interpreter (`python3.12`, `python3.11`, ...).
  - pip fallback is now blocked on Python 3.13+ with explicit guidance.
  - pip operations run through `${VENV_DIR}/bin/python -m pip` for deterministic interpreter usage.

### Removed
- None.
