<!--
Document : INSTALL.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.4.0
Date : 2026-04-26 00:00
-->
# INSTALL

## Target Platform

- Kali Linux

## Installation Root

All operations are aligned to this fixed path:

`/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali`

## Steps

1. Go to the project folder:

```bash
cd /mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali
```

2. Install prerequisite packages (recommended):

```bash
./install.sh --install
```

3. Check prerequisites:

```bash
./install.sh --prerequis
```

4. Run complete installation:

```bash
./install.sh --exec
```

`--exec` will:
- install and verify pipenv-based prerequisites,
- create/use the local project virtual environment `.venv`,
- install Friture from upstream using:
  - `pipenv run pip install git+https://github.com/tlecomte/friture.git@master`.

5. Launch Friture:

```bash
./run.sh --exec
```

## Notes

- The local pipenv virtual environment is expected at:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/.venv`
- Logs are written in `./logs`.
- Result summaries are written in `./results`.
