FROM alpine:latest

RUN apk update && \
    apk add --no-cache curl

WORKDIR /app

COPY . /app

CMD ["echo", "Container is running!"]
