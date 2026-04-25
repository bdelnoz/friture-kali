<!--
Document : SPECIFICATIONS_FR.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.4.0
Date : 2026-04-25 13:10
-->
# SPECIFICATIONS_FR.md

## Objectif

Définir les spécifications complètes et validées du dépôt `friture-kali`, y compris le comportement des scripts, la politique d'installation fixe, la synchronisation documentaire et les critères d'acceptation.

## Périmètre

Cette spécification couvre :

- le comportement et la maintenance de `install.sh`
- le comportement et la maintenance de `run.sh`
- les exigences de dossier d'installation fixe et de venv fixe
- la stratégie de compatibilité runtime Python pour l'installation de Friture
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
- `install.sh`
- `run.sh`

### Politique d'installation fixe

- Le dossier d'installation est fixé à :
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali`
- L'environnement virtuel est fixé à :
  - `/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/venv/friture`

### `install.sh`

- supporte : `--help`, `--exec`, `--prerequis`, `--install`, `--simulate`, `--changelog`, `--purge`, `--stop`
- vérifie/installe les prérequis apt (`python3-venv`, `python3-pyqt5`, `python3-pyqt5.qtopengl`, `python3-pip`)
- crée et utilise le chemin venv fixe
- sélectionne un interpréteur compatible `< 3.13` pour créer le venv
- installe Friture avec stratégie apt-first :
  - priorité à `apt install friture`
  - fallback vers `pip install friture` seulement si le paquet apt est indisponible et si l'interpréteur est compatible
- écrit les logs dans `./logs`
- écrit un résumé d'exécution dans `./results`

### `run.sh`

- supporte : `--help`, `--exec`, `--stop`, `--prerequis`, `--install`, `--simulate`, `--changelog`, `--purge`
- valide le dossier d'installation fixe et le venv fixe
- vérifie optionnellement la présence ALSA du Blue Yeti
- accepte la commande Friture depuis :
  - `${INSTALL_ROOT}/venv/friture/bin/friture`
  - le PATH système (`/usr/bin/friture` ou équivalent)
- gère le PID via `/tmp/friture.pid`
- écrit les logs dans `./logs`

## Exigences fonctionnelles

1. Les scripts DOIVENT conserver le comportement CLI documenté et les options.
2. Les scripts DOIVENT imposer/utiliser les chemins de dossier d'installation fixes.
3. Les scripts DOIVENT utiliser le chemin venv fixe du projet.
4. Toute mise à jour script DOIT inclure version/date/changelog.
5. Les tâches liées aux scripts DOIVENT synchroniser `README.md`, `CHANGELOG.md`, `INSTALL.md`, `WHY.md`.
6. `SPECIFICATIONS.md` et `SPECIFICATIONS_FR.md` DOIVENT rester synchronisés (version/date/sens).
7. L'installation de Friture DOIT privilégier apt pour compatibilité Python 3.13.
8. L'installeur NE DOIT PAS rester bloqué si seul Python 3.13+ est disponible.
9. L'installeur DOIT tenter un fallback git quand le fallback pip standard est bloqué.
10. La validation runtime DOIT accepter la commande `friture` installée système.

## Exigences non fonctionnelles

- priorité Kali Linux
- comportement reproductible
- sécurité par défaut, non destructif par défaut
- logs explicites et traçabilité
- aucune invention de résultats d'exécution

## Entrées

- options CLI de `install.sh` et `run.sh`
- état local des paquets apt/système
- état local des périphériques ALSA
- état local du dépôt

## Sorties

- opérations scripts déterministes
- logs dans `./logs`
- fichiers résultats dans `./results` quand générés
- documentation et spécifications synchronisées

## Fichiers et répertoires concernés

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

## Validation et critères d'acceptation

La tâche est acceptée quand :

1. les scripts implémentent la politique de dossier racine fixe et venv fixe,
2. la metadata/version/changelog scripts sont mis à jour,
3. la détection d'interpréteur compatible (<3.13) est implémentée pour créer le venv,
4. la stratégie d'installation apt-first de Friture est implémentée,
5. un comportement sans blocage existe pour les systèmes Python 3.13-only,
6. une tentative de fallback git est implémentée si le fallback pip standard est bloqué,
7. le runtime accepte la commande système Friture si binaire venv absent,
8. les documents compagnons obligatoires existent et sont synchronisés,
9. `SPECIFICATIONS.md` et `SPECIFICATIONS_FR.md` sont synchronisés,
10. les vérifications de syntaxe passent.

## Hors périmètre

- interprétation légale des preuves audio
- attribution d'identité depuis l'audio
- ajout de traitement cloud/web externe

## Changelog

### v1.4.0 — 2026-04-25 13:10 — Bruno DELNOZ

Raison/contexte :
- L'utilisateur a signalé que v1.3 échouait encore : pas de Python <3.13 disponible et paquet apt introuvable, créant une impasse d'installation.

Ajouts :
- Ajout de l'exigence de fonctionnement sans impasse sur systèmes Python 3.13-only.
- Ajout de l'exigence de tentative fallback git quand le fallback pip standard est bloqué.

Modifications :
- Mise à jour des exigences d'installation d'un mode hard-stop vers un mode fallback en couches.
- Mise à jour des critères d'acceptation en conséquence.

Suppressions :
- Aucune.

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
