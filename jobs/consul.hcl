job "consul" {
    datacenters = ["dc1"]
    type = "service"

    group "server" {
        count = 3

        constraint {
            operator = "distinct_hosts"
            value = "true"
        }

        task "consul" {
            driver = "docker"

            config {
                network_mode = "host"
                image = "consul:1.6.0-beta1"
                args = ["agent", "-config-dir", "/consul/config"]
                volumes = ["local/consul/server.hcl:/consul/config/server.hcl"]
            }

            template {
                data = <<EOF
                log_level = "DEBUG"
                data_dir = "/consul/data"
                datacenter = "dc1"

                enable_central_service_config = true

                server = true
                bootstrap_expect = 3
                retry_join = ["provider=gce tag_value=server"]

                bind_addr = "0.0.0.0"
                client_addr = "0.0.0.0"
                advertise_addr = "{{ env "attr.unique.network.ip-address" }}"

                ports {
                    grpc = 8502
                }

                connect {
                    enabled = true
                }

                ui = true
                EOF
                destination = "local/consul/server.hcl"
            }
        }
    }
}