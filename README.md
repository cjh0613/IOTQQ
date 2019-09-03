IOTQQ --为跨平台而生

### ⚠️使用协议⚠️
- **IOTQQ 不得用于包括且不限于~~赌博、色情、云盘、政治~~ 等网络违法违规服务，违者必究**
- **用户不得使用 IOTQQ 来进行批量业务，如：批量加群，加好友等。**
- **用户在使用本软件过程中，应遵守当地法律法规与深圳市腾讯计算机系统有限公司用户协议中相关行为规范，且用户不能使用本软件进行以下行为，包括但不限于：广告传播、黑产、黄、赌、毒、PC蛋蛋、北京赛车、黑色产业、灰色产业、算账下注、群发、批量加群等任何违法犯罪或与犯罪相关，用户使用本软件进行相关违法犯罪的行为，均应由用户自行承担，IOTQQ不对用户的任何言行与行为承担任何责任**
- **免责声明：IOTQQ软件是一款基于QQ协议的AI机器人软件，主要用于活跃QQ群气氛、管理群、群内娱乐活动等，协议版权归属于深圳市腾讯计算机系统有限公司所有，请联系邮箱(1700487478@qq.com)，将会对软件下架并删除相关内容。**

### 🆕树莓派运行展示🆕
- **[芝麻开门 VNC](http://101.71.139.30:43288/vnc.html) 密码12345678**

------------

|  IOTQQ功能 | Free  ⬆️              |
| ------------- | ------------------------------ |
| `好友消息 收发语音文字图文XML/JSON`| ✅     |
| `群组消息 收发语音文字图文XML/JSON`   |  ✅    |
| `私聊消息 收发语音文字图文XML/JSON`   |  ✅    |
| `Open RedBag`   | ✅    |
| `Send  RedBag`   |   ❌    |
| `QQ空间发图文`  |  ❌      |
| `群 邀请/踢人/加群`    |  ✅   |
| `好友 通过/拒绝/加人`    |  ✅     |
| `账号 登陆`    |   ❌ |
| `多账号 登陆`    |  ❌   |

**项目介绍**

*⚠️运行项目的必要条件 需要外网IP用来接收GitHub的WebHook通知 非外网用户可以借助转发工具来解决 如*
>frp

>ngrok

- **🆓**
- **🌞采用独特的插件机制 --Lua**
- **🌞提供WebSocket （SocketIO）**
- **🌞提供Web API**
- **🌞内置协程池 高效 稳定 迸发**
- **🌞完成了大部分核心接口 其他必要接口将后续更新 可在[issues](https://github.com/IOTQQ/IOTQQ/issues)中提出 bug or todo**
- **不断电稳定运行 0 崩 错误日志将会在log中体现**

#### 💗开启运行之旅

------------
```go
fmt.Println("Github Token 会用来创建通知仓库 如果不放心使用 请建立小号 初始化所有操作记得清空Bot-Notify 仓库")
```

**1⃣️下载对应平台版本的二进制包** 

**2⃣️申请GitHub Token 用于GitHubApi访问 默认限制每小时60次请求 有了Token可以5000/h
 申请流程登陆GitHub后->settings-> Developer settings->Developer settings->Generate New Token
 开启全部Token权限!**
 
**3⃣️填写配置文件CoreConf.conf**


       #默认使用本地配置文件 暂时不支持集群模式
      EnabledEtcd = false
        [Etcd]
          Nodes = ["", "", ""]
        [GithubConf]
        #必填 GitHub申请回来的Token
          Token = ""
          FullName = ""
          IssuesNum = 1
         #必填 域名端口替换成外网的IP:PORT 
          WebHookUrl = "http://xxxx.com:8080/v1/Github/WebHook"
          BitFlag = 0
          BitCtrl = 0
          CommentID = 0


    

**4⃣️运行程序 执行命令 `./IOTQQ 运行websocket/webapi 服务端口号 如:  ./IOTQQ 8080`**

**5⃣️一切准备就绪 当你外网服务器IP:PORT 或(内网用户)经过转发OK时 在打开浏览器访问WebHookUrl 浏览器返回OK则可以进行下一步 不通请检查防火墙 or 转发配置**

------------


#### ❤️初始化服务

- **服务运行成功后访问URL http://IP:PORT/v1/Github/InstallService 初始化成功后控制台会提示 `Auth初始化完成` 若未提示 重复上述操作 初始化完成后就可以 🌊了**

- **获取登陆二维码 访问Url http://IP:PORT/v1/Login/GetQRCOde 扫码登陆即可**

------------


### 🆒Lua相关API

###### WebPlugin APi
- 请勿修改 WebPlugins目录下的任意文件名以及文件内容的函数名 否则部分WebAP接口会失效
例如 `Api_AddFriend.lua` 文件内容 可修改代码逻辑

```lua
local log = require("log")
local api = require("coreApi")
function Api_AddFriend(CurrentQQ, data)
  --Coding start
    luaRes = api.api_GetUserAddFriendSetting(CurrentQQ, data.AddUserUid, data.Content)
    log.notice("From Lua api_GetUserAddFriendSetting Ret\n%d", luaRes.AddType)
    luaRes.Content = data.Content
    --来源2011 空间2020 QQ搜索 2004群组 2005讨论组
    luaRes.AddFromSource = data.AddFromSource
    luaRes.FromGroupID = data.FromGroupID
    api.api_AddFriend(CurrentQQ, luaRes)
    return luaRes
  --Coding end
  
end
```
###### Plugin APi
- 插件命名不受限制 xxx.lua 但是必须实现以下函数 

```lua
--收到好友/私聊消息触发该函数
function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
--收到群消息触发该函数
function ReceiveGroupMsg(CurrentQQ, data)
    return 1
end
--收到好友相关事件触发该函数
function ReceiveFriendEvents(CurrentQQ, data, extData)
    return 1
end
--收到群相关事件触发该函数
function ReceiveGroupEvents(CurrentQQ, data, extData)
    return 1
end

```
- 相关APi用法请查阅Plugins目录下的相关文件调用例程 这里不再赘述

------------

###### WebSocket APi 

- **实现的功能比较少只做了几个 配合WebAPI 实现 webQQ 易如反掌**
- ** 给出部分js代码**

```javascript
<script>
    var User = localStorage.getItem('User');
   
    var socket = io("127.0.0.1:8888", {
      transports: ['websocket']
    });

    socket.on('connect',
    function() {
        //从缓存或从cookies 读取历史登陆的QQ号
        //链接成功后获取用户缓存 获取成功后直接同步消息 失败直接获取二维码
        //同一浏览器会置换当前的websocket id
    
      if (User == null){

      //获取二维码
      socket.emit('GetQrcode', '1234', (data) =>{
      console.log(data); // data will be 'woot'
      var JsonPkg = JSON.parse(data);
      $('#qrcode').attr("src", 'data:image/png;base64,' + JsonPkg.Data.BQrpic);

       });

      }else{

        socket.emit('GetWebConn', User, (data) =>{
        console.log(data);

        $('#qrcode').attr("src", 'http://q1.qlogo.cn/g?b=qq&nk=' + User + '&s=640');
      });

      }
     
    })
    socket.on('OnCheckLoginQrcode',
    function(data) {
      //48未扫描 53已扫码 17 49 过期了
      // if (data.Data.ScanStatus ==17 || data.Data.ScanStatus == 49){
      // }
        console.log(data);
    });

    socket.on('OnLoginSuccess',
    function(data) {

      // 移除所有
      localStorage.clear();
      console.log(data);

      $('#qrcode').attr("src", 'http://q1.qlogo.cn/g?b=qq&nk=' + data.Uin + '&s=640');
      localStorage.setItem('User', data.Uin);
      localStorage.setItem('Nick', data.Nick);

      //window.location = "/main.html";
    });

       //获取群成员列表
       socket.emit('GetTroopMemberList', JSON.stringify({"Uid":User+"","Group":654264644}));
       //  //绑定群成员返回数据事件
       socket.on('OnTroopMemberInfo',function(data){

        console.log(data); 

       });
       // //获取好友列表命令
       //  socket.emit('GetFriendList',User);
       //  //绑定好友返回数据事件
       // socket.on('OnFriendlistInfo',function(data){

       //  console.log(data); 

       // });

        //获取群列表命令 
        //socket.emit('GetTroopList', User);
        //绑定群列表返回数据事件
       socket.on('OnTroopListInfo',function(data){

        console.log(data); 

       });

        socket.on('OnGroupMsgs',function(data){
            console.log("收到群消息");
            console.log(data);

        });
        socket.on('OnFriendMsgs',function(data){
            console.log("收到好友消息");
            console.log(data);

        });

</script> 
```
###### Web APi


- **请导入仓库中的WebAPI.json到Chrome的Restlet Client - REST API Testing插件中**


- ![WEBAPI](https://camo.githubusercontent.com/7f14b2ca2de14d40fc2d127392eea3fa04c78788/68747470733a2f2f692e6c6f6c692e6e65742f323031392f30392f30322f634e596a48676d52366f6244324c462e706e67)


- **插件下载地址[Restlet Client](https://chrome.google.com/webstore/detail/aejoelaoggembcahagimdiliamlcdmfm "1")**

### Tips

- **😄登陆成功后在手机端回复电脑 systeminfo可查看相关收发包等信息**
- **😄访问URL :http://IP:PORT/v1/ClusterInfo 可以查询相关信息**
- **😄集群模式暂未开放**
- **😄多账号登陆需授权**

