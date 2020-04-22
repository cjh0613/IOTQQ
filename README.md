IOTBOT --为跨平台而生

**运行在Mac平台**

![MAC](https://camo.githubusercontent.com/77144e212578e053a1ad14f888d4d53191c578fa/68747470733a2f2f73322e617831782e636f6d2f323031392f30392f30342f6e5a376744782e706e67)

**运行在树莓派3B+ 1G RAM**

![树莓派](https://camo.githubusercontent.com/754ac0f4716f4b4088fd1ba87b8535f78a6b5ac1/68747470733a2f2f73312e617831782e636f6d2f323032302f30342f31312f47484658336e2e706e67)

**运行在电视盒子 N1**
![电视盒子](https://camo.githubusercontent.com/fa9594a6577f447bd97f33ac40ca2a824fe5dd6b/68747470733a2f2f73322e617831782e636f6d2f323031392f31302f30332f75304e7765502e706e67)
![电视盒子](https://camo.githubusercontent.com/32c5b864b035a04b094bf77de272b1fa6336434e/68747470733a2f2f73322e617831782e636f6d2f323031392f31302f30332f75304e4946552e706e67)

**运行在路由器HIWI-FI**

![路由器](https://camo.githubusercontent.com/139a303674c16c57c98e94fc729cd17094127214/68747470733a2f2f73322e617831782e636f6d2f323031392f31302f30332f75304e76544b2e6d642e706e67)

### ⚠️使用协议⚠️
- **IOTBOT 不得用于包括且不限于~~赌博、色情、云盘、政治~~ 等网络违法违规服务，违者必究**
- **用户不得使用 IOTBOT 来进行批量业务，如：批量加群，加好友等。**
- **用户在使用本软件过程中，应遵守当地法律法规与深圳市腾讯计算机系统有限公司用户协议中相关行为规范，且用户不能使用本软件进行以下行为，包括但不限于：广告传播、黑产、黄、赌、毒、PC蛋蛋、北京赛车、黑色产业、灰色产业、算账下注、群发、批量加群等任何违法犯罪或与犯罪相关，用户使用本软件进行相关违法犯罪的行为，均应由用户自行承担，IOTQQ不对用户的任何言行与行为承担任何责任**
- **免责声明：IOTBOT 软件是一款基于MacQQ协议的AI机器人软件，主要用于活跃QQ群气氛、管理群、群内娱乐活动等，协议版权归属于深圳市腾讯计算机系统有限公司所有， 如有侵权请联系邮箱(1700487478@qq.com)，将会对软件下架并删除相关内容。**

### 🆕树莓派运行展示🆕
- **[芝麻开门 VNC](http://161.117.255.15:43288/vnc.html) 密码12345678**

------------

|  IOTBOT 功能 | Free  ⬆️              |
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

* ⚠️ 授权登陆此网站换取Token [Gitter Developer](https://developer.gitter.im/apps)

- **🆓**
- **🌞采用独特的插件机制 --Lua**
- **🌞提供WebSocket （SocketIO）**
- **🌞提供Web API**
- **🌞内置协程池 高效 稳定 迸发**
- **🌞完成了大部分核心接口 其他必要接口将后续更新 可在[issues](https://github.com/IOTQQ/IOTQQ/issues)中提出 bug or todo**
- **不断电稳定运行 0 崩 错误日志将会在log中体现**

#### 💗开启运行之旅

------------

**1⃣️下载对应平台版本的二进制包 [传送门](https://gitter.im/IOTQQTalk/IOTQQ)**

**2⃣️申请Gitter Developer 可用GitHub 授权登陆Gitter Developer 网站 换取Token**

![](https://camo.githubusercontent.com/b00bfed9f220fcb0cdeb8fb50b51875ac732b9ef/68747470733a2f2f73312e617831782e636f6d2f323032302f30342f31312f4748437168522e6a7067)
 
**3⃣️填写配置文件CoreConf.conf  首先配置Token 后启动程序**


      #自定义监听服务端口
      Port = "0.0.0.0:8888"
      #工作线程 默认50
      WorkerThread = 50
      #IOTBOT版本
      IOTQQVer = "v3.0.0"
      #Gitter Token
      Token = ""
      
        

![](https://camo.githubusercontent.com/e74c156fca18fe94ae211bcd0a8bd9604aa94a98/68747470733a2f2f73312e617831782e636f6d2f323032302f30342f31312f4748434f39312e6a7067)

**4⃣️运行程序 执行命令 `./IOTQQ` 默认开启8888端口作为WebSokcet/WebApi的服务端口**

`首次登陆会拉取部分脚本并有详细输出 当出现 Everything is ok! 说明服务就绪 获取登陆二维码 访问Url http://IP:PORT/v1/Login/GetQRcode 扫码登陆即可`

**5⃣️控制面板 精力有限 UI可能存在大量BUG 请自行修复 访问http://IP:PORT**

![](https://camo.githubusercontent.com/6600166bc0504b9cbdca07ba7967fb25a174b02d/68747470733a2f2f6674702e626d702e6f76682f696d67732f323032302f30342f396435346339383761323731613939302e706e67)

------------


### 🆒Lua相关API

###### WebPlugin APi
- 请勿修改 WebPlugins目录下的任意文件名以及文件内容的函数名 否则部分WebAP接口会失效

[详细介绍请移步](https://github.com/IOTQQ/IOTQQ/blob/master/%E5%BC%80%E5%8F%91%E6%8C%87%E5%8D%97%E4%B9%8BWebApi%E7%AF%87.md)

 
###### Plugin APi

- 插件命名不受限制 xxx.lua 但是必须实现以下函数 

```lua
--收到好友/私聊消息触发该函数
--CurrentQQ 响应消息的QQ
--data 消息数据 
function ReceiveFriendMsg(CurrentQQ, data)
    return 1 --1 继续处理后续插件 2 不在处理后续插件
end
--收到群消息触发该函数
function ReceiveGroupMsg(CurrentQQ, data)
    return 1
end
--收到所有相关事件的集合 如群成员进群退群管理升降消息撤回、好友撤回删除等事件
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

```
[详细介绍请移步](https://github.com/IOTQQ/IOTQQ/blob/master/%E5%BC%80%E5%8F%91%E6%8C%87%E5%8D%97%E4%B9%8BLuaApi%E7%AF%87.md)

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
    });
    //统一事件管理如好友进群事件 好友请求事件 退群等事件集合
    socket.on('OnEvents', function (data) {
      console.log("收到相关事件");
      console.log(JSON.stringify(data));

    });
    //收到好友消息的回调事件
    socket.on('OnFriendMsgs', function (data) {
      console.log("收到好友消息");
      console.log(data);
      console.log(JSON.stringify(data))
    });
    //收到群消息的回调事件
    socket.on('OnGroupMsgs', function (data) {
      console.log("收到群消息");
      console.log(data);
      console.log(JSON.stringify(data))
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

#### ❤️以下文章或项目排名不分先后 🙏感谢贡献 ❤️

### 相关文章
- **😄 [机器人从1开始](https://blog.fbicloud.com/articles/2019/09/29/1569767839256.html)**
- **😄 [精简机器人插件](http://47.111.230.167/index.php/archives/128/)**
- **😄 [实现一个“人工智能”QQ机器人！](https://segmentfault.com/a/1190000021259760)**
- **😄 [实现一个“人工智能”QQ机器人！续](https://segmentfault.com/a/1190000021350469)**
- **😄 [使用Python制作IOTQQ插件](https://mcenjoy.cn/152/)**
- **😄 [IOTBOT WebApi接口文档](https://www.showdoc.cc/IOTQQ)**
- **😄 [使用Go制作IOTQQ插件](https://mcenjoy.cn/174/)**

### 相关项目
- **😄 [仓鼠的QQ Bot框架-Java版本](https://github.com/ViosinDeng/HamsterBot-IOTQQ)**
- **😄 [机器人插件模板Python](https://github.com/mcoo/iotqq-plugins-demo)**
- **😄 [QQ群反垃圾机器人](https://github.com/rockswang/qqcensorbot)**
- **😄 [IOTBOT机器人框架开发的web版机器人框架](https://github.com/CB-ym/IOTQQ_web)**
- **😄 [IOTQQ的Python SDK](https://github.com/golezi/pyiotqq)**
- **😄 [C# 插件 By:枫林](https://github.com/fenglindubu/IOTQQ_Socket)**

### 感谢 
 - **gopher-lua [https://github.com/yuin/gopher-lua](https://github.com/yuin/gopher-lua)**
 - **gluahttp [https://github.com/cjoudrey/gluahttp](https://github.com/cjoudrey/gluahttp)**
 - **TarsGo [https://github.com/TarsCloud/TarsGo](https://github.com/TarsCloud/TarsGo)**
 - **BeegoLog [https://github.com/beego](https://github.com/beego)**
 - **AdminLTE [AdminLTE](https://github.com/ColorlibHQ/AdminLTE)**
 
 ### 交流裙
 - ![](https://camo.githubusercontent.com/77638ebe9b1c621da9395afc5af7bcb454459d3f/68747470733a2f2f6674702e626d702e6f76682f696d67732f323032302f30342f393233623939383431336136643334342e6a7067)
