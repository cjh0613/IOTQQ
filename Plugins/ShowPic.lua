local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    if (data.MsgType == "PicMsg") and (string.find(data.Content, "秀图")) then --发送图文指令 如秀图40001 文字和图片一起发送就会有效果了
        jData = json.decode(data.Content)
        srcindex = string.match(jData.Content, "%d+")
        -- 提取秀图特效类型40000-40006
        keyWord = jData.Content:gsub("秀图" .. srcindex, "")
        -- 替换关键字 秀图40001 会被替换成""
        Api.Api_SendMsg( --通过图片md5发送图片 秒发不用上传 相当于转发
            CurrentQQ,
            {
                toUser = data.FromGroupId,
                sendToType = 2,
                sendMsgType = "PicMsg",
                --发送图文消息
                content = string.format("[秀图%d]%s", srcindex, keyWord),
                --通过宏[PICFLAG]改变图文顺序  改为现文字后图片
                --通过宏[秀图40001] 范围 40000-40006 实现秀图发送 群有效好友无效
                atUser = 0,
                voiceUrl = "",
                voiceBase64Buf = "",
                picUrl = "",
                picBase64Buf = "",
                fileMd5 = jData.FileMd5
            }
        )
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
