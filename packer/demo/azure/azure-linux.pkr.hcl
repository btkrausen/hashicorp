source "azure-arm" "ubuntu" {
  # client_id                         = "XXXX"
  # client_secret                     = "XXXX"
  # tenant_id                         = "XXXX"
  # subscription_id                   = "XXXX"
  managed_image_resource_group_name = "packer_images"
  managed_image_name                = "packer-ubuntu-azure-{{timestamp}}"

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-focal"
  image_sku       = "20_04-lts"

  azure_tags = {
    Created-by = "Packer"
    OS_Version = "Ubuntu 20.04"
    Release    = "Latest"
  }

  location = "East US"
  vm_size  = "Standard_A2"
}

build {
  name = "ubuntu"
  sources = [
    "source.azure-arm.ubuntu",
  ]

  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y nginx"
    ]
  }

  # Install Azure CLI
  provisioner "shell" {
    inline = ["curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"]
  }

  post-processor "manifest" {}

}
