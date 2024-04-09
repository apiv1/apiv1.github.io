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
function global:dind-run() {
  if ($args.Count -lt 1) {
    Write-Output "usage: <DIND_IMAGE> [ARG1] [ARG2] ..."
    return
  }
  if (-not ($DIND_QUIET)) {
    Write-Output '[DIND] Running...'
  }
  $projectDirectory = if (-not ($PROJECT_DIRECTORY)) { $PWD.Path } else { $PROJECT_DIRECTORY }
  $projectDirectory = docker-path $projectDirectory

  $dockerSock = if ($null -ne $DOCKER_HOST -and ($null -eq $DOCKER_SOCK)) { $DOCKER_HOST.Replace('unix://', '') } else { $null }
  $ttyFlag = if (-not ($NO_TTY)) { '-t' } else { $null }

  $dockerSock = if (-not ($dockerSock)) { "/var/run/docker.sock" } else { $dockerSock }

  Set-Alias -Name doInvoke -Value $(if (-not ($NO_EXEC)) { 'Invoke-Expression' } else { 'Write-Output' } )
  doInvoke ("&'$DOCKER_BIN' run --rm -i $ttyFlag --tmpfs /tmp -v '${dockerSock}:/var/run/docker.sock' -v '${projectDirectory}:${PATH_PREFIX:-/_}${projectDirectory}' -w '${PATH_PREFIX:-/_}${projectDirectory}' -e 'PUID=$uid' -e 'PGID=$gid' -e 'DOCKER_SOCK=$dockerSock' -e 'PWD=$projectDirectory' $($args -join ' ')")
}
function global:dind-docker-compose() {
  dind-run -v docker-dind-context:/root/.docker apiv1/docker-compose $($args -join ' ')
}
function global:dind-compose() {
  dind-docker-compose $($args -join ' ')
}

function global:dind-docker-buildx() {
  dind-run -v docker-dind-context:/root/.docker apiv1/docker-buildx $($args -join ' ')
}
function global:dind-buildx() {
  dind-docker-buildx $($args -join ' ')
}

function global:dind-docker() {
  if ($args.Count -lt 1) {
    invoke-expression("&'$DOCKER_BIN'")
    return
  }
  if (Get-Command -ErrorAction SilentlyContinue ("docker-" + $args[0])) {
    invoke-expression ("docker-$($args -join ' ')")
  }
  else {
    invoke-expression ("&'$DOCKER_BIN' $($args -join ' ')")
  }
}

function global:dind-enable() {
  Set-Alias -Name docker-compose -Value dind-docker-compose -Scope Global
  Set-Alias -Name docker-buildx -Value dind-docker-buildx -Scope Global
  Set-Alias -Name docker -Value dind-docker -Scope Global
}
function global:dind-disable() {
  Remove-Alias -Name docker-compose -Scope Global
  Remove-Alias -Name docker-buildx -Scope Global
  Remove-Alias -Name docker -Scope Global
}

function global:dind() {
  if ($args.Count -lt 1) {
    Write-Output "usage: <docker command in dind>"
    return
  }
  if (Get-Command -ErrorAction SilentlyContinue ("dind-" + $args[0])) {
    invoke-expression ("dind-$($args -join ' ')")
  }
  else {
    dind-run -v docker-dind-context:/.docker apiv1/docker $($args -join ' ')
  }
}