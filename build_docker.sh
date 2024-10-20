#!/bin/bash
IMAGE_TAG="gebing1121/zerotier-pylon:latest"
cd "$(dirname "$0")" || exit 1
echo "[INFO] Logining to docker hub..."
docker login -u gebing1121
if [ $? -ne 0 ]; then echo "[ERROR] Logining to docker hub failed!"; exit 1; fi
echo "[INFO] Building and pushing '$IMAGE_TAG'..."
docker buildx build --push --platform "linux/amd64,linux/arm64" -t "$IMAGE_TAG" . -f Dockerfile --force-rm --pull
docker image rm "$IMAGE_TAG" > /dev/null 2>&1
if [ $? -ne 0 ]; then echo "[ERROR] Building and pushing '$IMAGE_TAG' failed!"; exit 2; fi
echo "[INFO] Building and pushing '$IMAGE_TAG' success."
