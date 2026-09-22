#!/bin/bash
#
# SessionStart hook -- install the sales division agents into Claude Code.
#
# Claude Code reads agent definitions from ~/.claude/agents/ when a session
# starts. Remote (web/mobile) sessions get a fresh, ephemeral container every
# time, so without this hook the agents are simply not there. Running the
# installer here puts them in place before the session begins.
#
# Scope: the sales division only (9 agents). Add more with a comma-separated
# list, e.g. --division sales,marketing -- or drop the flag for all 279.
set -euo pipefail

# Local machines keep ~/.claude/agents/ between runs, so installing there is
# the developer's own choice, not ours. Only act on the ephemeral remote ones.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-$(dirname "$0")/../..}"

# claude-code installs straight from the division folders, so the generated
# integrations/ tree is not needed -- skip the convert.sh step entirely.
./scripts/install.sh \
  --tool claude-code \
  --division sales \
  --no-interactive \
  --no-convert
