FROM python:3.12-slim

RUN apt update && apt install -y \
    procps \
    util-linux \
    mount \
    strace \
    iproute2 \
    gcc \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace