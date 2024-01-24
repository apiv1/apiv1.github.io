#!bin/sh

if test -n "${PASSWORD}" -o -n "${HASHED_PASSWORD}"; then
    AUTH="password"
else
    AUTH="none"
    echo "starting with no password"
fi

test -z ${PROXY_DOMAIN} || PROXY_DOMAIN_ARG="--proxy-domain=${PROXY_DOMAIN}"

mkdir -p /root/.code/{data,extensions}

exec tini -- code-server \
  --bind-addr ${CODE_SERVER_BIND_ADDR:-0.0.0.0:8443} \
  --user-data-dir /root/.code/data \
  --extensions-dir /root/.code/extensions \
  --disable-telemetry \
  --auth "${AUTH}" \
  "${PROXY_DOMAIN_ARG}" \
  "${CODE_SERVER_ARGS}" \
  /workspace