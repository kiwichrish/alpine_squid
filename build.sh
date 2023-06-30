#!/bin/bash

# quick'n'dirty build script for the container, nothing flash

echo "Pulling current alpine"
echo "==================================================="
docker pull alpine:latest
echo "==================================================="
echo "Building"
echo "==================================================="
docker build -t kiwichrish/alpine_squid:latest .
