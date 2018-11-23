"""
author: Fan Zhang
created on : 2018-11-23
"""
from socket import *
from cmd_decoder import *


host  = '10.160.36.185' # 这是客户端的电脑的ip
#host  = '127.0.0.1' # 这是客户端的电脑的ip
#port = 13141 #接口选择大于10000的，避免冲突
port = 4097
bufsize = 1024  #定义缓冲大小

addr = (host,port) # 元祖形式
udpClient = socket(AF_INET,SOCK_DGRAM) #创建客户端

while True:
    cmd = input('>>> ')
    #data = 'abc'
    #no = input()
    data = cmd_decoder(40,1,0x2,0x0)
    #cmd_decoder(no,1,0x3,0x0)
    if not data:
        break
    #data = data.encode(encoding="utf-8")
    udpClient.sendto(data,addr) # 发送数据
    data,addr = udpClient.recvfrom(bufsize) #接收数据和返回地址
    #print(data.decode(encoding="utf-8"),'from',addr)
    print(data)

udpClient.close()
