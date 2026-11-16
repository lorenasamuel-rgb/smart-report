#!/usr/bin/env bash
set -euo pipefail
export GITHUB_OWNER=lorenasamuel-rgb
export REPO_DESCRIPTION="AI risk signaling and cited reports for background screening. Accurate Hackathon 2026 prototype and PRD."
exec ~/.cursor/skills/publish-github-repo/scripts/push-github.sh "$@"
