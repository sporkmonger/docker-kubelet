FROM quay.io/sporkmonger/go
MAINTAINER Bob Aman <bob@sporkmonger.com>

# Make sure liveness probes can operate on DNS,
# supply curl for more advanced HTTP probes,
# and make rsync available for the Kubernetes build script
RUN apk add --update curl rsync bind-tools && rm -rf /var/cache/apk/*

RUN mkdir -p /opt/bin && mkdir -p /opt/kubernetes/manifests

ENV VERSION=v0.16.2

RUN go get -d github.com/GoogleCloudPlatform/kubernetes && \
  cd /go/src/github.com/GoogleCloudPlatform/kubernetes && \
  git checkout $VERSION && \
  ./hack/build-go.sh cmd/kubelet && \
  cp -p ./_output/local/bin/linux/amd64/kubelet /opt/bin/kubelet && \
  rm -rf ./_output && \
  cd -

CMD [ "/opt/bin/kubelet" ]
