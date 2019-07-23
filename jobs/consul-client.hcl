job "consul-client" {
    datacenters = ["dc1"]
    type = "system"

    group "client" {
        constraint {
            attribute = "${attr.platform.gce.tag.server}"
            value = "false"
        }

        task "consul" {
            driver = "docker"

            config {
                network_mode = "host"
                image = "consul:1.6.0-beta1"
                args = ["agent", "-config-dir", "/consul/config"]
                volumes = ["local/consul/client.hcl:/consul/config/client.hcl"]
            }

            template {
                data = <<EOF
                log_level = "DEBUG"
                data_dir = "/consul/data"
                datacenter = "dc1"

                retry_join = ["provider=gce tag_value=server"]
                EOF
                destination = "local/consul/client.hcl"
            }
        }
    }
}