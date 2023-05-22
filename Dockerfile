# Start by building the application.

# Базовый образ Alpine для создания non-root пользователя
FROM alpine:latest AS intermediate

# Создаем non-root пользователя и группу
RUN addgroup -S simplegroup && \
    adduser -S -G simplegroup simpleuser


# Базовый образ Go для сборки
FROM golang:1.19-alpine as build
WORKDIR /go/src/app
COPY . .
RUN go mod download
RUN go build -o /go/bin/app.bin cmd/main.go

# Final stage
FROM scratch
WORKDIR /
# Копируем бинарный файл из промежуточного образа
COPY --from=build /go/src/app .
# Копируем non-root пользователя и группу из промежуточного образа
COPY --from=intermediate /etc/passwd /etc/passwd
COPY --from=intermediate /etc/group /etc/group
# Устанавливаем точку входа и пользователя по умолчанию
ENTRYPOINT ["/app"]
USER simpleuser
#Монтируем папку upload
VOLUME ["/upload"]