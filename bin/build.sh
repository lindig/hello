#! /bin/sh

cat <<EOF
let git_revision = "$(git describe --always --long)"
let build_time = "$(date)"
EOF
