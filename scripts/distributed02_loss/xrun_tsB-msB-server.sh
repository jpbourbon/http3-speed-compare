#!/bin/bash
http=$1
s=$2
sDIR=$3
hB=$4
#echo "running comparison with parms=$http, $s at folder $sDIR"
cd $sDIR
#cur=`pwd`
#echo "at folder $cur"
$sDIR/comparison -http $http -ms B -serv 8000 -ts B -s $s -nameserv msb.jpbourbon-httpspeed.io -host msb.jpbourbon-httpspeed.io -ipserv $hB
