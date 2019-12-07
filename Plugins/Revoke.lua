local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")
--[[ mysql 缓存消息数据表结构
CREATE TABLE `msgcache` (
  `ID` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `GroupID` bigint(20) DEFAULT NULL COMMENT '群ID',
  `MsgSeq` int(11) DEFAULT NULL COMMENT '消息Seq',
  `MsgRandom` int(11) DEFAULT NULL COMMENT '消息Random',
  `MsgType` tinytext COMMENT '消息类型',
  `Data` longtext COMMENT '消息JSON内容',
  `MsgTime` int(11) DEFAULT NULL COMMENT '消息时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
]]
mysqlhost = ""
mysqldb = ""
mysqluser = ""
mysqlpass = ""
groupList = {[123456789] = true, [987654321] = true}
--用table 存放 群列表 实现对多群消息的缓存
function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    if CurrentQQ ~= "11111" then -- 处理欲响应的QQ 防止多个机器人在同一个群响应
        return 1
    end
    if data.FromUserId == 111111 then -- 不缓存机器人自己发送的消息
        return 1
    end

    if data.Content == "[群签到]请使用新版QQ进行查看。" then --防自动签到并撤回
        Api.Api_CallFunc(
            CurrentQQ,
            "PbMessageSvc.PbMsgWithDraw",
            {GroupID = data.FromGroupId, MsgSeq = data.MsgSeq, MsgRandom = data.MsgRandom}
        )
    end

    if groupList[data.FromGroupId] == nil then --欲处理消息的群ID 简单过滤一下
        return 1
    end
    c = mysql.new()
    -- 初始化mysql对象
    ok, err = c:connect({host = mysqlhost, port = 3306, database = mysqldb, user = mysqluser, password = mysqlpass})
    --建立连接
    if ok then
        sqlstr =
            string.format(
            [[INSERT INTO msgcache (GroupID, MsgSeq, MsgRandom,MsgType,Data,MsgTime)VALUES (%d,%d,%d,'%s','%s',%d)]],
            data.FromGroupId,
            data.MsgSeq,
            data.MsgRandom,
            data.MsgType,
            data.Content,
            data.MsgTime
        )
        res, err = c:query(sqlstr) --入库缓存消息
        log.info("%s", err)
        c.close(c)
    --释放连接
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    if CurrentQQ ~= "11111" then -- 处理欲响应的QQ 防止多个机器人在同一个群响应
        return 1
    end
    if groupList[extData.GroupID] == nil then --欲处理消息的群ID 简单过滤一下
        return 1
    end
    if data.MsgType == "ON_EVENT_GROUP_REVOKE" then --监听 群撤回事件
        str =
            string.format(
            "群成 %d 管理员UserID %s 撤回了 成员 UserID %s 消息Seq %s \n",
            extData.GroupID,
            extData.AdminUserID,
            extData.UserID,
            extData.MsgSeq
        )
        log.info("%s", str)
        if extData.AdminUserID == 11111 then -- 不缓存机器人自己发送的消息
            return 1
        end
        c = mysql.new()
        -- 初始化mysql对象
        ok, err = c:connect({host = mysqlhost, port = 3306, database = mysqldb, user = mysqluser, password = mysqlpass})
        --建立连接
        log.info("sql %v", err)
        if ok then
            sqlstr =
                string.format(
                "select * from msgcache where `GroupID`= %d and `MsgSeq` = %d",
                extData.GroupID,
                extData.MsgSeq
            )
            res, err = c:query(sqlstr) --跟群群id和消息SEQ查询出撤回的消息内容
            if err == nil then
                c.close(c)
                GroupID = tonumber(res[1]["GroupID"])
                MsgType = res[1]["MsgType"]
                Data = res[1]["Data"]

                if MsgType == "TextMsg" then
                    Api.Api_SendMsg(
                        CurrentQQ,
                        {
                            toUser = GroupID,
                            sendToType = 2,
                            sendMsgType = "TextMsg",
                            --发送文本消息
                            groupid = 0,
                            content = string.format(
                                "成员 [表情176][GETUSERNICK(%d)][表情176] 撤回的消息内容为：\n%s",
                                extData.UserID,
                                Data
                            ),
                            atUser = 0
                        }
                    )
                end
                if MsgType == "SmallFaceMsg" then
                    --Data {"Content":"[表情101]","Hex":"FKY=","Index":101,"tips":"[小表情]"}
                    Api.Api_SendMsg(
                        CurrentQQ,
                        {
                            toUser = GroupID,
                            sendToType = 2,
                            sendMsgType = "TextMsg",
                            groupid = 0,
                            content = string.format(
                                "成员 [表情176][GETUSERNICK(%d)][表情176] 撤回的消息内容为：\n%s",
                                extData.UserID,
                                json.decode(Data).Content
                            ),
                            atUser = 0
                        }
                    )
                end
                if MsgType == "PicMsg" then
                    --Data {"Content":"","FileId":2820717626,"FileMd5":"q0oEC5aloJJMFr10mplaXw==","FileSize":7026,"tips":"[群图片]","url":"http://gchat.qpic.cn/gchatpic_new/1700487478/960839480-2534335053-AB4A040B96A5A0924C16BD749A995A5F/0?vuin=u0026term=255u0026pictype=0"}
                    jData = json.decode(Data)
                    Api.Api_SendMsg( --通过图片md5发送图片 秒发不用上传 相当于转发
                        CurrentQQ,
                        {
                            toUser = GroupID,
                            sendToType = 2,
                            sendMsgType = "PicMsg",
                            --发送图文消息
                            content = string.format(
                                "成员 [PICFLAG][表情176][GETUSERNICK(%d)][表情176] 撤回的消息内容为：\n%s",
                                extData.UserID,
                                jData.Content
                            ),
                            --通过宏[PICFLAG]改变图文顺序  改为现文字后图片
                            atUser = 0,
                            voiceUrl = "",
                            voiceBase64Buf = "",
                            picUrl = "",
                            picBase64Buf = "",
                            fileMd5 = jData.FileMd5
                        }
                    )
                    Sleep(1)
                    Api.Api_SendMsg( --秒发不用上传 相当于转发
                        CurrentQQ,
                        {
                            toUser = GroupID,
                            sendToType = 2,
                            sendMsgType = "ForwordMsg",
                            content = "转发测试",
                            atUser = 0,
                            groupid = 0,
                            voiceUrl = "",
                            voiceBase64Buf = "",
                            picUrl = "",
                            picBase64Buf = "",
                            forwordBuf = jData.ForwordBuf,
                            forwordField = jData.ForwordField
                        }
                    )
                end
                if MsgType == "VideoMsg" then
                    --Data {"VideoMd5":"vAxS8r28V8DKH9P1Q6JmLw==","VideoSize":1022674,"ForwordBuf":"CqYBMzA1MTAyMDEwMDA0MzYzMDM0MDIwMTAwMDIwNDY1NWI2MTM2MDIwMzdhMTNmNTAyMDQ3ODRjOTc3YjAyMDQ1ZGVhN2E3YjA0MTBiYzBjNTJmMmJkYmM1N2MwY2ExZmQzZjU0M2EyNjYyZjAyMDM3YTFhZmQwMjAxMDAwNDE0MDAwMDAwMDg2NjY5NmM2NTc0Nzk3MDY1MDAwMDAwMDQzMTMwMzAzMxIQvAxS8r28V8DKH9P1Q6JmLxoIdGVzdC5tcDQgAigBMNK1PjjQBUCACkoQeVYSLP9QCkbTkFR1IDpsilIGY2FtZXJhWJi5BWABeACQAQCYAQA=","VideoUrl":"MzA1MTAyMDEwMDA0MzYzMDM0MDIwMTAwMDIwNDY1NWI2MTM2MDIwMzdhMTNmNTAyMDQ3ODRjOTc3YjAyMDQ1ZGVhN2E3YjA0MTBiYzBjNTJmMmJkYmM1N2MwY2ExZmQzZjU0M2EyNjYyZjAyMDM3YTFhZmQwMjAxMDAwNDE0MDAwMDAwMDg2NjY5NmM2NTc0Nzk3MDY1MDAwMDAwMDQzMTMwMzAzMw==","tips":"[短视频]"}
                    jData = json.decode(Data)
                    Api.Api_SendMsg( --秒发不用上传 相当于转发
                        CurrentQQ,
                        {
                            toUser = GroupID,
                            sendToType = 2,
                            sendMsgType = "ForwordMsg",
                            content = "",
                            atUser = 0,
                            groupid = 0,
                            voiceUrl = "",
                            voiceBase64Buf = "",
                            picUrl = "",
                            picBase64Buf = "",
                            forwordBuf = jData.ForwordBuf,
                            forwordField = jData.ForwordField
                        }
                    )
                end

                if MsgType == "AtMsg" then
                    --Data {"Content":"@Kar98k skjjkssjkjs","UserID":123456789,"tips":"[AT消息]"}
                    Api.Api_SendMsg(
                        CurrentQQ,
                        {
                            toUser = GroupID,
                            sendToType = 2,
                            sendMsgType = "TextMsg",
                            groupid = 0,
                            content = string.format(
                                "成员 [表情176][GETUSERNICK(%d)][表情176] 撤回的消息内容为：\n%s",
                                extData.UserID,
                                json.decode(Data).Content
                            ),
                            atUser = 0
                        }
                    )
                end
                if MsgType == "VoiceMsg" then
                    --Data {"tips":"[语音]","url":"http://grouptalk.c2c.qq.com/?ver=0u0026rkey=3062020101045b305902010102010102041fdef8ae042439416931554e5142586c536d78706a314c686843664959725f327a5f573064697653755902045dac2a21041f0000000866696c6574797065000000013100000005636f64656300000001310400u0026filetype=1u0026voice_codec=1"}
                    --log.info("sql %s", json.decode(Data).url)
                    Api.Api_SendMsg(
                        CurrentQQ,
                        {
                            toUser = GroupID,
                            sendToType = 2,
                            sendMsgType = "VoiceMsg",
                            --发送群语音消息
                            groupid = 0,
                            content = "",
                            atUser = 0,
                            voiceUrl = json.decode(Data).url,
                            --通过网络url进行发送语音
                            voiceBase64Buf = "",
                            picUrl = "",
                            picBase64Buf = ""
                        }
                    )
                end

                if MsgType == "ReplayMsg" then
                    --Data {"MsgSeq":3536,"ReplayContent":"11 @Mac","SrcContent":"...","UserID":123123,"tips":"[回复]"}
                    --log.info("sql %s", json.decode(Data).url)
                    Api.Api_SendMsg(
                        CurrentQQ,
                        {
                            toUser = GroupID,
                            sendToType = 2,
                            sendMsgType = "TextMsg",
                            groupid = 0,
                            content = string.format(
                                "成员 [表情176][GETUSERNICK(%d)][表情176] 撤回的消息内容为：\n%s",
                                extData.UserID,
                                json.decode(Data).ReplayContent
                            ),
                            atUser = 0
                        }
                    )
                end
                if MsgType == "XmlMsg" then
                    --Data {"MsgSeq":3536,"ReplayContent":"11 @Mac","SrcContent":"...","UserID":123123,"tips":"[回复]"}
                    --log.info("sql %s", json.decode(Data).url)
                    Api.Api_SendMsg(
                        CurrentQQ,
                        {
                            toUser = GroupID,
                            sendToType = 2,
                            sendMsgType = "XmlMsg",
                            groupid = 0,
                            content = string.format("%s", Data),
                            atUser = 0
                        }
                    )
                end
            end
        end
    end
    return 1
end
