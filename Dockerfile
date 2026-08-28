FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt install --no-install-recommends -y \
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
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash desktop && \
    echo 'desktop:123456' | chpasswd && \
    adduser desktop sudo

RUN printf '#!/bin/sh\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
unset XDG_RUNTIME_DIR\n\
export XDG_CURRENT_DESKTOP=XFCE\n\
export XDG_SESSION_DESKTOP=xfce\n\
exec dbus-launch --exit-with-session startxfce4\n' > /etc/xrdp/startwm.sh && \
    chmod +x /etc/xrdp/startwm.sh

RUN adduser xrdp ssl-cert

EXPOSE 3389

CMD service xrdp start && tail -f /dev/null
