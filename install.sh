#!/usr/bin/env sh
# Install the App Factory skill for the agent you actually use.
#
# WHY THIS EXISTS. Claude Code and Codex read the same file — a SKILL.md with
# `name` and `description` frontmatter — out of two different directories. So
# "converting the plugin for Codex" is a copy, and nobody should have to work
# that out for themselves. The first person who tried did it by hand.
#
#   Claude Code   installs as a plugin, from the marketplace (see below)
#   Codex         reads $HOME/.agents/skills/<name>/SKILL.md
#
# Run it from a checkout:
#
#   git clone --depth 1 https://github.com/jezemm/appfactory-plugin
#   sh appfactory-plugin/install.sh
#
# Deliberately not a curl-into-a-shell one-liner. This copies files into your
# home directory; you should be able to read it first.

set -eu

HERE=$(cd "$(dirname "$0")" && pwd)
SRC="$HERE/skills/appfactory"
MCP_URL="https://mcp.appfactory.jeremymarks.com.au/mcp"

[ -f "$SRC/SKILL.md" ] || { echo "no skill found at $SRC — run this from a checkout"; exit 1; }

# ── Codex ────────────────────────────────────────────────────────────────────
CODEX_SKILLS="$HOME/.agents/skills"
mkdir -p "$CODEX_SKILLS"
rm -rf "$CODEX_SKILLS/appfactory"
cp -R "$SRC" "$CODEX_SKILLS/appfactory"
echo "installed the skill for Codex → $CODEX_SKILLS/appfactory"

# The MCP server, which is the half that does the actual work. Appended rather
# than written over: this file holds every server the person has configured, and
# clobbering it to add one would be a poor trade.
CODEX_CFG="$HOME/.codex/config.toml"
if [ -f "$CODEX_CFG" ] && grep -q "mcp_servers.appfactory" "$CODEX_CFG" 2>/dev/null; then
  echo "  app factory already in $CODEX_CFG — left alone"
else
  mkdir -p "$HOME/.codex"
  {
    echo ""
    echo "[mcp_servers.appfactory]"
    echo "url = \"$MCP_URL\""
    echo "auth = \"oauth\""
  } >> "$CODEX_CFG"
  echo "  added the server to $CODEX_CFG"
fi

# THE STEP EVERYBODY SKIPS, said as loudly as a shell script can.
#
# Somebody installed the skill, never signed in, and their agent went looking
# for the CLI instead — hit an SSH prompt, tried HTTPS, got a 404 on a private
# repo, and built a plain Vite app by hand rather than saying it was stuck. The
# skill is only the instructions; without the server connected there is no
# factory behind them, and nothing about a successful copy says so.
echo ""
echo "  ─────────────────────────────────────────────────────────────"
echo "  NOT DONE YET. The skill is installed; the factory is not"
echo "  connected. Run this now, or nothing above can build anything:"
echo ""
echo "      codex mcp login appfactory"
echo ""
echo "  ─────────────────────────────────────────────────────────────" 

# ── Claude Code ──────────────────────────────────────────────────────────────
# Not copied. Claude Code installs this as a plugin and manages updates itself,
# and a stray copy in ~/.claude/skills would shadow the managed one and never
# get updated. Printed instead.
echo ""
echo "For Claude Code, run these instead — the FIRST one is the factory,"
echo "and the other two are only the instructions:"
echo "  claude mcp add --transport http appfactory $MCP_URL"
echo "  then /mcp inside Claude Code, and sign in"
echo "  /plugin marketplace add jezemm/appfactory-plugin"
echo "  /plugin install appfactory"
echo ""
echo "Docs: https://appfactory.jeremymarks.com.au/docs/start"
