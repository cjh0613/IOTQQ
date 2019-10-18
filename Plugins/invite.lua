local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")
local mysql = require("mysql")

--[[

    奖励机制 邀请10人 得1毛 被邀请人得1分
    在数据库中建立2个表
    CREATE TABLE `invite_users` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `GroupID` bigint(20) DEFAULT NULL COMMENT '群ID',
  `InviteUid` bigint(20) DEFAULT NULL COMMENT '邀请人ID',
  `JoinUid` bigint(20) DEFAULT NULL COMMENT '被邀请人ID',
  `InviteTime` int(11) DEFAULT NULL COMMENT '邀请进群时间',
  PRIMARY KEY (`ID`)
  ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


  CREATE TABLE `invites` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `InviteUid` int(11) DEFAULT NULL COMMENT '邀请人',
  `InviteCounts` int(11) DEFAULT NULL COMMENT '邀请人数',
  `TotalInvites` int(11) DEFAULT NULL COMMENT '总邀请人数',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

]]
function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    if (string.find(data.MsgType, "ON_EVENT_GROUP_JOIN") == 1) then
        if CurrentQQ ~= "QQ号" then -- 处理欲响应的QQ或群组 判断事件来源于哪个QQ 哪个群
            return 1
        end
        if data.FromUin ~= 0 then
            return 1
        end

        str =
            string.format(
            "GroupJoinEvent\n JoinGroup Id %d  \n JoinUin %d \n JoinUserName \n%s InviteUin \n%s",
            data.FromUin,
            extData.UserID,
            extData.UserName,
            extData.InviteUin --非管理员权限此值是0
        )

        log.info("%s", str)

        c = mysql.new()
        ok, err = c:connect({host = "127.0.0.1", port = 3306, database = "qqtoy", user = "root", password = ""})

        InviteUid = extData.InviteUin
        JoinUid = extData.JoinUin
        GroupID = data.FromUin

        if ok then
            sqlstr =
                string.format(
                "select count(*) from invite_users where `GroupID`= %d and `JoinUid` = %d",
                GroupID,
                JoinUid
            )
            res, err = c:query(sqlstr) --判断一下被邀请人是否存在 不存在则发红包奖励 排除重复进群退群

            log.info("err %s", err)
            if tonumber(res[1]["count(*)"]) > 0 then --说明存在记录 不给予发放奖励
                c.close(c)
                log.info("%s", "被邀请人 不给予发放奖励")
                return 1
            else --发放奖励
                response, error_message =
                    http.request(
                    "POST",
                    "http://127.0.0.1:8888/v1/LuaApiCaller",
                    {
                        query = "qq=" .. CurrentQQ .. "&funcname=SendSingleRed&timeout=10",
                        headers = {
                            Accept = "*/*"
                        },
                        body = string.format(
                            [[{"RevGroupid":%d,"RecvUid":%d,"Amount":1,"Paypass":"689264","TotalNum":1,"Wishing":"欢迎大佬入群","Skinid":1435,"RecvType":3,"RedType":6}]],
                            GroupID,
                            JoinUid
                        )
                    }
                )
                local html = response.body

                local j = json.decode(html)
                log.info("%s\n", "被邀请人 发放奖励" .. html)
            end

            sqlstr =
                string.format(
                "INSERT INTO invite_users (GroupID, InviteUid, JoinUid,InviteTime)VALUES (%d,%d,%d,%d)",
                GroupID,
                InviteUid,
                JoinUid,
                os.time()
            )
            res, err = c:query(sqlstr) --插入邀请信息

            sqlstr = string.format("select * from invites where `InviteUid`= %d", InviteUid)
            res, err = c:query(sqlstr) --判断邀请人是否存在 不存在则插入 否则更新奖励计划

            --if tonumber(res[1]["count(*)"]) > 0 then --条件查询的数据存在 ⚠️注意 怎么取数据

            if tonumber(#res) > 0 then
                sqlstr =
                    string.format(
                    "UPDATE `invites` SET `InviteCounts` = InviteCounts+1 ,`TotalInvites` = TotalInvites +1 WHERE `InviteUid` = %d",
                    InviteUid
                )
                c:query(sqlstr)

                if InviteUid == 0 then --排除主动搜索进群的 情况
                    c.close(c)
                    return 1
                end
                --sqlstr = string.format("select * from invites where `InviteUid`= %d", InviteUid)
                --res, err = c:query(sqlstr)
                if tonumber(res[1].InviteCounts) == 10 then
                    sqlstr = string.format("UPDATE `invites` SET `InviteCounts` = 0  WHERE `InviteUid` = %d", InviteUid)
                    c:query(sqlstr)

                    log.notice("%s", "发放邀请者奖励")

                    response, error_message =
                        http.request(
                        "POST",
                        "http://127.0.0.1:8888/v1/LuaApiCaller",
                        {
                            query = "qq=" .. CurrentQQ .. "&funcname=SendSingleRed&timeout=10",
                            headers = {
                                Accept = "*/*"
                            },
                            body = string.format(
                                [[{"RevGroupid":%d,"RecvUid":%d,"Amount":10,"Paypass":"689264","TotalNum":1,"Wishing":"10R任务奖励","Skinid":1435,"RecvType":3,"RedType":6}]],
                                GroupID,
                                InviteUid
                            )
                        }
                    )
                    local html = response.body
                    log.notice("%s\n", html)
                    Api.Api_SendMsg(
                        CurrentQQ,
                        {
                            toUser = GroupID,
                            sendToType = 2,
                            sendMsgType = "XmlMsg",
                            content = string.format(
                                [[<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><msg serviceID="1" templateID="1" action="" brief="&#91;红包奖励&#93;" sourceMsgId="0" url="" flag="2" adverSign="0" multiMsgFlag="0"><item layout="0"><title size="38" color="#9900CC" style="1">🆕10人任务奖励🆕</title></item><item layout="0"><hr hidden="false" style="0" /></item><item layout="6"><summary color="#FF0033">1⃣️%d累计邀请%d人</summary><summary color="#FF0099">💪继续努力💪</summary></item><source name="" icon="" action="" appid="-1" /></msg>]],
                                InviteUid,
                                res[1].TotalInvites
                            ),
                            atUser = 0,
                            groupid = 0
                        }
                    )
                end
                log.notice("%s", "已更新 邀请数据")
            else --数据不存在则插入
                sqlstr =
                    string.format(
                    "INSERT INTO invites (InviteUid, InviteCounts,TotalInvites)VALUES (%d,1,1)",
                    InviteUid
                )
                res, err = c:query(sqlstr) --插入邀请信息
                log.notice("%s", "已插入邀请者数据")
            end

            c.close(c)
        end
    end
    return 1
end
