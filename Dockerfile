FROM golang:1.12.4-alpine as builder

#TODO

FROM alpine:latest
RUN apk --no-cache add ca-certificates rsync openssh
WORKDIR /app

COPY --from=builder /app /app
ENTRYPOINT ["./run.sh", "start"]