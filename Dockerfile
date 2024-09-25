# Use an official Debian as the base image
FROM debian:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Add mirror sources
RUN echo "deb http://ftp.de.debian.org/debian buster main" > /etc/apt/sources.list

# Update and install dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    wget \
    ca-certificates \
    libstdc++6 \
    lib32stdc++6 \
    libtinfo6 \
    software-properties-common \
    xz-utils \
    xvfb

# Install dependencies for Wine GE
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    curl tar bzip2 \
    libx11-xcb1 \
    libxcb1 \
    libxcb-glx0 \
    libxrandr2 \
    libxinerama1 \
    libxi6 \
    libdbus-1-3 \
    libvulkan1 \
    vulkan-tools \
    winbind \
    libfreetype6 \
    libfreetype-dev \

    && rm -rf /var/lib/apt/lists/*

# Download and install SteamCMD
WORKDIR /battlebit/steamcmd
RUN wget -q https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -xvzf steamcmd_linux.tar.gz \
    && rm steamcmd_linux.tar.gz

# Install Wine GE
RUN mkdir -p /battlebit/wine-ge \
    && wget  https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton8-26/wine-lutris-GE-Proton8-26-x86_64.tar.xz -O /tmp/wine-ge.tar.xz \
    && tar -xf /tmp/wine-ge.tar.xz -C /battlebit/wine-ge/ \
    && rm /tmp/wine-ge.tar.xz

# Set the working directory
WORKDIR /battlebit/scripts

# Copy the run script into the container
COPY run.sh .

# Give execute permissions to the run script
RUN chmod +x run.sh

# Command to start the run script
CMD ["./run.sh"]
