local log = require("log")
local api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    if string.find(data.Content, "cooktest") then
        --暂时能用到这么多 api_GetUserCook 返回多是table
        session = api.api_GetUserCook(CurrentQQ)
        log.notice("ClientKey -->%s", session.ClientKey)
        log.notice("Cookies -->%s", session.Cookies)
        log.notice("Skey -->%s", session.Skey)
        log.notice("Gtk -->%s", session.Gtk)
        
        log.notice("Gtk32 -->%s", session.Gtk32)
    end

    return 1
end
function ReceiveFriendEvents(CurrentQQ, data, extData)
    return 1
end
function ReceiveGroupEvents(CurrentQQ, data, extData)
    return 1
end
