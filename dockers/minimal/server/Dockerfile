#FROM alpine:latest
#FROM buildpack-deps:stretch-scm
FROM debian:stretch-slim

#ENV GOPATH /go
#ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

WORKDIR /home/debian/go/src/bitbucket.org/jpbourbon/http3-speed-compare
COPY . .
#RUN go get -d -v ./...
COPY runHttpServ.sh /go/bin/
COPY comparison /go/bin
COPY comparison .
#RUN CGO_ENABLED=0 GOOS=linux go build -installsuffix cgo -o comparison comparison.go

# variables with settings to customize application in runtime.
ENV HTTP_VERSION=3
ENV MS=B
ENV TS=B
ENV PORT=8000
ENV S=1
ENV SERVERNAME=""
ENV IPSERVER=""

CMD ./runHttpServ.sh
