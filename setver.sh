#!/bin/sh
set -e

[ $1 ] || (echo "Usage: $0 version"; exit 1)

version=$1

npx semver ${version} || (echo "${version}: bad semver"; exit 1)

ex package.json <<++
    /"version":/s/: .*$/: "${version}",/
    w!
++

ex package-lock.json <<++
    3s/"version":.*,/"version": "${version}",/
    w!
++

ex lib/index.js <<++
    2s/ v.*/ v${version}/
    w!
++
