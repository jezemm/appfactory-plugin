# Phase 6 — Ship

Run the pipeline loop in `SKILL.md` until the frontier is empty. This file is the detail behind it.

## Release

- Autopilot applies account-touching steps; without it, `appfactory checklist run --apply` — one yes covers the batch through the first TestFlight and Play internal uploads. Do not stop after the store listings to wait to be asked to upload a build.
- A standalone `appfactory release --apply` also records those steps done.
- After `app.icons` writes new store/launcher icons, `release.ios` / `release.android` reopen if a build already exists — run them again in the same batch. The stores show the icon from the binary.
- A taken App Store name is not a hard stop: setup retries `{Name} App` once, persists if it creates, and continues.
- **Submit when the store's requirements are met.** `appfactory release ios --submit-beta --apply` posts TestFlight Beta App Review. `appfactory submit ios|android --apply` (the `you.submit.*` steps, run by the checklist) sends App Store review and the Play closed-testing release once the build, `app.code`, the listing text, screenshots and `web.site` exist. `app.review` and `site.review` run alongside and do not gate it. Report the state each submission returns.
- **Autopilot is the yes**, but read each account effect before it runs — the app NAME is reserved globally the moment the record exists.

## Before store setup — what only you can answer

These stop `store setup` by design (Sprinklers, 2026-09-28). Answer them; do not work around them.

- **What leaves the device.** `store setup ios|android` stops when the code calls a server that is not the app's own and `store.dataCollected` is not set. Read the calls it names, then declare each data type in `app.config.json` (`type`, `purposes`, `linked`, `tracking`, `shared`, `ephemeral`, `optional`, `note` — see `nature-strip/app.config.json`). Only if those requests carry nothing about the person: `"dataCollected": [], "dataCollectedReviewed": true`. A "collects nothing" label on an app that sends an address is a false label.
- **App or Game, and the category.** `launch` asks `store.appType` and `store.category` with a suggestion from the plan; under `--auto` the suggestion is taken and printed as assumed. Check it — a game rated as an app gets the wrong IARC questionnaire. Apple's category is set by `store setup ios`; **Play's app category has no API** — set it from the "App category — Store settings" card (Store settings → App category).
- **Anything printed as `assumed …`** by `launch` is a default, not a decision. Each line names the `checklist set` command that changes it; change the wrong ones before the store steps run.
- **Purpose strings.** `native sync` / `release ios` write an Info.plist string for every installed Capacitor plugin that needs one. Remove a plugin the app does not use (`npm rm …` — the run names them); reword a string with `apple.purposeStrings` in `app.config.json`, because App Review reads them.
- **OTA_CHANNELS** is predicted before the first build, merged (never overwritten) by `provision cicd`, and extended by every `release`. If a release prints `OTA_CHANNELS … could not`, run `appfactory provision cicd --apply`.
- **A red deploy.** `appfactory checklist` prints `last deploy failed at <gate>` when CI's newest deploy run failed — the web is then still on an older build. Fix the gate before telling anyone a web fix is live.

## What the pipeline covers

These are the checklist's own phase numbers.

| Checklist phase | Factory does | You do |
|-------|-------------|--------|
| 0 — Your Mac | doctor, secrets import, keys, certs repo, Apple/Google login | Complete 2FA in the factory Chrome window if it asks |
| 1 — Accounts | — | Enrolment and tax/banking are account-holder actions: report them |
| 2 — The app | scaffold, GitHub repo (`app.github`), npm install, addons | `app.code`, then `app.review` |
| 3 — Artwork | icons from name/colours (Gemini if keyed, otherwise a local brand icon) | — |
| 4 — Phone apps | native android + ios | — |
| 5 — Signing | certs and keystores; Play App Signing is automatic on the first bundle | — |
| 6 — Website | deploy to Cloud Run + map `{slug}.{parent}` when a parent is known | Apply DNS (below) |
| 6 — Search | robots, sitemap, canonical/OG/hreflang via `sync` (`app.seo`) | `app.seo.review` — [`SEO.md`](SEO.md) |
| 7 — Store setup | App Store + Play listings, Play access, content rating, content rights, availability | — (the IARC email is a certificate, not a click) |
| 8 — Listing | screenshots | Store text — after `app.review` and after `app.seo.review`, so listing and landing page share one keyword set |
| 9 — Release | build + upload to TestFlight + Play internal; `submit ios/android` as soon as the store's requirements exist | — |
| 10 — After | OTA publish; the public page (`web.site`) | `site.review`: the `impeccable` critique of the page, then `appfactory site --reviewed "<note>"` — [`MARKETING-SITE.md`](MARKETING-SITE.md) |

## Privacy and content-rating declarations

`store setup ios|android` derive App Privacy, Data Safety and the IARC rating from the addons, from `src/`, and from `store.*` in app.config.json (keys and record shape: README §7).

- **If the app has hand-written `server/` code** (anything no template or addon ships), read what it receives and set `store.dataCollected` before store setup. Until then both stores' privacy steps file nothing and exit 1 with a todo. `[]` plus `"dataCollectedReviewed": true` means "checked: nothing about the person". Example — a typed street address, geocoded and never stored:
  `{ "type": "physical-address", "purposes": ["app-functionality"], "linked": false, "tracking": false, "shared": false, "ephemeral": true, "optional": true }`
- **A game** (`store.appType: game`, a `games-*` / `GameApplication` category, or Apple `GAMES…`) is rated through Play's Game questionnaire. Defaults are "none"; set `store.contentRating` only where the honest answer is "yes" — those are then yours to finish.

## Custom domain and DNS

Mandatory when a parent domain is already known. Still never invent a registrable domain, never buy one.

1. Read `learned.originDomain` from `appfactory checklist --json`, or take the parent of a previous app's `cloud.customDomain`.
2. If a parent exists:
   ```
   appfactory checklist set cloud.customDomain {slug}.{parent}
   appfactory dns --apply
   ```
   e.g. slug `decision-time` + parent `example.com` → `decision-time.example.com`.
3. No owned parent anywhere → stay on `*.a.run.app`. Do not pick a TLD.

`web.deploy` / `appfactory provision --apply` and `you.dns` / `appfactory dns --apply` create the Cloud Run mapping:

```
gcloud beta run domain-mappings create \
  --service=<cloud.runService> --domain=<host> \
  --project=<cloud.gcpProject> --region=<cloud.region>
```

Fully-managed mappings only work under `gcloud beta` and in supporting regions (`us-east1`). Keep `web.origin` and listing URLs on `*.a.run.app` until `https://{customDomain}` returns 200.

**Applying the record** — never a paste card for the human:

1. The vault token, once per machine: `appfactory secrets set cloudflare.apiToken` — a Cloudflare **user** token with **Zone.DNS Edit** on the `learned.originDomain` zone (~40 characters; ~60 is usually a wrong paste). Never print it; `appfactory doctor` / `appfactory secrets` show whether it is set.
2. `appfactory dns --apply` then writes the mapping and the CNAME.
3. No token → Cloudflare **Code Mode** MCP at `https://mcp.cloudflare.com/mcp` (`search` + `execute` on `/zones` and `/zones/{id}/dns_records`).

Record: CNAME `{slug}` → `ghs.googlehosted.com`, **proxied: false** (orange-cloud breaks Cloud Run TLS). Cursor's official Cloudflare *plugin* does **not** write DNS — do not re-auth it expecting to. `you.dns` / `web.customDomain` are factory steps, not registrar gates.

## Final checks

Run these yourself and put the result of each (✅ / ❌ / ⏭️ not reached) in the report:

```
test -d <workspace>/<slug> && appfactory config                    # app exists
test -d node_modules                                               # npm install
test -d ios && test -d android                                     # native projects
test -f ~/.app-factory/keystores/<slug>.jks                        # Android key
curl -f https://<origin>                                           # web responds
appfactory store status                                            # store records
find fastlane/screenshots -name '*.png' 2>/dev/null | head -1      # screenshots
appfactory checklist --json | grep -q '"listing.copy".*"done"'     # store text
appfactory checklist --json | grep -q '"release".*"done"'          # release uploaded
```

Then open `/`, `/app` and `/demo` in a browser, walk the primary flow, and read `appfactory store status` for both listings. Write the final report from `SKILL.md`.
