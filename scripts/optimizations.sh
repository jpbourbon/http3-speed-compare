#!/bin/bash

_dev=$1

sysctl -w net.core.rmem_max=26214400
sysctl -w net.ipv4.conf.all.rp_filter=0
sysctl -w net.ipv4.conf.all.accept_local=1
sysctl -w net.ipv4.udp_rmem_min=131072
sysctl -w net.ipv4.udp_wmem_min=131072
ip link set dev $_dev mtu 9000
ip link set dev $_dev txqueuelen 10000

ifconfig $_dev
sysctl -a | grep mem_
