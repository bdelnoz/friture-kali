<!--
Document : SPECIFICATIONS.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.1.0
Date : 2026-04-25 10:30
-->
# SPECIFICATIONS.md

## Purpose

Define the complete, validated repository specifications for `friture-kali`, including script behavior, fixed installation policy, documentation synchronization, and acceptance criteria.

## Scope

This specification covers:

- `install.sh` behavior and maintenance
- `run.sh` behavior and maintenance
- fixed installation root and fixed venv requirements
- required companion documentation files
- logs and results artifact behavior

This specification does not cover:

- cloud telemetry
- non-Linux execution
- replacing shell scripts with another implementation language

## Existing verified behavior

### Repository files

Current root files:

- `AGENTS.md`
- `README.md`
- `SPECIFICATIONS.md`
- `SPECIFICATIONS_FR.md`
- `CHANGELOG.md`
- `INSTALL.md`
- `WHY.md`
- `install.sh`
- `run.sh`

### Fixed installation policy

- Installation root is fixed to:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali`
- Virtual environment is fixed to:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/venv/friture`

### `install.sh`

- supports: `--help`, `--exec`, `--prerequis`, `--install`, `--simulate`, `--changelog`, `--purge`, `--stop`
- checks/install prerequisites via apt (`python3-venv`, `python3-pyqt5`, `python3-pyqt5.qtopengl`, `python3-pip`)
- creates and uses fixed venv path
- installs `friture` inside venv
- writes logs under `./logs`
- writes execution summary under `./results`

### `run.sh`

- supports: `--help`, `--exec`, `--stop`, `--prerequis`, `--install`, `--simulate`, `--changelog`, `--purge`
- validates fixed install root and fixed venv
- checks optional Blue Yeti ALSA presence
- launches `friture` from fixed venv
- manages PID via `/tmp/friture.pid`
- writes logs under `./logs`

## Functional requirements

1. Scripts MUST keep full documented CLI behavior and options.
2. Scripts MUST enforce/use fixed installation root paths.
3. Scripts MUST use the fixed project venv path.
4. Script updates MUST include version/date/changelog updates.
5. Script-related tasks MUST synchronize `README.md`, `CHANGELOG.md`, `INSTALL.md`, and `WHY.md`.
6. `SPECIFICATIONS.md` and `SPECIFICATIONS_FR.md` MUST remain synchronized in version/date/meaning.

## Non-functional requirements

- Kali Linux first
- reproducible behavior
- safe-by-default and non-destructive by default
- explicit logs and traceability
- no fabricated execution claims

## Inputs

- CLI flags for `install.sh` and `run.sh`
- local apt/system package state
- local ALSA device state
- local repository state

## Outputs

- deterministic script operations
- logs in `./logs`
- result files in `./results` when generated
- synchronized repository documentation and specifications

## Files and directories concerned

- `install.sh`
- `run.sh`
- `README.md`
- `CHANGELOG.md`
- `INSTALL.md`
- `WHY.md`
- `SPECIFICATIONS.md`
- `SPECIFICATIONS_FR.md`
- `./logs/`
- `./results/`

## Interfaces and commands

- `./install.sh --help|--exec|--prerequis|--install|--simulate|--changelog|--purge|--stop`
- `./run.sh --help|--exec|--stop|--prerequis|--install|--simulate|--changelog|--purge`

Validation checks:

- `bash -n install.sh`
- `bash -n run.sh`

## Constraints and safety rules

- keep existing features unless explicitly requested otherwise
- avoid destructive actions by default
- preserve historical changelog entries (append-only)
- maintain English repository deliverables except `SPECIFICATIONS_FR.md`

## Validation and acceptance criteria

Task is accepted when:

1. scripts implement fixed root and fixed venv policy,
2. script metadata/version/changelog are updated,
3. required companion documentation files exist and are synchronized,
4. `SPECIFICATIONS.md` and `SPECIFICATIONS_FR.md` are synchronized,
5. syntax checks pass.

## Out-of-scope items

- legal interpretation of sound evidence
- identity attribution from audio
- external web/cloud processing additions

## Changelog

### v1.1.0 — 2026-04-25 10:30 — Bruno DELNOZ

Reason/context:
- Repository-wide maintenance with script bug review and mandatory fixed Kali installation root/venv requirement.

Additions:
- Added fixed installation root and fixed venv requirements.
- Added explicit companion documentation synchronization state.
- Added synchronized `SPECIFICATIONS_FR.md` requirement in current repository state.

Modifications:
- Updated verified behavior sections to match current scripts and docs.
- Updated acceptance criteria to include fixed path policy validation.

Removals:
- None.

### v1.0.0 — 2026-04-25 01:55 — Bruno DELNOZ

Initial specification created from verified repository and conversation state.
