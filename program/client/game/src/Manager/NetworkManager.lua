---------------------------------------------------------------------------------------------
-- 姓名：陈胜
-- 日期：2016年7月19日
-- 功能：网络管理
-- 备注： 
---------------------------------------------------------------------------------------------
local M = class("NetworkManager")
local json = require("json")
local scheduler = cc.Director:getInstance():getScheduler()
local PING_TIME = 25
---------------------------------------------------------------------------------------------
-- 初始化
---------------------------------------------------------------------------------------------
function M:init()
	self.httpIp = "";
	self.httpHandles = {}
    -- 是否连接中
    self._isConnectGameServer = false
    -- 连接游戏服务器的心跳
    self.connectHeartbeat = nil

    self.websocket = nil

    -- 注册的方法
    self.registerName = {};
end

------------------------------------------------------------------------------------------------------
-------------------------------------------------webSocket-------------------------------------------------
------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
-- 初始化
---------------------------------------------------------------------------------------------
function M:initWebsocket()
    if self.websocket then
        self.websocket:close()
        self.websocket = nil
    end
    
    -- 
    self.websocket = cc.WebSocket:create(GAME_LOGIN_SERVER_PORT)
    -- self.websocket = cc.WebSocket:create("ws://echo.websocket.org")

    local function wsOpen()
        print("网络连接成功 "..self.websocket.url)
    end

    local function wsMessage(msgData)
        print("收到消息 = ", #msgData, msgData)
        return self:wsMessageHandle(self:decode(msgData))
    end

    local function wsClose()
        print("网络连接关闭")
        self.websocket = nil
    end

    local function wsError(...)
        print("网络错误", ...)
    end

    self.websocket:registerScriptHandler(wsOpen,cc.WEBSOCKET_OPEN)
    self.websocket:registerScriptHandler(wsMessage,cc.WEBSOCKET_MESSAGE)
    self.websocket:registerScriptHandler(wsClose,cc.WEBSOCKET_CLOSE)
    self.websocket:registerScriptHandler(wsError,cc.WEBSOCKET_ERROR)
end

---------------------------------------------------------------------------------------------
-- 消息反序列化
---------------------------------------------------------------------------------------------
local t, msgId, msgTag
function M:decode(msgData)
    t = {}
    for i = 1, 8 do
        table.insert(t, table.remove(msgData, 1))
    end
    msgId = tonumber(string.char(unpack(t)))
    msgTag = netMessageProto[msgId]
    if msgTag then
        return msgId, protobuf.decode(msgTag, string.char(unpack(msgData)))
    end
    return msgId
end

---------------------------------------------------------------------------------------------
-- 消息序列化
---------------------------------------------------------------------------------------------
function M:encode(msgId, data)
    -- print("消息序列化 = ", string.format("%08d%s", msgId, data))
    return string.format("%08d%s", msgId, data)
end

---------------------------------------------------------------------------------------------
-- 消息发送
---------------------------------------------------------------------------------------------
function M:send(msgId, data)
    self.websocket:sendString(self:encode(msgId, data))
end

---------------------------------------------------------------------------------------------
-- 消息处理
---------------------------------------------------------------------------------------------
function M:wsMessageHandle(msgId, msgData)
    print("==========================================")
    print("-- 处理消息 ", msgId, msgData)
    if not net[netMessageHandle[msgId]] then
        log("-- 不存在处理函数 msgId = %s, 协议是否是最新？",msgId)
        print("==========================================")
        return
    end
    net[netMessageHandle[msgId]](msgData)
    print("==========================================")
end


---------------------------------------------------------------------------------------------
-- 关闭游戏服链接
---------------------------------------------------------------------------------------------
function M:closeGameSocket()
    self.websocket:close()
    self.websocket = nil
end

---------------------------------------------------------------------------------------------
-- 是否连接游戏服务器
---------------------------------------------------------------------------------------------
function M:isConnectGameServer()
    if self.websocket then
        return true
    end
    return false
end

------------------------------------------------------------------------------------------------------
-------------------------------------------------http-------------------------------------------------
------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- @url 
-- @msg
-- @callback: function handle(event, data) 
--     if event == HTTP_RESPONSE_SUCC then
--         -- 成功
--     else
--         -- 失败
--     end
-- end
---------------------------------------------------------------------------------------------
function M:httpSend(url,msg,callback)
    local xhr = cc.XMLHttpRequest:new()                  --创建一个请求  
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING --设置返回数据格式为字符串  
    xhr:open("POST", url)                                --设置请求方式  GET     或者  POST  
    local function onBack()         
        LockingScreen:unLock()                           --请求响应函数  
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then --请求状态已完并且请求已成功  
            --local statusString = "Http Status Code:"..xhr.statusText  
            --print("请求返回状态码"..statusString)  
            local s = json.decode(xhr.response) --获得返回的内容
            
            -- 判断错误码
            if 0 ~= s.code then
                if 500 == s.code or 101 == s.code or 102 == s.code then
                    return SceneManager:open("SceneLogin")
                end
                return Utils:promptByErrorCode(s.code);
            end
            
            for name, data in pairs(s.data) do
                if not self.registerName[name] then
                    log("警告：没有找到消息对应的处理方法: %s", name);
                else
                    self.registerName[name](data)
                end
            end

            if callback then
                return callback(HTTP_RESPONSE_SUCC)
            end 
        else
            return Utils:messageBox1("网络连接失败...",function() callback(HTTP_RESPONSE_FAIL) end);
        end
    end  
    xhr:registerScriptHandler(onBack) --注册请求响应函数  
    local strData = json.encode(msg)
    xhr:setRequestHeader("Content-Type","application/json;charset=UTF-8")
    print("loginData:getToken() = ",loginData:getToken());
    xhr:setRequestHeader("token", loginData:getToken())
    LockingScreen:lock()
    xhr:send(strData) --最后发送请求  
end

function M:httpRegisteredHandle(name, callback)
    assert(not self.registerName[name], "重复注册处理函数！")
    self.registerName[name] = callback
end


---------------------------------------------------------------------------------------------
-- http
---------------------------------------------------------------------------------------------
-- function M:httpSend(msgId, msgData, errorCallback)
-- 	-- json.decode
-- 	-- json.encode
-- 	local xhr = cc.XMLHttpRequest:new()
-- 	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
-- 	local _t = {
-- 		data = msgData,
-- 		msgId = msgId,
--     	time = os.time().."000"
-- }
-- 	local msg = self:httpCreateMsgPackage(_t)
-- 	xhr:open("GET", msg)
-- 	local function onReadyStateChanged()
--         print("xhr.response = ", xhr.response)
-- 	    if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) and json.isJson(xhr.response) then
-- 	    	-- 成功
-- 		    local data = json.decode(xhr.response)
-- 		    local callback = self:getHttpHandle(data.msgId)
-- 		    if callback then
-- 		    	callback(data)
-- 		    end
-- 	    else
-- 	    	-- 失败
-- 			Utils:prompt("网络连接失败！")
--             if errorCallback then
--                 errorCallback()
--             end
-- 	    end
-- 		xhr:unregisterScriptHandler()
-- 		LockingScreen:unLock()
-- 	end
-- 	xhr:registerScriptHandler(onReadyStateChanged)
-- 	xhr:send()
-- 	LockingScreen:lock()
-- end


-- ---------------------------------------------------------------------------------------------
-- -- 返回服务器系统时间
-- ---------------------------------------------------------------------------------------------
-- net_user.pang = function(serverTime)
--     NetworkManager.pinging = false
--     Utils:setServerTime(serverTime)
-- end

-- ---------------------------------------------------------------------------------------------
-- -- 服务器下发错误
-- ---------------------------------------------------------------------------------------------
-- net_user.notifyError = function(code)
--     if code ~= 0 then
--         return Utils:promptByErrorCode(code)
--     end
-- end


return M:init() or M