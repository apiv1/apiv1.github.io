FROM ubuntu:24.04
ARG TARGETOS
ARG TARGETARCH
RUN --mount=type=cache,target=/var/lib/apt/lists,id=apt_${TARGETOS}_${TARGETARCH} \
  sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
  sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
  apt install --update -y \
  git wget curl
RUN (/bin/echo -e '[url "https://kkgithub.com/"]\n  insteadOf = https://github.com/\n[url "https://github.com/"]\n  pushInsteadOf = https://github.com/' | tee ~/.gitconfig) && \
  (/bin/echo -e 'export NVM_DIR="$HOME/.nvm"\n[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm\n[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' | tee /etc/profile.d/nvm.sh)
RUN git clone --depth=1 https://github.com/nvm-sh/nvm ~/.nvm
RUN (/bin/echo -e '#!/bin/bash\nexec bash -c ". /etc/profile; ${*:-bash}"' | tee /entrypoint.sh) && chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

RUN /entrypoint.sh nvm install --lts