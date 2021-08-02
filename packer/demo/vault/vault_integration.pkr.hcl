source "null" "example" {
  communicator = "none"
}

build {
  sources = [
    "source.null.example"
  ]

  provisioner "shell-local" {
    environment_vars = ["API_KEY=${vault("/secret/data/myapp", "apiKey")}"]
    command          = "echo API_KEY is $API_KEY"
  }
}
