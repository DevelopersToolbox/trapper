#!/usr/bin/env bash

# -------------------------------------------------------------------------------- #
# Description                                                                      #
# -------------------------------------------------------------------------------- #
# Ensure that trapper can correctly identify and locate errors in child scripts.   #
# -------------------------------------------------------------------------------- #

# shellcheck disable=SC1091
source ../../src/trapper.sh

list_files()
{
    ls /root/
}

list_files
