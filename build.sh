#!/bin/bash

set -o errexit -o pipefail -o nounset

api=$INPUT_API
project=$INPUT_PROJECT
package=$INPUT_PACKAGE
username=$INPUT_USERNAME
password=$INPUT_PASSWORD
files=$INPUT_FILES
commit_message=$INPUT_COMMIT_MESSAGE

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
cd $GITHUB_WORKSPACE
cp -rvt "$HOME/$project/$package" $files
echo "::endgroup::"

echo "::group::Publishing to OBS"

cd $HOME/$project/$package
osc addremove
if [[ -z "$commit_message" ]]; then
  osc commit -m "OBS release: git#${GITHUB_SHA}"
else
  osc commit -m "$commit_message"
fi
echo "::endgroup::"
