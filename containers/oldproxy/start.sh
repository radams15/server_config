#!/bin/bash

#podman build -f Dockerfile -t oldssl-proxy

podman run -p 3128:3128 -p 3180:3180 -v ./oldproxy-certs:/etc/squid/ssl_cert:z valdikss/oldssl-proxy
