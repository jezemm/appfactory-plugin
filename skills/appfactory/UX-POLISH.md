# UX polish pass

Audit every surface, flow and interaction of `/app`, then implement the fixes in code — do not stop at a list. Runs after `app.code`, once the primary flow works end to end, and before screenshots so the listing shows the polished UI. `app.review` closes itself when a passing `appfactory verify` summary matches the current source.

**Invoke these skills; do not paraphrase them:**

| Skill | What it is for here | When |
|---|---|---|
| `impeccable` | the whole-interface audit: hierarchy, cognitive load, anti-patterns, live browser iteration | first, to find what is wrong |
| `ui-ux-pro-max` | concrete style, palette, font-pairing, icon and chart values, stack-specific implementation | when a fix needs a value, not a direction |
| `microinteractions` | dimension 3, scored against its eight-question diagnostic | on every control a person touches |
| `dataviz` | any chart, meter, stat tile or dashboard | before writing chart code |
| `design` | a canvas of artboards when a screen needs re-laying-out, not re-styling | only when a rebuild is on the table |

**Fan the dimensions out** — one subagent per dimension ([`PARALLEL.md`](PARALLEL.md)). Keep dimension 1 (hierarchy) and the final side-by-side look at all screenshots yourself: a design system is a cross-screen property.

**Rules:**
- Leave `src/core/` alone. Polish `src/App.vue`, `src/components/`, `src/styles/app.css`.
- **Check what is MISSING before what is ugly.** Walk "What every app ships with" in [`PHASE-4-SPEC.md`](PHASE-4-SPEC.md) first; a chassis pattern absent without a stated reason is the highest-impact fix.
- **A literal hex value or pixel padding in a component is a finding.** Replace with `var(--accent)`, `var(--sp-4)`, `var(--radius)`, `var(--text-sm)`.
- **A clean `impeccable` scan of a `.vue` tree is not evidence** — its detector resolves `:root` properties only in `.html`. Audit rendered screens or use the browser-grade path.
- **Put all the screenshots side by side at the end** and look at the chrome across them — toolbar and heading drift is invisible one screen at a time.
- Minimum CSS/JS; CSS transitions over JS libraries; animate `transform` and `opacity`; subtle enough not to notice on second use. Re-check mobile and keyboard after changes.
- Report issues found, changes made, and the `microinteractions` score with its failing rows.

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

**Use `<Onboarding :cards>` from `src/core/ui/`. Do not build a welcome screen.**
The chassis owns the layout; the CARDS are yours:

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

### 11. THE MARKETING SURFACE

`/` is reviewed separately, once, after the factory generates it — see [`MARKETING-SITE.md`](MARKETING-SITE.md). Findability is [`SEO.md`](SEO.md).
