#!/bin/bash

source /scripts/env.sh
source /scripts/utils.sh

steamusername=$(echo -n "$STEAM_USERNAME" | sed $'s/\r//')
steampassword=$(echo -n "$STEAM_PASSWORD" | sed $'s/\r//')
steambranch=$(echo -n "$STEAM_BRANCH" | sed $'s/\r//')

# 0 = success
# 1 = failure
sync_battlebit() {
    log_info "Syncing BattleBit (install or update)..."

    if ! command -v steamcmd >/dev/null 2>&1; then
        log_error "SteamCMD not found. This shouldn't happen..."
        return 1
    fi

    local attempt=1 max_attempts=5 delay=35
    while [ "$attempt" -le "$max_attempts" ]; do
        local guard; guard=$(get_steam_guard_code)
        if [ -n "$steambranch" ]; then
            steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "$GAME_DIR" \
                +login "$steamusername" "$steampassword" ${guard:+"$guard"} \
                +app_update 671860 -beta "$steambranch" validate +quit
        else
            steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "$GAME_DIR" \
                +login "$steamusername" "$steampassword" ${guard:+"$guard"} \
                +app_update 671860 validate +quit
        fi
        local ret=$?

        if ls "$GAME_DIR"/*.exe >/dev/null 2>&1; then
            log_info "BattleBit sync complete."
            return 0
        fi

        log_warn "Sync attempt $attempt/$max_attempts failed (exit $ret). Retrying in ${delay}s..."
        sleep "$delay"
        attempt=$((attempt + 1))
    done

    log_error "All sync attempts failed."
    return 1
}

game_installed() {
    ls "$GAME_DIR"/*.exe >/dev/null 2>&1
}

if [ "${BB_SKIP_UPDATE:-false}" = "true" ] && game_installed; then
    log_info "BB_SKIP_UPDATE=true and game already installed, skipping sync."
elif ! sync_battlebit; then
    log_error "Failed to sync BattleBit. Exiting."
    exit 1
fi