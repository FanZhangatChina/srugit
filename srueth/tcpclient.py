
#!/usr/bin/env python3
#-*- coding:utf-8 -*-
# python3 udpclient.py 40 1 0x3 0x0

import sys
from socket import *
from cmd_decoder import *

# HOST ='localhost'
HOST ='10.160.36.185'

PORT = 1024

BUFFSIZE=1024

ADDR = (HOST,PORT)

tctimeClient = socket(AF_INET,SOCK_STREAM)

CardNo = int(sys.argv[1])
RW = int(sys.argv[2])

RegAddr_s = sys.argv[3]
if RegAddr_s[0:2] == '0x' :
    RegAddr = int(RegAddr_s,16)
else :
    RegAddr = int(RegAddr_s,10)

RegData_s = sys.argv[4]
if RegData_s[0:2] == '0x' :
    RegData = int(RegData_s,16)
else :
    RegData = int(RegData_s,10)

tctimeClient.connect(ADDR)

while True:
    switch = input('Enter start:')
    data = cmd_decoder(CardNo,RW, RegAddr,RegData)
    if not data:
        break
    tctimeClient.send(data)

    if RW == 1 :
        data = tctimeClient.recv(BUFFSIZE) 
        data_s = data.hex()
        print('Register addr is: 0x',data_s[0:8])
        print('Register data is: 0x',data_s[8:16])
    else:
        print('Register WRITE finished')

tctimeClient.close()
