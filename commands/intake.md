---
description: Turn meeting notes into project state — /intake [file] (or paste the notes)
---
Process meeting notes, call transcripts, or client emails into this project. Source = the file named in the argument, anything pasted in this message, or (if neither) every file in this project's `inbox/` except `README.md` and `processed/`. One note at a time:

1. **Check fit.** Confirm the note is about this project. If it's mostly about a different project, say so and stop. If it touches other projects too, list them at the end (see step 6).
2. **Extract** into a structured block:
   - **Decisions** — what was agreed
   - **Actions** — who does what, by when (if a date was given)
   - **Deadlines** — ISO date + owner
   - **Blockers** — who we're waiting on, for what
   - **Asks of me** — anything the user personally owes someone
   - **Changes to the plan** — facts that change STATUS.md
   - **Open questions**

   Quote the note. Names, dates, and numbers exactly as written. Anything you inferred is marked "(inferred)". Never mark something done because it was discussed.
3. **File the note** as `meetings/YYYY-MM-DD-<slug>.md` (date of the meeting, not today, if the note says it), with a one-line header (date · who · source), the step-2 block on top (Actions as a Who / What / By table), and the raw text verbatim below under `## Raw notes (verbatim)`.
4. **Update STATUS.md:** fold the decisions, deadlines, blockers, and open questions into Now / Blockers / Next / Open questions, and re-stamp the date. If the note conflicts with STATUS.md, the note wins for *what happened* — say so in your reply.
5. **Board:** if a `PROJECTS.md` exists up the tree, add any dated deadlines (with owner) to its Deadlines table and refresh this project's row.
6. **Other projects:** if the note affects sibling projects, offer to write a short dated `HANDOFF.md` at each of their roots (≤ 20 lines: what was said, decisions, deadlines, questions). Don't write into another project without a yes.
7. If the note came from `inbox/`, move it to `inbox/processed/`.

Do not touch code, CLAUDE.md, or roadmaps. Reply with: where the note was filed, what changed in STATUS.md, deadlines added, and a short **"Needs you"** list.
