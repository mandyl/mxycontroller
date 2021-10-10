FROM golang:1.17 AS build-env
LABEL maintainer="mxy"

ARG ENABLE_PROXY=false

RUN rm -rf /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

WORKDIR /build
COPY go.mod .
COPY go.sum .

RUN if [ "$ENABLE_PROXY" = "true" ] ; then go env -w GOPROXY=https://goproxy.cn,direct ; fi \
    && go mod download

COPY . .
RUN make build

FROM centos:centos7
LABEL maintainer="mxy"

WORKDIR /mxycontroller
RUN yum -y install ca-certificates libc6-compat \
    && update-ca-trust \
    && echo "hosts: files dns" > /etc/nsswitch.conf

COPY --from=build-env mxycontroller .

ENTRYPOINT ["/mxycontroller/mxycontroller", "--kubeconfig", "~/.kube/config"]
