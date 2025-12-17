job "tetris" {
  datacenters = [dc1]

  group "games" {
    count = 5

    network {
      mode = "host"
      port "http" {
        to = 80
      }
    }
    task "tetris" {
      driver = "docker"
      config {
        image = "bsord/tetris"
        ports = ["http"]
      }
      resources {
        cpu    = 50
        memory = 50
      }
    }
  }
}