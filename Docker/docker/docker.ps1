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

  $dockerSock = if ($null -ne $DOCKER_HOST -and ($null -eq $DOCKER_SOCK)) { $DOCKER_HOST.Replace('unix://', '') } else { $null }
  $ttyFlag = if (-not ($NO_TTY)) { '-t' } else { $null }

  $dockerSock = if (-not ($dockerSock)) { "/var/run/docker.sock" } else { $dockerSock }

  Set-Alias -Name doInvoke -Value $(if (-not ($NO_EXEC)) { 'Invoke-Expression' } else { 'Write-Output' } )
  doInvoke ("&'$DOCKER_BIN' run --rm -i $ttyFlag --tmpfs /tmp -v '${dockerSock}:/var/run/docker.sock' -v '${projectDirectory}:${PATH_PREFIX:-}${projectDirectory}' -w '${PATH_PREFIX:-}${projectDirectory}' -e 'PUID=$uid' -e 'PGID=$gid' -e 'DOCKER_SOCK=$dockerSock' -e 'PWD=$projectDirectory' $($args -join ' ')")
}
function global:dood-docker-compose() {
  dood-run -v docker-context:/root/.docker apiv1/docker-compose $($args -join ' ')
}
function global:dood-compose() {
  dood-docker-compose $($args -join ' ')
}

function global:dood-docker-buildx() {
  dood-run -v docker-context:/root/.docker apiv1/docker-buildx $($args -join ' ')
}
function global:dood-buildx() {
  dood-docker-buildx $($args -join ' ')
}

function global:dood-docker() {
  if (Get-Command -ErrorAction SilentlyContinue ("dood-docker-" + $args[0])) {
    invoke-expression ("dood-docker-$($args -join ' ')")
  } elseif (Get-Command -ErrorAction SilentlyContinue ("docker-" + $args[0])) {
    invoke-expression ("docker-$($args -join ' ')")
  } else {
    invoke-expression ("&'$DOCKER_BIN' $($args -join ' ')")
  }
}

function global:dood-enable() {
  Set-Alias -Name docker-compose -Value dood-docker-compose -Scope Global
  Set-Alias -Name docker-buildx -Value dood-docker-buildx -Scope Global
  Set-Alias -Name docker -Value dood-docker -Scope Global
}
function global:dood-disable() {
  Remove-Alias -Name docker-compose -Scope Global
  Remove-Alias -Name docker-buildx -Scope Global
  Remove-Alias -Name docker -Scope Global
}

function global:dood() {
  if ($args.Count -lt 1) {
    Write-Output "usage: <docker command in dood>"
    return
  }
  if (Get-Command -ErrorAction SilentlyContinue ("dood-" + $args[0])) {
    invoke-expression ("dood-$($args -join ' ')")
  }
  else {
    dood-run -v docker-context:/.docker apiv1/docker $($args -join ' ')
  }
}