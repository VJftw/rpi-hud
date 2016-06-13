#!/bin/bash

export $XDG_CONFIG_HOME=/hud/weston.ini

weston & midori -e Fullscreen -a http://localhost
