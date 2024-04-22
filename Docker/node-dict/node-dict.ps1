function global:dict () {
  docker run --rm -it --network host apiv1/node-dict $($args -join ' ')
}