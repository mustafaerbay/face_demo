##
## Build
##
FROM golang:1.17-alpine as build
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build ./cmd/ops-test-app -o /ops-test-app

##
## Deploy
##
FROM alpine:3.9

ARG VERSION
LABEL version="$VERSION"
MAINTAINER mustafaerbay365@gmail.com

WORKDIR /
COPY --from=build /ops-test-app /app/ops-test-app
RUN adduser -D erbay &&\
    chown -R erbay:erbay /app/
USER erbay
CMD ["/app/ops-test-app"]