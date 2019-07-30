#!/bin/sh

TREXVERSION=2.59

if [ ! -f ./v${TREXVERSION}.tar.gz ]; then
  curl -LOJf https://trex-tgn.cisco.com/trex/release/v${TREXVERSION}.tar.gz
fi

docker build . -t codilimecom/trex:v${TREXVERSION} --build-arg TREXVERSION=${TREXVERSION}
docker tag codilimecom/trex:v${TREXVERSION} codilimecom/trex:latest

docker push codilimecom/trex:v${TREXVERSION} && \
  docker push codilimecom/trex:latest

