#UDP全双工

from socket import * #引入socket的所有属性
import threading #引入多线程
from time import ctime #引入时间戳函数
 #ctime(change time):最近更改文件的时间，包括文件名、大小、内容、权限、属主、属组等。
def Recv(sock, BUFSIZE=1024):#定义函数Recv
    print('Recver is UP!')
    while True:
        try:
            data, addr = sock.recvfrom(BUFSIZE) #接受数据
        except OSError:
            break
        print('%s [%s]' % (addr[0], ctime()), data.decode())
#打印出接收的数据，数据地址，时间戳
def main(targetHost, targetPost=21567):#定义函数main
    HOST = ''
    POST = 21567
    BUFSIZ = 1024#设置地址以，端口号以及缓存区
    ADDR = (HOST, POST)#连接地址包括本机地址和端口号
    targetADDR = (targetHost, targetPost)#连接地址包括目标地址以及端口号
    UdpSock = socket(AF_INET, SOCK_DGRAM)#创建UDP套接字
    UdpSock.bind(ADDR)#绑定IP地址和端口号
    # 开启新线程，获取信息
    threadrev = threading.Thread(target=Recv, args=(UdpSock, BUFSIZ))
    threadrev.start()
    # 主线程开始传输信息~
    while True:
        data = input('')
        UdpSock.sendto(data.encode(), targetADDR)
        if not data:
            print('End of Chat')
            break
    UdpSock.close()
if __name__ == '__main__':
    IP = input('输入目标机器的IP地址: ')
    main(IP)