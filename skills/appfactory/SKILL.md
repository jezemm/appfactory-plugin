---
name: appfactory
description: Build an app end to end, autonomously, from one sentence, using the App Factory. Use when the user says "build me an app that...", "I have an idea for an app", "I want to build an app that...", "help me turn this idea into a real app", or names an idea captured in Idea Box ("build idea 5dd53df4", "what is on the idea board"). Runs everything without stopping to ask — decides and logs, researches with parallel subagents, writes the spec, builds the app, verifies it until the gate passes, and ships it to the web, TestFlight and Play testing — then reports the links.
---

# App Factory

## Quick start

1. The user says "build me an app that…" (or names an Idea Box id). That sentence is the whole brief — you run everything else.
2. Check the factory is connected (next section), then run `appfactory autopilot on` once.
3. Work the phases below in order; read each phase file only when that phase starts.
4. The command spine: `appfactory new …` → `appfactory checklist run --apply` (proves the pipeline) → build from `IDEATION.md` → `appfactory verify` until exit 0 → `appfactory checklist run` until the frontier is empty.
5. End with the one final report (bottom of this file).

## STOP. Is the factory connected?

Before anything else, check for tools named `create_app`, `get_app_status` and `run_next_steps`, or an `appfactory` command that already runs.

- **THE MCP SERVER IS THE DEFAULT.** Tools present → use them; they need nothing installed and reach a live website.
- **CLI already installed** (`appfactory` runs) → prefer it for everything else: shorter loop, whole pipeline local. "Installed" means it runs — not that you should install it.
- **Neither → STOP and say so**, in one message, then wait:
  > App Factory is not connected yet — I have the instructions but not the factory. Connect it with:
  >
  >     claude mcp add --transport http appfactory https://mcp.appfactory.jeremymarks.com.au/mcp
  >
  > then `/mcp` to sign in. In Codex: `codex mcp login appfactory`. Anywhere else, add that address as an MCP server.
- **Do not install the CLI.** `npm i -g github:jezemm/app-factory` will not work: the repository is private, and the failure (SSH prompt, 404) reads like a broken machine, not "no access".
- **Never substitute your own scaffold for the factory.** A hand-built Vite app is a different product with the same name — no chassis, plan, QA, deploy or listing. No factory means a one-sentence answer, not a repository.
- Do not clone the factory repo, and do not create a GitHub repo first — the pipeline makes one.

## Operating mode: autonomous

The owner wants a finished v1, not a conversation. They give you the idea and answer ONE batch of questions at the start; then you run everything to the end.

- **Ask up front, then never.** Before the build starts, run `appfactory checklist --json` and `appfactory doctor`, and ask the owner everything you genuinely cannot do or decide — as many prompts as it takes, one at a time is fine: a missing one-time account step (Apple/Google enrolment, payment, tax/banking agreements, a store key, the Play service account's account-wide permissions) and facts only the owner knows (a real support email, if no earlier app has one). Everything else you decide. Once the build starts, do not ask again.

- **Decide, don't ask.** Wherever a question would go — clarifying questions, trade-offs, "does this look right" — make a defensible decision from the idea, earlier apps' answers and sensible defaults, and write it to `.appfactory/DECISIONS.md` (one line each: decision — why). The owner reads that afterwards; they are not waiting on you.
- **Run `appfactory autopilot on` once.** It is the owner's standing yes: `checklist run` then applies every step, account-touching ones included.
- **Verify your own work** before calling anything done (the loop below, step 7).
- **Fan out.** Independent work — lenses, persona categories, screens, polish dimensions — runs as parallel subagents that write their output to files and return a short summary. See [`PARALLEL.md`](PARALLEL.md).
- **Stop only for what legally needs the account holder** — Apple/Google enrolment, a payment method, tax/banking agreements — and even then keep going on everything not blocked by it. Those are one-time and normally done.
- **Finish with one report**: what shipped, the links (web app, marketing page, TestFlight public link, Play testing link), the decisions log, anything open.

## Two doors, one flow

Every command in these files is written as CLI. The MCP translation:

| What you are doing | MCP tool | CLI |
|---|---|---|
| Find an existing project | `list_apps` | `appfactory apps` |
| Scaffold from a brief | `create_app` | `appfactory new` |
| Say what the app IS | `set_plan` | edit `.appfactory/product-plan.json` |
| Write the plan into the app | `apply_plan` | `appfactory product apply` |
| Does the app match the plan? | `check_app` | `appfactory build` |
| Open it and look | `review_app` | `appfactory ux` |
| Where am I? | `get_app_status` | `appfactory checklist` |
| Run whatever can run | `run_next_steps` | `appfactory checklist run` |
| Answer a question it asked | `answer_questions` | `appfactory checklist set <key> <value>` |
| Start an iPhone build | `build_ios` (Xcode Cloud) | `appfactory release ios` (local Mac) or `appfactory xcode-cloud start` |
| How did the iPhone build go? | `get_ios_build_status` | `appfactory xcode-cloud status` |

**The iPhone build has two routes.** The hosted job runs on Linux and cannot run Xcode:

- **Xcode Cloud** — Apple builds on their own Macs; needs a one-time workflow in App Store Connect (a browser, not a Mac) and Apple connected. Driven by `build_ios` / `appfactory xcode-cloud start`.
- **A local Mac** with Xcode — `appfactory release ios`.

`get_ios_build_status` answers whether Xcode Cloud is configured **for this app** — a connected Apple account is a different fact. If it is not configured, say so and point at the setup; do not promise a build the factory cannot start.

**`get_app_status` / `appfactory checklist` is the source of truth about progress.** Never keep your own list in the conversation; it goes stale the moment anything runs.

### Two answers that cannot be taken back

The app's **name** and its **bundle id** are reserved with Apple worldwide the moment a store record exists, so choose them deliberately rather than asking: a short, distinctive name from the spec, checked with `appfactory new`'s App Store name lookup (setup falls back to `{Name} App` if it is taken), and a bundle id of the form `<reverse-domain of learned.originDomain>.<slug>` — or the owner's pattern from earlier apps. Log both, with why, in `.appfactory/DECISIONS.md`. Use the owner's name if the idea states one.

## The phases

| Phase | What happens | Read when it starts |
|---|---|---|
| **0–1 Idea** | Check Idea Box for an already-drilled idea; settle problem, audience, platform, money, key features yourself; write the problem statement | [`PHASE-0-IDEA.md`](PHASE-0-IDEA.md) |
| **2–3 Research** | Five expert lenses and 25 personas as parallel subagents; judge synthesis; `PERSONAS.md` | [`PHASE-2-RESEARCH.md`](PHASE-2-RESEARCH.md) |
| **4 Spec** | `IDEATION.md` a stranger could build from, screen by screen; design review before saving | [`PHASE-4-SPEC.md`](PHASE-4-SPEC.md) |
| **5 Build** | Scaffold → Prove the pipeline on the empty app → Build the app's functionality → `appfactory verify` loop → UX polish → public page | [`PHASE-5-BUILD.md`](PHASE-5-BUILD.md), then [`PARALLEL.md`](PARALLEL.md), [`UX-POLISH.md`](UX-POLISH.md), [`MARKETING-SITE.md`](MARKETING-SITE.md) |
| **6 Ship** | Checklist loop to empty frontier: deploy, DNS, search pass, store records, listing, release, final checks | [`PHASE-6-SHIP.md`](PHASE-6-SHIP.md), [`SEO.md`](SEO.md) |

Phases 5 and 6 overlap on purpose: start `checklist run --apply` and the product work at the same time.

## The pipeline loop

```
appfactory checklist --json
```

1. **Read the state.** Each step has a `status`; `frontier` is what's next, `runnable` what can run now, `why_not` why anything is blocked.
2. **Set answers** from the spec in one batch: `appfactory checklist set <key> <value>` (tagline, colours, target age, public/support email, `brand.iconPrompt`). `store.testers`: take the previous app's suggestion, not the public support address.
3. **Answer the `asks` yourself.** Take every `suggestion`; decide the rest from the spec and earlier apps' answers, set them all at once, log non-obvious ones in `.appfactory/DECISIONS.md`.
4. **Run everything runnable:** `appfactory checklist run`.
5. **Account-touching steps:** autopilot applies them — read the printed effects as you go. Without autopilot the equivalent is `appfactory checklist run --apply`; one yes covers the batch through the first TestFlight and Play internal uploads.
6. **Clear gates yourself.** Read `why_not` and the step's `todo`, and do it: fill the answer, run the command, fix the code, drive the browser form. Only an account-holder action waits — note it for the report and carry on.
7. **Verify, then repeat.** After the app builds, run `appfactory verify`, fix what `.appfactory/verify/todo.json` lists (one subagent per screen), re-run until it exits 0. Open the app, walk the primary flow, look at the screenshots critically. Loop until the frontier is empty.

## Hard rails

Each line prevents a failure that has happened.

- **One `checklist run` per app.** Two race `~/.app-factory/state/<slug>.json` and `app.config.json`. Code work runs in a subagent beside it, not a second runner.
- **Submit as soon as the stores' own requirements are met.** The checklist's `you.submit.*` steps run `appfactory submit ios|android --apply` once the build, the product in it, the listing text, screenshots and a support page exist. Quality passes (`app.review`, `site.review`) run alongside and never hold submission up — but finish them, and ship their fixes as an update.
- **Cloud Run region is `us-east1`.** Set `cloud.region` from the start; GitHub-connected Cloud Build and domain mappings fail elsewhere.
- **Reuse one billed GCP project** — `learned.gcpProject`. Never `gcloud projects create` per app (cap ~5, `FAILED_PRECONDITION`); never borrow an unrelated sibling project.
- **Never invent, buy or pass a domain.** No `--origin` on `appfactory new`; `*.a.run.app` is correct until an owned parent is known. When one is (`learned.originDomain`), use `{slug}.{parent}` — see `PHASE-6-SHIP.md`.
- **DNS is yours, not a paste card for the human.** CNAME `{slug}` → `ghs.googlehosted.com`, **proxied: false**. Never print `cloudflare.apiToken`.
- **Never create the GitHub repo by hand** (`gh repo create`) — `app.github` does it.
- **`src/core/` is factory-owned** — never edit it. A literal hex or pixel value in a component is a bug; use the tokens.
- **No `listing.screenshots` before `app.review`** — the shots go stale.
- **Factory Chrome only.** Never quit the user's everyday Chrome; if a stale factory Chrome holds `SingletonLock` under `~/.app-factory/browser/<apple|google>`, kill only that PID. Never two factory Chromes on one profile.
- **Report what happened, not what you hoped.** Read exit codes; on failure, say so and quote the last lines.

## Final report

When the pipeline is as done as it can be this session:

```
✅ {App Name}

   Web app:        https://{origin}/app
   Marketing page: https://{origin}/
   TestFlight:     {public link, or state}
   Play testing:   {testing link, or state}
   Folder:         {workspace}/{slug}/
   Spec:           IDEATION.md   Decisions: .appfactory/DECISIONS.md
   Verify:         {pass, or what is open}

   Still open: {account-holder actions only, with links}
```

If an account-holder gate (enrolment, agreements) is still open, list it with links and what to do. The factory remembers state between sessions; run `/appfactory` again and it picks up where it stopped.
