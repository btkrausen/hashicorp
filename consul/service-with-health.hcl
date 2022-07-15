service {
    id = "web-server-01"
    name = "front-end-eCommerce"
    
    address = "10.0.101.110"
    port = 80

    tags = ["v7.05", "production"]

    check = {
        id = "web"
        name = "Check web on port 80"
        tcp = "localhost:80"
        interval = "10s"
        timeout = "1s"
    }
}
