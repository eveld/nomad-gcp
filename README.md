# nomad-gcp
Setup for testing Nomad on GCP.

# Setup
```
# Create a vars.tfvars file
cat <<EOF > vars.tfvars
project = "my-project"
region = "europe-west1"

// Requirements for base image are: curl, unzip (,docker?)
nomad = {
    url = "https://releases.hashicorp.com/nomad/0.9.3/nomad_0.9.3_linux_amd64.zip"
    instance = {
        tag = "unique-tag"
        count = 3
        type = "g1-small"
        image = "ubuntu-base"
    }
}
EOF
```

```
# Create the infrastructure.
make build
```

```
# Destroy the infrastructure.
make destroy
```