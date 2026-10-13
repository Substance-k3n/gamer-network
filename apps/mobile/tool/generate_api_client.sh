#!/usr/bin/env bash
# Regenerates packages/api_client from packages/api-spec/openapi.json
# (docs/API.md "Wiring the Flutter app"). Run it whenever the spec changes
# on dev. Needs Java 11+ and Node (npx fetches the pinned generator).
set -euo pipefail
cd "$(dirname "$0")/.."
root=$(git rev-parse --show-toplevel)
out=packages/api_client

rm -rf "$out"
npx -y @openapitools/openapi-generator-cli@2.41.0 version-manager set 7.26.0 >/dev/null
npx -y @openapitools/openapi-generator-cli@2.41.0 generate \
  -i "$root/packages/api-spec/openapi.json" \
  -g dart-dio \
  -o "$out" \
  --additional-properties=pubName=api_client,pubVersion=0.0.0 \
  --global-property=apiTests=false,modelTests=false,apiDocs=false,modelDocs=false \
  >/dev/null
rm -f openapitools.json "$out/.travis.yml" "$out/git_push.sh"

(cd "$out" && dart pub get >/dev/null && dart run build_runner build --delete-conflicting-outputs >/dev/null && dart format lib >/dev/null)
echo "Generated $out from the spec."
