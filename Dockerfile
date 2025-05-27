# ================= Build Stage ==================
FROM golang:1.23-bookworm AS builder
WORKDIR /build

# 声明构建参数（不强制传入）
ARG HTTP_PROXY
ARG HTTPS_PROXY

# 设置为环境变量（如果没传，值为空，go 等会忽略）
ENV http_proxy=$HTTP_PROXY
ENV https_proxy=$HTTPS_PROXY

COPY ./avalanche-cli/go.mod .
COPY ./avalanche-cli/go.sum .
RUN go mod download

COPY ./avalanche-cli/ .
RUN ./scripts/build.sh

# ================= Release Stage ==================
FROM ubuntu:22.04
WORKDIR /

ARG HTTP_PROXY
ARG HTTPS_PROXY
ENV http_proxy=$HTTP_PROXY
ENV https_proxy=$HTTPS_PROXY

RUN apt-get update && apt-get install -y ca-certificates bash nano net-tools curl && rm -rf /var/lib/apt/lists/*
COPY --from=builder /build/bin/avalanche .
COPY ./network-config.json .

RUN /avalanche config update disable

CMD ["bash", "-c", "while true; do sleep 10; done"]