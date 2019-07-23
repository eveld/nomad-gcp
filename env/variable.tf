variable "project" {
    type = string
}

variable "region" {
    type = string
}

variable "nomad" {
    type = object({
        url = string
        instance = object({
            tag = string
            count = number
            type = string
            image = string
        })
    })
}