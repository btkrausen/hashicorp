source "googlecompute" "ubuntu" {
  account_file        = "secrets.json"
  image_name          = "packer-ubuntu-gcp-{{timestamp}}"
  image_description   = "Ubuntu 20-04 Image with Ngnix-{{timestamp}}"
  project_id          = "webfleet-220519"
  source_image_family = "ubuntu-2004-lts"
  ssh_username        = "ubuntu"
  tags                = ["packer"]
  zone                = "us-central1-a"
}

build {
  sources = ["source.googlecompute.ubuntu"]

  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }

  # Install GCP CLI
  provisioner "shell" {
    inline = [
      "echo Installing Google Cloud SDK CLI",
      "echo \"deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main\" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list",
      "sudo apt-get install -y apt-transport-https ca-certificates gnupg",
      "curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -",
      "sudo apt-get update && sudo apt-get -y install google-cloud-sdk",
      "gcloud --version"
    ]
  }
}
