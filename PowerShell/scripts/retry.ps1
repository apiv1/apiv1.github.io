# https://stackoverflow.com/questions/32348794/how-to-get-status-of-invoke-expression-successful-or-failed
function global:retry() {
  do {
    try {
      $global:LASTEXITCODE = 0
      Invoke-Expression ("$($args -join ' ')")
      if(!$LASTEXITCODE) {
        break
      }
    }
    catch {
      Write-Error $_
    }
    Write-Output 'Retrying...'
    Start-Sleep 1
  } while (1)
}