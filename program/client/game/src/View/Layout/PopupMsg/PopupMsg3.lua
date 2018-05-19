-----------------------------------------------------------------
--  姓名：陈胜
--  功能：提示框
--  日期：2016年12月7日
--	备注：
-----------------------------------------------------------------
local M = class("PopupMsg3", PopupBase)
local Helper = ccui.Helper;
---------------------------------------------------------------------------------------------
-- 初始化(需要派生类实现，一个对象只执行一次)
---------------------------------------------------------------------------------------------
function M:ctorCallback()
    self:initData()
	self:initNode()
end

---------------------------------------------------------------------------------------------
-- 初始化
---------------------------------------------------------------------------------------------
function M:initData()
    self.callback = nil
end

---------------------------------------------------------------------------------------------
-- 初始化节点
---------------------------------------------------------------------------------------------
function M:initNode()
	local node = cc.CSLoader:createNode("csb/popup/PopupMsg3.csb")
    self:addChild(node)
    self.closeButton = Helper:seekNodeByName(node, "btnClose")
    self.closeButton:setTag(POPUP_SELECT_EVENT_TYPE_CLOSE)
    Utils:registeredClickEvent(self.closeButton, self.buttonSelectHandle, self)
    self.textDesc = Helper:seekNodeByName(node, "Text_2")
    self.buttons = {
        [POPUP_SELECT_EVENT_TYPE_YES] = Helper:seekNodeByName(node, "btnSure"),
        [POPUP_SELECT_EVENT_TYPE_NO] = Helper:seekNodeByName(node, "btnCancel"),
        [POPUP_SELECT_EVENT_TYPE_OTHER] = Helper:seekNodeByName(node, "btnOther"),
    }

    for tag, button in pairs(self.buttons) do
        button:setTag(tag)
        Utils:registeredClickEvent(button, self.buttonSelectHandle, self)
    end

    self.fontSize = self.textDesc:getFontSize()
    self.fontName = self.textDesc:getFontName()
    self.itemSize = self.textDesc:getContentSize()
    -- self.textDesc:setString("")
    -- self.listView = ccui.Helper:seekNodeByName(node, "ListView_1")
end
---------------------------------------------------------------------------------------------
-- 按钮的事件
---------------------------------------------------------------------------------------------
function M:buttonSelectHandle(sender)
    self.chooseIndex = sender:getTag()
    LayoutManager:back()
end

---------------------------------------------------------------------------------------------
-- 设置字符串
---------------------------------------------------------------------------------------------
function M:setString(str)
    self.textDesc:setString(str)
end

---------------------------------------------------------------------------------------------
-- 设置按钮名字
---------------------------------------------------------------------------------------------
function M:setButtonText(buttonText)
    local text = 
    {
        [POPUP_SELECT_EVENT_TYPE_YES] = buttonText and buttonText[POPUP_SELECT_EVENT_TYPE_YES] or getLanguageById(cfgTip[100000].language),
        [POPUP_SELECT_EVENT_TYPE_NO] = buttonText and buttonText[POPUP_SELECT_EVENT_TYPE_NO] or getLanguageById(cfgTip[100001].language),
        [POPUP_SELECT_EVENT_TYPE_OTHER] = buttonText and buttonText[POPUP_SELECT_EVENT_TYPE_OTHER] or getLanguageById(cfgTip[100002].language),
    }
    for i,button in ipairs(self.buttons) do
        button:setTitleText(text[i])
    end
end

---------------------------------------------------------------------------------------------
-- 背景处理函数(派生类可以实现)
---------------------------------------------------------------------------------------------
function M:backgroundClickHandle()
end

---------------------------------------------------------------------------------------------
-- 打开回调(需要派生类实现, 每次打开将会调用)
-- @str 文本字符串
-- @callback 回调
-- @buttonText YES按钮的文字
---------------------------------------------------------------------------------------------
function M:openCallback(str, callback, buttonText)
    self.callback = callback
    self.chooseIndex = POPUP_SELECT_EVENT_TYPE_CLOSE
    self:setString(str or "say much all tears")
    self:setButtonText(buttonText)
end

---------------------------------------------------------------------------------------------
-- 关闭回调(需要派生类实现, 每次关闭将会调用)
---------------------------------------------------------------------------------------------
function M:closeCallback()
    if self.callback then
        local callback = self.callback
        local chooseIndex = self.chooseIndex
        local scene = SceneManager:getRunningScene()
        local delaytime = cc.DelayTime:create(0)
        local funcall = cc.CallFunc:create(function ()
            LockingScreen:unLock()
            callback(chooseIndex)
        end)
        LockingScreen:lock()
        scene:runAction(cc.Sequence:create(delaytime,funcall))
    end
end

---------------------------------------------------------------------------------------------
-- 销毁回调(需要派生类实现, 一个对象只执行一次)
---------------------------------------------------------------------------------------------
function M:destroyCallback()
end


return M
