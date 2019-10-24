#!/bin/bash
_oper=$1
_dev=$2

if [ $_oper == "add" ] 
then
tc qdisc add dev $_dev root handle 1:0 netem delay 50ms 20ms distribution normal
#tc qdisc add dev $_dev root netem loss 1%
tc qdisc add dev $_dev parent 1:1 handle 10: netem loss 1%
fi

if [ $_oper == "del" ]
then
tc qdisc del dev $_dev root handle 1:0 netem delay 50ms 20ms distribution normal
#tc qdisc del dev $_dev root netem loss 1%
tc qdisc del dev $_dev parent 1:1 handle 10: netem loss 1%
fi

