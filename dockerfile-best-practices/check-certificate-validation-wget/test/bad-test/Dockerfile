FROM alpine:latest

RUN apk --no-cache add wget

RUN wget --no-check-certificate https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.17.2.tar.xz

ENTRYPOINT ["wget"]