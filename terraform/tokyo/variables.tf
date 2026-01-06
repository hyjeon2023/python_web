variable "http-port" {
    type = number
    default = 80
    description = "The port the server will use for HTTP requests"
}

variable "backend-port" {
    type = number
    default = 9000
    description = "The port the server will use for backend requests"
}

variable "ssh-port" {
    type = number
    default = 22
    description = "The port the server will use for SSH requests"
}

variable "bastion-http-test-port" {
    type = number
    default = 8080
    description = "The port the server will use for bastion HTTP test requests"
}