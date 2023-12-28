job "tetris" {
  datacenters = ["dc1", "dc2"]

  group "games" {
    count = 5

    network {
      port "web" {
        to = 80
      }
    }
    
    spread {
      attribute = "${node.datacenter}"
      
      target "dc1" {
        percent = 70
      }

      target "dc2" {
        percent = 30
      }
    }

    task "tetris" {
      driver = "docker"

      config {
        image = "bsord/tetris"
        ports = ["web"]
      }
      resources {
        cpu    = 50
        memory = 256
      }
    }
  }
}