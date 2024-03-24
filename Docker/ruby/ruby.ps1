$global:RUBY_IMAGE='ruby:alpine'
function global:ruby-compose () {
  dind-run apiv1/ruby:dind --project-directory $( docker-path $PWD.Path ) -f /compose.yml $($args -join ' ')
}
function global:ruby-env () {
  ruby-compose run --rm --entrypoint sh ruby $($args -join ' ')
}
function global:ruby-cli () {
  ruby-compose run --rm ruby $($args -join ' ')
}
