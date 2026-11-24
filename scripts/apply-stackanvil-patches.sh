#!/usr/bin/env bash
# Applies patches/<name>/*.patch to the nested submodule each directory names.
# Run it after a recursive checkout and before building natives. It skips patches
# that are already applied and fails on any patch that no longer fits.
set -euo pipefail
cd "$(dirname "$0")/.."
# A Windows path on Git Bash, where git.exe does not read MSYS paths
root=$(pwd -W 2>/dev/null || pwd)

# <patch directory>:<submodule path>, kept bash 3 compatible for macOS runners
for entry in libjuice:jni/libdatachannel/deps/libjuice; do
  name=${entry%%:*}
  dir=${entry#*:}
  for patch in patches/"$name"/*.patch; do
    [ -e "$patch" ] || continue
    if git -C "$dir" apply --reverse --check "$root/$patch" 2>/dev/null; then
      echo "Already applied: $patch"
    else
      git -C "$dir" apply "$root/$patch"
      echo "Applied: $patch"
    fi
  done
done
