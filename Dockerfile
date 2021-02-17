FROM alpine
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.80.0/hugo_0.80.0_Linux-64bit.tar.gz
RUN tar xzf hugo_0.80.0_Linux-64bit.tar.gz -C /usr/local
WORKDIR /var
RUN /usr/local/hugo new site hugo
WORKDIR /var/hugo/themes/
RUN apk add --no-cache git
RUN git clone https://github.com/shenoybr/hugo-goa
COPY ./template/config.toml /var/hugo/config.toml
WORKDIR /var/hugo/
RUN /usr/local/hugo -b https://thor-hansen.com

FROM nginx
COPY --from=0 /var/hugo/ /var/hugo/
COPY ./template/nginx.conf /etc/nginx/nginx.conf
COPY ./config/profile.png /var/hugo/public/img/profile.png
EXPOSE 80
