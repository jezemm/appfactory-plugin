# Phase 0–1 — The idea

Output: a 3–5 sentence problem statement at the top of `.appfactory/DECISIONS.md`. No questions to the owner.

## Phase 0 — Is it already written down?

Idea Box captures an idea and drills it with seventeen questions that map almost one for one onto Phase 1. If the idea was drilled there, most of Phase 1 is done.

### Fork A — the idea is on a board

Take this when the user names an idea (`build idea 5dd53df4`), asks what is on the board, or mentions Idea Box.

```bash
appfactory ideas                      # the board: id, drill score, title
appfactory ideas <id> --json          # one idea, parsed
```

| Field | What it is |
|---|---|
| `idea` | The original free-form idea, in their own words, drill answers stripped out |
| `answers` | `{ concept, problem, audience, … }` — what they have already said |
| `missing` | The questions **still unanswered**, each with `question` and `asks` |
| `coverage` | `{ answered, total }` |

- **Fill in only what is in `missing`** — by deciding, as Phase 1 says, and recording it. A 17/17 idea means Phase 1 is finished: go straight to Phase 2.
- **Read `idea` — the free-form text — as the brief.** It is the only part in their own voice.
- No board configured is not a blocker: fall back to Fork B.

### Fork B — there is no board

Run Phase 1 as written.

### Record where it came from

When the spec is written in Phase 4, put the id in the front matter of `IDEATION.md`, so a later session can re-read the original and the requester can be told when it ships:

```yaml
---
ideaBoxId: 5dd53df4c1e20a91
ideaBoxSource: https://your-board.example
---
```

## Phase 1 — Clarify

Answer these yourself from the idea — do not interview the owner. Where the idea is silent, pick the answer that makes the strongest, simplest v1 and record it in `.appfactory/DECISIONS.md`. A concrete problem statement, not a wishlist.

| Area | What to decide |
|------|------------------|
| **Problem** | What does this app do? What need does it fill? What's the one thing it does that nothing else does? |
| **Audience** | Who is it for? Age range? Tech literacy? Global or region-specific? One demographic or several? |
| **Platform** | Mobile-first? Web-first? Both? Does it need to work offline? Tablets? |
| **Monetization** | Free? Paid upfront? Subscriptions? Ads? In-app purchases? Free trial? |
| **Key features** | The 2–3 things someone must be able to do in the first session |
| **Inspiration** | What apps already exist in this space? What is good or bad about them? |
| **Constraints** | Timeline? Budget for services (hosting, APIs, store fees)? |

**Stop** when you can write the problem statement: *who needs what, why they can't get it today, and how this app is different.* Write it at the top of `.appfactory/DECISIONS.md` and move on to [`PHASE-2-RESEARCH.md`](PHASE-2-RESEARCH.md).
