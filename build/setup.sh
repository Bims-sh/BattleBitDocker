#!/bin/sh

set -e

# Install dependencies
dpkg --add-architecture i386
apt-get update
apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    gnupg

# Add WineHQ repository (stable)
mkdir -p /etc/apt/keyrings
curl -fsSL https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq.gpg

. /etc/os-release
echo "deb [signed-by=/etc/apt/keyrings/winehq.gpg] https://dl.winehq.org/wine-builds/debian/ ${VERSION_CODENAME} main" \
    > /etc/apt/sources.list.d/winehq.list

apt-get update
apt-get install --no-install-recommends -y \
    libstdc++6 \
    lib32stdc++6 \
    winehq-stable \
    winbind \
    xvfb \
    screen \
    tini \
    gosu \
    tzdata \
    bash \
    unzip \
    adduser \
    python3
rm -rf /var/lib/apt/lists/*

# Remove default debian user if it exists
if id debian > /dev/null 2>&1; then
  deluser debian
fi

# Add battlebit user
addgroup --gid 1000 battlebit
adduser --system --shell /bin/false --uid 1000 --ingroup battlebit --home "$BATTLEBIT_HOME" battlebit
