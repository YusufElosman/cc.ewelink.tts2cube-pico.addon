#!/bin/bash
build_version=$(cat ./version)
rm -f packages/web/.env
echo VITE_VERSION=$build_version > packages/web/.env

rm -rf build && mkdir build

npx lerna run build

cp -r packages/server/dist build/server

cp -r packages/web/dist build/public

cp docker/Dockerfile build
cp docker/publish.sh build
cp docker/.dockerignore build
cp version build

cat << EOF > ./build/buildinfo
Build Version: $build_version
Build Date: $(date '+%F %T')
EOF