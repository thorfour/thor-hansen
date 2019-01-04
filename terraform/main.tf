provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "default" {
    name = "default"
    public_key = "${file("${var.ssh_key_path}.pub")}"
}

data "template_file" "hugo_config" {
    template = "${file("../config/config.toml")}"

    vars {
        url = "${var.url}"
        name = "${var.name}"
        description = "${var.description}"
        github = "${var.github}"
        linkedin = "${var.linkedin}"
        twitter = "${var.twitter}"
        email = "${var.email}"
    }
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

    # TODO THOR wget the latest hugo release
    # TODO THOR generate a hugo server here
    # TODO THOR checkout theme
    # TODO THOR copy profile.png

    provisioner "file" {
        content = "${data.template_file.hugo_config.rendered}"
        destination "/var/hugo/config.toml"
        
        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.ssh_key_path}")}"
        }
    }

    # TODO THOR regenerate site with new config

    provisioner "file" {
        source = "../config/nginx.conf"
        destination = "/etc/nginx/nginx.conf"

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
            "systemctl restart nginx",
        ]

        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.ssh_key_path}")}"
        }
    }
}
