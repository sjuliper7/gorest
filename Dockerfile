FROM golang:1.16-alpine AS builder

RUN apk update && apk upgrade && \
    apk --no-cache --update add bash git make gcc g++ libc-dev

WORKDIR /go/src/github.com/gorest

COPY . .
RUN go mod vendor -v && go build -o engine main.go


FROM alpine:latest

RUN apk add ca-certificates && mkdir /app

WORKDIR /gorest

EXPOSE 5000

COPY --from=builder /go/src/github.com/gorest/engine /app
RUN ls -lh

CMD /app/engine