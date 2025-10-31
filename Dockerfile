FROM node:24-bookworm AS builder

WORKDIR /data

COPY ./ /data

RUN corepack enable pnpm && \
    pnpm install && \
    pnpm run generate

FROM caddy:alpine
COPY --from=builder /data/.output/public /usr/share/caddy
COPY <<"EOT" /etc/caddy/Caddyfile
http:// {
    file_server
    root * /usr/share/caddy
    tls off
}
EOT
