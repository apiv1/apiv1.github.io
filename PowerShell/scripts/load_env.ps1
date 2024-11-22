function global:load_envs() {
  foreach ($item in Get-ChildItem -ErrorAction SilentlyContinue ~/.ps1.d/"*.ps1") {
    . ($item).FullName
  }
}
load_envs