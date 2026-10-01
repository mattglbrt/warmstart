#!/usr/bin/env bash
# orient-wrap installer.
#
#   bash install.sh <project-path> ["Project Name"]   set up one project (files + commands)
#   bash install.sh --global                          install /orient + /wrap for every project (~/.claude/commands)
#   bash install.sh --orchestrator <workspace-root>   install the optional root/orchestrator layer
#   bash install.sh --update-commands <path>          overwrite a project's orient/wrap with this version
#
# Idempotent: never overwrites an existing file (except --update-commands, which only touches the commands).
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
TODAY="$(date +%F)"

usage() { sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }

# copy src → dest only if dest doesn't exist
put() {
  if [ -e "$2" ]; then echo "  exists, left alone: $2"
  else mkdir -p "$(dirname "$2")"; cp "$1" "$2"; echo "  created: $2"; fi
}

# render a template with {PROJECT NAME} / {GROUP NAME} / {YYYY-MM-DD} filled in
render() {
  local tpl="$1" dest="$2" name="$3"
  if [ -e "$dest" ]; then echo "  exists, left alone: $dest"; return; fi
  mkdir -p "$(dirname "$dest")"
  local esc; esc="$(printf '%s' "$name" | sed 's/[&/\]/\\&/g')"
  sed -e "s/{PROJECT NAME}/$esc/g" -e "s/{GROUP NAME}/$esc/g" -e "s/{YYYY-MM-DD}/$TODAY/g" "$tpl" > "$dest"
  echo "  created: $dest"
}

[ $# -ge 1 ] || usage

case "$1" in
  -h|--help) usage ;;

  --global)
    DEST="$HOME/.claude/commands"
    echo "Installing /orient + /wrap for all projects → $DEST"
    put "$SRC/commands/orient.md" "$DEST/orient.md"
    put "$SRC/commands/wrap.md"   "$DEST/wrap.md"
    echo "Done. Per-project files (STATUS.md etc.) still come from: bash install.sh <project-path>"
    ;;

  --update-commands)
    [ $# -ge 2 ] || usage
    DEST="$2/.claude/commands"; mkdir -p "$DEST"
    cp "$SRC/commands/orient.md" "$SRC/commands/wrap.md" "$DEST/"
    echo "Updated orient.md + wrap.md in $DEST"
    ;;

  --orchestrator)
    [ $# -ge 2 ] || usage
    ROOT="$2"
    echo "Installing the orchestrator layer → $ROOT"
    put "$SRC/orchestrator/CLAUDE.md" "$ROOT/CLAUDE.md"
    for c in "$SRC"/orchestrator/commands/*.md; do put "$c" "$ROOT/.claude/commands/$(basename "$c")"; done
    render "$SRC/templates/PROJECTS.md"  "$ROOT/PROJECTS.md" ""
    render "$SRC/templates/RECURRING.md" "$ROOT/_system/RECURRING.md" ""
    put "$SRC/PLAYBOOK.md" "$ROOT/_system/PLAYBOOK.md"
    for t in "$SRC"/templates/*.md; do put "$t" "$ROOT/_system/templates/$(basename "$t")"; done
    mkdir -p "$ROOT/inbox/processed" "$ROOT/_system/reviews"
    [ -e "$ROOT/inbox/README.md" ] || echo "Drop meeting notes, emails, transcripts here, then run /intake from the workspace root." > "$ROOT/inbox/README.md"
    echo "
Done. Next:
  1. Edit $ROOT/CLAUDE.md — fill in the Map and People sections.
  2. Set up each project:  bash $SRC/install.sh <project-path>
  3. Start Claude Code at $ROOT and try /pulse."
    ;;

  -*) usage ;;

  *)
    DEST="$1"; NAME="${2:-$(basename "$(cd "$DEST" 2>/dev/null && pwd || echo "$DEST")")}"
    mkdir -p "$DEST"
    echo "Installing orient/wrap → $DEST ($NAME)"
    put "$SRC/commands/orient.md" "$DEST/.claude/commands/orient.md"
    put "$SRC/commands/wrap.md"   "$DEST/.claude/commands/wrap.md"

    if [ -e "$DEST/claude.md" ] && [ ! -e "$DEST/CLAUDE.md" ]; then
      echo "  exists, left alone: $DEST/claude.md"
    else
      render "$SRC/templates/CLAUDE.project.md" "$DEST/CLAUDE.md" "$NAME"
    fi
    render "$SRC/templates/STATUS.md" "$DEST/STATUS.md" "$NAME"

    if [ -e "$DEST/SESSION_LOG.md" ] || [ -e "$DEST/docs/SESSION_LOG.md" ]; then
      echo "  exists, left alone: SESSION_LOG.md"
    else
      LOGDIR="$DEST"; [ -d "$DEST/docs" ] && LOGDIR="$DEST/docs"
      render "$SRC/templates/SESSION_LOG.md" "$LOGDIR/SESSION_LOG.md" "$NAME"
    fi

    if [ -f "$DEST/.gitignore" ] && ! grep -q 'settings.local.json' "$DEST/.gitignore"; then
      printf '\n.claude/settings.local.json\n' >> "$DEST/.gitignore"
      echo "  added .claude/settings.local.json to .gitignore"
    fi

    echo "
Done. Next:
  1. Fill in $DEST/CLAUDE.md — durable facts only (what, stack, commands, conventions).
     If CLAUDE.md already existed, add the 'Session workflow' footer from templates/CLAUDE.project.md.
  2. Start Claude Code in $DEST and run /orient. End every session with /wrap."
    ;;
esac
