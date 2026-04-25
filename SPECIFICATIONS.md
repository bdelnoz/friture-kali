<!--
Document : SPECIFICATIONS.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.0.0
Date : 2026-04-25 01:55
-->
# SPECIFICATIONS.md

## Purpose

Define the functional and technical specifications for a Kali Linux real-time audio frequency monitoring system using a Blue Yeti USB microphone.

The objective is to detect specific sound events (notably whistle-like high-frequency sounds) in real time, with future support for automated alerting, timestamped evidence generation, and dashboard integration.

---

## Scope

This project covers:

- live microphone capture from Blue Yeti
- real-time spectrum analysis
- frequency band monitoring
- configurable dB threshold detection
- future automatic alert triggering
- future ntfy.sh notification support
- future integration with the existing Python dashboard

This project does not initially cover:

- post-recording offline-only analysis
- Windows support
- Bluetooth audio devices
- cloud-hosted processing

---

## Existing Verified Behavior

### Environment

- OS: Kali Linux
- Primary workstation: koutoubia
- User preference: Kali repositories only when possible
- No AppImage preferred
- No Windows solutions

### Audio Device

Verified ALSA capture device:

```text
card 2 : Yeti Stereo Microphone
device 0 : USB Audio
```

Operational ALSA target:

```text
plughw:2,0
```

### Tested Tool

JAAA verified:

```text
Version: 0.9.2
```

Findings:

- live spectrum display works
- limited interface for advanced monitoring
- no clean persistent preset system
- GUI settings are not fully reproducible via CLI

---

## Functional Requirements

### FR-01 Live Frequency Visualization

The system must display audio frequencies in real time directly from the microphone.

### FR-02 Live dB Level Monitoring

The system must display live amplitude levels in dB.

### FR-03 Frequency Band Targeting

The system must allow monitoring of specific frequency ranges.

Examples:

- 2 kHz → 5 kHz
- 8 kHz → 12 kHz
- up to 20+ kHz for very high-pitched whistles

### FR-04 Configurable Trigger Threshold

The user must be able to define a threshold level that triggers an event.

### FR-05 Future Alerting

The system must support future automated actions when a threshold is exceeded.

Examples:

- dashboard alert
- ntfy.sh push notification
- local log entry

### FR-06 Evidence Preservation

The system should support future timestamped evidence generation.

Examples:

- saved audio snippet
- generated spectrogram
- detection event log

---

## Non-Functional Requirements

- real-time behavior required
- low latency preferred
- minimal package footprint preferred
- HTTPS-only external access if needed
- strong reproducibility
- forensic-friendly traceability
- Linux-native workflow only

---

## Inputs

### Primary Input

- Blue Yeti USB microphone

### Configuration Inputs

- target frequency range
- trigger threshold in dB
- alert mode selection
- destination for logs/results

---

## Outputs

### Immediate Outputs

- live spectrum display
- live dB levels
- visual frequency monitoring

### Future Outputs

- detection logs
- saved evidence files
- spectrogram exports
- dashboard alerts
- ntfy.sh notifications

---

## Files and Directories Concerned

Expected repository structure:

```text
./README.md
./WHY.md
./INSTALL.md
./CHANGELOG.md
./SPECIFICATIONS.md
./SPECIFICATIONS_FR.md
./logs/
./results/
```

---

## Interfaces and Commands

### ALSA verification

```bash
arecord -l
```

### Live capture test

```bash
arecord -D plughw:2,0 -f S16_LE -c 2 -r 44100 -V mono /tmp/test.wav
```

### Existing analyzer

```bash
jaaa -A -C plughw:2,0
```

Future implementation may use:

- Python
- NumPy
- SciPy
- sounddevice
- ffmpeg
- ntfy.sh

---

## Constraints and Safety Rules

- no assumptions presented as facts
- only verified technical statements
- preserve evidence integrity
- avoid destructive actions by default
- no external dependency if avoidable
- no outbound exposure of collected data without explicit approval

---

## Validation and Acceptance Criteria

The project is considered valid when:

- the microphone is reliably captured
- targeted frequency bands are visible in real time
- threshold conditions are configurable
- detections can be observed consistently
- the system is suitable for documenting repeated whistle events

---

## Out-of-Scope Items

- legal interpretation
- identity attribution of the source person
- law enforcement conclusions
- remote cloud analytics
- mobile app implementation

---

## Changelog

### v1.0.0 — 2026-04-25 01:55 — Bruno DELNOZ

Initial specification created from verified repository and conversation state.

Added:

- project purpose
- real-time audio monitoring scope
- verified ALSA microphone configuration
- JAAA baseline validation
- functional requirements
- future automation direction
- evidence preservation objective

