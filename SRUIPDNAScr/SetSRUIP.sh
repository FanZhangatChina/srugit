#!/bin/bash
./slow_control WIPLtoFlash.txt
echo WIPLtoFlash.txt
sleep 1
echo sleep 1
./slow_control WIPHtoFlash.txt
echo WIPHtoFlash.txt
sleep 1
echo sleep 1
./slow_control RIPfromFlash.txt
echo RIPfromFlash.txt
