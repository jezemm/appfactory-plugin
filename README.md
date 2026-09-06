# App Factory — Claude Code plugin

Take an app idea from a sentence to a working, deployed app: a website, an
iPhone app and an Android app, from one codebase.

```
/plugin marketplace add jezemm/appfactory-plugin
/plugin install appfactory
```

Then describe what you want:

```
/appfactory an app for tracking which plants in my garden need
watering, and when I last did it
```

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

## What you need

The plugin is the instructions. The factory itself is either:

- **the hosted service**, connected to Claude Code as an MCP server — nothing to
  install, and it does everything up to and including a live website; or
- **the CLI**, `npm i -g github:jezemm/app-factory`, which additionally builds
  the actual iPhone and Android apps.

Without one of those connected, the plugin can plan an app but not build one.

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
