#!/bin/bash

set -o errexit -o pipefail -o nounset

api=$INPUT_API
project=$INPUT_PROJECT
package=$INPUT_PACKAGE
username=$INPUT_USERNAME
password=$INPUT_PASSWORD
files=$INPUT_FILES

assert_non_empty() {
  name=$1
  value=$2
  if [[ -z "$value" ]]; then
    echo "::error::Invalid Value: $name is empty." >&2
    exit 1
  fi
}

assert_non_empty inputs.project "$project"
assert_non_empty inputs.package "$package"
assert_non_empty inputs.username "$username"
assert_non_empty inputs.password "$password"
assert_non_empty inputs.files "$files"

export HOME=/home/builder

echo "::group::Intializing .oscrc"
cat > $HOME/.oscrc <<EOF
[general]
apiurl=$api

[$api]
user = $username
pass = $password
EOF
echo "::endgroup::"

echo "::group::Checkouting package"
cd $HOME
osc checkout $project $package
echo "::endgroup::"

echo "::group::Copying files into $project/$package"
cp -rt "$project/$package" $files
echo "::endgroup::"

echo "::group::Publishing to OBS"
cd $project/$package
osc addremove
osc commit -m "OBS release: git#${GITHUB_SHA}"
echo "::endgroup::"
