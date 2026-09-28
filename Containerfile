ARG DEBIAN_VERSION=13.6
FROM docker.io/gautada/debian:${DEBIAN_VERSION} as npm

# ╭――――――――――――――――――╮
# │ METADATA         │
# ╰――――――――――――――――――╯
LABEL org.opencontainers.image.title="paperclip"
LABEL org.opencontainers.image.description="paperclip - ai agent coodinator"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/gautada/paperclip"
LABEL org.opencontainers.image.source="https://github.com/gautada/paperclip"
LABEL org.opencontainers.image.license="Liscense"

# https://github.com/paperclipai/paperclip#quickstart
# ╭――――――――――――――――――╮
# │ PACKAGES         │
# ╰――――――――――――――――――╯
RUN apt-get update \
 && apt-get upgrade --yes \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* 

WORKDIR /opt/paperclip
RUN curl -fsSLO https://paperclip.ing/install.sh \
 && curl -fsSLO https://paperclip.ing/install.sh.sha256 \
 && chmod +x ./install.sh


# ╭――――――――――――――――――――╮
# │ USER               │
# ╰――――――――――――――――――――╯
# Rename the base debian user to container based user.
# Follows the same pattern as other gautada containers.
# The user name ryan was chosen after Ryan Dahl, the creator of Node.js.
# as suggested by ChatGPT
ARG OLDUSER=debian
ARG USER=clippy
RUN /usr/sbin/usermod -l $USER $OLDUSER \
 && /usr/sbin/usermod -d /home/$USER -m $USER \
 && /usr/sbin/groupmod -n $USER $OLDUSER \
 && PASSWORD="$(openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c 24)" \
 && printf '%s:%s\n' "$USER" "$PASSWORD" | /usr/sbin/chpasswd
