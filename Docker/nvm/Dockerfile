FROM ubuntu:24.04 AS base

FROM base AS base_private
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  apt-get update --allow-unauthenticated
RUN apt install -y \
  git wget curl
RUN echo '[url "https://kkgithub.com/"]\n  insteadOf = https://github.com/\n[url "https://github.com/"]\n  pushInsteadOf = https://github.com/' | tee ~/.gitconfig
RUN echo 'export NVM_DIR="$HOME/.nvm"\n[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm\n[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' | tee ~/.bash_aliases
RUN git clone --depth=1 https://github.com/nvm-sh/nvm ~/.nvm
RUN echo '#!/bin/bash\nexec bash -c ". ~/.bash_aliases; ${*:-bash}"' | tee /entrypoint.sh && chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

RUN /entrypoint.sh nvm install --lts