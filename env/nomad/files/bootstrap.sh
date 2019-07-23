#!/bin/bash

# Install Nomad
curl -fsSL -o /tmp/nomad.zip ${nomad_url}
unzip -o -d /usr/local/bin/ /tmp/nomad.zip

# Set up credential helpers for Google Container Registry.
mkdir -p /etc/docker
cat <<EOF > /etc/docker/config.json
{
    "credHelpers": {
        "gcr.io": "gcr"
    }
}
EOF

# Configure Nomad.
mkdir -p /etc/nomad.d
cat <<EOF > /etc/nomad.d/server.hcl
log_level = "DEBUG"
data_dir = "/tmp/nomad"

server {
    enabled = true
    bootstrap_expect = 3

    server_join {
        retry_join = ["provider=gce tag_value=${join_tag}"]
    }
}


client {
    enabled = true
    options {
        "docker.auth.config" = "/etc/docker/config.json"
    }
}

consul {
    address = "localhost:8500"

    server_service_name = "nomad"
    client_service_name = "nomad-client"

    auto_advertise = true

    server_auto_join = true
    client_auto_join = true
}
EOF

cat <<EOF > /etc/systemd/system/nomad.service
[Unit]
Description=Nomad
Documentation=https://nomadproject.io/docs/

[Service]
TimeoutStartSec=0
ExecStart=/usr/local/bin/nomad agent -config=/etc/nomad.d

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable nomad.service
systemctl restart nomad