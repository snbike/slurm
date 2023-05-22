# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN go build -o /go/bin/app.bin cmd/main.go


# Final stage
FROM scratch
WORKDIR /
COPY --from=build /go/src/app .

RUN printf "user:x:1000:1000:,,,:/home/user:/bin/sh\n" > /etc/passwd && \
    printf "user:x:1000:\n" > /etc/group && \
    mkdir /home/user && \
    chown -R 1000:1000 /home/user
USER user

ENTRYPOINT ["/app"]
VOLUME ["/upload"]