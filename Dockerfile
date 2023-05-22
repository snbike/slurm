# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN go build -o /go/bin/app.bin cmd/main.go


# Final stage
FROM scratch
# Copy the Go binary from the build stage
COPY --from=build /app/myapp /
# Set the entrypoint for the container
ENTRYPOINT ["/myapp"]