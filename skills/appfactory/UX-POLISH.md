# UX polish pass

You are a world-class UX designer and interaction engineer reviewing this app. Your job is to audit every surface, flow, and interaction — then implement concrete improvements that elevate this from functional to exceptional.

Work through the following review dimensions one at a time. For each, identify specific issues in the current implementation, then make the changes directly.

**When to run this:** After the first build (`app.code`) when the primary user flow works end to end. Mark complete with `appfactory checklist done app.ux`. Prefer finishing this before screenshots so the store listing shows the polished UI.

**The skills this pass runs through, not around.** Each one is invoked, not
paraphrased — they carry current, specific guidance that this file deliberately
does not duplicate:

| Skill | What it is for here | When |
|---|---|---|
| `impeccable` | the whole-interface audit: hierarchy, cognitive load, anti-patterns, live browser iteration | first, to find what is wrong |
| `ui-ux-pro-max` | searchable style, palette, font-pairing, icon and chart data, and stack-specific implementation | when a fix needs a concrete value rather than a direction |
| `microinteractions` | dimension 3, scored against its eight-question diagnostic | on every control a person touches |
| `dataviz` | any chart, meter, stat tile or dashboard in the app | before writing chart code, not after |
| `design` | a canvas of artboards when a screen needs to be SEEN side by side before it is rebuilt | only when a rebuild is on the table |

`impeccable` first: it is the one that finds problems. `ui-ux-pro-max` second:
it is the one that supplies values. Do not run `design` as a matter of course —
it produces a mockup, and this pass changes running code. Reach for it when a
screen needs re-laying-out rather than re-styling, and when comparing several
directions on one canvas is genuinely cheaper than trying them in the app.

**Fan the dimensions out.** They are independent by construction — accessibility,
copy, performance and responsive behaviour do not need to agree about anything —
so one subagent per dimension is the cheapest way to run this pass, and the file
dumps stay in the children. Two things stay with you: dimension 1 (hierarchy)
and the final look at all the screenshots side by side, because a design system
is a cross-screen property and an agent that sees one screen cannot see it. See
[`PARALLEL.md`](PARALLEL.md).

**How to work:**
1. Review the app against every dimension below.
2. Identify the top issues — prioritize by impact on user confidence and task completion.
3. Implement the improvements directly in the code. Don't just list suggestions.
4. For each change, use the minimum CSS/JS needed. Prefer CSS transitions over JS animation libraries. Prefer `transform` and `opacity` for animations (GPU-accelerated, no layout thrash).
5. Keep animations subtle — they should feel natural, not performative. If a user would consciously notice an animation on second use, it's probably too much.
6. Test that nothing breaks on mobile or with keyboard navigation after your changes.
7. Report the issues found and the improvements made.

Leave `src/core/` alone — it is factory-owned and an upgrade replaces it. Polish the app's own screens, styles and copy: `src/App.vue`, `src/components/`, `src/styles/app.css`.

**Start by checking what is MISSING, not what is ugly.** The chassis ships a known set of patterns — tab bar, pushed screens, onboarding, empty states, sheets, swipe-to-delete, undo, grouped settings, screen-reader announcements — most of them Ionic components, and the most common finding in this pass is that the build skipped several of them rather than that it implemented them badly. Walk the "What every app ships with" table in `SKILL.md` first; anything absent without a stated reason is the highest-impact fix on this page.

**A literal hex value or pixel padding in a component is a finding.** Every one is a place the app stops matching itself. Replace with the token: `var(--accent)`, `var(--sp-4)`, `var(--radius)`, `var(--text-sm)`.

**A clean static scan of a `.vue` tree is not evidence.** The `impeccable`
skill's detector routes by extension: only `.html` and `.htm` go through the
engine that resolves `:root` custom properties, and everything else is matched
as literal source text. So on a chassis app — which has no raw hex anywhere by
construction — it returns zero findings *because* the app did the tokenised
thing correctly. One app scanned clean and scored 10/20 on a screen-by-screen
audit of the same build. Use the browser-grade path, which reads computed
styles, or audit the rendered screens; never report a clean detector run as a
pass.

**And the checks below are per-screen; a design system is not.** Six toolbar
patterns and five heading sizes across twenty-four screens is invisible one
screen at a time, and nobody reviews twenty-four screens side by side. When you
finish, put the screenshots next to each other and look at the chrome across all
of them at once.

---

### 1. FIRST IMPRESSIONS & VISUAL HIERARCHY

- Does the page communicate its purpose within 3 seconds?
- Is there a clear visual hierarchy guiding the eye? (primary action → supporting content → secondary actions)
- Are there any "walls of sameness" — areas where everything competes equally for attention?
- Is whitespace used deliberately to create breathing room, or is it accidental?
- Does the typography establish a clear scale? (display → heading → body → caption — with visible contrast between levels)

### 2. USER FLOWS & TASK COMPLETION

- Map every distinct user flow (onboarding, core task, settings, error recovery).
- For each flow: can the user complete the task without hesitating, backtracking, or guessing?
- Are there dead ends — states where the user doesn't know what to do next?
- Does each step clearly indicate: where I am, what I can do here, and how to move forward?
- Are destructive actions (delete, discard, leave without saving) gated with appropriate friction — but not so much friction that routine actions feel heavy?
- Is the happy path effortless? Does the sad path feel recoverable rather than punishing?

### 2b. THE FIRST RUN

Onboarding is the first screen anyone sees and, in every app this factory has
built, the ugliest one — so it gets its own dimension rather than a line inside
flows.

**Use `<Onboarding :cards>` from `src/core/ui/`. Do not build a welcome screen.**
The chassis owns the layout — art in a fixed-aspect box, the promise at display
size, dots, one full-width action in the thumb zone, Skip quiet and below. Every
hand-rolled version regresses to a toolbar with a title in it, which is what
made these screens look like a settings wizard for as long as they did.

What is actually yours is the CARDS, and that is where the ugliness usually is:

- **Three cards. Four at the outside.** A fourth card is a manual, and nobody
  reads a manual to find out what an app is.
- **One promise per card, in the customer's words** — what the app does *for
  them*, not what it has. "Know before you go" beats "Real-time data sync".
- **A card that explains a control is a bug in the control.** Fix the control.
- **The last button is the first real action.** `finishLabel="Add your first
  item"`, not "Get started" — the sequence should end by doing something.
- **Art is optional and bad art is worse than none.** A card with a strong line
  of copy and no image reads as considered; a card with a stock illustration
  reads as a template. If you have no real art, ship the copy alone — the layout
  is written for both.
- **Every card must survive 200% reading size and a 5" screen.** Two lines of
  title, three of body. Check it.
- **No onboarding at all is a valid answer.** An app whose first screen explains
  itself does not need a preamble in front of it. Pass an empty array and the
  component renders nothing.

Then check the rest of the first run, which is the part nobody looks at twice:
the app's very first screen with no data in it (that is an empty state, and it
is the most-seen screen in the app), the first permission prompt (never on
launch — ask at the moment the feature needs it, with a sentence saying why),
and what a returning user sees on day two, which should not be the welcome
again.

### 3. MICRO-INTERACTIONS — THE SOUL OF THE INTERFACE

**Invoke the `microinteractions` skill and work this dimension through it.** It
carries Dan Saffer's four-part structure (Trigger, Rules, Feedback, Loops &
Modes), the eight-question diagnostic and the scoring band. Do not audit this
dimension from the list below alone — the list is what to look at; the skill is
how to judge it.

**The bar: every control a person touches scores 8/10 or better.** Score is
`round(passed / 8 x 10)` over the diagnostic rows. State the score, name the
rows that failed, and fix each one in code. A control at 5/10 "works" — that is
precisely the band this pass exists to move.

Audit at minimum: the app's primary action, every destructive action, every
form submit, every toggle, and whatever the app is actually *for*.

**Start with the four parts, in order.** Most failures here are structural
rather than careless:

- **Trigger** — does it exist visibly, say what it does, and show which state it
  is in (idle, pressed, disabled, busy)? An invisible gesture needs a visible
  alternative.
- **Rules** — what happens at zero, at the maximum, on a repeated tap, on
  interruption? Repeated trigger and empty are the two that break in front of a
  customer.
- **Feedback** — inside 100ms, in proportion to the event, and next to the thing
  that changed. `useAction()` in `src/core/ui/action.js` gives you the first
  three for free; use it rather than a hand-rolled `loading` ref.
- **Loops and modes** — what does the hundredth use look like? Strip the hint
  with `showUntilLearned()`. Any mode has to be visible the whole time it is on.

Then the implementation detail:

**State transitions:**
- Every element that changes state (buttons, toggles, cards, modals) should animate between states rather than jump. Use transitions of 150-250ms for UI controls, 300-500ms for layout changes.
- Buttons should have distinct idle -> hover -> active -> disabled states with visible differences.
- Use subtle scale transforms on press (scale 0.97-0.98) to create tactile feedback.

**Loading & progress:**
- Replace any bare spinners with skeleton screens that mirror the layout of incoming content.
- For actions that take 300ms-2s, use optimistic UI - show the result immediately and reconcile in the background.
- For longer operations, show determinate progress when possible, indeterminate only as a fallback. **Never a bar that moves on a timer** - a fake percentage is the one feedback failure a person cannot forgive once they notice it.
- Add a subtle pulse or shimmer to loading skeletons so they feel alive.

**Feedback & confirmation:**
- Every user action must produce immediate visible feedback - no silent button presses.
- Success states: use a brief, non-blocking toast or inline confirmation rather than a modal. Include a micro-animation (checkmark draw-on, subtle bounce). **Confirm only what the person cannot already see** - a toast announcing a change that is visible on screen is noise, and noise is how people learn to ignore the toast that matters.
- Error states: highlight the specific field or element that failed, not just a banner at the top. Use shake/jiggle animation (subtle, 300ms) to draw the eye to the error location.
- Use haptic-style visual feedback: a brief color flash, a ripple, or a scale pulse on interaction. On native, `haptic()` from `core/util.js` is real - scale it to the event (`tick` for a small change, `pop` for something completed or destroyed).

**Scroll & reveal:**
- Content entering the viewport should fade/slide in subtly (translate 10-20px, not 50+). Stagger sibling elements by 50-80ms for a cascade effect.
- Parallax only where it reinforces content hierarchy - never decorative parallax.
- Sticky headers should transition smoothly (shrink, blur background, add shadow) rather than snap. On this chassis the header is `<AppHeader>` and it already earns its hairline on scroll - do not re-implement it per screen.

**Hover & focus micro-interactions:**
- Interactive elements should telegraph their interactivity before being clicked - cursor change, subtle lift (shadow + translate), color shift, or underline reveal.
- Cards/list items: subtle elevation change or border highlight on hover.
- Links within text: underline animation (slide-in from left, or color transition) rather than static underline toggle.

**Drag, swipe, and gesture:**
- If the app has draggable elements, they should lift (shadow + scale) when grabbed, show a clear drop target, and snap to position with a spring animation on release.
- Swipe actions (if applicable): show the action surface progressively as the user swipes, with resistance at the threshold. Pair the gesture with a visible alternative - a swipe nobody discovers is a feature nobody has.

**Empty states & transitions:**
- Empty states should not be blank. Show an illustration or icon, a clear explanation of why it's empty, and a single primary action to fix it.
- Transitions between empty -> populated states should animate smoothly (content fading/scaling in).

**One signature moment, not twenty.** Pick the action this app is *for* and make
that moment distinctive; everything else gets the quiet default. Apply the
removal test - if nobody would miss it, it is decoration. And never put the next
step behind an animation the person cannot tap through.

**Reduced motion means less movement, not none.** The chassis collapses travel
and scale and keeps a crossfade (`src/styles/ionic.css`). A blanket
`animation-duration: 0.01ms` is not respecting the preference; it turns every
state change into an instant swap that reads as a mis-tap.

### 4. INFORMATION ARCHITECTURE & NAVIGATION

- Is the navigation discoverable without a tutorial?
- Are labels written in the user's language (not developer/system language)?
- Is the current location always clear? (active nav state, breadcrumbs, page title)
- Can the user orient themselves instantly after returning from a deep page?
- Are related actions grouped, and are unrelated actions separated?
- On mobile: are primary actions reachable with one thumb in the natural grip zone (bottom 40% of screen)?

### 5. FORM & INPUT DESIGN

- Labels above inputs (not placeholder-only — placeholders vanish on focus and kill usability).
- Show formatting requirements before the user types, not after they fail.
- Use inline validation on blur, not on every keystroke (which is distracting) and not on submit-only (which is too late).
- Auto-focus the first input when a form appears.
- Use appropriate input types (email, tel, url, number) for mobile keyboard optimization.
- For multi-step forms: show a progress indicator and let users go back without losing data.
- Disable submit buttons only when truly necessary, and prefer showing a brief error message instead — disabled buttons without explanation are a dead end.

### 6. ACCESSIBILITY AS INTERACTION QUALITY

Accessibility isn't a checklist — it's interaction quality for everyone:
- Focus management: when a modal opens, focus moves inside. When it closes, focus returns to the trigger.
- Focus rings: visible, high-contrast, styled to match the design (not the browser default blue ring, but not removed either).
- Reduced motion: wrap all animations in `prefers-reduced-motion` media queries. Provide a static fallback that still communicates state changes.
- Color contrast: minimum 4.5:1 for body text, 3:1 for large text and UI controls. Don't rely on color alone to communicate state — pair with icons, text, or pattern.
- Screen reader: interactive elements have descriptive labels. Live regions (`aria-live`) announce dynamic content changes (toasts, counters, status updates).
- Touch targets: minimum 44×44px on mobile, with adequate spacing between adjacent targets.
- `appfactory ux` now fails on missing accessible names, WCAG AA contrast misses, and keyboard traps / focus escaping an open dialog. Fix those before the taste pass.

### 7. RESPONSIVE & ADAPTIVE BEHAVIOR

- Test every component at 320px, 768px, 1024px, 1440px.
- Navigation should adapt: full nav on desktop, collapsible on tablet, bottom bar or hamburger on mobile.
- Tap targets and spacing must increase on touch devices, not just shrink the desktop layout.
- Tables, charts, or data-heavy components need a mobile strategy (horizontal scroll, card view, or progressive disclosure).
- Modals on mobile should be full-screen or bottom-sheet, not centered floating boxes.

### 8. COPY & MICROCOPY

- Button labels should be specific verbs: "Save changes" not "Submit", "Create account" not "Go".
- Error messages should say what went wrong AND what to do about it: "Email is already registered — try logging in instead" not "Invalid email".
- Empty states need a call to action, not just "Nothing here".
- Confirmations should name the action: "Project deleted" not "Success".
- Avoid jargon, system-speak, and hedging ("An error may have occurred"). Be direct.
- Placeholder text should be realistic examples, not "Enter text here".

### 9. PERFORMANCE AS UX

- Perceived performance matters more than actual performance. Does the UI feel instant?
- Lazy-load below-fold images and heavy components.
- Debounce search inputs (250–400ms).
- Cache previous results so going "back" is instant (no re-fetch).
- Avoid layout shifts — reserve space for images, ads, and dynamic content before they load.
- Use optimistic updates for common actions (like, save, toggle) — show the result immediately.

### 10. DELIGHT & POLISH

The last 5% that separates good from memorable:
- A thoughtful page transition or route animation.
- A custom favicon and page title that updates dynamically (e.g., showing unread count, or current context).
- A considered color mode toggle (light/dark) with smooth transition — only if the design system called for it; do not bolt one on unprompted.
- Keyboard shortcuts for power users, with a discoverable shortcut reference (? key) — when the app has enough density to warrant them.
- A custom selection color that matches the brand.
- Scroll-to-top behavior that's smooth, not jarring.
- Custom scrollbar styling that's subtle and on-brand.
- A print stylesheet if the content is ever printable.
- Error pages (404, 500) that are actually helpful and on-brand — not generic.
- The very first interaction (first click, first hover, first scroll) should already feel polished.

### 11. THE MARKETING SURFACE — THE PAGE BEFORE THE APP

Dimensions 1–10 are about `/app`. This one is about `/`, which is the URL the
store listing points at, the link a person is handed, and the first page a
store reviewer opens. It is the only surface in the product whose defects are
seen by people who never installed anything.

**Nothing else in the pipeline audits it.** `appfactory ux` boots the QA session
at `/demo` and walks the router's screens, so `/` is not merely unvisited — it
is unreachable from the mechanism that decides what to visit. The one automated
eye on it is `scripts/ci-lighthouse.mjs`, which grades performance and
accessibility. A card still reading "Replace these three" scores 100 on both.
So this dimension is done by opening the page and reading it.

**And it ships whether or not anyone writes it.** `web.deploy` publishes the
scaffold as it stands. One app went live with `{{app.tagline}}` under its name,
three cards headed "Replace these three", three captions reading "Name the
screen", and an About page opening "Replace this paragraph" — and was still
wearing them when the release step asked for that URL for the App Store.

**This dimension is about whether the page is any good. `SEO.md` is about
whether it can be found** — positioning, keywords, structured data, answer-engine
citability, and the fact that the store listing is the same research. Run this
one first: an SEO pass over a page that still says "Replace these three" is
auditing the scaffold.

**If the app has no audience to convince, delete `public/landing.html` and say
so.** `/` then serves the app and this dimension does not apply. That is a real
answer for a tool somebody installs from a link they were already sent. It is
not the answer for anything with a price, a catalogue, a coverage area or a
competitor.

#### 11.1 What pages the product needs

One page is not a marketing site. The template ships one because a scaffold has
one thing to say; a product usually has more, and the page set is not a taste
question — **it falls out of the product's own data**. One page per repeated
thing, one page per question a buyer asks before committing:

| The product has… | …so the site has |
|---|---|
| a catalogue (models, plans, venues, breeds) | an index page and one page per item |
| use cases people arrive with | one page per use case, named the way they say it |
| a price that is not obvious | a pricing page with a **worked example**, priced at the expensive case |
| a coverage area, a device requirement, a waitlist | a page that answers "does this work for me" on the page |
| a thing that can go wrong | a safety/trust page that names what is *not* in place yet |
| a process with steps after the button | a how-it-works page carrying real screenshots |

Nobody searches for a product name they have never heard. They search for the
job, and the page that answers the job is the one that gets found — which is
also why these pages must exist as real URLs rather than as anchors on one long
scroller. Plus the four the factory already ships: privacy, terms, support,
about, **rewritten for this app**.

Sanity check: if you cannot name what question each page answers, in the
customer's words, you have made a site map instead of a site.

#### 11.2 Generate the site from the product's data — this is the default

**Do not type a number onto a marketing page.** Write a build script that
imports the app's own data modules and its own pure functions, and computes
every figure the site prints. A price, an arrival time, a rate, a capability
list, a covered suburb, a model name — each of these is a fact the app already
owns, and the app is the thing that has to honour it.

The rules that make this safe:

- **Read-only, one direction.** The generator may import from `src/data/*` and
  from pure helpers (`src/lib/pricing.js`, `src/lib/geo.js`); it must never
  write there, and it must stay out of `src/pages/`, `src/components/` and the
  app's state. It is a build script, not the app.
- **Wire it to the build** (`"prebuild": "node scripts/build-site.mjs"`) so the
  site cannot be older than the data. Commit the output.
- **Compute the claim through the same function the app calls.** Not a
  reimplementation of the formula — the function. That is the whole point: the
  site and the product cannot disagree, because there is only one of them.
- **Fail the build on the cases that would produce a lie**: a catalogue item
  with no image at the widths the page requests, a figure that came back null.
  Warn loudly; never render a blank or a zero.
- **Omit rather than invent.** No figure, no sentence. A generator that writes
  "from $XX" is worse than one that writes nothing.

The payoff is a sentence only this product can say, in the place it matters
most: *"Optimus can be with you in about 42 minutes. A 3-hour job is $215,
delivered."* Every one of those values is the app's answer, rendered at build
time.

#### 11.3 The CTA contract — carry the intent through the door

A visitor who read a page about one thing and pressed the button must arrive at
**that thing**, not at the app's home screen. Every CTA carries what its page
was about:

```
/app?robot=optimus     the item page they were reading
/app?task=cleaning     the use case they arrived with
/app?mode=now          the intent the button expressed
/app?address=3186      the answer they just gave on the page
```

- **Read the query once at boot and push a route.** On this chassis the router
  uses a memory history, so the served URL is invisible unless something reads
  it deliberately.
- **Validate every parameter against the app's own catalogue.** An unknown value
  degrades to the home screen. A link that lands on a not-found screen is worse
  than a link that lands on Home, and links get shortened, pasted and mangled.
- **Write the contract once.** The generator builds every href through the same
  helper the app parses with. A contract stated in two places is a contract that
  will drift, and the marketing side is the half nobody tests.
- **Every page gets an exit to the app, the demo, and the beta** — header,
  footer and the page's own close. A person decides on the page they are on.

#### 11.4 The hero

- **The product is in it.** The real object, the real screen, the real thing —
  above the fold, large. A centred headline over two buttons is what a page
  looks like when nobody had anything to show.
- **One sentence under the buttons that only this product could say**, carrying
  a real figure from 11.2. Not the tagline again.
- **One primary action.** A second is allowed and it is nearly always the demo.
  A third is a decision the visitor has to make before they know anything.
- **Preload the hero image** and give it `fetchpriority="high"`; it is the LCP
  element and the budget is measured on it.

#### 11.5 One accent, and it is not a bullet

The accent belongs to the primary button, the brand mark, the current nav item
and the focus ring. **Nowhere else.** Not list bullets, not link colour, not
hover, not section headings, not icons.

This is the single most common way a generated site goes generic, and it is
measurable: one site painted its accent onto a list bullet and shipped 147 red
dots across 22 pages, up to 21 on one page. A reader who has been shown that red
means nothing cannot be got at with red when it finally means something — and
the thing it means is "press this".

Count them. If the accent appears more than a handful of times on a page, the
page has no primary action.

#### 11.6 Imagery, and the demo

- **Photographs and product shots fill their frame.** `object-fit: cover`, cropped
  deliberately. `object-fit: contain` inside a padded grey box inside a bordered
  card is a decision to make the best asset on the page small.
- **Ship the widths.** Three (≈480 / 800 / full), a `sizes` attribute, `loading="lazy"`
  below the fold, explicit `width`/`height` on every image so nothing shifts.
- **App screenshots come from `/demo`**, captured by `appfactory screenshots`,
  which writes web-sized frames to `public/marketing/`. They are the same
  captures as the store frames, so they cannot drift from the shipping UI.
  A broken image is worse than no image — delete the block if the captures do
  not exist yet.
- **The demo is the strongest asset the site has.** It is the product, working,
  with nothing to install. Link it from the hero, from the header, from the
  footer, and close on it. One ghost button on page two is how to waste it.

#### 11.7 Evidence honesty

The site is the first place a product is tempted to lie, and everything on it is
read by a store reviewer.

- **No invented testimonials, logos, ratings, user counts, awards, press
  mentions or certifications.** Not as placeholders, not "for layout", not
  greyed out. If it is not true today, the section does not exist today.
- **Say what is not real yet.** A fleet, a coverage area or an integration that
  is illustrative says so, in the footer and on the page that claims it. This
  reads as confidence, and its absence is what gets a listing rejected.
- **Prices and availability must be the app's** (11.2) or they must not be
  numbers.
- **Every link resolves.** Including the TestFlight one — an absent or blank
  value renders *nothing*, never a placeholder href.

#### 11.8 Responsive and accessibility floors

Non-negotiable, and cheap on a static page:

- One `<h1>` per page; heading levels descend without skipping.
- A skip link, a `<main id="main">`, landmark `<nav>`/`<footer>` with labels,
  `aria-current="page"` on the active nav item.
- Every interactive target ≥ 44px, including nav links and the mobile menu.
- Body text ≥ 16px and a measure of 60–75 characters; never a pinned root
  font-size (see § 7 — the same rule as the app).
- Contrast 4.5:1 for text, 3:1 for large text and UI edges — including the
  accent on its own background, which is where a brand red usually fails.
- Visible focus on everything focusable, and `prefers-reduced-motion` honoured
  by every transition on the page.
- Works at 320px wide and at 200% zoom without a horizontal scrollbar.
- The page must be readable and navigable with **no JavaScript at all** — it is
  static HTML; anything interactive on it (a coverage check, a waitlist form)
  is an enhancement over content that already reads.

#### 11.9 The budgets

`scripts/ci-lighthouse.mjs` runs Lighthouse against `/` and `/app` in CI and
fails the workflow: **performance ≥ 55, accessibility ≥ 85**, plus `budget.json`
(FCP 4000ms, LCP 5500ms, TTI 7500ms; 900KB script, 200KB CSS, 500KB image,
1800KB total, 15 third-party requests).

Those are floors for an app shell that ships a framework. **A static marketing
page has no excuse for scoring near them** — hand-written CSS, no framework, no
third-party script, and images that are the only weight on the page should put
`/` at or near 100 on both. Treat anything under 95 on `/` as a finding, and
check the SEO basics Lighthouse is not currently asked to score: a canonical, a
unique title and meta description per page, and the page's presence in
`sitemap.xml`.

#### 11.10 You have built a generic template if…

Every one of these is a *default* — what the obvious choice produces when nobody
decided. Each was found on a real generated site, and each is a rewrite:

- **The hero is centred text with no product in it**, and the thing being sold
  first appears below the fold.
- **"How it works" is three grey cards.** Three cards is what a section looks
  like when it has nothing to show; a numbered typographic list with a real
  screenshot beside it is what it looks like when it does.
- **A grid of identical tiles** — eight boxes of the same size, in which nothing
  is more important than anything else, which is the same as nothing being
  important.
- **The accent is on the bullets** (§ 11.5), and the primary button has no
  colour left of its own.
- **The one sentence only this product can say is missing** from the page that
  exists to say it — the computed price, the arrival time, the number that is
  the whole reason the product is interesting.
- **The demo is linked once, on page two, as a ghost button** — or not at all
  from the home page.
- **The photography is shrunk on purpose**: `object-fit: contain` in a padded
  grey box in a bordered card.
- **The three cards still say what the scaffold said**, or the captions still
  say "Name the screen", or About still opens "Replace this paragraph".
- **Every CTA says "Open the app"** and goes to the same place (§ 11.3).
- **The page could be about any product** if you swapped the name out. That is
  the summary test, and if it passes, none of the above got fixed.
