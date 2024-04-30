#!/bin/sh

test -n "$DISABLE_DOCKERD" && return 1

dockerd ${DOCKERD_OPT}