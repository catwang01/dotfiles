#!/bin/bash

set -uo pipefail;

function log() {
  local date_format="${BASHLOG_DATE_FORMAT:-+%F %T}";
  local date="$(date "${date_format}")";

  args=("${@:2}");

  echo "[$date] $args"
}