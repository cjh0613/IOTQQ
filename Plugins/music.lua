local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    log.notice("From Lua Log ReceiveFriendMsg %s", CurrentQQ)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    if string.find(data.Content, "点歌") then
        keyWord = data.Content:gsub("点歌", "")
        if keyWord == "" then
            return 1
        end
        response, error_message =
            http.request(
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
        local html = response.body
        local str = html:match("callback%((.+)%)")
        local j = json.decode(str)
        local songID = ""
        if j.data and j.data.song and j.data.song.list and j.data.song.list[1] then
            songID = j.data.song.list[1].id
        end
        if songID ~= "" then
            ApiRet =
                Api.Api_SendMsg(
                CurrentQQ,
                {
                    toUser = data.FromGroupId,
                    sendToType = 2,
                    sendMsgType = "JsonMsg",
                    groupid = 0,
                    content = string.format(
                        [[{"config":{"forward":1,"type":"card","autosize":1},"prompt":"[应用]音乐","app":"com.tencent.music","ver":"0.0.0.1","view":"Share","meta":{"Share":{"musicId":"%s"}},"desc":"音乐"}]],
                        tostring(songID)
                    ),
                    atUser = 0
                }
            )
            html = nil
            str = nil
            j = nil
            log.notice("From Lua SendMsg Ret-->%d", ApiRet.Ret)
        end
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
