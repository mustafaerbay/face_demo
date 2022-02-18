FROM alpine:3.9
ARG VERSION
LABEL version="$VERSION"
MAINTAINER mustafaerbay365@gmail.com
COPY ops-test-app /app/
RUN adduser -D erbay &&\
    chown -R erbay:erbay /app/
USER erbay
CMD ["/app/ops-test-app"]