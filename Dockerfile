# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN go build -o /go/bin/app.bin cmd/main.go

# Базовый образ Alpine для создания non-root пользователя
FROM alpine:latest AS intermediate
RUN addgroup -S simplegroup && \
    adduser -S -G simplegroup simpleuser


# Final stage
FROM scratch
WORKDIR /
COPY --from=build /go/src/app .

COPY --from=intermediate /etc/passwd /etc/passwd
COPY --from=intermediate /etc/group /etc/group
RUN mkdir /home/simpleuser && \
    chown -R simpleuser:simplegroup /home/simpleuser

ENTRYPOINT ["/app"]

USER simpleuser

VOLUME ["/upload"]