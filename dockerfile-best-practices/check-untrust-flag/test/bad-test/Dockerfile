FROM alpine:latest

RUN apk update && \
    apk add --no-cache --allow-untrusted curl

WORKDIR /app

COPY . /app

CMD ["echo", "Container is running!"]
