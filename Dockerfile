FROM quay.io/sporkmonger/secure-bootstrap
MAINTAINER Bob Aman <bob@sporkmonger.com>

# Make sure liveness probes can operate on DNS
RUN apk add --update curl bind-tools && rm -rf /var/cache/apk/*

RUN mkdir -p /opt/bin && mkdir -p /opt/kubernetes/manifests

ENV VERSION=v0.16.2 \
  BIN_DIR=bin/linux/amd64

RUN curl -# -L -o /opt/bin/kubelet "https://storage.googleapis.com/kubernetes-release/release/$VERSION/bin/linux/amd64/kubelet" && \
  chmod +x /opt/bin/kubelet

CMD [ "/opt/bin/kubelet" ]
