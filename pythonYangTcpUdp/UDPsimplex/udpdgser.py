#UDP单工
'''服务器'''
#!/usr/bin/env python
import socket  #导入socket模
address=('192.168.1.103',2345) #设置服务器端IP地址以及端口号
s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM) #创建UDP套接字
s.bind(address) #绑定地址与端口号
while True:
    data, addr = s.recvfrom(2048) #接受数据
    if not data:
        break
    print("got data from", addr)
    print( data.decode())
s.close()