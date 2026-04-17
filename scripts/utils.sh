#!/bin/bash

# ===> Steam Guard -------------------------------------------------------------
get_steam_guard_code() {
    if [ -n "$STEAM_SHARED_SECRET" ]; then
        python3 /scripts/steam_totp.py "$STEAM_SHARED_SECRET"
    fi
}

# ===> Ownership ---------------------------------------------------------------
update_ownership() {
    chown -R "$1:$2" "$BATTLEBIT_HOME"
}

# ===> Colors ------------------------------------------------------------------
RESET='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'

# ===> Logging -----------------------------------------------------------------
log_info() {
    echo -e "[$(date +'%H:%M:%S')] ${GREEN}[INFO]${RESET} $1"
}

log_warn() {
    echo -e "[$(date +'%H:%M:%S')] ${YELLOW}[WARN]${RESET} $1"
}

log_error() {
    echo -e "[$(date +'%H:%M:%S')] ${RED}[ERRO]${RESET} $1"
}
