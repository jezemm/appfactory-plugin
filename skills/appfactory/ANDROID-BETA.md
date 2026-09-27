# Android public beta: Google Group + Play closed testing

The pattern Late Again and Nature Strip use to let anyone try the Android build. Anyone joins a public Google Group, then opts in on Play. It's the Android counterpart to a public TestFlight link, and it's the closed test that new personal accounts need anyway (12+ testers for 14 days) before production.

Internal testing is **not** this. It's limited to a hand-kept email list and doesn't count toward the production requirement.

## Order of work

1. **Google Group** (owner's Google account, browser):
   - Create `<slug>-testers` at groups.google.com. Name it "<App> Testers", with a one-line description ("Join to test the <App> Android beta on Google Play. It's just a list: nothing is posted here.").
   - Privacy settings: who can search = **Anyone on the web**; who can join = **Anyone can join**; who can post = **Group owners**; who can view members = **Group owners**.
   - Creating it shows a **CAPTCHA**, which is an owner step: ask them to tick it and press Create group.
   - Check it exists: `https://groups.google.com/g/<slug>-testers/about` shows the settings.
2. **Closed track + testers (API works, until the track is "upgraded")**:
   - `PUT edits/{id}/testers/alpha {googleGroups:["<slug>-testers@googlegroups.com"]}` succeeds on a fresh alpha track. The 403 in STORE-SUBSCRIPTIONS.md only applies after the track is upgraded in the console.
   - It answers **400 "Invalid Google Groups"** until the group exists. After creation it can lag for a minute or two, so retry every 60 s.
   - `PUT edits/{id}/tracks/alpha` with a release for the current versionCode. On a **draft app** (never published) the status must be `draft`; `completed` answers "Only releases with status draft may be created on draft app".
3. **Finish setting up the app** (Play Console → Dashboard → "Finish setting up your app"). Closed testing stays locked until every item is ticked. `appfactory store setup` covers privacy, sign-in, ads, content rating, target audience and data safety. These still needed doing by hand for Nature Strip:
   - **Government apps**: No.
   - **Financial features**: "My app doesn't provide any financial features" → Next → Save.
   - **Health**: "My app does not have any health features" → Next → Save.
   - **App category and contact details**:
     - Contact email and website go through the API: `PATCH edits/{id}/details {contactEmail, contactWebsite}` (use `store.publicEmail` and the site URL).
     - Category is **console only** (Store settings → App category → Edit). A game is App or game = Game, then its category, e.g. Simulation.
   - **Store listing**: the console's default language must be a language whose listing is complete.
     - The factory uploads en-AU, but the app was created with default en-US and an **empty en-US listing** (title only). That blocks saving the closed release with "Add a full description to save".
     - Fix it via the API: `PATCH edits/{id}/details {defaultLanguage:"en-AU"}`, then `DELETE edits/{id}/listings/en-US`.
4. **Closed track** (Test and release → Testing → Closed testing → Closed testing - Alpha → Manage track):
   - **Countries / regions** tab → Add countries / regions → select all → Save.
   - **Preview and confirm the release** → the only warning left should be "no deobfuscation file" (harmless) → Save.
5. **Publishing overview** → "Submit N changes for review". Play first runs quick checks (up to ~14 min), and the button unlocks when they finish. Google's review then takes a few days.
6. **Marketing page**: a Beta section with both phones' steps, and the Android CTA pointing at it.
   - Android steps: (1) join the group with the Google account the phone uses; (2) open `https://play.google.com/apps/testing/<package>`, tap **Become a tester**, then **Download it on Google Play**.
   - Add the note "If Play says the app isn't available yet, the Android beta is still in Google's review…".
   - Record `store.links.playTesting` and `store.links.androidGroup` in app.config.json.
   - Examples: late-again `public/landing.html` (#beta) and nature-strip `public/landing.html` (#beta).

## Gotchas
- **The Play Console UI is hostile to automation.** Dropdowns render off-screen and deep links sometimes bounce to the app list. Navigate from the app dashboard's own links, and use the API wherever it exists (testers, track release, details, listings).
- **Old drafts block promotion** ("Track already has a draft release"). Replace them.
- **After the first review passes,** later closed-testing releases can go through the API as `completed`.

Status per app lives in each app's docs/TODO.md. Nature Strip was submitted 2026-09-27.
