FROM alpine:3.8

WORKDIR /workdir
COPY . /workdir

RUN set -ex && \
    apk add --no-cache \
        bash \
        curl \
        util-linux

ENTRYPOINT [ "./lectl" ]

CMD [ "--help" ]
