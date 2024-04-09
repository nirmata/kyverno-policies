# Multi-Stage Platform

FROM --platform=$BUILDPLATFORM ubuntu:22.04-slim AS build
COPY test.sh /test.sh

FROM build as run
LABEL foo=bar
