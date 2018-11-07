import socket #导入socket模
import threading #引入多线程

s=socket.socket(socket.AF_INET,socket.SOCK_STREAM) #建立一个TCP套接字
s.bind(("127.1.1.101",9999)) #利用bind方法将地址与端口号绑定
s.listen(2) #设定至多可连接的客户端个数
sock,addr=s.accept() #利用accept方式可以用来接受客户端对于与服务端的连接请求
true=True #定义布尔类型
def rec(sock): #使用def方法定义函数rec
    global true #定义全局变量
    while true:
        t=sock.recv(1024).decode('utf8')  #函数的核心语句就一条接收方法（数据接收使用了utf8编码方式）
        if t == "exit":
            true=False
        print(t)
trd=threading.Thread(target=rec,args=(sock,)) #将消息的接受和发送分开来进行
#将接收的函数（或方式）从主线程里抓出来丢到另一个线程里独自运行
trd.start() #开启多线程
while true:
    t=input()
    sock.send(t.encode('utf8')) #数据的发送利用send方法
    if t == "exit":
        true=False
s.close()