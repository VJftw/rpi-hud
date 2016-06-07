#!/bin/sh

echo ""
echo "===> Stopping and Removing Docker containers"
echo ""
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
echo ""
echo "===> Cleaning up extra images"
echo ""
docker rm -v $(docker ps -a -q -f status=exited)
docker rmi $(docker images -f "dangling=true" -q)

## Pull and Run smart-mirror orchestrate container
docker pull vjftw/smart-mirror
docker run -d -v /var/run/docker.sock:/var/run/docker.sock -v /smart-mirror:/smart-mirror -p 8081:8081 vjftw/smart-mirror

# Wait for ready
curl -O https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
chmod +x wait-for-it.sh
echo ""
./wait-for-it.sh -t 300 0.0.0.0:80 -- echo "=> Frontend is up"
./wait-for-it.sh -t 300 0.0.0.0:8080 -- echo "=> API is up"
./wait-for-it.sh -t 300 0.0.0.0:8081 -- echo "=> Ochestrate is up"

if [ -f /boot/xinitrc ]; then
	ln -fs /boot/xinitrc /home/hud_user/.xinitrc;
	su - hud_user -c 'startx -- -nocursor' &
fi

exit 0;
