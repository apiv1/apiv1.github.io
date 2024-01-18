#!bin/sh

if [ -n "${PASSWORD}" ] || [ -n "${HASHED_PASSWORD}" ]; then
    AUTH="password"
else
    AUTH="none"
    echo "starting with no password"
fi

if [ -z ${PROXY_DOMAIN+x} ]; then
    PROXY_DOMAIN_ARG=""
else
    PROXY_DOMAIN_ARG="--proxy-domain=${PROXY_DOMAIN}"
fi

mkdir -p /root/.code/{data,extensions}

exec tini -- code-server \
  --bind-addr 0.0.0.0:8443 \
  --user-data-dir /root/.code/data \
  --extensions-dir /root/.code/extensions \
  --disable-telemetry \
  --auth "${AUTH}" \
  "${PROXY_DOMAIN_ARG}" \
  /workspace