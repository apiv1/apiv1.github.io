function global:myvim-compose () {
  dind-run apiv1/myvim:dind --project-directory $( docker-path $PWD.Path ) -f /compose.yml $($args -join ' ')
}
function global:myvim-env () {
  myvim-compose run --rm editor $($args -join ' ')
}
function global:myvim () {
  myvim-env vim $($args -join ' ')
}
