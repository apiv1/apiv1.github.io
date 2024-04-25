ARG STAGE_BUILDER=builder
ARG STAGE_DEPLOY=deploy
FROM ubuntu:20.04 as builder
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && sed -i -E 's/^# deb-src /deb-src /g' /etc/apt/sources.list \
    && apt-get update --allow-unauthenticated \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        build-essential \
        dpkg-dev \
        git \
        libpulse-dev \
        pulseaudio \
    && apt-get build-dep -y pulseaudio \
    && apt-get source pulseaudio \
    && rm -rf /var/lib/apt/lists/*

RUN cd /pulseaudio-$(pulseaudio --version | awk '{print $2}') \
    && ./configure

RUN git clone https://github.com/neutrinolabs/pulseaudio-module-xrdp.git /pulseaudio-module-xrdp \
    && cd /pulseaudio-module-xrdp \
    && ./bootstrap \
    && ./configure PULSE_DIR=/pulseaudio-$(pulseaudio --version | awk '{print $2}') \
    && make \
    && make install

FROM ${STAGE_BUILDER} as stage-builder

# Build the final image
FROM ubuntu:24.04 as deploy
ARG TARGETOS
ARG TARGETARCH
RUN --mount=type=cache,target=/var/cache/apt/archives,id=apt_${TARGETOS}_${TARGETARCH} \
    sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --update -y --no-install-recommends \
        dbus-x11 \
        locales \
        pavucontrol \
        pulseaudio \
        pulseaudio-utils \
        sudo \
        x11-xserver-utils \
        xfce4 \
        xfce4-goodies \
        xfce4-pulseaudio-plugin \
        xorgxrdp \
        xrdp \
        xubuntu-icon-theme \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i -E 's/^; autospawn =.*/autospawn = yes/' /etc/pulse/client.conf \
    && [ -f /etc/pulse/client.conf.d/00-disable-autospawn.conf ] && sed -i -E 's/^(autospawn=.*)/# \1/' /etc/pulse/client.conf.d/00-disable-autospawn.conf || : \
    && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

COPY --from=stage-builder /usr/lib/pulse-*/modules/module-xrdp-sink.so /usr/lib/pulse-*/modules/module-xrdp-source.so /var/lib/xrdp-pulseaudio-installer/
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/*
EXPOSE 3389/tcp
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

FROM ${STAGE_DEPLOY} as stage-deploy

FROM stage-deploy AS chrome
RUN --mount=type=cache,target=/var/cache/apt/archives,id=apt_${TARGETOS}_${TARGETARCH} \
    apt-get --update install -y \
    wget \
    gpg && \
    echo 'deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google-chrome.list && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/chrome.gpg && \
    apt-get install -y --update \
    google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*
RUN unlink /usr/bin/google-chrome && \
    unlink /usr/bin/google-chrome-stable && \
    echo /etc/alternatives/google-chrome --disable-dev-shm-usage '"$@"' > /usr/bin/google-chrome && chmod +x /usr/bin/google-chrome && \
    echo /opt/google/chrome/google-chrome --disable-dev-shm-usage '"$@"' > /usr/bin/google-chrome-stable && chmod +x /usr/bin/google-chrome-stable