#!/usr/bin/env bash
# Put this TV (TCL 55C755, Korea) back the way it was before the cleanup on 2026-10-24: the stock
# Google TV home, every package from batch-1..7 enabled again, Google's screensaver, the old DNS and no
# launcher key helper. The values below come from backup/20261024-0118 (taken before the first change).
# The launcher itself stays installed but is no longer Home; remove it in Settings > Apps if you like.
#
# Usage: TV_HOST=<tv ip> mytv/restore-all.sh
set -euo pipefail
: "${TV_HOST:?set TV_HOST to the TV IP address, e.g. TV_HOST=192.168.1.50 $0}"
cd "$(dirname "$0")/.."
STOCK=com.google.android.apps.tv.launcherx
TV() { tools/venv/bin/python -I tools/tv.py "$@"; }

# The key helper filters remote keys; with it gone the stock home answers the gear and app buttons again.
TV "settings put secure enabled_accessibility_services ''; settings put secure accessibility_enabled 0; echo key helper off"

# Newest batch first, so each record puts back the state its own list found. restore.sh enables the
# stock launcher and makes it Home again on every run.
for n in 7 6 5 4 3 2 1; do
  echo "== batch-$n"
  tools/restore.sh "mytv/batch-$n.txt" "$STOCK"
done

# dreamx is enabled again by batch-7, so its screensaver can be selected again.
TV "settings put secure screensaver_components com.google.android.apps.tv.dreamx/.service.Backdrop; echo screensaver back"
# Private DNS was never set before (both keys absent), so delete them rather than write a value.
TV "settings delete global private_dns_specifier; settings delete global private_dns_mode; echo private DNS back to automatic"

echo "== check"
TV "pm list packages -d; cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME | tail -n 1"
echo "Done. Press Home on the remote; the stock Google TV home should come up."
