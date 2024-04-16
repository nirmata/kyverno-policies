FROM centos:latest

RUN dnf -y update --setopt=sslverify=true && \
    dnf -y install wget\

CMD [ "echo", "Hello world" ]