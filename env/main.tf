provider "google" {
  project     = var.project
  region      = var.region
}

module "nomad" {
  source = "./nomad"

  nomad_url = var.nomad_url
  
  server_region = var.region
  server_tag = var.environment_id
  server_type = var.server.type
  server_count = var.server.count
  server_image = var.server.image
}