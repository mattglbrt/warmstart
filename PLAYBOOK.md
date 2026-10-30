# The warmstart playbook

The full system. The README is the quick version; this is the why and the details.

## 1. Design principles

1. **Three files, three lifespans.** Durable context (`CLAUDE.md` changes rarely), current state (`STATUS.md` changes every session), and history (`SESSION_LOG.md` is append-only). Never mix them. Once status facts creep into CLAUDE.md, it rots. If you have to read a 90KB log to know where a project stands, orientation gets expensive.
2. **Context economy over context volume.** Claude Code auto-loads the CLAUDE.md chain (workspace → group → project) every session, so those files must stay tight. Everything else is pulled in on demand: STATUS.md for state, `context/` files for domain knowledge, SESSION_LOG.md only for history questions. It's retrieval by well-named small files instead of embeddings infrastructure. It costs nothing to run and needs no setup.
3. **One source of truth per fact.** Where-we-are lives in STATUS.md. What-happened lives in SESSION_LOG.md. If a fact needs to appear twice, one place holds it and the other points at it.
4. **The board is the business.** `PROJECTS.md` has one row per project. If the board is current, you can switch between projects in 30 seconds.
5. **A session that ends without a wrap is a session the next one pays for.**

## 2. The file standard

**Project folder** (required):
- `CLAUDE.md` — what it is, stack, key commands, conventions, doc map, optional wrap extras.
- `STATUS.md` — Now / Blockers / Next / Recently done / Open questions, date-stamped. One page max.
- `SESSION_LOG.md` — append-only, **newest entry first**. In `docs/` if the project has a docs folder, else the project root.
- Optional: `docs/ARCHITECTURE.md`, `docs/ROADMAP.md`, `context/` for domain knowledge read on demand.

**Group folder** (optional — a client, product line, or venture holding several projects):
- `CLAUDE.md` — the business, the engagement, project index, shared infra, people, hard rules.
- `STATUS.md` — a one-page rollup across its projects.
- `meetings/` — dated meeting notes.

**Workspace root** (optional):
- `PROJECTS.md` — the board, plus a deadlines table.
- `CLAUDE.md` — the orchestrator (see §9), if you use that layer.

Templates for all of these are in `templates/`.

## 3. Session workflow

**Start — `/orient`:** read any `HANDOFF.md`, then the project STATUS.md (+ group STATUS.md if relevant). Get a short brief and pick the session's focus. Don't open the session log unless you need history.

**End — `/wrap`:**
1. Add a SESSION_LOG entry at the top: what happened, decisions, what's open.
2. Rewrite STATUS.md with today's date.
3. If the picture changed, update the group STATUS.md and the PROJECTS.md row.
4. Fold any HANDOFF.md into STATUS, then delete it.
5. Compact the log if it's over ~50KB.
6. Run the project's wrap extras.

**After a meeting — `/intake`:** paste the notes or drop them in `inbox/`. It extracts decisions, actions, deadlines, blockers, asks of you, and open questions, quoting the note and marking inferences. It files the note as `meetings/YYYY-MM-DD-<slug>.md` (summary on top, raw text verbatim below) and folds the changes into STATUS.md. It offers `HANDOFF.md` files for any other projects the note touches. Meeting notes are evidence: names, dates, and numbers stay exactly as written, and nothing becomes "done" because it was discussed. If a note conflicts with STATUS.md, the note wins for what happened.

## 4. Status discipline

STATUS.md has five sections:
- **Now** — 2–4 lines.
- **Blockers** — who or what you're waiting on, always naming a person.
- **Next** — ranked, ≤5 items.
- **Recently done** — the last few sessions only.
- **Open questions** — each with an owner.

Hard cap: one page. STATUS.md is what makes session startup cheap, so it has to stay small enough to read in one gulp. Anything older than "recently" belongs in the session log.

Good STATUS habits:
- Lead with the thing that's about to bite: a date, a broken link, a decision someone owes you.
- "Rules earned recently" is a useful optional section. Put lessons the next session must not relearn there, then promote the durable ones into CLAUDE.md.
- Never mark something done because it was discussed. Done means done.

## 5. Weekly review (Friday, ~30 min)

Run `/weekly` from the workspace root (orchestrator layer), or do it by hand:
- Walk every project's STATUS.md: status changes, top 3 for next week, blockers to chase, and deadlines inside 14 days.
- Flag STATUS files older than 14 days, then refresh them or mark them dormant.
- Walk `RECURRING.md`, which holds the work that comes back on a cadence rather than finishing.
- Refresh `PROJECTS.md`. Its "Blocked on" column is your chase list.

## 6. Setting up a new project

```bash
bash install.sh <path-to-project> ["Project Name"]
```

It creates `CLAUDE.md`, `STATUS.md`, `SESSION_LOG.md`, and `.claude/commands/{orient,wrap,intake}.md`. It never overwrites a file that already exists. After that:
1. Fill in CLAUDE.md with durable facts only.
2. Add a row to `PROJECTS.md` if you keep a board.
3. Set up `.gitignore` before the first commit: `.env*`, logs, raw data, `.claude/settings.local.json`.

## 7. Naming & hygiene

- Dated artifacts get a `YYYY-MM-DD` prefix. Meeting notes go in `meetings/`, per group.
- Kebab-case folder names, with no trailing spaces.
- Logs go in `logs/` (gitignored), never the project root.
- `.env` files stay on disk and never go in git. Docs reference secrets by location and never copy them.
- Raw source data is read-only. Never edit the originals.

## 8. Log compaction

When SESSION_LOG.md passes ~50KB:
- Move the older half to `SESSION_LOG_ARCHIVE.md`.
- In its place, leave a dated summary block of 5–15 lines: the era covered, major things shipped, and key decisions with dates.

Claude reads the summary by default and the archive only when asked.

The same idea works for any doc that only grows. For roadmaps, move shipped items to a changelog section. For trackers, archive the closed rows.

## 9. The orchestrator layer (optional)

If you run many projects, start a Claude Code session at the **workspace root** with `orchestrator/CLAUDE.md` installed there. That session becomes the management layer above every project:

- Drop meeting notes or emails in `inbox/` and run **`/intake`**. It files the note under the group's `meetings/`, updates the group and project STATUS.md files and the board, then writes a dated **`HANDOFF.md`** at each affected project root.
- The next project session picks the handoff up on `/orient` and folds it in, then deletes it, on `/wrap`.
- **`/brief <group>`** — meeting prep.
- **`/followup <group>`** — a recap email draft, never sent.
- **`/weekly`** — the Friday review.
- **`/pulse`** — a read-only 60-second status.

The division of labor: **the orchestrator manages, project sessions build.** Keep intake, briefs, and cross-project sync out of build sessions, where they'd burn the context that's meant for the work.

## 10. Wrap extras

Every project has its own end-of-day chores. Put them in a `## Wrap extras` section of the project's CLAUDE.md instead of forking `wrap.md`. Examples from real use:
- Run `docker ps` and stop this project's containers unless something outside the session depends on them. Ask if unsure.
- Rebuild a personal dashboard that reads every project's STATUS.md (so STATUS is the only thing to update), and add any changed deadline to its data file.
- Commit the session's work with a `Wrap YYYY-MM-DD: …` message.

## 11. Maintaining the system

To change the standard, edit this playbook and the templates, then re-run the installer, which only adds missing files. To push a new version of the commands, use `--update-commands`.

If a convention isn't being followed after two weeks, either enforce it in `/wrap` or delete it from the playbook. A rule nobody follows is worse than no rule.
