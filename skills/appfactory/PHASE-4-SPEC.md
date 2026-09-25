# Phase 4 — The spec

Output: `IDEATION.md` in the workspace folder (or the current directory if no workspace is set).

**The bar: someone who has read none of the prior work could build the app's functionality from it, screen by screen, without guessing.** Phase 5 writes code straight from this file; a thin spec makes a thin app. One line per screen or feature is not enough.

## App identity
- **Name**: from Phase 1
- **Tagline**: one line, from the problem statement
- **Description**: 2–3 paragraphs, from the PM lens and persona synthesis

## Design direction — first, for the app AND its public page

One bounded pass, before the design system below is written. It is cheaper than any rebuild, and it is where "could be any app" is decided. This is the checklist's `app.design` step.

1. **`impeccable init`** → `PRODUCT.md` in the app root: audience, the job, tone, the anti-references. Answer its interview yourself from this spec (it accepts a structured simulated-user interview); do not ask the owner. Every later `impeccable` run — the build checks, `app.review`, `site.review` — reads it.
2. **Directions, on a canvas when you have one.** If the Claude Design tools are connected (`create_design`, `create_inspiration_document`), make two or three distinct directions on one canvas, each showing the **primary screen and the landing-page hero** together, so the app and its page are one product. Without them, run `impeccable`'s new-work flow to commit one visual world in-thread. Pick one yourself and log why in `.appfactory/DECISIONS.md`. Two or three, once — not a loop.
3. **Write it down where the code reads it.** After `appfactory new`, put the chosen direction's tokens in `DESIGN.md` *outside* the generated markers under a `## Direction` heading, as CSS custom properties in a css block — `--accent`, `--bg`, `--ink`, `--font-display`, `--font-body`, `--font-mono`, `--radius` (stacks end in a generic family, e.g. `'Petrona', Georgia, serif`), plus spacing and motion notes — and pick the design recipe that matches it. The app's styles and the site generator (`appfactory site`) both take their look from there.

## Design system
Specific enough that two sessions building from it produce the same-looking app — the direction above, made concrete. Use `ui-ux-pro-max` for exact palette, font-pairing and style values rather than inventing them.
- **Colour palette** — hex for each: background, surface/card, primary text, muted text, accent (buttons/links), success, error/warning. Derived from the app's mood, not two colours reused everywhere.
- **Typography** — font family (say "system stack" explicitly if so) and a named scale of 4–5 sizes/weights: screen title, section header, body, button label, caption.
- **Spacing and sizing** — base unit (e.g. 8px) and its scale; one corner radius in px; touch target floor (44px).
- **Component look** — buttons (default/pressed/disabled), cards (border vs shadow vs flat), inputs, list items; 2–3 sentences each.
- **Motion** — an explicit policy, even "no motion beyond native browser defaults".
- **Tone reference** — one or two apps it should feel closer to, what is borrowed and what is avoided.

## First run
- **Onboarding cards** — three (four at most), one promise each in the customer's words about what the app does *for them*, not a feature tour. Title and body per card; the last button is the first real action ("Add your first item", not "Get started"). **"No onboarding" is a valid explicit answer** — say which and why. The chassis owns the layout (`<Onboarding :cards>`); the spec owns the copy.
- **The first screen with no data** — the most-seen screen; what it says and its one action.
- **Permissions** — which, and at which moment. Never on launch; each with the sentence saying why.

## App icon
- **Concept** — subject/motif, composition, how it reads at home-screen size.
- **Colours** — which palette colours and in what proportion.
- **Style** — flat/geometric, illustrative, photographic or wordmark, and why.
- **Generation input** — one dense sentence for `brand.iconPrompt`. `app.icons` always runs (Gemini if keyed, otherwise a local brand monogram); do not wait for artwork or a key. Skip the prompt only if real artwork was supplied.

## What every app ships with

**The resolved chassis and its bindings provide the technical implementation.** Design against them; do not invent a parallel stack or hard-code Ionic patterns from memory. After `appfactory new`, read:

| Artefact | What it tells you |
|---|---|
| `APPSPEC.json` | Product intent: stack profile, navigation shell, design recipe, platforms |
| `resolved-blueprint.json` | Pinned chassis, adapters, and **bindings** that implement that intent |
| `DESIGN.md` | Visual contract from the design recipe (generated block) plus project notes outside the markers |
| `.appfactory/ownership.json` | Which paths the factory/adapters own vs which the app owns |
| Chassis / binding instruction packs | Framework-specific how-to (components, router shape, tokens) for **this** chassis |

You decide screens, copy, flows and the domain model; the chassis decides which shell component, router and tokens file. Name each product concern in the spec — tabs or stack destinations, empty states, settings, help, demo data, destructive actions with undo, announcements — and implement it the way the resolved chassis documents. **If the app deliberately omits a shell affordance, say which and why. Silence is not an answer.**

**House style is available, not compulsory.** Read the chassis's own house-style/shell docs (under its `src/core/`); take them wholesale, in part, or not — state which. Always use the recipe's tokens (`recipe.css` or equivalent).

## Three surfaces

The server routes `/` to a marketing page, `/app` to the app, `/demo` to the app with sample data.

- **Landing page** (`public/landing.html`) — the factory generates it (see [`MARKETING-SITE.md`](MARKETING-SITE.md)) in the direction chosen above; the spec supplies the headline, the one sentence under it, and three points about what someone GETS. **If the app has no audience to convince, say so** — the file is deleted and `/` serves the app.
- **Demo** (`/demo`) — what sample data shows off. Seeded with `demoData(rows)`, kept out of real storage, `DemoBanner` left in place.
- **The four documents** — privacy, terms, support, about. Say what is true of THIS app, especially anything it sends off the device; App Review opens all four.

## Key screens
For each of the 4–6 core screens, a paragraph: the specific UI elements, what the user can do, what happens when they do it, what state it reads or writes, and which components/colours it uses. Not "detour alert card" but: name, photo, blurb, detour-time badge, two buttons (Take it / Skip), what each does to state, a Card with the accent on the primary button.

## Primary user flow
A new user's first session as numbered steps, screen by screen, action by action — a script someone could act out.

## Feature plan
- **MVP** (fewer than 8) — 2–4 sentences each of the actual mechanic, not the name. If you can't describe it, make a defensible product decision and log it.
- **v2+** — one line each.

## Technical direction
- **Architecture** — client, server, data, services (2–3 sentences).
- **Data model** — entities with their fields and relationships, e.g. `Trip { destination, distance, stops[], startedAt }`.
- **Addons** — which of auth/sync/collab/paywall/sharelinks/email.
- **Target age rating** — from the security lens and audience.
- **Mocked vs real** — anything the MVP fakes instead of a paid API, and what a real integration would need.

## Store listing
- **Keywords** — 5–10 search terms
- **Promotional text** — one sentence for the App Store subtitle
- **Support email**

## Design review (before saving)

For each, the spec already answers it concretely or you add the line now:

1. **First impressions** — what the first screen says in 3 seconds; the single primary action.
2. **Flows** — onboarding, core task, settings, error recovery, no dead ends.
3. **Empty & error states** — every list/feed/search has an empty state (why + one CTA); errors say what happened and what to do.
4. **Forms** — labels (not placeholder-only), validation on blur, input types, destructive-action friction.
5. **Motion** — explicit policy; the transitions that matter.
6. **Accessibility** — modal focus order, contrast intent, touch targets, reduced-motion fallback.
7. **Responsive** — navigation and primary actions on phone vs desktop (thumb zone).
8. **Copy** — specific button verbs; no "Submit" / "Success" / "Nothing here".
9. **Delight** — only what this app earns.

This does not replace the post-build pass (`app.review`).

## Save it

Do not stop for approval. Review once against the list above, fix what it finds, then write `IDEATION.md` with `cat > IDEATION.md << 'EOF'`. If the idea came from Idea Box, open with the front matter from [`PHASE-0-IDEA.md`](PHASE-0-IDEA.md). Link `PERSONAS.md` rather than repeating the cards. Then [`PHASE-5-BUILD.md`](PHASE-5-BUILD.md).
