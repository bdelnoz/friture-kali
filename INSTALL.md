<!--
Document : INSTALL.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.2.0
Date : 2026-04-25 12:15
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

2. Check prerequisites:

```bash
./install.sh --prerequis
```

3. (Optional) Install prerequisite packages only:

```bash
./install.sh --install
```

4. Run complete installation:

```bash
./install.sh --exec
```

`--exec` prefers `apt install friture` and falls back to `pip install friture` only when the apt package is unavailable.

5. Launch Friture:

```bash
./run.sh --exec
```

## Notes

- The virtual environment is created at:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/venv/friture`
- Logs are written in `./logs`.
- Result summaries are written in `./results`.
