#!/bin/bash

# Load environment variables from .env file
source config/.env

# Set the correct Wine prefix to use user's home directory
export WINEPREFIX=/home/steam/.wine

# Remove X Server lock
rm -rf /tmp/.X1-lock

# Set up virtual X server using Xvfb
Xvfb :1 -screen 0 1024x768x16 &

# Set the DISPLAY environment variable
export DISPLAY=:1

# Check if SteamCMD directory exists
if [ ! -d "/home/steam/steamcmd" ]; then
  echo "SteamCMD directory not found. Make sure you have set up the volume correctly."
  exit 1
fi

# Log in to SteamCMD using the provided credentials
/home/steam/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /home/steam/battlebit +login "$STEAM_USERNAME" "$STEAM_PASSWORD" +app_update 671860 validate +quit

# Check if the game directory exists
if [ ! -d "/home/steam/battlebit" ]; then
  echo "Game directory not found. There might be an issue with downloading the game."
  exit 1
fi

# Read server configurations from /config/server.conf
if [ -f "/home/steam/config/server.conf" ]; then
  source /home/steam/config/server.conf
else
  echo "Server config file not found: /home/steam/config/server.conf"
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

# Run the BattleBit game server using Wine with the formulated arguments
cd /home/steam/battlebit
exec wine ./BattleBit.exe "${battlebit_args[@]}"
