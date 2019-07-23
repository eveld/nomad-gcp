provider "google" {
  project     = var.project
  region      = var.region
}

module "nomad" {
  source = "./nomad"

  url = var.nomad.url
  instance = var.nomad.instance
}