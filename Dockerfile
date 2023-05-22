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
ENTRYPOINT ["/app"]

RUN printf "simpleuser:x:1000:1000:,,,:/home/simpleuser:/bin/sh\n" > /etc/passwd && \
    printf "simpleuser:x:1000:\n" > /etc/group && \
    mkdir /home/simpleuser && \
    chown -R 1000:1000 /home/simpleuser
WORKDIR /home/simpleuser
USER simpleuser

VOLUME ["/upload"]