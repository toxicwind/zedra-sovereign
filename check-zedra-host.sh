#!/usr/bin/env bash
export PATH="$HOME/.cargo/bin:$PATH"
cd /home/toxic/projects/zedra-tanlethanh || exit 1
cargo check -p zedra-host > /tmp/zedra-check.log 2>&1
echo "EXIT=$?" >> /tmp/zedra-check.log
