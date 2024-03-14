# Multi-Stage Capital Build

FROM busybox:1.33 AS base
COPY test.sh /test.sh

FROM base AS build
LABEL foo=bar

FROM base
