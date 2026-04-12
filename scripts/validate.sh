#!/bin/bash
# validate.sh - pre-commit and CI validation for the eHour Claude Code plugin.
# Checks that all required plugin files exist and have the expected structure.
# Exit 0 on success, non-zero on any failure.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "PASS: $*"; }

# jq is required
command -v jq >/dev/null 2>&1 || fail "jq is required but not installed. Install with: sudo apt-get install -y jq (Debian/Ubuntu) or brew install jq (macOS)"

# --- Plugin manifest (lives under plugins/ehour/) ---
PLUGIN_DIR="plugins/ehour"
[[ -f "$PLUGIN_DIR/.claude-plugin/plugin.json" ]] || fail "$PLUGIN_DIR/.claude-plugin/plugin.json missing"
jq -e '.name == "ehour"' "$PLUGIN_DIR/.claude-plugin/plugin.json" >/dev/null \
  || fail "plugin.json: .name must be \"ehour\""
jq -e '.description | length > 0' "$PLUGIN_DIR/.claude-plugin/plugin.json" >/dev/null \
  || fail "plugin.json: .description missing or empty"
jq -e '.author.name' "$PLUGIN_DIR/.claude-plugin/plugin.json" >/dev/null \
  || fail "plugin.json: .author.name missing"
pass "plugin.json"

# --- MCP server registration (lives under plugins/ehour/) ---
[[ -f "$PLUGIN_DIR/.mcp.json" ]] || fail "$PLUGIN_DIR/.mcp.json missing"
jq -e '.ehour.type == "http"' "$PLUGIN_DIR/.mcp.json" >/dev/null \
  || fail ".mcp.json: .ehour.type must be \"http\""
jq -e '.ehour.url == "https://ehourapp.com/mcp"' "$PLUGIN_DIR/.mcp.json" >/dev/null \
  || fail ".mcp.json: .ehour.url must be \"https://ehourapp.com/mcp\""
pass ".mcp.json"

# --- Slash command skills (lives under plugins/ehour/skills/) ---
for skill in ehour-log ehour-projects ehour-users; do
  f="$PLUGIN_DIR/skills/$skill/SKILL.md"
  [[ -f "$f" ]] || fail "$f missing"
  grep -q "^name: $skill$" "$f" \
    || fail "$f: missing 'name: $skill' in frontmatter"
  grep -q "^description: " "$f" \
    || fail "$f: missing 'description:' in frontmatter"
  pass "$f"
done

# --- Marketplace manifest (lives at repo root .claude-plugin/) ---
[[ -f .claude-plugin/marketplace.json ]] || fail ".claude-plugin/marketplace.json missing"
jq -e '.name == "ehour-plugins"' .claude-plugin/marketplace.json >/dev/null \
  || fail "marketplace.json: .name must be \"ehour-plugins\""
jq -e '.plugins | length == 1' .claude-plugin/marketplace.json >/dev/null \
  || fail "marketplace.json: expected exactly 1 plugin entry"
jq -e '.plugins[0].name == "ehour"' .claude-plugin/marketplace.json >/dev/null \
  || fail "marketplace.json: .plugins[0].name must be \"ehour\""
jq -e '.plugins[0].source == "./plugins/ehour"' .claude-plugin/marketplace.json >/dev/null \
  || fail "marketplace.json: .plugins[0].source must be \"./plugins/ehour\""
pass "marketplace.json"

echo
echo "All validation checks passed."
