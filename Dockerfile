FROM node:23-alpine3.20

WORKDIR /app
COPY . /app

ARG UID
ARG GID
ARG PORT
ARG TARGETPLATFORM

ENV UID=${UID:-1010}
ENV GID=${GID:-1010}
ENV PORT=${PORT:-3000}

RUN if [ -n "$TARGETPLATFORM" ] && [ "$TARGETPLATFORM" != "linux/amd64" ]; then \
      apk add --no-cache qemu-aarch64-static; \
    fi

RUN addgroup -g ${GID} --system meting \
    && adduser -G meting --system -D -s /bin/sh -u ${UID} meting

RUN npm i

RUN chown -R meting:meting /app
USER meting

EXPOSE ${PORT}

CMD ["node", "/app/node.js"]
