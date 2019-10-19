
# 开发指南之LuaApi篇

* **整个框架的核心自然是插件机制了而且还可以个性化自定义开发 考虑到跨平台所以选择的lua 编辑即所得不重启框架实在是舒服开发成本相对新手来说有点高 不过熟悉一些lua简单的语法和数据结构可以enjoy其中的乐趣了**
* **你也可以通过WebSocket对接来实现自己的框架和自己的插件机制**
* **Lua虚拟机是基于这个项目[gopher-lua](https://github.com/yuin/gopher-lua) 通过Golang对Lua的实现也就85%的功能 这些功能足够用啦 而且效率来说相对不错**

## 插件开发

### 1.目录结构及其文件介绍

* **下载回来的压缩包包含了框架的完整目录结构`CoreConf.conf`文件为全局的配置文件 存放Girhub Token/服务端口等重要信息**
* **`Logs`为日志目录**
* **`WebPlugins`为WebApi接口集合里面的文件就不要编辑咯**
* **`UsersConf`目录存放用户登录设备信息数据二次登录数据等 ⚠️不可手动编辑或自主创建⚠️**
* **`Plugins`为插件目录**

### 2.我们一起写一个复读机的插件吧
* **首先启动框架授权认证初始化Token后登录有消息日志输出即为登录成功**
* **首先在插件目录中创建一个.lua的文件 这里以Replay.lua 创建这样一个空文件**
* **粘贴lua开发模版代码**
```lua
local log = require("log") --导入日志输出模块
local Api = require("coreApi")--导入API模块
local json = require("json")--导入JSON解析模块
local http = require("http")--导入HTTP模块
--处理好友消息会调用此函数
--CurrentQQ 当前登录的QQ号
--[[data数据结构为
        data.FromUin  发送消息对象 int
        data.ToUin,   接收消息对象 int
        data.MsgType, 消息类型    string
        data.Content, 内容       string
        data.MsgSeq   消息SEQ序号 int
]]
function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
--处理群消息会调用此函数
--CurrentQQ 当前登录的QQ号
--[[
        data.FromGroupId,   消息来源群ID               int
        data.FromGroupName, 消息来源的群名              string
        data.FromUserId,    触发该消息的用户UserID(QQ)  int
        data.FromNickName,  触发该消息用户的昵称         string
        data.MsgType,       消息类型                   string
        data.Content,       消息内容                   string
        data.MsgSeq,        消息SEQ序号                int
        data.MsgTime,       消息时间                   int
        data.MsgRandom      消息RANDOM                int
]]
function ReceiveGroupMsg(CurrentQQ, data)
    return 1
end
--收到所有相关事件的集合 如群成员进群退群管理升降消息撤回、好友撤回删除等事件
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
```
* **相关事件以及数据结构请查看Plugins目录里的Events.lua文件这里为就不贴代码了😄**

![](https://camo.githubusercontent.com/fd421548798a72c6997f8c3b47d02fe13aab9943/68747470733a2f2f6674702e626d702e6f76682f696d67732f323031392f31302f316163626664376337633361383465372e706e67)

### 复读机插件的实现

* **准备好lua的插件模版代码 我们就开始完善他的功能吧**
* **我们想让机器人在`群`里实现`复读` 自然要在`ReceiveGroupMsg`这个函数下实现 通过这个函数接`收复读机xxx的指令`**


```lua
local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    if string.find(data.Content, "复读机") == 1 then --判断一下所接收的消息里是否含有复读机字样 有则进行处理
        keyWord = data.Content:gsub("复读机", "") --提取关键词 保存到keyWord里

        --log.notice("From Lua data.FromGroupId %d", data.FromGroupId)
        --提取完关键词我们就要 从哪个群收到的消息在进行复读回复回去(当然你也可以判断一下 keyWord=="" 的情况 )
        luaRes =
            Api.Api_SendMsg(--调用发消息的接口
            CurrentQQ,
            {
                toUser = data.FromGroupId, --回复当前消息的来源群ID
                sendToType = 2, --2发送给群1发送给好友3私聊
                sendMsgType = "TextMsg", --进行文本复读回复
                groupid = 0, --不是私聊自然就为0咯
                content = keyWord, --回复内容
                atUser = 0 --是否 填上data.FromUserId就可以复读给他并@了
            }
        )
        log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
```
* **这样一个复读机插件就实现完毕了可以拿到任何平台上去运行咯 是不是很方便 emm 香**

### 群点歌插件的实现
* **新创建一个music.lua的文件 然后老规矩准备好lua的插件模版代码 然后我们完善点歌功能**
* **我们想让机器人在`群`里实现点歌 自然要在`ReceiveGroupMsg`这个函数下实现 通过这个函数接`点歌xxx`的指令**


```lua
local log = require("log") --导入一些必要的模块
local Api = require("coreApi")
local json = require("json")
local http = require("http")
function ReceiveFriendMsg(CurrentQQ, data)
    --log.notice("From Lua Log ReceiveFriendMsg %s", CurrentQQ)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    if string.find(data.Content, "点歌") then--判断是否含有点歌的关键字
        keyWord = data.Content:gsub("点歌", "") --提取歌名
        if keyWord == "" then --判断了为🈳️的情况
            return 1 --返回1继续处理脚本2当前消息不在处理后续脚本
        end
        response, error_message =
            http.request( --调用http模块 和查询QQ音乐歌曲的API
            "GET",
            "https://c.y.qq.com/soso/fcgi-bin/client_search_cp",
            {
                query = "ct=24&qqmusic_ver=1298&new_json=1&remoteplace=txt.yqq.song&searchid=&t=0&aggr=1&cr=1&catZhida=1&lossless=0&flag_qc=0&p=1&n=20&w=" ..
                    keyWord,
                headers = {
                    Accept = "*/*"
                }
            }
        )
        local html = response.body --返回包体
        local str = html:match("callback%((.+)%)") --取匹配json文本
        local j = json.decode(str) --json反序列化成table
        local songID = ""
        if j.data and j.data.song and j.data.song.list and j.data.song.list[1] then
            songID = j.data.song.list[1].id --找出歌曲的🆔
        end
        if songID ~= "" then
            ApiRet =
                Api.Api_SendMsg( --调用发消息的接口
                CurrentQQ,
                {
                    toUser = data.FromGroupId, --回复群
                    sendToType = 2, --2
                    sendMsgType = "JsonMsg", --欲发json卡片格式的消息
                    groupid = 0,
                    content = string.format(
                        [[{"config":{"forward":1,"type":"card","autosize":1},"prompt":"[应用]音乐","app":"com.tencent.music","ver":"0.0.0.1","view":"Share","meta":{"Share":{"musicId":"%s"}},"desc":"音乐"}]],
                        tostring(songID)--构建json数据
                    ),
                    atUser = 0
                }
            )
            html = nil
            str = nil
            j = nil
            log.notice("From Lua SendMsg Ret-->%d", ApiRet.Ret) --发送歌曲卡片
        end
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
```

## 后续
* **用Lua开发插件很方便 保存到PLugins目录里就可以测试咯  后续还有更新一些有趣的插件 如群成员邀请统计/天气查询／防撤回。。。and so on！😄 Enjoy Yourself欢迎贡献你的Code Or Plugins**
# 2019102
