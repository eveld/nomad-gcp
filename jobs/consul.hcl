job "consul" {
    datacenters = ["dc1"]
    type = "service"

    group "consul-1" {
        count = 1

        task "consul" {
            driver = "docker"

            config {
                image = "consul:1.6.0-beta1"
            }
        }
    }
}