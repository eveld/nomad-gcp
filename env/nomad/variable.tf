variable "url" {
    type = string
}

variable "instance" {
    type = object({
        zone = string
        count = number
        type = string
        image = string
        tag = string
    })
}