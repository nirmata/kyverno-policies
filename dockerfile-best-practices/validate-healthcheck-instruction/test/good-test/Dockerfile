FROM ubuntu:latest

HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1

CMD ["nginx", "-g", "daemon off;"]
