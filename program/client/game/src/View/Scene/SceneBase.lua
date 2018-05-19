-----------------------------------------------------------------
--  姓名：陈胜
--  功能：场景基础类
--  日期：2016年7月18日
--	备注：
-----------------------------------------------------------------
local M = class("SceneBase", cc.Scene)
local scheduler = cc.Director:getInstance():getScheduler()

---------------------------------------------------------------------------------------------
-- 构造
---------------------------------------------------------------------------------------------
function M:ctor()
    self._tipList = {} -- 提示列表
    self._promptNode = cc.Node:create() -- 提示内容的节点
    self._promptNode:setLocalZOrder(LayoutManager.config.ZORDER_MAX)
    self:addChild(self._promptNode)
	self:registrationKeyBackHandler()
    self:_addEventListener()
	self:ctorCallback()
end

---------------------------------------------------------------------------------------------
-- 添加事件监听
---------------------------------------------------------------------------------------------
function M:_addEventListener()
    -- 改变玩家数据的通知
    -- local eventDispatcher = self:getEventDispatcher()
    -- local listener = cc.EventListenerCustom:create("sdk_exit_finish", function (event)
    --     Utils:endGame()
    -- end)
    -- eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

---------------------------------------------------------------------------------------------
-- 弹出游戏处理
---------------------------------------------------------------------------------------------
function M:popupGameHandler()
end

---------------------------------------------------------------------------------------------
-- 改变场景回调
---------------------------------------------------------------------------------------------
function M:replaceSceneHandle()
    self._promptNode:removeAllChildren()
    for k, node in pairs(self._tipList) do
        node:release()
    end
    self._tipList = {}
end

---------------------------------------------------------------------------------------------
-- 添加提示消息
---------------------------------------------------------------------------------------------
function M:addMessageTip(msgTip)
    if tolua.isnull(self) then
        return -- 对象是空就不显示
    end
    table.insert(self._tipList, msgTip)
    msgTip:retain()
    if self._promptNodeAction then
        return
    end
    local function handle()
        if #self._tipList == 0 then
            -- 没有播放数据就停止定时器
            self:stopAction(self._promptNodeAction)
            self._promptNodeAction = nil
            return
        end
        local tip = self._tipList[1]
        table.remove(self._tipList, 1)
        for i,v in ipairs(self._promptNode:getChildren()) do
            v:moveBy( { time = 0.2, y = 90 })
        end
        self._promptNode:addChild(tip)
        tip:release()
    end
    local delaytime = cc.DelayTime:create(0.2)
    local funcall= cc.CallFunc:create(handle)
    self._promptNodeAction = cc.RepeatForever:create(cc.Sequence:create(delaytime, funcall))
    self._promptNode:runAction(self._promptNodeAction)
    handle()
end

---------------------------------------------------------------------------------------------
-- 初始化(需要派生类实现，一个对象只执行一次)
---------------------------------------------------------------------------------------------
function M:ctorCallback()
	log("构造场景回调")
end

---------------------------------------------------------------------------------------------
-- 打开回调(需要派生类实现, 每次打开将会调用)
---------------------------------------------------------------------------------------------
function M:openCallback( ... )
	log("打开场景回调")
end

---------------------------------------------------------------------------------------------
-- 关闭回调(需要派生类实现, 每次关闭将会调用)
---------------------------------------------------------------------------------------------
function M:closeCallback()
	log("关闭场景回调")
end

---------------------------------------------------------------------------------------------
-- 销毁回调(需要派生类实现, 一个对象执行一次)
---------------------------------------------------------------------------------------------
function M:destroyCallback()
    log("销毁场景回调")
end

---------------------------------------------------------------------------------------------
-- 获取资源纹理列表资源
-- 这个方法只能当做静态方法，不能使用self
---------------------------------------------------------------------------------------------
function M:getResourcesList()
    return {
        [RESOURCES_TYPE.LOCAL] = {},
        [RESOURCES_TYPE.PLIST] = {},
    }
end

---------------------------------------------------------------------------------------------
-- 适配分辨率
---------------------------------------------------------------------------------------------
function M:adaptationResolution(widget)
    LayoutBase:adaptationResolution(widget)
end
 
---------------------------------------------------------------------------------------------
-- 注册返回按钮事件
---------------------------------------------------------------------------------------------
function M:registrationKeyBackHandler()
    local function onKeyReleased(keyCode, event)
        if LockingScreen:isLock() then
            -- 锁定状态不做任何操作
            return
        end
        if keyCode == cc.KeyCode.KEY_BACK then
            log("按下返回键!")
            LayoutManager:back()
        elseif keyCode == cc.KeyCode.KEY_MENU  then
            log("按下菜单键!")
            LayoutManager:closeAll()
        end
    end
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    self.KeyBackListener = listener
end

---------------------------------------------------------------------------------------------
-- 清理返回按钮事件
---------------------------------------------------------------------------------------------
function M:removeKeyBackHandler()
    self:getEventDispatcher():removeEventListener(self.KeyBackListener)
end

return M
