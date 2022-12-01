#!/bin/bash

port=3390

# Read configuration file ~/.config/cloudflare-tunnel-rdp/config.conf

source ~/.config/cloudflare-tunnel-rdp/config.conf

# check if url is set

if [ -z "$url" ]; then
    echo "url is not set"
    exit 1
fi

# Read hosts in ~/.config/cloudflare-tunnel-rdp/hosts/*

index=0
hosts=()

for host in ~/.config/cloudflare-tunnel-rdp/hosts/*
do
    # source configuration file
    source $host
    # check if host is defined
    if [ -z "$hostname" ]; then
        echo "Host is not defined in $host"
        exit 1
    fi

    # check if name is defined
    if [ -z "$name" ]; then
        echo "Name is not defined in $host"
        exit 1
    fi

    # print hostname and name, with index
    echo "Host $index: $name ($hostname)"
    # add host to array
    hosts+=($host)
    # increment index
    index=$((index+1))

    # reset hostname and name
    unset hostname
    unset name
done

# ask user to select host
echo ""
echo "Select host:"
read host

# source configuration file
source ${hosts[$host]}

# decide port
# while port is occupied, increment port
while lsof -Pi :$port -sTCP:LISTEN -t >/dev/null; do
    port=$((port+1))
done

cloudflared access rdp --hostname $hostname --url localhost:$port
