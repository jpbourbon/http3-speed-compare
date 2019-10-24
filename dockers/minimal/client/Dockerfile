#FROM alpine:latest
#FROM buildpack-deps:stretch-scm
FROM debian:stretch-slim

WORKDIR /home/debian/go/src/bitbucket.org/jpbourbon/http3-speed-compare
COPY . .
#RUN go get -d -v ./...
COPY runHttpClient.sh /go/bin/
COPY comparison /go/bin
COPY comparison .
#RUN CGO_ENABLED=0 GOOS=linux go build -installsuffix cgo -o comparison comparison.go

# variables with settings to customize application in runtime.
ENV HTTP_VERSION=3
ENV MS=A
ENV TS=B
ENV PORT=8000
ENV DBHOST=""
ENV DBPORT=3306
ENV DBUSER=root
ENV DBPASS=changeme
ENV DELAY=1
ENV S=1
ENV HOST=""

CMD ./runHttpClient.sh
