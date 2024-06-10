FROM amazoncorretto:8-alpine3.12-full
RUN apk update && apk add procps libc6-compat bash
COPY commands.sh /app/commands.sh
WORKDIR /app
ENTRYPOINT ["bash", "/app/commands.sh"]