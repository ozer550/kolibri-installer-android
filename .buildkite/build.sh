#! /bin/bash
set -euo pipefail

mkdir -p whl

echo "--- Downloading whl file"

# Allows for building directly from pipeline or trigger
if [[ $LE_TRIGGERED_FROM_BUILD_ID ]]
then
  echo "Downloading from triggered build"
  buildkite-agent artifact download 'dist/*.whl' . --build ${BUILDKITE_TRIGGERED_FROM_BUILD_ID}
  mv dist/* whl
else
  echo "Downloading from pip"
  pip download -d ./whl kolibri
fi

echo "--- :android: Build APK"
make run_docker

# TODO upload directly to google cloud