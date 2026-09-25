# Phase 2–3 — Research

Output: `.appfactory/research/lens-<name>.md` ×5, `.appfactory/research/personas-<category>.md` ×5, `PERSONAS.md`, and every trade-off call logged in `.appfactory/DECISIONS.md`. Launch all ten subagents in one go — the lenses and persona categories do not depend on each other. A fast, cheaper model is fine for all of them. Give each the problem statement by path.

## Phase 2 — Five expert lenses

**Five parallel subagents.** Each writes its mini-report to `.appfactory/research/lens-<name>.md` and returns a summary of at most 150 words.

**Product designer** — The UX flow. What does the first screen look like? The primary action on every screen? Visual direction (minimal, playful, professional)? Accessibility needs (contrast, touch targets, screen reader)? Key screens (onboarding, main feed, detail, settings, account)?

**Product manager** — MVP vs v2+. Success metrics (DAU, retention, conversion). 2–3 competitors and how this differs. 2–3 user stories that capture the core experience. The riskiest assumption to validate first.

**Principal engineer** — Architecture (client, server, data layer, third-party services). What data is stored and how it relates. Third-party APIs needed. 100 users vs 100,000. The hardest technical problem.

**DevOps engineer** — Hosting (Cloud Run? static? serverless?). CI/CD. Monitoring and error tracking. Monthly cost at launch scale. Deployment strategy. What must be in place before launch.

**Security engineer** — Auth model (email/password? OAuth? phone?). What user data is collected and stored. Compliance (COPPA under 13, GDPR for EU, HIPAA for health). API security (rate limiting, auth, validation). Encryption at rest and in transit.

### Judge synthesis (main context)

- The top 3 design decisions that matter most
- Where the lenses conflict (e.g. designer wants rich animation, engineer warns about low-end devices)
- The trade-offs, and **the call you made on each** — logged in `.appfactory/DECISIONS.md`

Then move on; do not wait for approval.

## Phase 3 — 25 personas

**Five parallel subagents, one per category.** Each runs its five personas through a first session with the app, writes the five full cards to `.appfactory/research/personas-<category>.md`, and returns only its top 2–3 themes.

| Category | What they test | 5 variants |
|----------|---------------|------------|
| **Power users** | Deep feature exploration, efficiency, shortcuts, power flows, batch operations | 1. The daily power user who lives in the app 2. The automation tinkerer who wants APIs and shortcuts 3. The data nerd who mines every stat and export 4. The power novice — skilled but new to this domain 5. The multitasker juggling three things at once |
| **Casual users** | First-run experience, onboarding clarity, can they do the main thing without reading? | 1. The five-minute trial — downloads, opens, judges 2. The weekend explorer — has time, no deadline 3. The reluctant adopter — forced to use this by someone else 4. The intermittent user — opens once a month, forgot everything 5. The elderly first-timer — first smartphone app, period |
| **Skeptical users** | "Why not just use X?" Switching cost, trust, privacy, lock-in | 1. The competitor loyalist — deeply invested in a rival app 2. The privacy hawk — reads every permission, distrusts cloud 3. The price-sensitive skeptic — "free apps are the product" 4. The burned-by-hype user — tried 5 apps, all disappointed 5. The offline-only advocate — "what if I have no signal?" |
| **Accessibility-needs users** | Screen reader, colour, motor, cognitive, hearing | 1. VoiceOver/TalkBack user — blind, navigates solely by audio 2. Low-vision user — high contrast, large text, zoom 3. Motor-impaired user — switch control, one-handed, tremor 4. Colour-blind user — red-green, blue-yellow, complete 5. Cognitive accessibility — ADHD, dyslexia, brain fog, memory |
| **Niche & edge-case users** | Unusual contexts, constraints, extreme preferences | 1. The offline traveller — patchy signal, sync when possible 2. The tiny-screen user — budget Android, 4" display 3. The language learner — English as second language, idioms 4. The night-shift worker — dark mode, silence, dim screen 5. The parent-in-a-hurry — one hand, 30 seconds, child screaming |

Card format:

```
**{Persona name}** ({category})

✅ Works: what delights them
⚠️ Confusing: what they stumbled on
❌ Missing: what they expected but wasn't there
💡 Suggestion: what would fix it
```

### Synthesis (main context)

Across all 25: the themes, the patterns that cross categories, and the #1 thing to fix before building. Fold that into the spec — no presentation step.

### Write the research now

Concatenate the five category files into `PERSONAS.md` in the workspace folder, organised by category — the full cards, not the summary. The spec cites outcomes ("skeptical users flagged onboarding friction"); this file holds the evidence. Then [`PHASE-4-SPEC.md`](PHASE-4-SPEC.md).
