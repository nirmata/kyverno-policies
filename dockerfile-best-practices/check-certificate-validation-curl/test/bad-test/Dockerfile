FROM alpine:latest

RUN apk --no-cache add curl

RUN curl --insecure -LO https://github.com/glasskube/glasskube/releases/download/v0.0.1/glasskube_v0.0.1_amd64.deb

ENTRYPOINT ["curl"]