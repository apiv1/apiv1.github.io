FROM apiv1/remote-desktop AS chrome_deploy
RUN apt-get --update install -y \
  wget \
  fonts-wqy-microhei \
  && wget --no-check-certificate https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && apt-get install -y ./google-chrome-stable_current_amd64.deb \
  && rm -rf ./google-chrome-stable_current_amd64.deb \
  && rm -rf /var/lib/apt/lists/*
RUN unlink /usr/bin/google-chrome && \
  unlink /usr/bin/google-chrome-stable && \
  echo /etc/alternatives/google-chrome --disable-dev-shm-usage > /usr/bin/google-chrome && chmod +x /usr/bin/google-chrome && \
  echo /opt/google/chrome/google-chrome --disable-dev-shm-usage > /usr/bin/google-chrome-stable && chmod +x /usr/bin/google-chrome-stable