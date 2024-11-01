FROM golang:1.21-alpine AS build
RUN apk add --no-cache gcc musl-dev sqlite-dev  # Adiciona sqlite-dev para compilar com SQLite
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN go mod tidy
ENV CGO_ENABLED=1
RUN go build -o server .

FROM alpine:latest
RUN apk add --no-cache sqlite  # Instala o SQLite no estágio final
RUN mkdir /app
COPY ./static /app/static
COPY --from=build /app/server /app/
VOLUME [ "/app/dbdata", "/app/files" ]
WORKDIR /app
ENV WUZAPI_ADMIN_TOKEN SetToRandomAndSecureTokenForAdminTasks
CMD [ "/app/server", "-logtype", "json" ]
