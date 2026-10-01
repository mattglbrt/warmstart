# orient/wrap

A session system for [Claude Code](https://claude.com/claude-code). It uses two slash commands and three files, so every session starts knowing where the project is and ends leaving it better documented than it found it.

```
/orient   →   work   →   /wrap
  reads         ↑         writes
STATUS.md       │      SESSION_LOG.md + STATUS.md
  (+ HANDOFF)   └──────── next session ───────┘
```

## The problem

Every Claude Code session starts cold. You either re-explain the project, or Claude spends a big slice of its context reading code, old notes, and logs to work out where things stand. Then the session ends, and what you decided lives only in a transcript you'll never open again.

Multiply that across ten projects and you spend half your time re-orienting.

## The fix: three files, three lifespans

| File | Holds | Changes | Who reads it |
|---|---|---|---|
| `CLAUDE.md` | Durable facts: what it is, stack, commands, rules | Rarely | Claude Code, automatically, every session |
| `STATUS.md` | Where we are **now**: Now / Blockers / Next / Recently done / Open questions. **One page max.** | Every session | `/orient` |
| `SESSION_LOG.md` | What happened, newest first. Decisions and the reasons for them. | Appended every session | Only when you ask a history question |

The rule that makes it work is **never mix them**. If status creeps into CLAUDE.md, CLAUDE.md rots. If you have to read a 90KB log to know where you are, orientation gets expensive. STATUS.md stays one page, so orientation costs one small file.

## The two commands

**`/orient`** (start of session) reads any `HANDOFF.md`, then `STATUS.md`, and gives you a five-part brief: where it is, what's in flight, blockers, what the handoff changes, and a ranked suggestion for this session's focus. It deliberately does *not* read the log or the code.

**`/wrap`** (end of session):
- writes a session-log entry (what happened, decisions and why, artifacts, what's open)
- rewrites STATUS.md with today's date
- rolls up to a parent STATUS.md and a `PROJECTS.md` board if you keep them
- folds any `HANDOFF.md` into STATUS and deletes it
- compacts the log when it passes ~50KB
- runs any project-specific **wrap extras**

It ends by handing you the ranked Next list.

> A session that ends without a wrap is a session the next one pays for.

## Install

Requires bash: macOS, Linux, WSL, or Git Bash on Windows.

```bash
git clone https://github.com/<you>/orient-wrap.git
cd orient-wrap

# Set up a project (creates CLAUDE.md, STATUS.md, SESSION_LOG.md, .claude/commands/{orient,wrap}.md)
bash install.sh ~/code/my-project "My Project"
```

The installer never overwrites a file that already exists, so it's safe on existing projects. If your project already has a CLAUDE.md, add the short "Session workflow" footer from `templates/CLAUDE.project.md` to it.

**Other options:**

```bash
bash install.sh --global                      # /orient + /wrap available in every project (~/.claude/commands)
bash install.sh --orchestrator ~/code         # the optional management layer (see below)
bash install.sh --update-commands ~/code/x    # push a newer orient/wrap into a project
```

Then open Claude Code in the project and run `/orient`. End every session with `/wrap`.

## See it

[`examples/bakery-site/`](examples/bakery-site/) is a small fictional project mid-flight. It has a STATUS.md, a session log, a CLAUDE.md with a wrap extra, and a HANDOFF.md waiting to be picked up. Copy the folder somewhere, start Claude Code in it, and run `/orient`.

## Wrap extras

Every project has its own end-of-session chores. Don't fork `wrap.md`. Add a section to the project's CLAUDE.md instead:

```markdown
## Wrap extras
- Run `docker ps`; stop this project's containers unless something outside the session needs them. Ask if unsure.
- Commit the session's work as `Wrap YYYY-MM-DD: <headline>`.
```

## Scaling up: groups, the board, and the orchestrator

This part is optional. Use it once you're juggling a lot of projects.

```
workspace/
├── CLAUDE.md            ← orchestrator (optional)
├── PROJECTS.md          ← the board: one row per project + deadlines
├── inbox/               ← drop meeting notes here
├── _system/             ← playbook, templates, RECURRING.md, weekly reviews
└── clients/acme/        ← a "group": CLAUDE.md + rollup STATUS.md + meetings/
    ├── website/         ← a project: CLAUDE.md, STATUS.md, SESSION_LOG.md
    └── crm/
```

- **Groups** (a client, a product line) get their own CLAUDE.md and a one-page rollup STATUS.md. Claude Code loads the CLAUDE.md chain automatically, so shared rules live in one place.
- **The board** (`PROJECTS.md`) has one row per project, plus a deadlines table. `/wrap` keeps your row current.
- **The orchestrator** is a Claude Code session started at the workspace root. It manages and doesn't build:
  - **`/intake`** — drop meeting notes in `inbox/`. It files them, updates the STATUS files and the board, and writes a `HANDOFF.md` into each affected project. The next session in that project picks the handoff up on `/orient`.
  - **`/pulse`** — a 60-second read-only status: what's due, who's blocking what, and what's stale.
  - **`/weekly`** — the Friday review across everything.
  - **`/brief <group>`** — meeting prep.
  - **`/followup <group>`** — a recap email draft. It never sends.

Keeping management out of build sessions means build sessions spend their context building.

## The rules that matter

1. **STATUS.md ≤ one page.** If it's longer, move the old stuff to the log.
2. **Newest entry first** in the session log.
3. **Every blocker names a person. Every deadline has a date and an owner.**
4. **"Done" means done**, not "discussed."
5. **One source of truth per fact.** Everything else points at it.
6. **If a rule isn't followed after two weeks**, enforce it in `/wrap` or delete it.

The full reasoning is in [PLAYBOOK.md](PLAYBOOK.md).

## What's in here

```
commands/              orient.md, wrap.md — the two project commands
orchestrator/          CLAUDE.md + intake, pulse, weekly, brief, followup (optional root layer)
templates/             CLAUDE.project.md, CLAUDE.group.md, STATUS.md, SESSION_LOG.md,
                       HANDOFF.md, PROJECTS.md, RECURRING.md, WEEKLY_REVIEW.md
examples/bakery-site/  a worked example
install.sh             the installer
PLAYBOOK.md            the full system
```

## FAQ

**Does this need an API key or any service?** No. It's markdown files and slash commands, and it runs on whatever Claude Code plan you already have.

**Why not just use Claude Code's memory / `--continue`?** Use those too. They remember *conversations*. This remembers the *project*, in plain files that live in the repo, diff in git, survive a switch between machines, and are readable by teammates and future you without opening Claude at all.

**Should STATUS.md and SESSION_LOG.md be committed?** Usually yes. They're the project's working memory, and git history on STATUS.md is a nice timeline. Skip it for a repo where internal notes shouldn't be public.

**Can I change the STATUS sections?** Yes. Edit `templates/STATUS.md` and the section list in `commands/wrap.md` together.

## License

MIT. Built by Matt Gilbert ([Everyway](https://goeveryway.com)) from the system he runs his consulting practice on.
