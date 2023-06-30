#!/bin/sh
echo -ne '\033c\033]0;PSE\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Hallowscape" "$@"
