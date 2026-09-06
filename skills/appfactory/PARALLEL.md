# Working in parallel

A full pipeline run is one agent reading twenty-four screens, three specs and a
QA report into one context, sequentially. That is slow, and — because everything
read stays read — it is expensive in a way that compounds: by the time the last
screen is written, the context is carrying every file that went before it.

Two separate levers, and they are not the same lever:

| Lever | Buys | Where |
|---|---|---|
| **Fan out to subagents** | tokens, mostly | this document |
| **Concurrency in the tools** | wall clock | `appfactory ux --concurrency`, `checklist run` waves — already on |

The tools parallelise themselves now. `appfactory ux` audits screens several at
a time (86s → 28s on a twenty-four screen app, byte-identical report), and
`checklist run` runs steps that declare `concurrencySafe` together. You do not
have to orchestrate either.

---

## When to fan out

**Fan out when the work divides cleanly and the outputs do not need to agree
with each other in detail.** A subagent starts cold: whatever it needs to know,
you have to tell it, and whatever it learns dies with it. That is the whole
trade — the parent context never holds the twenty files the child read, and the
child never learns what the other children decided.

Good:

- **Building screens from an approved spec.** Each screen is a file. The spec
  already says what goes on it, and the chassis already decides everything that
  crosses screens. Four agents building six screens each is the case this
  factory has actually run.
- **Review dimensions.** `UX-POLISH.md` has eleven dimensions and they are
  genuinely independent — accessibility, copy, performance and responsive
  behaviour do not need to agree about anything.
- **Reading to answer a question.** "Which files define the tab bar" is a fan-out
  search whose only useful output is the answer. Use `Explore`; the file dumps
  stay in the child.
- **Per-platform work.** The App Store record and the Play record are two
  different companies. So are the two store listings' assets.

Bad, and each of these has actually gone wrong:

- **Anything above the toolbar.** Four agents given no contract produced six
  toolbar patterns and five heading sizes across twenty-four screens, every
  screen fine on its own. Fan-out multiplies whatever the brief leaves open.
  **Before you fan out, check that the thing you are dividing has a contract.**
  If it does not, write the contract first — that is cheaper than reconciling
  six answers afterwards.
- **The design spec itself.** It is one document that has to hold together.
- **Anything that writes the same file.** Two agents editing `src/router.js` is
  a merge you will do by hand.
- **The final review.** A design system is a cross-screen property; an agent
  that sees one screen cannot see it. Somebody has to look at all of them.

---

## How to fan out well

**Give each child the contract, not the conversation.** Point it at
`DESIGN.md`, the navigation shell's `SHELL.md`, `house-style.md` and
`microinteractions.md` by path. Do not paste them: the child can read them, and
pasting spends the tokens in both contexts.

**Name what the child owns and what it must not touch.** One agent, one set of
files. `src/core/` is off limits to all of them.

**Ask for a small, structured result.** What it built, what it decided that the
spec did not cover, and what it could not do. Not a narrative, and not the code
— the code is on disk. A child that returns a summary you have to read in full
has spent your context anyway.

**Decide the shared vocabulary up front.** Route names, store shape, component
names, the status words. Two agents inventing `BookingCard` and `BookingRow` for
the same thing is the cheapest possible thing to have prevented.

**Reconcile deliberately, once.** After the fan-out, look at the set: run
`appfactory ux` (the cross-screen census in the report is exactly this), then
`UX-POLISH.md` with the screenshots side by side. Expect to find drift; that is
not a failure of the method, it is the cost of it, and it is smaller than the
cost of building twenty-four screens one at a time.

---

## The shape that works

```
1  Spec           one agent, one document, no fan-out
2  Contract       confirm the chassis answers every cross-screen question:
                  chrome, tokens, status words, routes, store shape
3  Build          fan out — one agent per feature area, four to six files each
4  Reconcile      appfactory ux; read the design-system block of the report
5  Polish         fan out by DIMENSION, not by screen (UX-POLISH.md)
6  Ship           checklist run — it waves the independent steps itself
```

Step 2 is the one people skip, and it is the one that decides whether step 4 is
a formality or a rebuild.
