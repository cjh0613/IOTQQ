using SocketIOClient;
using SocketIOClient.Messages;
using System;


namespace TestProject
{
    class Program
    {
        public static Client socket;

        static void Main(string[] args)
        {

            socket = new Client("http://127.0.0.1:8888/");
            socket.Opened += SocketOpened;
            socket.Message += SocketMessage;
            socket.SocketConnectionClosed += SocketConnectionClosed;
            socket.Error += SocketError;

            socket.Connect();
            string QQ = "123456789";//框架在线的QQ号
            // register for 'connect' event with io server
            socket.On("connect", (fn) =>
            {
                Console.WriteLine(((ConnectMessage)fn).ConnectMsg);
                //重连成功 取得 在线QQ的websocket 链接connid
                //Ack
                socket.Emit("GetWebConn", QQ, null, (callback) =>
                {
                    var jsonMsg = callback as string;
                    Console.WriteLine(string.Format("callback [root].[messageAck]: {0} \r\n", jsonMsg));
                }
                 );
                //获取已登录QQ的群列表
                //socket.Emit("GetGroupList", QQ);

                //获取已登录QQ的好友列表
                //socket.Emit("GetQQUserList", QQ);
                //获取已登录QQ的群123456789成员列表
                // 
                //string JSON = "{" + string.Format("\"Uid\":\"{0}\",\"Group\":{1}", QQ, 123456789) + "}";
                //socket.Emit("GetGroupUserList", JSON.Replace("\"", "\\\""));//json 需要处理一下转义

                //获取登录二维码
                socket.Emit("GetQrcode", "", null, (callback) =>
                {
                    var jsonMsg = callback as string;
                    Console.WriteLine(string.Format("GetQrcode From Websocket: {0} \r\n", jsonMsg));
                }
                   );



            });


            //二维码检测事件
            socket.On("OnCheckLoginQrcode", (fn) =>
            {
                Console.WriteLine("OnCheckLoginQrcode\n" + ((JSONMessage)fn).MessageText);
            });
            //收到群消息的回调事件
            socket.On("OnGroupMsgs", (fn) =>
              {
                  Console.WriteLine("OnGroupMsgs\n" + ((JSONMessage)fn).MessageText);
              });
            //收到好友消息的回调事件
            socket.On("OnFriendMsgs", (fn) =>
            {
                Console.WriteLine("OnFriendMsgs\n" + ((JSONMessage)fn).MessageText);
            });


            //获取群成员的回调事件
            // socket.On("OnGroupUserList", (fn) =>
            // {
            //     Console.WriteLine("OnGroupUserList\n" + ((JSONMessage)fn).MessageText);
            // });

            // //获取群列表的回调事件
            // socket.On("OnGroupList", (fn) =>
            // {
            //     Console.WriteLine("OnGroupList\n" + ((JSONMessage)fn).MessageText);
            // });
            // //获取好友列表的回调事件
            // socket.On("OnQQUserList", (fn) =>
            // {
            //     Console.WriteLine("OnQQUserList\n" + ((JSONMessage)fn).MessageText);
            // });
            //统一事件管理如好友进群事件 好友请求事件 退群等事件集合
            socket.On("OnEvents", (fn) =>
            {
                Console.WriteLine("OnEnevts\n" + ((JSONMessage)fn).MessageText);
            });

            // make the socket.io connection





            Console.ReadLine();
        }


        static void SocketOpened(object sender, EventArgs e)
        {
            Console.WriteLine("SocketOpened\r\n");

        }

        static void SocketError(object sender, ErrorEventArgs e)
        {
            Console.WriteLine("socket client error:");
            Console.WriteLine(e.Message);
        }

        static void SocketConnectionClosed(object sender, EventArgs e)
        {
            Console.WriteLine("WebSocketConnection was terminated!");
        }

        static void SocketMessage(object sender, MessageEventArgs e)
        {
            // uncomment to show any non-registered messages
            if (string.IsNullOrEmpty(e.Message.Event))
                Console.WriteLine("Generic SocketMessage: {0}", e.Message.MessageText);
            else
                Console.WriteLine("Generic SocketMessage: {0} : {1}", e.Message.Event, e.Message.Json.ToJsonString());
        }
        public static void Close()
        {
            if (socket != null)
            {
                socket.Opened -= SocketOpened;
                socket.Message -= SocketMessage;
                socket.SocketConnectionClosed -= SocketConnectionClosed;
                socket.Error -= SocketError;
                socket.Dispose(); // close & dispose of socket client
            }
        }
    }
}
