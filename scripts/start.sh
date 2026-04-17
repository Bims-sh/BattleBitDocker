#!/bin/bash

source /scripts/env.sh
source /scripts/utils.sh

update_user_id() {
    if [[ -v UID ]]; then
        if [[ $UID != 0 ]]; then
            if [[ $UID != $(id -u battlebit) ]]; then
                log_info "Changing uid of battlebit to $UID"
                usermod -u "$UID" battlebit
            fi
        else
            runAsUser=root
        fi
    fi
}

update_group_id() {
    if [[ -v GID ]]; then
        if [[ $GID != 0 ]]; then
            if [[ $GID != $(id -g battlebit) ]]; then
                log_info "Changing gid of battlebit to $GID"
                groupmod -o -g "$GID" battlebit
            fi
        else
            runAsGroup=root
        fi
    fi
}

start_server() {
    log_info "Starting BattleBit server..."
    export WINEDEBUG="${WINEDEBUG:-+err}"
    export WINEESYNC=1
    # Disable wine-gecko and wine-mono download prompts (not needed for IL2CPP)
    export WINEDLLOVERRIDES="mscoree=disabled;mshtml=disabled"
    Xvfb :0 -screen 0 1024x768x16 -nolisten tcp 2>/dev/null &
    export DISPLAY=:0

    if [ ! -f "$HOME/.wine/system.reg" ]; then
        log_info "Initializing Wine prefix..."
        wineboot --init 2>&1 | grep -v fixme
        wineserver -w
    fi

    mapfile -t server_args < <(build_args)
    cd "$LOGS_DIR" || exit 1

    if [ "${BB_ACCEPT_EULA:-false}" = "true" ]; then
        printf 'Accept EULA & TOS=true\n' > "$LOGS_DIR/eula.txt"
    fi
    local wine_log="$LOGS_DIR/wine_stderr.log"
    wine "$GAME_DIR/BattleBit.exe" "${server_args[@]}" >"$wine_log" 2>&1 &
    wine_pid=$!

    # Record start time for log file detection
    local start_time; start_time=$(date +%s)

    # Wait for the game to create a new log file
    log_file=""
    for _ in $(seq 1 60); do
        log_file=$(find "$LOGS_DIR" -name "log_*.txt" 2>/dev/null \
            | while IFS= read -r f; do
                  [ "$(date -r "$f" +%s 2>/dev/null)" -ge "$start_time" ] && echo "$f" && break
              done | head -1)
        [ -n "$log_file" ] && break
        sleep 1
    done

    if [ -z "$log_file" ]; then
        log_warn "No log file found after 60s. Wine output:"
        cat "$wine_log" >&2
        wait "$wine_pid"
        return
    fi

    log_info "Streaming game log: $log_file"
    tail -f "$log_file" &
    tail_pid=$!

    wait "$wine_pid"
    kill "$tail_pid" 2>/dev/null
}

if [ "$(id -u)" = 0 ]; then
    runAsUser=battlebit
    runAsGroup=battlebit

    update_user_id
    update_group_id
    update_ownership "$runAsUser" "$runAsGroup"

    exec gosu "${runAsUser}:${runAsGroup}" bash -c \
        "source /scripts/env.sh && \
         source /scripts/utils.sh && \
         source /scripts/update.sh && \
         $(declare -f start_server) && \
         start_server"
else
    source /scripts/update.sh
    exec start_server "$@"
fi