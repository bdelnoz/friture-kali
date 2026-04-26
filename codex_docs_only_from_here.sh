#!/usr/bin/env bash
set -u

ROOT="."
OUT="/tmp/codex_docs_only_from_here_$(date +%Y-%m-%d_%H%M%S).log"

PROMPT='Mets à jour uniquement les fichiers Markdown et documentations (*.md, README*, CHANGELOG*, INSTALL*, WHY*, SPECIFICATIONS*) en fonction des scripts, du code et des fonctionnalités présents dans ce dépôt.

Contraintes strictes :
- Ne modifie AUCUN script ni fichier de code, quel que soit le langage.
- Ne modifie AUCUN fichier de configuration ou paramètre.
- Ne modifie AUCUN fichier binaire, lockfile, JSON, YAML, TOML, INI, ENV, service systemd, Dockerfile, Makefile, shell, Python, JS, TS, etc.
- Ne crée/modifie/supprime que des fichiers de documentation Markdown.
- Mets la documentation en cohérence avec l’état réel du dépôt.
- Si la documentation est déjà correcte, ne change rien.
- À la fin, vérifie avec git diff --name-only que seuls des fichiers de documentation ont été modifiés.'

echo "LOG: $OUT"

find "$ROOT" -type d -name .git -prune | sort | while read -r gitdir; do
  repo="$(dirname "$gitdir")"

  echo
  echo "===== REPO: $repo =====" | tee -a "$OUT"

  cd "$repo" || continue

  if [ -n "$(git status --porcelain)" ]; then
    echo "SKIP dirty repo: $repo" | tee -a "$OUT"
    cd - >/dev/null || exit 1
    continue
  fi

  codex exec "$PROMPT" 2>&1 | tee -a "$OUT"

  echo "--- Modified files:" | tee -a "$OUT"
  git diff --name-only | tee -a "$OUT"

  BAD="$(git diff --name-only | grep -Ev '(^|/)(README|CHANGELOG|INSTALL|WHY|SPECIFICATIONS|AGENTS|CLAUDE|CONTRIBUTING|SECURITY|LICENSE|NOTICE)(_[A-Z]{2})?(\.md)?$|\.md$' || true)"

  if [ -n "$BAD" ]; then
    echo "ERROR non-doc files modified in $repo:" | tee -a "$OUT"
    echo "$BAD" | tee -a "$OUT"
    echo "Rollback repo..." | tee -a "$OUT"
    git restore .
    git restore --staged .
    cd - >/dev/null || exit 1
    continue
  fi

  echo "OK docs-only: $repo" | tee -a "$OUT"

  cd - >/dev/null || exit 1
done

chown nox:nox "$OUT" 2>/dev/null || true
echo "$OUT"
