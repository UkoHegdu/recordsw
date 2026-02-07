#!/usr/bin/env bash
# Call POST /api/v1/cron/daily with CRON_SECRET from .env. Run from repo root (e.g. via crontab).
# Usage: ./deploy/cron-daily.sh

set -e
cd "$(dirname "$0")/.."
[[ -f .env ]] || { echo "cron-daily: .env not found" >&2; exit 1; }

CRON_SECRET=$(grep -E '^CRON_SECRET=' .env | sed 's/^CRON_SECRET=//' | tr -d '\r' | head -1)
[[ -n "$CRON_SECRET" ]] || { echo "cron-daily: CRON_SECRET not set in .env" >&2; exit 1; }

curl -s -S -X POST -H "Authorization: Bearer $CRON_SECRET" "http://localhost/api/v1/cron/daily"
