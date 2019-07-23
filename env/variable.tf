variable "project" {
    type = string
}

variable "region" {
    type = string
}

variable "environment_id" {
    type = string
}

variable "nomad_url" {
    type = string
}

variable "server" {
    type = object({
        count = number
        type = string
        image = string
    })
}