#UDP单工
'''客户端'''
#!/usr/bin/env python
import socket #导入socket模
addr=('192.168.43.57',2345) #确定服务器端IP地址以及端口号
s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM) #建立一个UDP套接字
while True:
    data=input()
    if not data:
        break
    s.sendto(data.encode('utf8'),addr) #发送数据
s.close()