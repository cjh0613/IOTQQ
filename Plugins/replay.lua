local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    log.notice("From Lua Log ReceiveFriendMsg %s", CurrentQQ)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    if (string.find(data.Content, "复述") == 1) then
        keyWord = data.Content:gsub("复述", "")

        --log.notice("From Lua data.FromGroupId %d", data.FromGroupId)

        luaRes =
            Api.Api_SendMsg(
            CurrentQQ,
            {
                toUser = data.FromGroupId,
                sendToType = 2,
                sendMsgType = "TeXiaoTextMsg",
                groupid = 0,
                content = keyWord,
                atUser = 0
            }
        )
        log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
        return 1
    end

    if data.MsgType == "TextMsg" then --机器人智能回复接口
        response, error_message =
            http.request(
            "GET",
            "https://api.ownthink.com/bot",
            {
                query = "appid=xiaosi&spoken=" .. url_encode(data.Content),
                headers = {
                    Accept = "*/*"
                }
            }
        )
        local html = response.body --返回json数据
        if html == nil then
            return 1
        end
        local jData = json.decode(html)
        log.info("api %s", html)
        if jData ~= nil then
            Api.Api_SendMsg(
                CurrentQQ,
                {
                    toUser = data.FromGroupId,
                    sendToType = 2,
                    sendMsgType = "VoiceMsg",
                    groupid = 0,
                    content = "",
                    atUser = 0,
                    voiceUrl = "https://dds.dui.ai/runtime/v1/synthesize?voiceId=qianranfa&speed=0.8&volume=100&audioType=wav&text=" ..
                        url_encode(jData.data.info.text), --将回复的文字转成语音并听过网络Url方式发送回复语音
                    voiceBase64Buf = "",
                    picUrl = "",
                    picBase64Buf = ""
                }
            )
        end
    end
    return 1
end
function url_encode(str)
    if (str) then
        str = string.gsub(str, "\n", "\r\n")
        str =
            string.gsub(
            str,
            "([^%w ])",
            function(c)
                return string.format("%%%02X", string.byte(c))
            end
        )
        str = string.gsub(str, " ", "+")
    end
    return str
end
