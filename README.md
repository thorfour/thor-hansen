#  thor-hansen.com
Personal webpage generator

Automatically deployes a [Goa](https://themes.gohugo.io/hugo-goa/) themed webpage to a digital ocean droplet.

# Usage

You'll need a [DigitalOcean](https://www.digitalocean.com/) account and [API key](https://www.digitalocean.com/docs/api/create-personal-access-token/) and [Docker](https://www.docker.io) to deploy

`make deploy`

Then you can navigate to that droplets ip address to view the page

To tear the server down

`make teardown`
