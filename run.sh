#!/usr/bin/env bash

# Run re container in docker.
# Store your .radare2rc, .vimrc, etc in a ./rc directory. The contents will be copied to
# /root/ in the container.

if [[ -z ${1} ]]; then
    echo -e "Missing argument container name."
    exit 0
fi

container_name=${1}

# Create docker container and run in the background
# Add this if you need to modify anything in /proc:  --privileged 
docker run -it \
    -h ${container_name} \
    -d \
    --security-opt seccomp:unconfined \
    --name ${container_name} \
    maravedi/re

# Tar config files in rc and extract it into the container
if [[ -d rc ]]; then
    cd rc
    if [[ -f rc.tar ]]; then
        rm -f rc.tar
    fi
    for i in .*; do
        if [[ ! ${i} == "." && ! ${i} == ".." ]]; then
            tar rf rc.tar ${i}
        fi
    done
    cd - > /dev/null 2>&1
    cat rc/rc.tar | docker cp - ${container_name}:/root/
    rm -f rc/rc.tar
else
    echo -e "No rc directory found. Nothing to copy to container."
fi

# Create stop/rm script for container
cat << EOF > ${container_name}-stop.sh
#!/bin/bash
docker stop ${container_name}
docker rm ${container_name}
rm -f ${container_name}-stop.sh
EOF
chmod 755 ${container_name}-stop.sh

# Create a workdir for this CTF
docker exec ${container_name} mkdir /root/work

# Get a shell
docker attach ${container_name}
