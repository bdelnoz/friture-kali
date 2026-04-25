<!--
Document : INSTALL.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.1.0
Date : 2026-04-25 10:30
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

3. Install system prerequisites (if needed):

```bash
./install.sh --install
```

4. Run complete installation:

```bash
./install.sh --exec
```

5. Launch Friture:

```bash
./run.sh --exec
```

## Notes

- The virtual environment is created at:
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/venv/friture`
- Logs are written in `./logs`.
- Result summaries are written in `./results`.
