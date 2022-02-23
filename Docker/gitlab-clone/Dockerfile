FROM ruby:3.1.0-alpine AS base

FROM base AS base_private
ARG ALPINE_PROXY=${ALPINE_PROXY:-"mirrors.ustc.edu.cn"}
ARG RUBYGEMS_PROXY=${RUBYGEMS_PROXY:-"https://gems.ruby-china.com/"}
ARG NPM_PROXY=${NPM_PROXY:-"https://registry.yarnpkg.com"}
RUN gem sources --add "${RUBYGEMS_PROXY}" --remove https://rubygems.org/ && \
    bundle config mirror.https://rubygems.org "${RUBYGEMS_PROXY}"
RUN sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_PROXY}/g" /etc/apk/repositories

FROM base_private AS runner
RUN gem install git gitlab
RUN apk add --no-cache --update git git-lfs openssh tzdata
COPY --from=base /etc/apk/repositories /etc/apk/repositories

FROM runner AS deploy
ENV GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
COPY ./gitlab-clone /usr/local/sbin/gitlab-clone
RUN chmod +x /usr/local/sbin/gitlab-clone

ENTRYPOINT [ "/usr/local/sbin/gitlab-clone" ]