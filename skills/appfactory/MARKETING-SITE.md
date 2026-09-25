# The public page

`/` is the page a stranger reads before installing, the URL both store listings
point at, and the first thing a store reviewer opens. `appfactory ux` never
visits it (QA boots at `/demo`), and Lighthouse scores a placeholder page 100 —
so it gets one deliberate look.

## 1. Let the factory generate it

`appfactory site --apply` (the `web.site` step) writes `public/landing.html`,
`about.html` and `support.html` from what the app already knows: the plan's
screens become what it does, the primary flow becomes how it works, the listing
and APPSPEC summary become the lede, `public/marketing/*.png` become the hero
and the screenshot strip, DESIGN.md and the design recipe set the palette, type,
radius and layout variant, and `store.links` in app.config.json becomes the
"Get the app" block — the web app always, **Join the iOS beta** once a
TestFlight public link exists, **Join the Android beta** once a closed or open
Play track is live, and the store pages once the app is. Beta review and the
release gate save those links themselves, and the page re-renders.

So the page is never a placeholder, and most of the time improving it means
improving its inputs — a sharper plan, a real description, better screenshots —
and re-running. The design pass below is for when the generated page is right
but not yet *good*. The moment you edit `public/landing.html` by hand it is
yours: the generator leaves it alone and writes its next version to
`.appfactory/site/landing.generated.html` instead (`--force` replaces yours,
after backing it up).

Run `appfactory screenshots` first if the captures do not exist — a broken image is
worse than none.

The page inherits the app's palette, type scale and tokens. It is allowed to be
more expressive than the app — more space, larger type, a real hero — and it is not allowed to
be a different product.

**No audience to convince** (a tool somebody installs from a link they were
sent) → delete `public/landing.html` and log why; `/` then serves the app and
the step detects as done. Not the answer for anything with a price, a
catalogue, a coverage area or a competitor.

## 2. One critical visual review — the `site.review` step

This is a checklist step. It runs on its own track, alongside the app build and store work, and holds nothing else up. Serve the page, open
it at 390px and at desktop width, and run the **`impeccable`** skill's
`critique` on `public/landing.html` (Persuade mode). Read it as somebody who has
never heard of the app. Fix real problems only — the list below — and do not
restyle a page that works. When done, record it against this version of the page:

    appfactory site --reviewed "<what the review found and what you changed>"

Regenerating the page with different content reopens the step. A problem that
would repeat on every app is a template bug: fix `cli/lib/site/` in the factory
and note it in FACTORY-TEST-NOTES.md, which improves every page at once.

- **Scaffold text survived** — `{{app.tagline}}`, "Replace these three", "Name the screen", "Replace this paragraph" on About. The step's detector catches these; fix them in the source data and re-run `appfactory site`.
- **The hero says what the software is instead of what it does for the reader**, or the product (real screen, real object) is not in it above the fold.
- **The sentence only this product can say is missing** — the computed price, the arrival time, the number that is the reason it is interesting. Figures come from the app's own data and functions, never typed; no figure, no sentence.
- **More than one primary action.** A second is allowed and it is nearly always the demo. The demo is linked from the hero, header and footer.
- **The accent is spent elsewhere.** It belongs to the primary button, the brand mark, the current nav item and the focus ring — nowhere else.
- **A CTA drops the visitor at Home** when the page was about one thing. Every CTA carries its intent (`/app?task=cleaning`), validated against the app's catalogue; unknown values degrade to Home.
- **Imagery shrunk on purpose** — `object-fit: contain` in a padded grey box. Photos fill their frame.
- **Invented evidence** — testimonials, logos, ratings, user counts, press. If it is not true today, the section does not exist. Say what is illustrative.
- **The page could be about any product** with the name swapped. That is the summary test.

Fix in the generator's inputs (spec copy, `app.config.json`, the data) where
possible, so a re-run does not undo the fix; otherwise in `public/landing.html`.

**Only if the layout itself is wrong** — not the words — redesign it.
`design` first, and this is the one place it leads (a static page has no running
code to disturb, so two directions on one canvas are cheap); then build; then
`impeccable` last, against the rendered page and not the source (its detector
resolves `:root` properties only in `.html`). This is the exception, not a step.

## The constraints that are not negotiable

- **Both stores fetch the support URL before they accept a submission.** `support.html` and `about.html` resolve and say something real; privacy and terms describe this app.
- **No remote `@import` in the boot path.** Use `@font-face` with `font-display: swap`; `appfactory check` fails the other form.
- **Every image has width and height**, plus `srcset`/`sizes` and `loading="lazy"` below the fold. Preload the hero image with `fetchpriority="high"`.
- **Floors:** one `<h1>`; skip link and `<main id="main">`; targets ≥ 44px; body ≥ 16px; contrast 4.5:1 (3:1 large text/UI, including the accent on its background); visible focus; `prefers-reduced-motion` honoured; no horizontal scroll at 320px or 200% zoom; readable with no JavaScript.
- **Lighthouse on `/` below 95 is a finding** — a static page has no excuse for the app shell's floors (`scripts/ci-lighthouse.mjs`: performance ≥ 55, accessibility ≥ 85).
- **It ships live.** `public/` is deployed verbatim.
- **Every link resolves**, including TestFlight — a missing value renders nothing, never a placeholder href.
- **The words are the SEO.** Run `app.seo.review` ([`SEO.md`](SEO.md)) after this, not before.
