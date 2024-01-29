#!/bin/bash
this_dir=$(dirname -- "$( readlink -f -- "$0"; )")

sudo kanata --cfg "$this_dir/spacefn.kbd"