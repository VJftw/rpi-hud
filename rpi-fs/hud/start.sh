#!/bin/bash

# Wait for ready
curl -O https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
chmod +x wait-for-it.sh
echo ""
# ./wait-for-it.sh -t 300 0.0.0.0:8080 -- echo "=> API is up"

if [ -f /boot/xinitrc ]; then
    ln -s /boot/xinitrc /home/hudapp/.xinitrc;
	startx -- -nocursor &
fi

exit 0;
