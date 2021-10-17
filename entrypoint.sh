#!/bin/sh -l

set -o errexit -o pipefail -o nounset

echo '::group::Creating builder user'
useradd --create-home --shell /bin/bash builder
passwd --delete builder
echo '::endgroup::'

exec runuser builder --command 'bash -l -c /build.sh'
