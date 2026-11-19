#!/usr/bin/env bash
# Builds and runs bin/fluxgram-ctl (cmd/fluxgram-ctl) -- Go is the only
# prerequisite. fluxgram-ctl stays in the foreground and runs the server and
# its admin panel until it is stopped (Ctrl+C); everything else is set up in
# the admin panel, whose address it prints.
#
#   ./fluxgram-macos.sh           run the server and the admin panel.
#   ./fluxgram-macos.sh stop      stop a running one (from another terminal).
#   ./fluxgram-macos.sh status    show what is running.
#   ./fluxgram-macos.sh restart   restart the server and the admin panel.
#   ./fluxgram-macos.sh update    git pull, rebuild, restart.
#   ./fluxgram-macos.sh logs      print the current run's startup log.
set -uo pipefail
cd "$(dirname "$0")"

ok()  { echo "[ok] $*"; }
die() { echo "[ERROR] $*" >&2; exit 1; }

if command -v go >/dev/null 2>&1; then
  ok "Go found: $(go version)"
else
  echo "[ERROR] Go is not installed (needed to build fluxgram-server / fluxgram-admin-panel)"
  die "install Go from https://go.dev/dl/ (or: brew install go) and re-run this script"
fi

echo "[cfg] Building fluxgram-ctl..."
if ! go build -o bin/fluxgram-ctl ./cmd/fluxgram-ctl; then
  die "failed to build fluxgram-ctl -- see the messages above"
fi

echo
exec bin/fluxgram-ctl "$@"
