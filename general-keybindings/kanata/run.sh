#!/bin/bash
this_dir=$(dirname -- "$( readlink -f -- "$0"; )")

sudo /Users/ed/.cargo/bin/kanata --cfg "$this_dir/spacefn.kbd"
