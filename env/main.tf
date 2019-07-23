provider "google" {
  project     = var.project
  region      = var.region
}

data "google_project" "project" {}

module "nomad" {
  source = "./nomad"

  url = var.nomad.url
  instance = var.nomad.instance
}