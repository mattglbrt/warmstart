# CLAUDE.md — bakery-site

## What this is
A static rebuild of a neighborhood bakery's WordPress site. Done = all pages ported, old URLs redirected, and the order form working, live on the bakery's domain.

## Stack & environment
Astro 5 · Netlify (hosting + Forms). No secrets in the repo, and the Netlify site is linked via `netlify link`. Local: `npm run dev` → http://localhost:4321.

## Key commands
- `npm run dev` · `npm run build` · `netlify deploy --prod`

## Conventions
- Prices, hours, and allergen info come only from the owner (Dana) in writing. Never copy them from the old site.
- Images: WebP, max 1600px wide, always with `width`/`height` attributes.

## Doc map
- `STATUS.md` — where we are now (read first)
- `SESSION_LOG.md` — history, newest first
- `docs/redirects.csv` — old WordPress URL → new path

## Wrap extras
- Commit the session's work: `git add -A && git commit -m "Wrap YYYY-MM-DD: <headline>"`.

---

## Session workflow
Start: `/orient` — read `STATUS.md`. End: `/wrap` — session log entry, refresh STATUS.md, roll up if the picture changed.
