---
description: Process meeting notes / inputs from inbox (or pasted) into the system
---
Process inputs. Source = every file in `inbox/` (ignore `README.md` and `processed/`) plus anything pasted in this message. For EACH note, one at a time:

1. **Identify** the group and the project(s) it touches (folder names in the workspace map in the root `CLAUDE.md`). If ambiguous, ask before proceeding.
2. **Extract** into a structured block: Decisions · Actions (owner, date if any) · Deadlines (ISO date, owner) · Blockers (who) · Asks of me · Facts that change STATUS · Open questions. Quote the note; mark inferences "(inferred)".
3. **File the note:** write a cleaned copy to `<group>/meetings/YYYY-MM-DD-<slug>.md` in the shape of `_system/templates/MEETING_NOTE.md`: the structured block at the top and the raw text below. Preserve the raw text verbatim.
4. **Update state:** the group `STATUS.md` (date-stamped) and, where the note clearly changes a project's picture, that project's `STATUS.md`. Do not touch code, roadmaps, or CLAUDE.md files.
5. **Board:** add dated deadlines (with owner) to the Deadlines table in `PROJECTS.md`, and update affected project rows.
6. **Handoff:** write `HANDOFF.md` at each affected project root — dated, ≤ 20 lines: what was said that matters to the build, decisions that change scope, deadlines now binding, questions for the next session to resolve. If a HANDOFF.md already exists, add a new dated section at the top.
7. Move the raw file to `inbox/processed/` (keep the name).

Use subagents for any reading beyond STATUS files. Finish with a report: per note — group, files written, STATUS changes, deadlines added, handoffs written — and a single consolidated **"Needs me"** list.
