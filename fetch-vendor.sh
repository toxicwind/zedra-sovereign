#!/usr/bin/env bash
export PATH="$HOME/.cargo/bin:$PATH"
set -e
ROOT=/home/toxic/projects/zedra-tanlethanh
cd "$ROOT"
if [ -d vendor/zed/.git ]; then
  echo "vendor/zed already present"
else
  git clone --branch feat/gpui-mobile https://github.com/tanlethanh/zed.git vendor/zed
fi
cd vendor/zed
git checkout d354031faf0f87742c9faff7d33bc75ab41d277e
echo "VENDOR_OK"
