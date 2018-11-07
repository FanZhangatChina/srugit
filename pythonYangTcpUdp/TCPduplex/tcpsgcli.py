import socket #导入socket模
import threading #引入多线程

s=socket.socket(socket.AF_INET,socket.SOCK_STREAM) #建立一个TCP套接字
s.connect(("192.168.43.57",9999)) #利用connect（）方法主动初始化TCP服务器连接
true=True

def rec(s): #定义函数rec
    global true
    while true:
        t=s.recv(1024).decode("utf8")  #客户端也同理
        if t == "exit":
            true=False
        print(t)
trd=threading.Thread(target=rec,args=(s,))#将接收的函数（或方式）从主线程里抓出来丢到另一个线程里独自运行
trd.start()
while true:
    t=input()
    s.send(t.encode('utf8'))
    if t == "exit":
        true=False
s.close()