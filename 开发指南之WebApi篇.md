# 开发指南之 WebApi 篇

## 概述

**本文将对 2 个方面进行开发讲解和接口调用分别对`短链接WebApi` 和`长连接WebSocket`进行简要解说**
**开发必备技能 基本的 HTTP 原理 以及 HTPP 的<abbr >GET</abbr>和<abbr>POST</abbr>请求**

## 安装 WebAPi 测试插件

- 下载仓库中的 `WebAPi.json`接口文档和`Restlet Client - REST API Testing.crx`插件导入到 Chrome 浏览器中
- 插件布局如下:
  ![](https://camo.githubusercontent.com/bdc50dde4b93f5507b3d661aa4645fbcc5f67e14/68747470733a2f2f6674702e626d702e6f76682f696d67732f323031392f31302f396139626563386662653661666366652e706e67)

- 每个接口都有详细的参数说明 不要上来就问有没有 xxx 功能，能不能怎样 xxx，你想如何如何...请您搭建好食用后在提问补充。多发 issus 提问提 Bug

例子 🌰：以如何通过 WebApi 给好友发送消息为例

请求方式 HTTP POST<br>
POST 地址 `http://127.0.0.1:8888/v1/LuaApiCaller?qq=123456789&funcname=SendMsg&timeout=10`<br>
POST 数据 `{"toUser":1700487478,"sendToType":1,"sendMsgType":"TextMsg","content":"你好","groupid":0,"atUser":0,"replayInfo":null}`

其中 POST 地址 qq=为所操作的 QQ 号理解为框架登录的 QQ 机器人也可以
funcname=参数为 LuaAPi 函数名所有 APi 可在`WebPlugins`目录下`Api_LuaCaller.lua`查看 以及 WebApi 插件接口列表中查看

**新手 ⚠️ 不建议 ⚠️ 编辑`Api_LuaCaller.lua`此文件 此文件包含了 WebApi 所有的约定 改错就全废 当然你可以通过此文件查看插件中 LuaApi 的调用方式以及参数说明 🈲️ 文件名不可更改 文件内容已实现自动热重载**

POST 数据为 JSON 类型

```lua
--组建参数 table
toUser --欲发给的对象 群或 QQ 好友或私聊对象 整数型
sendToType --发送消息对象的类型 1 好友 2 群 3 私聊 整数型
sendMsgType -- 欲发送消息的类型 "TextMsg","JsonMsg","XmlMsg","ReplayMsg" ,"TeXiaoTextMsg","PicMsg","VoiceMsg","PhoneMsg" 文本型
groupid -- 发送私聊消息是 在此传入群 ID 其他情况为 0 整数型
content -- 发送的文本内容
atUser -- At 用户  传入用户的 QQ 号 其他情况为 0 整数类型 (不支持多人@)
replayInfo --回复类型数据结构
```

这样就完成了 通过 WebApi 给好友/群/私聊发送消息 更详细的字段介绍请看`WebApi插件列表`和 `Api_LuaCaller.lua`

## 通过 WebSocket 实现时时消息和相关事件接收

**这里来说说如何通过长连接 WebSocket 来对接 说 WebSocket 不如说 SocketIO、SocketIO 是对 Websocket 的进一步实现 实现了事件的监听以及 Ack 应答等机制 仓库中以给出 c#和 js 的相关源码**

**对接成功后你就可以实现自己的框架咯使用自己熟悉的语言开发 插件等 完全脱离 Lua(除非不想跨平台) 通过长连接收消息收事件 通过短链接 WebApi 调用功能 简直是饕餮盛宴 一个字 香! emm...**

c# 直接下载仓库中的源码到本地运行 ⚠️ 这个库也是我现改的 - -测试基本没什么问题

```C#
static void Main(string[] args)
{
    socket = new Client("http://127.0.0.1:8888/");//连接框架中的服务地址
    socket.Opened += SocketOpened;//绑定打开事件
    socket.Message += SocketMessage;//绑定消息事件
    socket.SocketConnectionClosed += SocketConnectionClosed;//绑定连接断开事件
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
    socket.On("OnGroupUserList", (fn) =>
    {
        Console.WriteLine("OnGroupUserList\n" + ((JSONMessage)fn).MessageText);
    });
    //获取群列表的回调事件
    socket.On("OnGroupList", (fn) =>
    {
        Console.WriteLine("OnGroupList\n" + ((JSONMessage)fn).MessageText);
    });
    //获取好友列表的回调事件
    socket.On("OnQQUserList", (fn) =>
    {
        Console.WriteLine("OnQQUserList\n" + ((JSONMessage)fn).MessageText);
    });
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
//释放连接等操作
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
```

**JS 的代码我就不贴出来了 emm 看仓库 食用**

**欢迎贡献你的 Code**
