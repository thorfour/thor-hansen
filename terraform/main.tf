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

data "template_file" "nginx_config" {
    template = "${file("../config/nginx.conf")}"

    vars {
        url = "${var.url}"
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
            "wget https://github.com/gohugoio/hugo/releases/download/v${var.hugo_release}/hugo_${var.hugo_release}_Linux-64bit.tar.gz",
            "tar xzf hugo_${var.hugo_release}_Linux-64bit.tar.gz -C /usr/local/hugo",
            "cd /var"
            "/usr/local/hugo new site hugo",
            "cd /var/hugo/themes",
            "git clone https://github.com/shenoybr/hugo-goa",
        ]

        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.ssh_key_path}")}"
        }
    }

    provisioner "file" {
        content = "${data.template_file.hugo_config.rendered}"
        destination "/var/hugo/config.toml"
        
        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.ssh_key_path}")}"
        }
    }

    provisioner "remote-exec" {
        inline = [
            "cd /var/hugo",
            "/usr/local/hugo -b https://${var.url}",
        ]

        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.ssh_key_path}")}"
        }
    }

    provisioner "file" {
        path = "../config/profile.png"
        destination "/var/hugo/${var.url}/www/img/profile.png"
        
        connection {
            type = "ssh"
            user = "root"
            private_key = "${file("${var.ssh_key_path}")}"
        }
    }


    provisioner "file" {
        content = "${data.template_file.nginx_config.rendered}"
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
            "echo $'certbot --non-interactive --agree-tos -m certbot@${var.url} --nginx -d ${var.url}' > certbot.sh",
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
