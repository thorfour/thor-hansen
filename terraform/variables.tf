variable "do_token" {}

variable "ssh_key_path" {
    default = "~/.ssh/id_rsa"
}

variable "hugo_release" {
    default = "https://github.com/gohugoio/hugo/releases/download/v0.53/hugo_0.53_Linux-64bit.deb"
}

variable "os_image" {
    default = "ubuntu-18-04-x64"
}

variable "cpu_size" {
    default = "s-1vcpu-1gb"
}
