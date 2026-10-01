# CLAUDE.md — {PROJECT NAME}

<!-- Durable facts only. Anything that changes week to week goes in STATUS.md. Keep this short: Claude Code loads it into every session. -->

## What this is
{2–4 lines: purpose, who uses it, what "done" looks like.}

## Stack & environment
{Languages, frameworks, services. Note where secrets live (e.g. `.env`) — never paste them here. Local dev URL, deploy target.}

## Key commands
{Build / test / run / deploy commands.}

## Conventions
{Do/don't rules that keep quality up.}

## Doc map
- `STATUS.md` — where we are now (read first)
- `SESSION_LOG.md` (or `docs/SESSION_LOG.md`) — history, newest first
- {other docs: ARCHITECTURE, ROADMAP, context/ files read on demand}

## Wrap extras
<!-- Optional. Project-specific steps /wrap should run at the end of every session. Delete the section if you don't need it. Examples:
- Run `docker ps`; stop this project's containers unless something outside the session needs them.
- Update this project's card in ~/dashboard/data.json and rebuild.
-->

---

## Session workflow
Start: `/orient` — read `STATUS.md`. End: `/wrap` — session log entry, refresh STATUS.md, roll up to the group STATUS.md + `PROJECTS.md` if the picture changed.
