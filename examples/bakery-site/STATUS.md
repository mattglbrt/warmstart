# STATUS — bakery-site · updated 2026-03-12

## Now
Static Astro rebuild of a neighborhood bakery's WordPress site. Five of seven pages are ported, and the order form posts to Netlify Forms. Launch is planned for Fri **03-20**.

## Blockers
- **Dana (owner):** final menu prices. The menu page is built with placeholders marked `TBD`.
- **Dana:** DNS access, so the domain can be pointed at Netlify.

## Next (ranked)
1. Port the last two pages (Catering, About).
2. Swap in Dana's prices as soon as they arrive. Do not guess them.
3. Set up 301 redirects from the old WordPress URLs (list in `docs/redirects.csv`).
4. Run a Lighthouse pass on mobile and fix anything under 90.

## Recently done
- 03-12 — Order form wired to Netlify Forms, with a test submission received.
- 03-10 — Home, Menu, Visit, and Gallery pages ported, with images re-exported to WebP.

## Open questions
- Does Dana want online ordering later? If so, Square or Shopify? (Dana)

## Rules earned recently
- Menu prices only come from Dana in writing. The old site's prices are 2 years stale.
