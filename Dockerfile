ARG BASE_IMAGE=ghcr.io/steamcmd/steamcmd:debian
FROM ${BASE_IMAGE}

ENV BATTLEBIT_HOME="/opt/battlebit"

ENV UID=1000
ENV GID=1000
ENV WINEARCH=win64

# Create directories
RUN mkdir -p $BATTLEBIT_HOME/logs

# Setup users and dependencies
RUN --mount=target=/build,source=build \
    /build/setup.sh

WORKDIR $BATTLEBIT_HOME

# Copy scripts
COPY scripts/ /scripts/
COPY entrypoint.sh .
RUN chmod +x /scripts/*.sh entrypoint.sh
VOLUME ["/opt/battlebit/game", "/opt/battlebit/config", "/opt/battlebit/.wine", "/opt/battlebit/logs"]

ENTRYPOINT ["/usr/bin/tini", "--", "./entrypoint.sh"]
