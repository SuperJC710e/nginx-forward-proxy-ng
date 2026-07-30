#@# vim: set ft=dockerfile ts=2 sw=2 sts=2 et:
# -----------------------------------------------------------------------------
# Dockerfile for nginx with proxy_connect module

# Global ARGs (available to all stages)
ARG ALPINE_VERSION=3.24
ARG NGINX_VERSION=1.31.3

# Stage 1: Build Environment
FROM alpine:${ALPINE_VERSION} AS builder

# ARGs need to be redeclared after FROM to be available in this stage
ARG NGINX_VERSION
LABEL maintainer="Takahiro INOUE <github.com/hinata>"
LABEL maintainer="Jason Clark <gihub.com/SuperJC710e>"

# Install build dependencies
WORKDIR /tmp

RUN apk update && \
    apk --no-cache add \
      alpine-sdk \
      curl \
      git \
      openssl-dev \
      pcre-dev \
      zlib-dev

# Download and compile Nginx with proxy connect module
RUN curl -LSs http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O && \
    tar xf nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    ./configure \
      --add-module=./ngx_http_proxy_connect_module \
      --sbin-path=/usr/sbin/nginx \
      --prefix=/usr/local/nginx && \
    make -j $(nproc) && \
    make install

# Stage 2: Final Runtime Image
FROM alpine:${ALPINE_VERSION}

LABEL maintainer="Takahiro INOUE <github.com/hinata>"
LABEL maintainer="Jason Clark <gihub.com/SuperJC710e>"

# Install only runtime dependencies (including gettext for envsubst)
RUN apk update && \
    apk --no-cache add \
      pcre \
      openssl \
      zlib \
      gettext

# Copy built Nginx and required files from builder stage
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY --from=builder /usr/local/nginx /usr/local/nginx

# Add default configuration, template and entrypoint
COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf
COPY ./nginx.conf.template /usr/local/nginx/conf/nginx.conf.template
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /

EXPOSE 3128

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "nginx", "-g", "daemon off;" ]
