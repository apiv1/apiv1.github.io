FROM ubuntu:20.04 as builder
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && sed -i -E 's/^# deb-src /deb-src /g' /etc/apt/sources.list \
    && DEBIAN_FRONTEND="noninteractive" apt-get install --update -y --no-install-recommends \
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


# Build the final image
FROM ubuntu:24.04 as deploy
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i -E 's/^; autospawn =.*/autospawn = yes/' /etc/pulse/client.conf \
    && [ -f /etc/pulse/client.conf.d/00-disable-autospawn.conf ] && sed -i -E 's/^(autospawn=.*)/# \1/' /etc/pulse/client.conf.d/00-disable-autospawn.conf || : \
    && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

COPY --from=builder /usr/lib/pulse-*/modules/module-xrdp-sink.so /usr/lib/pulse-*/modules/module-xrdp-source.so /var/lib/xrdp-pulseaudio-installer/
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/*
EXPOSE 3389/tcp
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]