FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xrdp \
    dbus-x11 \
    xterm \
    sudo \
    curl \
    wget \
    git \
    firefox \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash desktop && \
    echo 'desktop:123456' | chpasswd && \
    usermod -aG sudo desktop

RUN printf '%s\n' \
    '#!/bin/sh' \
    'unset DBUS_SESSION_BUS_ADDRESS' \
    'unset XDG_RUNTIME_DIR' \
    'export XDG_CURRENT_DESKTOP=XFCE' \
    'export XDG_SESSION_DESKTOP=xfce' \
    'export XAUTHORITY=$HOME/.Xauthority' \
    'exec dbus-launch --exit-with-session startxfce4' \
    > /etc/xrdp/startwm.sh && \
    chmod +x /etc/xrdp/startwm.sh

RUN adduser xrdp ssl-cert

RUN mkdir -p /var/run/xrdp /var/run/dbus

EXPOSE 3389

CMD ["/bin/bash", "-c", "rm -f /var/run/xrdp/xrdp.pid /var/run/xrdp/xrdp-sesman.pid; xrdp-sesman; xrdp --nodaemon"]
