from socket import *
from time import ctime

host = '' #监听所有的ip
#port = 13141 #接口必须一致
port = 4097
bufsize = 1024
addr = (host,port)

udpServer = socket(AF_INET,SOCK_DGRAM)
udpServer.bind(addr) #开始监听

while True:
    print('Waiting for connection...')
    data,addr = udpServer.recvfrom(bufsize)  #接收数据和返回地址
    #处理数据
    data  = data.decode(encoding='utf-8').upper()
    #data = "at %s :%s"%(ctime(),data)
    udpServer.sendto(data.encode(encoding='utf-8'),addr)
    #发送数据
    print(data,'...recevied from and return to :',addr)

udpServer.close()
