FROM alpine

ARG HUGO_VERSION
ENV VERSION $HUGO_VERSION

RUN mkdir /usr/local/hugo
ADD https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz /usr/local/hugo
RUN tar xzf /usr/local/hugo/hugo_${VERSION}_Linux-64bit.tar.gz -C /usr/local/hugo
RUN rm /usr/local/hugo/hugo_${VERSION}_Linux-64bit.tar.gz

CMD /usr/local/hugo/hugo
