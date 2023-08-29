# Use an official Ubuntu as the base image
FROM python:3-slim-bookworm

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    wget \
    ca-certificates \
    libstdc++6 \
    lib32stdc++6 \
    libtinfo5 \
    software-properties-common \
    wine winbind xvfb screen \
    && rm -rf /var/lib/apt/lists/*

# Install wine32
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install --no-install-recommends -y wine32 \
    && rm -rf /var/lib/apt/lists/*

# Create directories for SteamCMD and BattleBit
RUN mkdir -p /home/steam/steamcmd /home/steam/battlebit

# Download and install SteamCMD, update it, force install dir
WORKDIR /home/steam/steamcmd
RUN wget -q https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -xvzf steamcmd_linux.tar.gz \
    && rm steamcmd_linux.tar.gz \
    && /home/steam/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /home/steam/battlebit +quit

# Set the working directory
WORKDIR /home/steam

# Copy the run script into the container
COPY run.sh login.sh ./

# Give execute permissions to the run script
RUN chmod +x run.sh

# Command to start the run script
CMD ["./run.sh"]
