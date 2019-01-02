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
            "apt update",
            "apt -y install software-properties-common",
            "add-apt-repository universe",
            "add-apt-repository ppa:certbot/certbot -y",
            "apt update",
            "apt -y install python-certbot-nginx",
            "apt -y install nginx",
            "mkdir -p /var/www/thor-hansen",
        ]

        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.ssh_key_path}")}"
        }
    }

    provisioner "file" {
        source = "../hugo/"
        destination = "/var/www/thor-hansen"
    
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

    # Dump a script to execute later once dns is updated
    provisioner "remote-exec" {
        inline = [
            "echo $'certbot --non-interactive --agree-tos -m certbot@thor-hansen.com --nginx -d thor-hansen.com' > certbot.sh",
            "chmod +x certbot.sh",
        ]

        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.ssh_key_path}")}"
        }
    }
}
