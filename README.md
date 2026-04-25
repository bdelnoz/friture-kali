<!--
Document : infos/README.md – friture-kali
Auteur : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.0.0
Date : 2026-04-25 00:00
-->

# friture-kali – Documentation technique détaillée

## 1. Objectif

Déployer **Friture** sous Kali Linux dans un venv Python isolé pour analyser en temps réel le spectre audio capté par un microphone USB Blue Yeti.

---

## 2. Pourquoi un venv sous Kali

Kali Linux impose l'isolation des packages Python installés via `pip` (PEP 668 / `externally-managed-environment`). L'utilisation d'un venv est **obligatoire** pour éviter les conflits avec les packages système.

L'option `--system-site-packages` permet de réutiliser `python3-pyqt5` installé au niveau système, évitant une recompilation lourde dans le venv.

---

## 3. Choix de Friture

| Critère                    | JAAA      | Friture   |
|----------------------------|-----------|-----------|
| Spectre temps réel         | ✅        | ✅        |
| Spectrogramme défilant     | ❌        | ✅        |
| Niveaux dB                 | ✅        | ✅        |
| Sélection device audio GUI | partielle | ✅        |
| Hautes fréquences (≥12kHz) | ✅        | ✅        |
| Extensible Python          | ❌        | ✅        |
| Presets persistants        | ❌        | ✅        |

---

## 4. Détail de l'installation

### 4.1 Dépendances système

```bash
sudo apt install python3-pyqt5 python3-pyqt5.qtopengl python3-venv -y
```

### 4.2 Création du venv

```bash
python3 -m venv ~/venv/friture --system-site-packages
```

### 4.3 Installation de Friture

```bash
source ~/venv/friture/bin/activate
pip install friture
```

---

## 5. Sélection du Blue Yeti

Au lancement de Friture : **Preferences → Input device** → sélectionner `Yeti Stereo Microphone`.

Identifié par ALSA comme :
```
card 2 : Yeti Stereo Microphone
device 0 : USB Audio
plughw:2,0
```

---

## 6. Bandes fréquentielles surveillées

| Bande cible       | Usage                                |
|-------------------|--------------------------------------|
| 2 kHz – 5 kHz     | Sifflements vocaux courants          |
| 8 kHz – 12 kHz    | Sifflements aigus / sifflets         |
| 12 kHz – 20+ kHz  | Sifflets ultra-aigus / à chiens      |

---

## 7. Évolutions prévues

- `sound_monitor.sh` : détection automatique + horodatage
- Alertes `ntfy.sh`
- Intégration dashboard Python
- Preuve horodatée exploitable

---

## 8. Auteur

**Bruno DELNOZ** — bruno.delnoz@protonmail.com
