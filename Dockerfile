FROM steamcmd/steamcmd:ubuntu

# Probably don't mess with APP_ID
ENV APP_ID "896660"
# Later, possibly support 'unstable' and 'beta' branches
ENV APP_BRANCH "public"
# Container install directory for dedicated server files
ENV INSTALL_DIR "/opt/valheim_server"
# world and configuration files
ENV DATA_DIR "/root/.config/unity3d/IronGate/Valheim"

# The helper scripts require these packages
RUN \
    apt update && \
    apt install -y \
        python3 \
        python3-requests \
        python3-pip && \
    pip3 install python-a2s

# update steamcmd
RUN \
    steamcmd +quit

ADD . .

EXPOSE 2456-2458
EXPOSE 2456-2458/udp

VOLUME [$DATA_DIR, $INSTALL_DIR]

# unset steamcmd parent entrypoint
ENTRYPOINT []
CMD ["entrypoint.sh"]
