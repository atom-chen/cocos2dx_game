-----------------------------------------------------------------
--  姓名：陈胜
--  功能：功能管理
--  日期：2016年11月11日
--	备注：
-----------------------------------------------------------------
local M = class("FunctionManager")

---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------
function M:init()
    self.data = {}

    -- 功能开启时红点处理
    self.tipHandlers = {}
    self:initTipHandlers()
end

function M:initTipHandlers()
    -- 竞技场
    self.tipHandlers[900023] = function(value)
        -- body
        require("model.pvpfight.pvp_fight"):updateTipBubble()
    end
    -- 道场
    self.tipHandlers[900013] = function(value)
        -- body
        require("model.daochang"):updateTipBubble()
    end
end

---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------
function M:setData(data)
    for k,id in pairs(data or {}) do
        self.data[id] = true
    end
    local event = cc.EventCustom:new(EVENT_FUNCTION_OPEN_UPDATE)
    event.data = data
    EventDispatcher:dispatchEvent(event)

    local func = nil
    for k,id in pairs(self.data) do
        func = self.tipHandlers[k]
        if func then
            func()
        end
    end
end

---------------------------------------------------------------------------------------------
-- 直接设置信息
-- 创建角色的战斗使用
---------------------------------------------------------------------------------------------
function M:setDataFlag(data)
    for k, v in pairs(data or {}) do
        self.data[k] = v
    end
end

---------------------------------------------------------------------------------------------
-- 功能是否开启
---------------------------------------------------------------------------------------------
function M:isOpen(cid)
    return self.data[cid]
end

---------------------------------------------------------------------------------------------
-- 获取功能开启等级
---------------------------------------------------------------------------------------------
function M:getOpenLevel(cid)
    return cfgFunctionType[cid].needLv
end

-- ---------------------------------------------------------------------------------------------
-- -- 获取功能开启说明
-- ---------------------------------------------------------------------------------------------
-- function M:getOpenDesc(cid)
--     return Utils:getLanguage(cfgFunctionType[cid].openDesc)
-- end

---------------------------------------------------------------------------------------------
-- 开启功能通知
---------------------------------------------------------------------------------------------
net_player.notifyFunctionTypeOpen = function(functionTypeId)
    M:setData({functionTypeId})
end

return M:init() or M


