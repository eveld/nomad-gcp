// A backend service that points at the Nomad servers instance group.
resource "google_compute_region_backend_service" "nomad" {
  name             = "nomad"
  protocol         = "TCP"
  timeout_sec      = 10
  session_affinity = "CLIENT_IP"

  backend {
    group = "${google_compute_instance_group_manager.server.instance_group}"
  }

  health_checks = ["${google_compute_health_check.nomad.self_link}"]
}

// A healthcheck that checks the Nomad http port.
resource "google_compute_health_check" "nomad" {
  name               = "nomad"
  check_interval_sec = 10
  timeout_sec        = 3

  tcp_health_check {
    port = "4646"
  }
}

// A forwarding rule so we can reach the Nomad servers instance group.
resource "google_compute_forwarding_rule" "nomad" {
  name       = "server-forwarding-rule"
  backend_service = "${google_compute_region_backend_service.nomad.self_link}"
  load_balancing_scheme = "INTERNAL"
  ports = ["4646"]
}

// Allow health checks to reach the instances.
resource "google_compute_firewall" "health-checks" {
  name    = "health-checks"
  network = "default"

  allow {
    protocol = "tcp"
  }

  source_ranges = ["35.191.0.0/16","130.211.0.0/22"]
  target_tags = ["allow-health-checks"]
}

// Output the internal loadbalancer IP for Nomad.
output "nomad" {
  value = google_compute_forwarding_rule.nomad.ip_address
}