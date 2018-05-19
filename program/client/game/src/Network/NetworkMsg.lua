-----------------------------------------------------------------
--  姓名：WDJ
--  功能：消息号
--  日期：2018年04月25日
-----------------------------------------------------------------
setmetatable(_G, { })


NETWORK_LOGIN          = "/login"
NETWORK_GETPLAYERINFO  = "/xjll/user"
NETWORK_BUYGOODS       = "/xjll/item/buy"
NETWORK_GET_SERVERTIME ="/time"
NETWORK_RESULT =  "/xjll/level/submit"


if CC_DISABLE_GLOBAL then
    cc.disable_global()
end