#!/bin/bash

docker build -t gypark/tcp_server:1.0 -f Dockerfile_server .
docker push gypark/tcp_server:1.0

docker build -t gypark/tcp_client:1.0 -f Dockerfile_client .
docker push gypark/tcp_client:1.0

