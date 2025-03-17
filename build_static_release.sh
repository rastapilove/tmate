#!/bin/bash
set -eux

# This is invoked by .travis.yml

VERSION="2.4.0"
PLATFORM="amd64"

RELEASE_NAME=tmate-$VERSION-static-linux-$PLATFORM
echo "Building $RELEASE_NAME"

docker build . --tag local-$PLATFORM/tmate-build --build-arg PLATFORM=$PLATFORM

mkdir -p releases
cd releases

rm -rf $RELEASE_NAME
mkdir -p $RELEASE_NAME
docker run --rm local-$PLATFORM/tmate-build cat /build/tmate > $RELEASE_NAME/tmate
chmod +x $RELEASE_NAME/tmate
tar -cf - $RELEASE_NAME | xz > tmate-$VERSION-static-linux-$PLATFORM.tar.xz

rm -rf $RELEASE_NAME-symbols
mkdir -p $RELEASE_NAME-symbols
docker run --rm local-$PLATFORM/tmate-build cat /build/tmate.symbols > $RELEASE_NAME-symbols/tmate.symbols
tar -cf - $RELEASE_NAME-symbols | xz > dbg-symbols-tmate-$VERSION-static-linux-$PLATFORM.tar.xz
