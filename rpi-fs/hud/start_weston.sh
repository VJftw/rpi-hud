#!/bin/bash

echo $XDG_CONFIG_HOME
echo $XCURSOR_SIZE

sleep 5;

weston & midori -e Fullscreen -a http://localhost
