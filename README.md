# nginx-forward-proxy

This is an updated version of the original from [https://github.com/hinata/nginx-forward-proxy](https://github.com/hinata/nginx-forward-proxy).

Changes:

- Update Alpine base version
- Updated nginx base version
- Split container build into a multi-stage build to reduce final size

## What is this?

The 'nginx-foward-proxy' is a simple HTTP proxy server using nginx.  
You can easily build a HTTP proxy server using this.

## Try this container

### Requirement packages

- Docker

### How to use

```shell
$ docker run --rm -d -p 3128:3128 ghcr.io/superjc710e/nginx-forward-proxy-ng:latest
$ curl -x http://127.0.0.1:3128 https://www.google.co.jp
```

- Docker Compose

Example with a local `nginx.conf` override file:

```yaml
name: nginx-forward-proxy
services:
    nginx-forward-proxy:
        ports:
            - 3128:3128
        image: nginx-forward-proxy:latest
        volumes:
          - ./config/nginx.conf:/usr/local/nginx/conf/nginx.conf
        restart: always
```

## See also

- https://github.com/chobits/ngx_http_proxy_connect_module

## LICENSE

Apache 2.0
