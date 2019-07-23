variable "project" {
    type = string
}

variable "region" {
    type = string
}

variable "participant" {
    type = string
}

variable "nomad" {
    type = object({
        url = string
        instance = object({
            tag = string
            zone = string
            count = number
            type = string
            image = string
        })
    })
}