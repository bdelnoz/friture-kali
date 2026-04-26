<!--
Document : SPECIFICATIONS_FR.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.4.0
Date : 2026-04-26 00:00
-->
# SPECIFICATIONS_FR.md

## Objectif

Définir les spécifications complètes et validées du dépôt `friture-kali`, y compris le comportement des scripts, la politique d'installation fixe, la synchronisation documentaire et les critères d'acceptation.

## Périmètre

Cette spécification couvre :

- le comportement et la maintenance de `install.sh`
- le comportement et la maintenance de `run.sh`
- les exigences de dossier d'installation fixe
- le flux d'installation et d'exécution basé sur pipenv
- les documents compagnons obligatoires
- les logs et artefacts de résultats

Cette spécification ne couvre pas :

- la télémétrie cloud
- l'exécution hors Linux
- le remplacement des scripts shell par un autre langage

## Comportement existant vérifié

### Fichiers du dépôt

Fichiers racine actuels :

- `AGENTS.md`
- `README.md`
- `SPECIFICATIONS.md`
- `SPECIFICATIONS_FR.md`
- `CHANGELOG.md`
- `INSTALL.md`
- `WHY.md`
- `install.sh` (référence uniquement dans cette tâche, aucune modification)
- `run.sh`

### Politique d'installation fixe

- Le dossier d'installation est fixé à :
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali`
- L'environnement virtuel local pipenv est attendu à :
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/.venv`

### `install.sh`

- supporte : `--help`, `--exec`, `--prerequis`, `--install`, `--simulate`, `--changelog`, `--purge`, `--stop`
- la version courante indiquée est `v1.6.0` (datée `2026-04-26`)
- vérifie/installe les prérequis apt (`pipenv`, `python3-pyqt5`, `python3-pyqt5.qtopengl`, `git`)
- crée/utilise un `.venv` local de projet via pipenv
- installe Friture depuis l'upstream via :
  - `pipenv run pip install git+https://github.com/tlecomte/friture.git@master`
- écrit les logs dans `./logs`
- écrit un résumé d'exécution dans `./results`

### `run.sh`

- supporte : `--help`, `--exec`, `--stop`, `--prerequis`, `--install`, `--simulate`, `--changelog`, `--purge`
- valide le dossier d'installation fixe
- valide des candidats runtime compatibles pipenv
- vérifie optionnellement la présence ALSA du Blue Yeti
- accepte la commande Friture depuis l'un de :
  - `${INSTALL_ROOT}/.venv/bin/friture`
  - `pipenv run friture` (quand `Pipfile` existe)
  - le PATH système (`/usr/bin/friture` ou équivalent)
- gère le PID via `/tmp/friture.pid`
- écrit les logs dans `./logs`

## Exigences fonctionnelles

1. Les scripts DOIVENT conserver le comportement CLI documenté et les options.
2. Les scripts DOIVENT imposer/utiliser les chemins de dossier d'installation fixes.
3. `run.sh` DOIT aligner le lancement runtime avec l'état d'installation pipenv.
4. Toute mise à jour script DOIT inclure version/date/changelog.
5. Les tâches liées aux scripts DOIVENT synchroniser `README.md`, `CHANGELOG.md`, `INSTALL.md`, `WHY.md`.
6. `SPECIFICATIONS.md` et `SPECIFICATIONS_FR.md` DOIVENT rester synchronisés (version/date/sens).
7. La documentation DOIT décrire le flux pipenv comme référence.
8. `install.sh` NE DOIT PAS être modifié dans cette tâche (état validé par l'utilisateur).
9. La validation runtime DOIT accepter le fallback système `friture` s'il est disponible.

## Exigences non fonctionnelles

- priorité Kali Linux
- comportement reproductible
- sécurité par défaut, non destructif par défaut
- logs explicites et traçabilité
- aucune invention de résultats d'exécution

## Entrées

- options CLI de `install.sh` et `run.sh`
- état local des paquets apt/système
- état local pipenv/.venv
- état local des périphériques ALSA
- état local du dépôt

## Sorties

- opérations scripts déterministes
- logs dans `./logs`
- fichiers résultats dans `./results` quand générés
- documentation et spécifications synchronisées

## Fichiers et répertoires concernés

- `install.sh` (référence uniquement dans cette tâche, aucune modification)
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
- `./Pipfile.lock` (si généré)

## Interfaces et commandes

- `./install.sh --help|--exec|--prerequis|--install|--simulate|--changelog|--purge|--stop`
- `./run.sh --help|--exec|--stop|--prerequis|--install|--simulate|--changelog|--purge`

Vérifications :

- `bash -n install.sh`
- `bash -n run.sh`

## Contraintes et règles de sécurité

- conserver les fonctionnalités existantes sauf demande explicite contraire
- éviter les actions destructives par défaut
- préserver l'historique des changelogs (append-only)
- maintenir les livrables dépôt en anglais sauf `SPECIFICATIONS_FR.md`
- ne pas modifier `install.sh` dans le périmètre de cette demande

## Validation et critères d'acceptation

La tâche est acceptée quand :

1. le comportement de `run.sh` est compatible avec le flux pipenv actuel de `install.sh`,
2. les métadonnées version/changelog/date de `run.sh` sont mises à jour,
3. `README.md`, `INSTALL.md`, `WHY.md`, `CHANGELOG.md` sont synchronisés avec le flux pipenv,
4. `SPECIFICATIONS.md` et `SPECIFICATIONS_FR.md` sont synchronisés,
5. `install.sh` reste inchangé,
6. les vérifications de syntaxe passent.

## Hors périmètre

- interprétation légale des preuves audio
- attribution d'identité depuis l'audio
- ajout de traitement cloud/web externe

## Changelog

### v1.4.0 — 2026-04-26 00:00 — Bruno DELNOZ

Raison/contexte :
- L'utilisateur confirme que `install.sh` a été modifié manuellement et ne doit pas être touché ; il demande la mise à jour de `run.sh` et des documents Markdown.

Ajouts :
- Ajout des exigences de synchronisation runtime/doc orientées pipenv.
- Ajout de la contrainte explicite de non-modification de `install.sh` dans cette tâche.

Modifications :
- Mise à jour du comportement d'installation vérifié : stratégie `.venv` pipenv en référence principale.
- Mise à jour des exigences runtime et documentation pour refléter le chemin de lancement pipenv.

Suppressions :
- Retrait de la dépendance normative au chemin fixe `venv/friture` comme référence principale runtime.

### v1.3.0 — 2026-04-25 12:45 — Bruno DELNOZ

Raison/contexte :
- L'utilisateur a signalé un échec persistant quand le paquet apt n'était pas disponible et que le fallback pip tentait un build legacy sous Python 3.13.

Ajouts :
- Ajout de l'exigence de détection d'interpréteur compatible (<3.13) pour créer le venv.
- Ajout de l'exigence de blocage du fallback pip sur Python 3.13+.

Modifications :
- Mise à jour des exigences d'installation avec sélection d'interpréteur et fallback pip sécurisé.
- Mise à jour des critères d'acceptation avec contrôles de compatibilité runtime Python.

Suppressions :
- Aucune.

### v1.2.0 — 2026-04-25 12:15 — Bruno DELNOZ

Raison/contexte :
- Échec runtime signalé quand `pip install friture` tentait de construire une dépendance numpy legacy sous Python 3.13.

Ajouts :
- Ajout de l'exigence d'installation Friture en priorité via apt.
- Ajout de l'exigence d'acceptation runtime de la commande `friture` système.

Modifications :
- Mise à jour du comportement vérifié scripts avec apt-first et fallback PATH système.
- Mise à jour des critères d'acceptation avec gestion compatibilité Python 3.13.

Suppressions :
- Aucune.

### v1.1.0 — 2026-04-25 10:30 — Bruno DELNOZ

Raison/contexte :
- Maintenance globale du dépôt avec revue de bugs scripts et exigence dossier Kali fixe + venv fixe.

Ajouts :
- Ajout des exigences de dossier d'installation fixe et venv fixe.
- Ajout de l'état de synchronisation documentaire compagnon.
- Ajout de l'existence synchronisée de `SPECIFICATIONS_FR.md`.

Modifications :
- Mise à jour des sections de comportement vérifié selon scripts/docs actuels.
- Mise à jour des critères d'acceptation avec validation des chemins fixes.

Suppressions :
- Aucune.

### v1.0.0 — 2026-04-25 01:55 — Bruno DELNOZ

Spécification initiale créée depuis l'état vérifié du dépôt et de la conversation.
