FROM steamcmd/steamcmd:ubuntu

# Probably don't mess with APP_ID
ENV APP_ID "896660"
# Later, possibly support 'unstable' and 'beta' branches
ENV APP_BRANCH "public"

ENV APP_HOME /valheim

# the application uses only one port as of now, 2457 on UDP by default
ENV APP_PORT "2457"

# Container install directory for dedicated server files
ENV INSTALL_DIR "$APP_HOME/valheim_server"
# world and configuration files
ENV DATA_DIR "$APP_HOME/.config/unity3d/IronGate/Valheim"

ARG DEBIAN_FRONTEND=noninteractive
# The helper scripts require these packages
RUN \
    apt update && \
    apt install -y --no-install-recommends \
        python3 \
        python3-requests \
        python3-pip && \
    pip3 install python-a2s

### XXX: remove
# Create the application user
# RUN useradd -m -d $APP_HOME $APP_USER

# Switch user and set working dir
# USER $APP_USER
WORKDIR $APP_HOME

# docker is weird with these variables
# ENV USER $APP_USER
ENV HOME $APP_HOME

# COPY --chown=$APP_USER . $APP_HOME/
COPY . $APP_HOME/
# RUN chown -R $APP_USER $APP_HOME

# update steamcmd
RUN steamcmd +quit


# Server does not appear to use TCP
# EXPOSE 2456-2458
# EXPOSE 2456-2458/udp
EXPOSE $APP_PORT/udp

VOLUME ["$DATA_DIR", "$INSTALL_DIR"]

# unset steamcmd parent entrypoint
ENTRYPOINT [""]
CMD ["./entrypoint.sh"]
