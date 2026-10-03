ARG NODE_VERSION=24.20.0
FROM docker.io/gautada/node:${NODE_VERSION} as npm

# ╭――――――――――――――――――╮
# │ METADATA         │
# ╰――――――――――――――――――╯
LABEL org.opencontainers.image.title="paperclip"
LABEL org.opencontainers.image.description="paperclip - ai agent coordinator"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/gautada/paperclip"
LABEL org.opencontainers.image.source="https://github.com/gautada/paperclip"
LABEL org.opencontainers.image.license="Upstream"

# ╭――――――――――――――――――╮
# │ PACKAGES         │
# ╰――――――――――――――――――╯
# https://github.com/paperclipai/paperclip#quickstart
RUN apt-get update \
 && apt-get upgrade --yes \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/paperclip
RUN /usr/bin/npm install --global --ignore-scripts=false paperclipai

# ╭――――――――――――――――――――╮
# │ USER               │
# ╰――――――――――――――――――――╯
# Rename the base debian user to container based user.
# Follows the same pattern as other gautada containers.
# The user name ryan was chosen after Ryan Dahl, the creator of Node.js.
# as suggested by ChatGPT
ARG OLDUSER=ryan
ARG USER=clippy
RUN /usr/sbin/usermod -l $USER $OLDUSER \
 && /usr/sbin/usermod -d /home/$USER -m $USER \
 && /usr/sbin/groupmod -n $USER $OLDUSER \
 && PASSWORD="$(openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c 24)" \
 && printf '%s:%s\n' "$USER" "$PASSWORD" | /usr/sbin/chpasswd

# ╭――――――――――――――――――╮
# │ VERSION          │
# ╰――――――――――――――――――╯
# Overrides the base image's version reporter, per debian's own
# contract: container-version should print ONLY this layer's version.
COPY usr/bin/container-version /usr/bin/container-version
RUN chmod 0755 /usr/bin/container-version

# ╭――――――――――――――――――╮
# │ SERVICE          │
# ╰――――――――――――――――――╯
COPY etc/services.d/paperclip/run /etc/services.d/paperclip/run
RUN chmod 0755 /etc/services.d/paperclip/run

EXPOSE 8080/tcp 3100/tcp
WORKDIR /home/clippy
