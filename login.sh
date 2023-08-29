#!/bin/bash

# Fix windows newline characters for steam credentials
steamusername=$(echo -n "$STEAM_USERNAME" | sed $'s/\r//')
steampassword=$(echo -n "$STEAM_PASSWORD" | sed $'s/\r//')
betaname=$(echo -n "$BETA_NAME" | sed $'s/\r//')

/home/steam/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /home/steam/battlebit +login "$steamusername" "$steampassword" +quit