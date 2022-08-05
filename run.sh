#!/bin/sh

# before running
# docker build -t image_optim .

docker run --rm -ti \
  -v $(cd && cd images && pwd):/images/ \
  -v $(pwd)/config:/root/.config/ \
  image_optim
