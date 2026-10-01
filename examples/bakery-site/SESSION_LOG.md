# Session Log — bakery-site

Append-only working record. **Newest entry first.**

---

## 2026-03-12 — Order form live on Netlify Forms

**Context:** The form was the last piece of functionality that touched the backend before launch.

**What happened:** Rebuilt the order form in `src/components/OrderForm.astro` with `data-netlify="true"` and a honeypot field, then submitted a test order. It landed in Netlify → Forms, and the notification email went to Dana's address.

**Decisions:** Netlify Forms over a third-party form service. It's free at this volume and removes one account for Dana to manage.

**Open:** Menu prices (Dana). DNS access (Dana).

**Next session:** Catering and About pages, then redirects.

## 2026-03-10 — Four pages ported

**Context:** First build session after the kickoff call.

**What happened:** Ported Home, Menu, Visit, and Gallery. Re-exported 40 images to WebP, which took the page weight from 6.1 MB to 1.4 MB.

**Decisions:** Kept the old URL structure where we could to minimize redirects.

**Open:** Prices on the old site look stale. Asked Dana.

**Next session:** Order form.
