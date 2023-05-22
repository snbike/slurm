# Start by building the application.
# Базовый образ Alpine для создания non-root пользователя
FROM alpine:latest AS intermediate

# Создаем non-root пользователя и группу
RUN addgroup -S simplegroup && \
    adduser -S -G simplegroup simpleuser


FROM golang:1.19-alpine as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN go build -o /go/bin/app.bin cmd/main.go

# Базовый образ Alpine для создания non-root пользователя

# Final stage
FROM scratch
WORKDIR /
COPY --from=build /go/src/app .

# Копируем non-root пользователя и группу из промежуточного образа
COPY --from=intermediate /etc/passwd /etc/passwd
COPY --from=intermediate /etc/group /etc/group

ENTRYPOINT ["/app"]

USER simpleuser

VOLUME ["/upload"]