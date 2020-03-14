#!/bin/sh

docker run --rm -it \
	-v /etc/passwd:/etc/passwd:ro \
	-v /etc/group:/etc/group:ro \
	-v /etc/shadow:/etc/shadow:ro \
	-v $(pwd):$HOME \
	-w $HOME \
	-u $(id -u):$(id -g) \
	zephyr
