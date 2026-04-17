#!/bin/bash

# ===> Server Configuration ---------------------------------------------------------
export BB_NAME="${BB_NAME:-Battlebit Server}"
export BB_PASSWORD="${BB_PASSWORD:-}"
export BB_LOCALIP="${BB_LOCALIP:-0.0.0.0}"
export BB_BROADCASTIP="${BB_BROADCASTIP:-}"
export BB_PORT="${BB_PORT:-29999}"
export BB_APIENDPOINT="${BB_APIENDPOINT:-}"
export BB_HZ="${BB_HZ:-60}"
export BB_ANTICHEAT="${BB_ANTICHEAT:-eac}"
export BB_MAXPING="${BB_MAXPING:-150}"
export BB_VOXELMODE="${BB_VOXELMODE:-false}"
export BB_FIRSTGAMEMODE="${BB_FIRSTGAMEMODE:-conq}"
export BB_FIRSTMAP="${BB_FIRSTMAP:-lonovo}"
export BB_FIXEDSIZE="${BB_FIXEDSIZE:-none}"
export BB_FIRSTSIZE="${BB_FIRSTSIZE:-tiny}"
export BB_MAXSIZE="${BB_MAXSIZE:-ultra}"

# ===> Container Options ------------------------------------------------------------
export UID="${BB_UID:-1000}"
export GID="${BB_GID:-1000}"
export BATTLEBIT_HOME="/opt/battlebit"
export GAME_DIR="$BATTLEBIT_HOME/game"
export CONFIG_DIR="$BATTLEBIT_HOME/config"
export LOGS_DIR="$BATTLEBIT_HOME/logs"

# ===> Steam Configuration ----------------------------------------------------------
export STEAM_USERNAME="${STEAM_USERNAME:-}"
export STEAM_PASSWORD="${STEAM_PASSWORD:-}"
export STEAM_SHARED_SECRET="${STEAM_SHARED_SECRET:-}"
export STEAM_BRANCH="${BB_STEAM_BRANCH:-}"
export BB_SKIP_UPDATE="${BB_SKIP_UPDATE:-false}"

# ===> Build Functions --------------------------------------------------------------
build_args() {
    local args="-batchmode -nographics -lowmtumode"

    args+=" -Name=$BB_NAME"

    if [ -n "$BB_PASSWORD" ]; then
        args+=" -Password=$BB_PASSWORD"
    fi

    args+=" -LocalIP=$BB_LOCALIP"
    if [ -n "$BB_BROADCASTIP" ]; then
        args+=" -BroadcastIP=$BB_BROADCASTIP"
    fi
    args+=" -Port=$BB_PORT"
    if [ -n "$BB_APIENDPOINT" ]; then
        args+=" -ApiEndpoint=$BB_APIENDPOINT"
    fi
    args+=" -Hz=$BB_HZ"
    args+=" -AntiCheat=$BB_ANTICHEAT"
    args+=" -MaxPing=$BB_MAXPING"
    args+=" -VoxelMode=$BB_VOXELMODE"
    args+=" -FirstGamemode=$BB_FIRSTGAMEMODE"
    args+=" -FirstMap=$BB_FIRSTMAP"
    args+=" -FixedSize=$BB_FIXEDSIZE"
    args+=" -FirstSize=$BB_FIRSTSIZE"
    args+=" -MaxSize=$BB_MAXSIZE"

    echo "$args"
}
