function global:code-server () {
  dood-run -e "NETWORK_MODE='$NETWORK_MODE'" -e "PROXY_DOMAIN='$PROXY_DOMAIN'" -e "LISTEN_ADDR='$LISTEN_ADDR'" -e "CODE_SERVER_BIND_ADDR='$CODE_SERVER_BIND_ADDR'" -e "PASSWORD='$PASSWORD'" -e "HASHED_PASSWORD='$HASHED_PASSWORD'" apiv1/code-server:compose --project-directory $( docker-path $PWD.Path ) -f /compose.yml $($args -join ' ')
}