data "google_compute_zones" "available" {}

// The Nomad server group.
resource "google_compute_instance_group_manager" "server" {
  name               = "server-group-manager"
  instance_template  = google_compute_instance_template.server.self_link
  base_instance_name = "server"
  zone               = data.google_compute_zones.available.names[0]
  target_size        = var.instance.count
}

// The instance template for the Nomad servers.
resource "google_compute_instance_template" "server" {
  name_prefix  = "server-template-"
  description = "This template is used for server instances."

  tags = ["server", var.instance.tag, "allow-health-checks"]

  labels = {
    environment = "dev"
  }

  instance_description = "server instance"
  machine_type         = var.instance.type
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = var.instance.image
    auto_delete  = true
    boot         = true
  }

  metadata_startup_script = "${data.template_file.metadata_startup_script.rendered}"

  network_interface {
    network = "default"

    access_config {}
  }

  lifecycle {
    create_before_destroy = false
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

// The startup script that sets up the Nomad cluster.
data "template_file" "metadata_startup_script" {
  template = "${file("${path.module}/files/bootstrap.sh")}"
  vars = {
    nomad_url = var.url
    join_tag = var.instance.tag
  }
}