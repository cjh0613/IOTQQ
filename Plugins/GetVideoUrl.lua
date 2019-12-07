local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    if (string.find(data.MsgType, "VideoMsg") == 1) then --判断是否是视频消息类型
        vdata = json.decode(data.Content)
        videodata = {
            GroupID = data.FromGroupId,
            VideoUrl = vdata.VideoUrl,
            VideoMd5 = vdata.VideoMd5
        }
        --构造table 参数表
        luaResp = Api.Api_CallFunc(CurrentQQ, "PttCenterSvr.ShortVideoDownReq", videodata) --通过cmd调用功能包
        luaRes =
            Api.Api_SendMsg(
            CurrentQQ,
            {
                toUser = data.FromGroupId,
                sendToType = 2,
                sendMsgType = "TextMsg",
                groupid = 0,
                content = "解析视频URL-->" .. luaResp.VideoUrl,
                atUser = 0
            }
        )
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
