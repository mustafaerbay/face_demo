FROM alpine:3.9
COPY ops-test-app /app/
RUN adduser -D player &&\
    chown -R player:player /app/
USER player
CMD ["/app/ops-test-app"]