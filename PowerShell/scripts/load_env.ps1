function global:load_envs() {
  foreach ($item in Get-ChildItem -ErrorAction SilentlyContinue ~/.ps1.d) {
    . ($item).FullName
  }
}
load_envs