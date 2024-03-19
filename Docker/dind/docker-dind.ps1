$DOCKER_BIN = $((Get-Command docker).Path)

function docker-path() {
  $result = $args[0]
  $result = $result -replace '\\', '/'
  $result = $result -replace ':', ''
  if(!('/' -eq $result[0])) {
    $result = '/' + $result
  }
  return $result
}

function docker-dind() {
  if ($args.Count -lt 1) {
    Write-Output "usage: <DIND_IMAGE> [ARG1] [ARG2] ..."
    return
  }
  $projectDirectory = if (-not ($env:PROJECT_DIRECTORY)) { $PWD.Path } else { $env:PROJECT_DIRECTORY }
  $projectDirectory = docker-path $projectDirectory

  $dockerSock = if ($null -ne $env:DOCKER_HOST -and ($null -eq $env:DOCKER_SOCK)) { $env:DOCKER_HOST.Replace('unix://', '') } else { $null }
  $ttyFlag = if (-not ($env:NO_TTY)) { '-t' } else { $null }

  $dockerSock = if (-not ($dockerSock)) { "/var/run/docker.sock" } else { $dockerSock }
  invoke-expression ("&'$DOCKER_BIN' run --rm -i $ttyFlag --tmpfs /tmp -v '${dockerSock}:/var/run/docker.sock' -v '${projectDirectory}:${projectDirectory}' -w '${projectDirectory}' -e 'PUID=$uid' -e 'PGID=$gid' -e 'DOCKER_SOCK=$dockerSock' $($args -join ' ')")
}

function docker-compose() {
  docker-dind apiv1/docker-compose $($args -join ' ')
}

function docker-buildx() {
  docker-dind apiv1/docker-buildx $($args -join ' ')
}

function docker() {
  if ($args.Count -lt 1) {
    invoke-expression("&'$DOCKER_BIN'")
    return
  }
  if(Get-Command -ErrorAction SilentlyContinue ("docker-" + $args[0])) {
    invoke-expression ("docker-$($args -join ' ')")
  } else {
    invoke-expression ("&'$DOCKER_BIN' $($args -join ' ')")
  }
}
