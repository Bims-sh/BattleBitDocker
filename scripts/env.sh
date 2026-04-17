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
export BB_ACCEPT_EULA="${BB_ACCEPT_EULA:-false}"

# ===> Build Functions --------------------------------------------------------------
# Prints one argument per line so callers can safely read into an array
# (handles server names with spaces correctly)
build_args() {
    echo "-batchmode"
    echo "-nographics"
    echo "-lowmtumode"
    echo "-Name=$BB_NAME"
    [ -n "$BB_PASSWORD" ]    && echo "-Password=$BB_PASSWORD"
    echo "-LocalIP=$BB_LOCALIP"
    [ -n "$BB_BROADCASTIP" ] && echo "-BroadcastIP=$BB_BROADCASTIP"
    echo "-Port=$BB_PORT"
    [ -n "$BB_APIENDPOINT" ] && echo "-ApiEndpoint=$BB_APIENDPOINT"
    echo "-Hz=$BB_HZ"
    echo "-AntiCheat=$BB_ANTICHEAT"
    echo "-MaxPing=$BB_MAXPING"
    echo "-VoxelMode=$BB_VOXELMODE"
    echo "-FirstGamemode=$BB_FIRSTGAMEMODE"
    echo "-FirstMap=$BB_FIRSTMAP"
    echo "-FixedSize=$BB_FIXEDSIZE"
    echo "-FirstSize=$BB_FIRSTSIZE"
    echo "-MaxSize=$BB_MAXSIZE"
}
