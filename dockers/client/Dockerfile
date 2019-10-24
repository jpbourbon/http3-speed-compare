

FROM http-speed-base:latest

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

WORKDIR /go/src/bitbucket.org/jpbourbon/http3-speed-compare
COPY . .
RUN go get -d -v ./...
#COPY runHttpClient.sh /go/bin/
RUN CGO_ENABLED=0 GOOS=linux go build -installsuffix cgo -o comparison comparison.go

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
