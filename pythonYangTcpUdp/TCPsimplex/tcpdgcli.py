# tcp_client.py单工
'''客户端'''
from socket import *
from time import ctime

HOST = '192.168.1.101' #主机地址
PORT = 23345 #端口号
BUFSIZ = 2048 #缓存区大小，单位是字节，这里设定了2K的缓冲区
ADDR = (HOST, PORT) #链接地址

tcpCliSock = socket(AF_INET, SOCK_STREAM) #创建一个TCP套接字
tcpCliSock.connect(ADDR) #绑定地址
while True:
  msg = input('请输入:') #输入数据
  if not msg: break #如果 msg 为空，则跳出循环
  tcpCliSock.send(msg.encode())
  data = tcpCliSock.recv(BUFSIZ) #接收数据,BUFSIZ是缓存区大小
  if not data: break #如果data为空，则跳出循环
  print(data.decode())