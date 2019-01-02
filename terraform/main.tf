provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "default" {
    name = "default"
    public_key = "${file("${var.ssh_key_path}.pub")}"
}

# Create the server droplet
resource "digitalocean_droplet" "hugo_server" {
    image = "${var.os_image}"
    name = "hugo-server"
    region = "nyc3"
    size = "${var.cpu_size}"
    monitoring = true
    ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]
    tags = ["terraform", "hugo"]

    provisioner "remote-exec" {
        inline = [
            "apt -y install nginx",
            "apt -y install python-certbox-nginx",
        ]

        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.ssh_key_path}")}"
        }
    }

    provisioner "file" {
        source = "../hugo/"
        destination = "/var/www/thor-hansen/"
    
        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.ssh_key_path}")}"
        }
    }

    provisioner "file" {
        source = "../config/default"
        destination = "/etc/nginx/sites-available/default"

        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.ssh_key_path}")}"
        }
    }

    provisioner "remote-exec" {
        inline = [
            "certbox --nginx -d thor-hansen.com",
            "systemctl nginx restart",
        ]

        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.ssh_key_path}")}"
        }
    }
}
