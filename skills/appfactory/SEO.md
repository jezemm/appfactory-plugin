# Search pass

The app's public surface — the landing page at `/`, the web app at `/app`, the
demo at `/demo`, and the four policy pages — is how anyone who is not already
holding a phone finds this thing. `appfactory sync` writes the mechanical half
of that (canonical, Open Graph, `hreflang`, `<html lang>`, robots, sitemap, and
a `SoftwareApplication` block once store IDs exist). This pass is the other
half: the part that needs judgement, run against the deployed site.

**When to run this:** after `web.deploy`, and before the store listing copy is
finalised — the keyword work is the same work, and doing it twice produces two
different answers to "what is this app called". Mark complete with
`appfactory checklist done app.seo.review`.

---

## Run the skills, do not improvise

Invoke them; do not paraphrase them from memory or hand-write an audit a skill already does.

| Skill | What it answers | When |
|---|---|---|
| `seo-plan` | what this app should rank for at all, and the page architecture that gets there | first, before any copy exists |
| `seo-audit` | the whole deployed site: crawlability, indexation, CWV, schema, content | after the first real deploy |
| `seo-page` | one page in depth — usually the landing page, which is the only page most app sites have | whenever the landing copy changes |
| `seo-schema` | structured data: is it there, is it valid, is it the right type | every pass |
| `seo-geo` | AI Overviews, ChatGPT, Perplexity — increasingly how a new app gets found at all | every pass |
| `seo-technical` | robots, sitemap, headers, JS rendering, mobile | when the audit flags something or the hosting changes |
| `seo-content` | E-E-A-T, depth, thin content | when the landing page is mostly claims |
| `seo-images` | alt text, formats, sizes, and the OG image actually rendering | when screenshots or marketing art land |
| `seo-drift` | did a deploy quietly break something that was working | before and after a hosting or domain change |

Start with `seo-plan` if the app has no positioning yet, `seo-audit` if it is
already live. Both fan out to the specialists themselves; running every skill by
hand is slower and produces the same answers.

---

## What is already handled, so you do not re-do it

`appfactory sync` owns these, and they are rewritten on every sync from
`app.config.json`. **Do not hand-edit them into the HTML** — the markers are
regenerated and your edit is lost.

- `<link rel="canonical">`, `og:*` and `twitter:*` on `/` and `/app`
- `hreflang` alternates plus `x-default`, from the store locales
- `<html lang>` on every page, from `store.primaryLocale`
- `apple-itunes-app` and the `SoftwareApplication` JSON-LD, **once store IDs
  exist** — which is late in the pipeline, so an early audit will correctly
  report missing structured data and the fix is to finish the store steps, not
  to write the block by hand
- `robots.txt`, `sitemap.xml`, the web manifest's `id` and `categories`

If a skill reports one of these as wrong, the fix is in `app.config.json` and a
re-run of `appfactory sync`, not in the page.

---

## What is yours

**The landing page is one page and it has one job.** Most app sites are a hero,
three points and two store badges, and they rank for the app's own name and
nothing else. Decide deliberately whether that is the ambition. If it is not,
`seo-plan` produces the architecture and `seo-cluster` groups the topics.

A page a person has to write is a real cost, and should be a decision rather
than a default. A page GENERATED from the app's own data is not: when the robot
catalogue, the task list and the price table already exist in `src/data/`, the
per-model and per-category pages cost a template each and can never drift from
what the app actually does, because the claim on the page is computed from the
source the app books against. Decide the page SET deliberately; do not decide
each page. See [`MARKETING-SITE.md`](MARKETING-SITE.md) and `docs/MARKETING-SURFACE.md`.

**Write for the question, not the product.** People search the problem
("split a restaurant bill by what each person ate"), not the category ("expense
app"). The landing page's first heading should answer a question somebody typed.

**One passage per claim, self-contained.** This is what makes a page citable by
an answer engine as well as readable by a person: a paragraph that survives
being lifted out of the page still makes sense. `seo-geo` scores this directly.

**The OG image is the whole preview.** It is what appears in every share, every
message and every AI card. Check it renders — `seo-images` will, and a broken
`og-image.png` looks identical to a working one until somebody shares the link.

---

## Report

Say what you ran, the score or grade each skill returned, what you changed, and
what you deliberately left. An SEO pass that ends in a list of recommendations
nobody applied is the same as no pass — implement the fixes in the repo
(`public/landing.html`, `app.config.json`, the marketing copy), redeploy, and
re-run the audit against the live site rather than against your intentions.
