
''' Demo'''
import socketio

# standard Python
sio = socketio.Client()

# SocketIO Client
#sio = socketio.AsyncClient(logger=True, engineio_logger=True)

# ----------------------------------------------------- 
# Socketio
# ----------------------------------------------------- 

@sio.event
def connect():
    print('connected to server')
    sio.emit('GetWebConn','QQ号')#取得当前已经登录的QQ链接

@sio.on('OnGroupMsgs')
def OnGroupMsgs(message):
    ''' 监听群组消息'''
    print(message)

@sio.on('OnFriendMsgs')
def OnFriendMsgs(message):
    ''' 监听好友消息 '''
    print(message)
@sio.on('OnEvents')
def OnEvents(message):
    ''' 监听相关事件'''
    print(message)   
# ----------------------------------------------------- 
def main():
    sio.connect('http://192.168.199.147:8888',transports=['websocket'])

    sio.wait()
    # Cleanup
    sio.disconnect()

if __name__ == '__main__':
   main()