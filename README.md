# nginx-forward-proxy

This is an updated version of the original from [https://github.com/hinata/nginx-forward-proxy](https://github.com/hinata/nginx-forward-proxy).

Changes:

- Update Alpine base version
- Updated nginx base version
- Split container build into a multi-stage build to reduce final size

![Ngninx Forward Proxy Icon](./assets/nginx_forward_proxy_icon-003.svg "Nginx Forward Proxy Icon")

## What is this?

The 'nginx-foward-proxy' is a simple HTTP proxy server using nginx.  
You can easily build a HTTP proxy server using this.

## Try this container

### Requirement packages

- Docker

### How to use

```shell
docker run --rm -d -p 3128:3128 ghcr.io/superjc710e/nginx-forward-proxy-ng:latest
curl -x http://127.0.0.1:3128 https://www.google.co.jp
```

### Environment Variables

You can customize the proxy behavior using environment variables:

| Variable                   | Description                                      | Default   |
|----------------------------|--------------------------------------------------|-----------|
| `PROXY_PORT`               | Port for the proxy to listen on                  | `3128`    |
| `WORKER_PROCESSES`         | Number of nginx worker processes                 | `auto`    |
| `WORKER_CONNECTIONS`       | Maximum connections per worker                   | `1024`    |
| `RESOLVER`                 | DNS resolver IP address                          | `1.1.1.1` |
| `RESOLVER_IPV6`            | Enable/disable IPv6 resolution (`on`/`off`)      | `off`     |
| `RESOLVER_TIMEOUT`         | DNS resolver cache validity timeout              | `5s`      |
| `PROXY_CONNECT_TIMEOUT`    | Timeout for establishing proxy connections       | `60s`     |
| `PROXY_SEND_TIMEOUT`       | Timeout for sending to proxy                     | `60s`     |
| `PROXY_READ_TIMEOUT`       | Timeout for reading from proxy                   | `60s`     |
| `SEND_TIMEOUT`             | Timeout for sending to client                    | `60s`     |
| `CLIENT_BODY_TIMEOUT`      | Timeout for reading client request body          | `60s`     |
| `CLIENT_HEADER_TIMEOUT`    | Timeout for reading client request headers       | `60s`     |
| `KEEPALIVE_TIMEOUT`        | Keep-alive connection timeout                    | `65s`     |
| `FORCE_CONFIG_GENERATION`  | Force config generation even with mounted config | `false`   |

**Configuration Precedence:**

1. By default, nginx.conf is generated from the template using environment variables on every container start
2. To use a custom `nginx.conf` file, mount both the config file AND a marker file `.config_mounted`:

   ```yaml
   volumes:
     - ./config/nginx.conf:/usr/local/nginx/conf/nginx.conf
     - ./config/.config_mounted:/usr/local/nginx/conf/.config_mounted
   ```

3. Set `FORCE_CONFIG_GENERATION=true` to override a mounted config and regenerate from template with environment variables

Example with custom resolver:

```shell
docker run --rm -d -p 3128:3128 \
  -e RESOLVER=8.8.8.8 \
  -e RESOLVER_IPV6=on \
  ghcr.io/superjc710e/nginx-forward-proxy-ng:latest
```

Example with custom port and timeouts:

```shell
docker run --rm -d -p 8080:8080 \
  -e PROXY_PORT=8080 \
  -e PROXY_CONNECT_TIMEOUT=120s \
  -e PROXY_READ_TIMEOUT=120s \
  ghcr.io/superjc710e/nginx-forward-proxy-ng:latest
```

### Docker Compose

Example with environment variables:

```yaml
name: nginx-forward-proxy
services:
  nginx-forward-proxy:
    ports:
      - 3128:3128
    image: ghcr.io/superjc710e/nginx-forward-proxy-ng:latest
    environment:
      - PROXY_PORT=3128
      - WORKER_PROCESSES=auto
      - WORKER_CONNECTIONS=1024
      - RESOLVER=8.8.8.8
      - RESOLVER_IPV6=off
      - RESOLVER_TIMEOUT=5s
      - PROXY_CONNECT_TIMEOUT=60s
      - PROXY_SEND_TIMEOUT=60s
      - PROXY_READ_TIMEOUT=60s
      - SEND_TIMEOUT=60s
      - CLIENT_BODY_TIMEOUT=60s
      - CLIENT_HEADER_TIMEOUT=60s
      - KEEPALIVE_TIMEOUT=65s
    restart: always
```

Example with a custom `nginx.conf` override file:

```yaml
name: nginx-forward-proxy
services:
  nginx-forward-proxy:
    ports:
      - 3128:3128
    image: ghcr.io/superjc710e/nginx-forward-proxy-ng:latest
    volumes:
      - ./config/nginx.conf:/usr/local/nginx/conf/nginx.conf
      - ./config/.config_mounted:/usr/local/nginx/conf/.config_mounted
    restart: always
```

## See also

- [https://github.com/chobits/ngx_http_proxy_connect_module](https://github.com/chobits/ngx_http_proxy_connect_module)

## LICENSE

Apache 2.0
