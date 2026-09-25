# Working in parallel

Two different levers:

| Lever | Buys | Where |
|---|---|---|
| **Fan out to subagents** | tokens — the child's file reads never enter your context | this document |
| **Concurrency in the tools** | wall clock | `appfactory ux --concurrency`, `checklist run` waves — already on |

The tools parallelise themselves: `appfactory ux` audits screens several at a
time, and `checklist run` runs steps that declare `concurrencySafe` together.
You do not orchestrate either.

**The biggest saving is not a subagent:** start `checklist run --apply` and the
product work at the same time. The website deploys with no accounts (checklist
phase 3) and the empty app reaches TestFlight (phase 9) while you build; the
screens, the page and the store copy (phase 10) are what you do during those
waits, not after them.

## When to fan out

**When the work divides cleanly and the outputs need not agree in detail.** A
subagent starts cold and what it learns dies with it.

Good:

- **Research** — the five lenses and five persona categories (`PHASE-2-RESEARCH.md`): ten independent subagents, launched together.
- **Screens from an approved spec** — each screen is a file; the chassis decides everything that crosses screens.
- **Polish dimensions** — `UX-POLISH.md`'s dimensions are independent.
- **Verify findings** — one subagent per `screens[]` entry in `.appfactory/verify/todo.json`, each limited to files matching `editable`.
- **Reading to answer a question** — use `Explore`; the file dumps stay in the child.
- **Per-platform work** — the App Store and Play records are two companies.
- **The proving build and the product** — the release needs nothing from you while it runs.

Bad — each has gone wrong:

- **Anything above the toolbar without a contract.** Fan-out multiplies whatever the brief leaves open (six toolbar patterns across twenty-four screens). **Before you fan out, check the thing you are dividing has a contract**; if not, write it first.
- **The design spec itself** — one document that has to hold together.
- **Anything that writes the same file** — two agents in `src/router.js` is a hand merge.
- **The final review** — a design system is a cross-screen property.

## How to fan out well

- **Give each child the contract by path, not by paste**: `DESIGN.md`, the navigation shell's `SHELL.md`, `house-style.md`, `microinteractions.md`.
- **Name what it owns and must not touch.** One agent, one set of files. `src/core/` is off limits to all.
- **Each screen agent checks its own screen once before it returns**: render it at phone width and run one `impeccable` critique on it against `PRODUCT.md` and `DESIGN.md`; fix what it finds in the files it owns. One pass, not a loop — the cross-screen review is step 4 below.
- **Ask for a small structured result**: what it built, what it decided that the spec did not cover, what its `impeccable` check found and fixed, what it could not do. Not the code — that is on disk.
- **Decide shared vocabulary up front**: route names, store shape, component names, status words.
- **Reconcile once**: `appfactory ux` (its cross-screen census), then `UX-POLISH.md` with the screenshots side by side. Expect some drift; it is the cost of the method.

## The shape that works

```
1  Spec           one agent, one document, no fan-out — including the design
                  direction (app.design): impeccable init, then one canvas of directions
2  Contract       confirm the chassis answers every cross-screen question:
                  chrome, tokens, status words, routes, store shape
3  Build          fan out — one agent per feature area, four to six files each
4  Reconcile      appfactory ux; read the design-system block of the report
5  Polish         fan out by DIMENSION, not by screen (UX-POLISH.md)
6  Ship           checklist run — it waves the independent steps itself
```

Step 2 is the one people skip, and it decides whether step 4 is a formality or a rebuild.
