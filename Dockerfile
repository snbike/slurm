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
RUN echo 'simpleuser:x:1000:1000::/:' > /etc/passwd
RUN echo 'simpleuser:x:1000:' > /etc/group
RUN mkdir /app && chown -R simpleuser:simpleuser /app
USER simpleuser
COPY app /go/src/app
ENTRYPOINT ["/app"]
VOLUME ["/upload"]