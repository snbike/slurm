# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN go build -o /go/bin/app.bin cmd/main.go


# Final stage
FROM scratch
RUN echo 'simpleuser:x:1000:1000::/:' > /etc/passwd && \
    echo 'simpleuser:x:1000:' > /etc/group
WORKDIR /
COPY --from=build /go/src/app .
ENTRYPOINT ["/app"]
USER simpleuser
VOLUME ["/upload"]