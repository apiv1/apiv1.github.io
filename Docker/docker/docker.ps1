$global:DOCKER_BIN = $((Get-Command docker).Path)
function global:docker-path() {
  $result = $args[0]
  $result = $result -replace '\\', '/'
  $result = $result -replace ':', ''
  if (!('/' -eq $result[0])) {
    $result = '/' + $result
  }
  return $result
}
function global:dood-run() {
  if ($args.Count -lt 1) {
    Write-Output "usage: <DOOD_IMAGE> [ARG1] [ARG2] ..."
    return
  }
  if (-not ($DOOD_QUIET)) {
    Write-Output '[DOOD] Running...'
  }
  $projectDirectory = if (-not ($PROJECT_DIRECTORY)) { $PWD.Path } else { $PROJECT_DIRECTORY }
  $projectDirectory = docker-path $projectDirectory

  $dockerSock = $DOCKER_SOCK
  $dockerSock = if ($null -ne $DOCKER_HOST -and ($null -eq $dockerSock)) { $DOCKER_HOST.Replace('unix://', '') } else { $null }
  $ttyFlag = if (-not ($NO_TTY)) { '-t' } else { $null }

  $dockerSock = if (-not ($dockerSock)) { "/var/run/docker.sock" } else { $dockerSock }

  Set-Alias -Name doInvoke -Value $(if (-not ($NO_EXEC)) { 'Invoke-Expression' } else { 'Write-Output' } )
  doInvoke ("&'$DOCKER_BIN' run --rm -i $ttyFlag --tmpfs /tmp:exec,rw -v '${dockerSock}:/var/run/docker.sock' -v '${projectDirectory}:${PATH_PREFIX:-}${projectDirectory}' -w '${PATH_PREFIX:-}${projectDirectory}' -e 'PUID=$uid' -e 'PGID=$gid' -e 'DOCKER_SOCK=$dockerSock' -e 'PWD=$projectDirectory' $($args -join ' ')")
}
function global:dood_docker-compose() {
  dood-run -v docker-context:/root/.docker apiv1/docker-compose $($args -join ' ')
}
function global:dood_compose() {
  dood_docker-compose $($args -join ' ')
}

function global:dood_docker-buildx() {
  dood-run -v docker-context:/root/.docker apiv1/docker-buildx $($args -join ' ')
}
function global:dood_buildx() {
  dood_docker-buildx $($args -join ' ')
}

function global:dood_docker() {
  if (Get-Command -ErrorAction SilentlyContinue ("dood_docker-" + $args[0])) {
    invoke-expression ("dood_docker-$($args -join ' ')")
  } elseif (Get-Command -ErrorAction SilentlyContinue ("docker-" + $args[0])) {
    invoke-expression ("docker-$($args -join ' ')")
  } else {
    invoke-expression ("&'$DOCKER_BIN' $($args -join ' ')")
  }
}

function global:dood_enable() {
  Set-Alias -Name docker-compose -Value dood_docker-compose -Scope Global
  Set-Alias -Name docker-buildx -Value dood_docker-buildx -Scope Global
  Set-Alias -Name docker -Value dood_docker -Scope Global
}
function global:dood_disable() {
  Remove-Alias -Name docker-compose -Scope Global
  Remove-Alias -Name docker-buildx -Scope Global
  Remove-Alias -Name docker -Scope Global
}

function global:dood() {
  if ($args.Count -lt 1) {
    Write-Output "usage: <docker command in dood>"
    return
  }
  if (Get-Command -ErrorAction SilentlyContinue ("dood_" + $args[0])) {
    invoke-expression ("dood_$($args -join ' ')")
  }
  else {
    dood-run -v docker-context:/.docker apiv1/docker $($args -join ' ')
  }
}