#!/usr/bin/env bash
# Build the launcher from this branch (Korean strings + this TV's config.xml) and install it as Home.
# HOME_KEY_SERVICE=1 is not optional here: without it the gear, YouTube and Netflix buttons do nothing,
# because the stock home that answered them is disabled. A reinstall drops the helper, so always use this.
#
# Usage: TV_HOST=<tv ip> mytv/build-and-install.sh
set -euo pipefail
: "${TV_HOST:?set TV_HOST to the TV IP address, e.g. TV_HOST=192.168.1.50 $0}"
cd "$(dirname "$0")/.."
BRANCH=$(git branch --show-current)
if [ "$BRANCH" != my-tv ]; then
  echo "On branch '$BRANCH', not my-tv: this would install that branch's config.xml. Run: git switch my-tv" >&2
  exit 1
fi
# Temurin 17 lives in ~/Library/Java/JavaVirtualMachines, where java_home finds it.
export JAVA_HOME="${JAVA_HOME:-$(/usr/libexec/java_home -v 17)}"
HOME_KEY_SERVICE=1 launcher/build-and-install.sh
