#!/bin/bash

# Load environment variables from .env file
source /battlebit/config/.env

# Paths
export WINE_PATH="/battlebit/wine-ge/lutris-GE-Proton8-26-x86_64"
export PATH="$PATH:/battlebit/steamcmd:$WINE_PATH/bin"

# Wine Prefix
export WINEPREFIX="/battlebit/game/.wine64"
export WINEPREFIX_FONTCONFIG_PATH="/usr/lib/x86_64-linux-gnu/libfreetype.so.6"

# Check if SteamCMD directory exists
if [ ! -d "/battlebit/steamcmd" ]; then
  echo "SteamCMD directory not found. Make sure you have set up the volume correctly."
  exit 1
fi

# Fix windows newline characters for steam credentials
steamusername=$(echo -n "$STEAM_USERNAME" | sed $'s/\r//')
steampassword=$(echo -n "$STEAM_PASSWORD" | sed $'s/\r//')
steamguardcode=$(echo -n "$STEAM_GUARD_CODE" | sed $'s/\r//')
betaname=$(echo -n "$BETA_NAME" | sed $'s/\r//')

# Log in to SteamCMD using the provided credentials
#if [ "$ENABLE_BETA" = "true" ]; then
#  steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /battlebit/game +set_steam_guard_code "$steamguardcode" +login "$steamusername" "$steampassword" +app_update 671860 -beta "$betaname" validate +quit
#else
#  steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /battlebit/game +set_steam_guard_code "$steamguardcode" +login "$steamusername" "$steampassword" +app_update 671860 validate +quit
#fi

# Check if the game directory exists
if [ ! -d "/battlebit/game" ]; then
  echo "Game directory not found. There might be an issue with downloading the game."
  exit 1
fi

# Read server configurations from /config/server.conf
if [ -f "/battlebit/config/server.conf" ]; then
  source /battlebit/config/server.conf
else
  echo "Server config file not found: /battlebit/config/server.conf"
  exit 1
fi

# Formulate the arguments for BattleBit executable
battlebit_args=(
  -batchmode
  -nographics
  -lowmtumode
  "-Name=$Name"
  "-Password=$Password"
  "-AntiCheat=$AntiCheat"
  "-Hz=$Hz"
  "-Port=$Port"
  "-MaxPing=$MaxPing"
  "-LocalIP=$LocalIP"
  "-VoxelMode=$VoxelMode"
  "-ConfigPath=$ConfigPath"
  "-ApiEndpoint=$ApiEndpoint"
  "-FixedSize=$FixedSize"
  "-FirstSize=$FirstSize"
  "-MaxSize=$MaxSize"
  "-FirstGamemode=$FirstGamemode"
  "-FirstMap=$FirstMap"
)

echo "/-----------------------------/"
echo "Server Settings:"
echo "Name: $Name"
echo "Password: $Password"
echo "AntiCheat: $AntiCheat"
echo "Hz: $Hz"
echo "Port: $Port"
echo "MaxPing: $MaxPing"
echo "LocalIP: $LocalIP"
echo "VoxelMode: $VoxelMode"
echo "ConfigPath: $ConfigPath"
echo "ApiEndpoint: $ApiEndpoint"
echo "FixedSize: $FixedSize"
echo "FirstSize: $FirstSize"
echo "MaxSize: $MaxSize"
echo "FirstGamemode: $FirstGamemode"
echo "FirstMap: $FirstMap"
echo "/-----------------------------/"
echo "Launching the BattleBit game server..."

# Start Xvfb in the background with 1x1 resolution
Xvfb :99 -screen 0 1x1x16 &  # Start Xvfb with 1x1 resolution
export DISPLAY=:99            # Set DISPLAY environment variable

# Run from the logs directory so we don't have to move them outselves
mkdir -p /battlebit/game/logs
cd /battlebit/game/logs

# Redirect stdout to the log file
WINEDEBUG=-all WINEARCH=win64 wine /battlebit/game/BattleBit.exe "${battlebit_args[@]}"
