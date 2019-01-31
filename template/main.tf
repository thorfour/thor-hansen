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

# output generated files
resource "null_resource" "local_nginx" {
    triggers {
        template = "${data.template_file.nginx_config.rendered}"
    }
    
    provisioner "local-exec" {
        command = "echo \"${data.template_file.nginx_config.rendered}\" > nginx.conf"
    }
}

resource "null_resource" "local_hugo" {
    triggers {
        template = "${data.template_file.hugo_config.rendered}"
    }
    
    provisioner "local-exec" {
        command = "echo '${data.template_file.hugo_config.rendered}' > config.toml"
    }
}
