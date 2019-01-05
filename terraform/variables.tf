variable "do_token" {}

variable "ssh_key_path" {
    default = "~/.ssh/id_rsa"
}

variable "hugo_release" {
    default = "0.53"
}

variable "os_image" {
    default = "ubuntu-18-04-x64"
}

variable "cpu_size" {
    default = "s-1vcpu-1gb"
}

variable "url" {
    default = "thor-hansen.com"
}

variable "name" {
    default = "Thor Hansen"
}

variable "description" {
    default = "cloud scale distributed systems engineer at [DigitalOcean](http://www.digitalocean.com/)"
}

variable "github" {
    default = "thorfour"
}

variable "linkedin" {
    default = "thor-hansen"
}

variable "twitter" {
    default = "thor4hansen"
}

variable "email" {
    default = "me@thor-hansen.com"
}
