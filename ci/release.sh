#!/usr/bin/env bash
change release "$(pubver bump "$1")" -l "https://github.com/f3ath/maybe-just-nothing/compare/%from%...%to%"