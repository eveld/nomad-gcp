variable "url" {
    type = string
}

variable "instance" {
    type = object({
        count = number
        type = string
        image = string
        tag = string
    })
}