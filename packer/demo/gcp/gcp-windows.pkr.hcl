source "googlecompute" "windows_2019" {
  account_file      = "secrets.json"
  image_name        = "packer-w2k19-gcp-{{timestamp}}"
  image_description = "Windows 2019 Server-{{timestamp}}"
  project_id        = "webfleet-220519"
  source_image      = "windows-server-2019-dc-v20200813"
  zone              = "us-central1-a"
  disk_size         = 50
  machine_type      = "n1-standard-2"
  communicator      = "winrm"
  winrm_username    = "packer_user"
  winrm_insecure    = true
  winrm_use_ssl     = true
  metadata = {
    windows-startup-script-cmd = "winrm quickconfig -quiet & net user /add packer_user & net localgroup administrators packer_user /add & winrm set winrm/config/service/auth @{Basic=\"true\"}"
  }
}

build {
  sources = ["sources.googlecompute.windows_2019"]
}
