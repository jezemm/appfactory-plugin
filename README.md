# App Factory — the agent skill

Take an app idea from a sentence to a working, deployed app: a website, an
iPhone app and an Android app, from one codebase.

## Two things, and the second is the one people skip

This repo is the **instructions**. The **factory** is a separate hosted service.
Installing the skill without connecting the server gives you an assistant that
has read the manual and has no machine — and it will not obviously fail, it will
go looking for something else to do.

Connect the factory first. Then install the skill.

## 1. Connect the factory

**Claude Code:**

```
claude mcp add --transport http appfactory \
  https://mcp.appfactory.jeremymarks.com.au/mcp
```

then `/mcp` inside Claude Code and sign in through your browser.

**Codex:** `install.sh` below writes the config, then:

```
codex mcp login appfactory
```

**Anything else that speaks MCP** — Cursor, and others — add this address as a
server in its settings and sign in:

```
https://mcp.appfactory.jeremymarks.com.au/mcp
```

You get the whole flow either way: the same instructions are served as an MCP
prompt called **ideate-and-build**, so a client that cannot read a skill file
gets them anyway.

## 2. Install the skill

**Claude Code** — inside Claude Code:

```
/plugin marketplace add jezemm/appfactory-plugin
/plugin install appfactory
```

**Codex** — same skill, different directory, so a script does the copy:

```
git clone --depth 1 https://github.com/jezemm/appfactory-plugin
sh appfactory-plugin/install.sh
codex mcp login appfactory
```

That puts the skill in `~/.agents/skills/appfactory/` and appends the App
Factory server to `~/.codex/config.toml`. Read the script first if you like —
it is thirty lines and it only copies files.

## Use it

```
/appfactory an app for tracking which plants in my garden need
watering, and when I last did it
```

In Codex, or anywhere without a slash command, just say it: *"use App Factory to
build me an app for tracking…"*.

## What it does

Four stages. You are involved in the first three and barely needed for the last.

1. **It asks you questions.** Who it is for, what they do today instead, the one
   thing it has to do well, what someone sees before there is any data. This is
   the stage that decides whether you get *your* app or a generic one.
2. **It argues with the idea.** Who already does this, what is genuinely hard,
   and the strongest honest reason not to build it — now rather than after a
   store review.
3. **It writes the design down** and waits for you to agree. Every screen, what
   a tap does, the data, the colours. The last cheap moment to change your mind.
4. **It builds, checks and ships.** Writes the app, opens it in a real browser
   and looks at every screen, deploys it, and takes the phone apps as far as
   they can go.

## What it will not do on its own

- **Pick your app's name or bundle id.** Both are reserved with Apple worldwide
  the moment a store record exists and cannot be changed afterwards.
- **Spend money or touch your accounts without asking.** It shows you what will
  happen, split into what can and cannot be undone, and waits.
- **Submit your app for review.** There is deliberately no setting for it.

## If it says it cannot find the factory

You installed step 2 and skipped step 1. Go back and connect it.

The CLI (`appfactory` in a terminal) is a shorter loop and can build iOS on a
Mac you already have — but its repository is **private**, so unless you have
been given access, the hosted service above is the one to use. It does
everything up to and including a live website.

### You do not need a Mac

Apple only allows iPhone apps to be built on macOS — and Apple rents its own
Macs, as Xcode Cloud. App Factory starts a build there and reads the result
back, so the whole thing works without one. It needs a one-time workflow set up
in App Store Connect, which is a browser rather than a Mac; App Factory
deliberately does not create it for you, because how often you build spends your
Apple allowance.

## Where your app ends up

Your own accounts, every time. The code goes to a private repository in your
GitHub, the website to your Google Cloud project, the apps to your Apple and
Play accounts. Nothing needs to phone home, and if you stop using App Factory
the app keeps working.

## Docs

<https://appfactory.jeremymarks.com.au/docs/>

- [How it works](https://appfactory.jeremymarks.com.au/docs/architecture) — plain English
- [The plugin](https://appfactory.jeremymarks.com.au/docs/plugin) — this, in more detail
- [What it can't do](https://appfactory.jeremymarks.com.au/docs/limits) — the honest list

## A note on the skill files

`skills/appfactory/` is copied from the App Factory repository, which is where
it is maintained. Some paths it mentions (`cli/checklist.mjs`, `template/…`)
exist only once the CLI is installed; they are addressed to an agent that has
it. Do not edit these files here — changes belong upstream, or they are
overwritten on the next release.
