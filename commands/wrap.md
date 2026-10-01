---
description: End-of-session wrap — session log, STATUS.md, board, handoff cleanup
---
You are ending a working session. Do the following in order:

1. **Session log.** Summarize this session: what happened, decisions made (with reasoning), artifacts created (with paths), what's still open. Add it as a new entry at the TOP of this project's `SESSION_LOG.md` (check `docs/SESSION_LOG.md` first, else the project root), matching the existing entry format. Newest first, always.
2. **STATUS.md.** Rewrite it: Now / Blockers / Next (ranked) / Recently done / Open questions. Stamp today's date in the header. Keep it under one page — anything older than "recently" belongs in the log, not here.
3. **Roll up.** If the project's phase, next action, or blockers changed: update the group `STATUS.md` one directory up (if there is one) and this project's row in the nearest `PROJECTS.md` board up the tree (if there is one).
4. **Handoff.** If a `HANDOFF.md` exists at the project root: fold anything still relevant into STATUS.md (Next / Blockers / Open questions), note in the session-log entry which handoff items were addressed, then delete `HANDOFF.md`.
5. **Compaction.** If `SESSION_LOG.md` now exceeds ~50KB, move the older half to `SESSION_LOG_ARCHIVE.md` and leave a dated summary block in its place (5–15 lines: era covered, major things shipped, key decisions with dates).
6. **Wrap extras.** If this project's `CLAUDE.md` has a `## Wrap extras` section, do those steps now (e.g. update a dashboard, stop Docker containers). If you can't tell whether a step is safe, ask rather than act.
7. **Reply** with the refreshed "Next" list (and one line per wrap extra you ran), so the user leaves with clear next actions.
