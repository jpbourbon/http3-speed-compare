# HTTP3 SPEED COMPARE #

A testbed framework to compare and collect data about perceived HTTP protocol speeds

### What is this repository for? ###

This repo aims to be the central point where the codebase for the testbed framework is stored to facilitate and make transparent the field work for the prossecution of a masters degree in the subject of Enterprise Information Science.


### How do I get set up? ###

To be able to compile the source code you need to install go > 1.12
There is a binary in the repo as well, may not require the install of the go packages but that is not tested.

To run uncompiled code: go run comparison.go
To run binary: ./comparison

At this moment the status of the code allows for a GET roundtrip between the microservices.

Start Microservices (D to A, run in parallel):
./comparison -http [1.1|2|3] -ms D -serv 8001
./comparison -http [1.1|2|3] -ms C -serv 8001 -conn 8002
./comparison -http [1.1|2|3] -ms B -serv 8000 -conn 8001
./comparison -http [1.1|2|3] -ms A -conn 8000

### Contribution guidelines ###

TODO

### Who do I talk to? ###

TODO
