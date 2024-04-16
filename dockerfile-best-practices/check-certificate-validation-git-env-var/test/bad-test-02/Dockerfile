FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y git

ARG GIT_SSL_NO_VERIFY=true

CMD [ "echo", "hello world" ]