<!--
Document : SPECIFICATIONS.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.4.0
Date : 2026-04-26 00:00
-->
# SPECIFICATIONS.md

## Purpose

Define the complete, validated repository specifications for `friture-kali`, including script behavior, fixed installation policy, documentation synchronization, and acceptance criteria.

## Scope

This specification covers:

- `install.sh` behavior and maintenance
- `run.sh` behavior and maintenance
- fixed installation root requirements
- pipenv-based runtime and installation flow
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
- `install.sh` (reference-only in this task, no modifications)
- `run.sh`

### Fixed installation policy

- Installation root is fixed to:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali`
- Pipenv local virtual environment is expected at:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/.venv`

### `install.sh`

- supports: `--help`, `--exec`, `--prerequis`, `--install`, `--simulate`, `--changelog`, `--purge`, `--stop`
- current version metadata indicates `v1.6.0` (dated `2026-04-26`)
- checks/install prerequisites via apt (`pipenv`, `python3-pyqt5`, `python3-pyqt5.qtopengl`, `git`)
- creates and uses local project `.venv` via pipenv
- installs Friture from upstream source using:
  - `pipenv run pip install git+https://github.com/tlecomte/friture.git@master`
- writes logs under `./logs`
- writes execution summary under `./results`

### `run.sh`

- supports: `--help`, `--exec`, `--stop`, `--prerequis`, `--install`, `--simulate`, `--changelog`, `--purge`
- validates fixed install root
- validates pipenv-compatible runtime candidates
- checks optional Blue Yeti ALSA presence
- accepts Friture command from one of:
  - `${INSTALL_ROOT}/.venv/bin/friture`
  - `pipenv run friture` (when `Pipfile` exists)
  - system PATH (`/usr/bin/friture` or equivalent)
- manages PID via `/tmp/friture.pid`
- writes logs under `./logs`

## Functional requirements

1. Scripts MUST keep full documented CLI behavior and options.
2. Scripts MUST enforce/use fixed installation root paths.
3. `run.sh` MUST align runtime launch with pipenv-based installation state.
4. Script updates MUST include version/date/changelog updates.
5. Script-related tasks MUST synchronize `README.md`, `CHANGELOG.md`, `INSTALL.md`, and `WHY.md`.
6. `SPECIFICATIONS.md` and `SPECIFICATIONS_FR.md` MUST remain synchronized in version/date/meaning.
7. Documentation MUST describe pipenv-based install/runtime flow as source of truth.
8. `install.sh` MUST NOT be modified in this task (user-validated working state).
9. Runtime validation MUST accept system `friture` fallback when available.

## Non-functional requirements

- Kali Linux first
- reproducible behavior
- safe-by-default and non-destructive by default
- explicit logs and traceability
- no fabricated execution claims

## Inputs

- CLI flags for `install.sh` and `run.sh`
- local apt/system package state
- local pipenv/.venv state
- local ALSA device state
- local repository state

## Outputs

- deterministic script operations
- logs in `./logs`
- result files in `./results` when generated
- synchronized repository documentation and specifications

## Files and directories concerned

- `install.sh` (reference-only in this task, no modifications)
- `run.sh`
- `README.md`
- `CHANGELOG.md`
- `INSTALL.md`
- `WHY.md`
- `SPECIFICATIONS.md`
- `SPECIFICATIONS_FR.md`
- `./logs/`
- `./results/`
- `./.venv/`
- `./Pipfile`
- `./Pipfile.lock` (if generated)

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
- no modification of `install.sh` in this request scope

## Validation and acceptance criteria

Task is accepted when:

1. `run.sh` behavior is compatible with current `install.sh` pipenv flow,
2. `run.sh` metadata/version/changelog are updated,
3. `README.md`, `INSTALL.md`, `WHY.md`, `CHANGELOG.md` are synchronized with pipenv workflow,
4. `SPECIFICATIONS.md` and `SPECIFICATIONS_FR.md` are synchronized,
5. `install.sh` remains unchanged,
6. syntax checks pass.

## Out-of-scope items

- legal interpretation of sound evidence
- identity attribution from audio
- external web/cloud processing additions

## Changelog

### v1.4.0 — 2026-04-26 00:00 — Bruno DELNOZ

Reason/context:
- User confirmed `install.sh` was manually changed and must remain untouched; requested updates for `run.sh` and Markdown docs to match current installer behavior.

Additions:
- Added pipenv-based synchronization requirements for runtime and docs.
- Added explicit no-change constraint for `install.sh` in this task.

Modifications:
- Updated verified install behavior from fixed `venv/friture` strategy to pipenv `.venv` workflow.
- Updated runtime/documentation requirements to reflect pipenv launch path.

Removals:
- Removed normative dependency on fixed `venv/friture` path as primary runtime source of truth.

### v1.3.0 — 2026-04-25 12:45 — Bruno DELNOZ

Reason/context:
- User reported continued install failure when apt package was unavailable and pip fallback attempted legacy backend builds on Python 3.13.

Additions:
- Added mandatory compatible interpreter detection (<3.13) for venv creation.
- Added mandatory block for pip fallback on Python 3.13+.

Modifications:
- Updated install behavior requirements to include interpreter selection and guarded pip fallback.
- Updated acceptance criteria for Python runtime compatibility controls.

Removals:
- None.

### v1.2.0 — 2026-04-25 12:15 — Bruno DELNOZ

Reason/context:
- Runtime failure reported when `pip install friture` attempted to build legacy numpy dependency on Python 3.13.

Additions:
- Added apt-first Friture installation strategy requirement.
- Added runtime acceptance requirement for system-installed `friture` command.

Modifications:
- Updated verified script behavior to include apt-first install and system PATH fallback.
- Updated acceptance criteria with Python 3.13 compatibility handling.

Removals:
- None.

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
