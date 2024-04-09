function global:myvim-compose () {
  dood-run apiv1/myvim:compose --project-directory $( docker-path $PWD.Path ) -f /compose.yml $($args -join ' ')
}
function global:myvim-env () {
  myvim-compose run --rm editor $($args -join ' ')
}
function global:myvim () {
  myvim-env vim $($args -join ' ')
}
