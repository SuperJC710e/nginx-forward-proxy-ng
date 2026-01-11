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
| `RESOLVER_IP`              | DNS resolver IP address                          | `1.1.1.1` |
| `RESOLVER_IPV6`            | Enable/disable IPv6 resolution                   | `off`     |
| `FORCE_CONFIG_GENERATION`  | Force config generation even if nginx.conf exists| `false`   |

**Configuration Precedence:**

1. If a custom `nginx.conf` file is mounted via volume, it will be used as-is (environment variables are ignored)
2. Set `FORCE_CONFIG_GENERATION=true` to override a mounted config and generate from template with environment variables
3. If no config file exists, one will be automatically generated from the template using environment variables

Example with custom resolver:

```shell
docker run --rm -d -p 3128:3128 \
  -e RESOLVER_IP=8.8.8.8 \
  -e RESOLVER_IPV6=on \
  ghcr.io/superjc710e/nginx-forward-proxy-ng:latest
```

Example with custom port:

```shell
docker run --rm -d -p 8080:8080 \
  -e PROXY_PORT=8080 \
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
      - RESOLVER_IP=8.8.8.8
      - RESOLVER_IPV6=off
    restart: always
```

Example with a local `nginx.conf` override file:

```yaml
name: nginx-forward-proxy
services:
  nginx-forward-proxy:
    ports:
      - 3128:3128
    image: ghcr.io/superjc710e/nginx-forward-proxy-ng:latest
    volumes:
      - ./config/nginx.conf:/usr/local/nginx/conf/nginx.conf
    restart: always
```

## See also

- [https://github.com/chobits/ngx_http_proxy_connect_module](https://github.com/chobits/ngx_http_proxy_connect_module)

## LICENSE

Apache 2.0
