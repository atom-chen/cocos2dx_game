-----------------------------------------------------------------
--  姓名：陈胜
--  功能：界面基础类
--  日期：2016年7月20日
--	备注：
-----------------------------------------------------------------
local M = class("LayoutBase", cc.Node) 
local ignoreHeight = 0
-- local center = cc.p(display.cx, (display.height - ignoreHeight)/2 + ignoreHeight)
local center = cc.p(display.cx, display.cy)
---------------------------------------------------------------------------------------------
-- 构造
---------------------------------------------------------------------------------------------
function M:ctor()
	self:createMask()
	self:ctorCallback()
end

---------------------------------------------------------------------------------------------
-- 获取忽略的高
---------------------------------------------------------------------------------------------
function M:getIgnoreHeight()
	return ignoreHeight
end

---------------------------------------------------------------------------------------------
-- 获取中心坐标
---------------------------------------------------------------------------------------------
function M:getCenterPos()
	return center
end

---------------------------------------------------------------------------------------------
-- 初始化(需要派生类实现，一个对象执行一次)
---------------------------------------------------------------------------------------------
function M:ctorCallback()
	log("构造layout:%s回调", self.__cname)
end

---------------------------------------------------------------------------------------------
-- 打开回调(需要派生类实现, 每次打开将会调用)
---------------------------------------------------------------------------------------------
function M:openCallback( ... )
	log("+0:%s回调", self.__cname)
end

---------------------------------------------------------------------------------------------
-- 关闭回调(需要派生类实现, 每次关闭将会调用)
---------------------------------------------------------------------------------------------
function M:closeCallback()
	log("关闭layout:%s回调", self.__cname)
end

---------------------------------------------------------------------------------------------
-- 销毁回调(需要派生类实现, 一个对象执行一次)
---------------------------------------------------------------------------------------------
function M:destroyCallback()
	log("销毁layout:%s回调", self.__cname)
end

---------------------------------------------------------------------------------------------
-- 是否全屏
---------------------------------------------------------------------------------------------
function M:isLayout()
	return true
end

---------------------------------------------------------------------------------------------
-- 背景处理函数(派生类可以实现)
---------------------------------------------------------------------------------------------
function M:backgroundClickHandle()
	print("点击背景处理！")
end

---------------------------------------------------------------------------------------------
-- 创建mask
---------------------------------------------------------------------------------------------
function M:createMask(cx, cy)
	-- 你的样子
	self._mask = cc.Sprite:create()
	self:addChild(self._mask)
	self._mask:setTextureRect(cc.rect(0,0,display.width, display.height))
	self._mask:setColor(cc.BLACK)
	self._mask:setOpacity(128)
	self._mask:setPosition(cx or display.cx, cy or display.cy)
	-- 你的信仰
	local listener = cc.EventListenerTouchOneByOne:create() -- 创建一个事件监听器
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(function (touch, event)
		-- 拦截触摸
    	local target = event:getCurrentTarget()
        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local s = target:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)
        if cc.rectContainsPoint(rect, locationInNode) then
			self:backgroundClickHandle()
            return true
        end
        return false
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self._mask) -- 将监听器注册到派发器中
end

---------------------------------------------------------------------------------------------
-- 获取资源纹理列表资源
-- 这个方法只能当做静态方法，不能使用self
---------------------------------------------------------------------------------------------
function M:getResourcesList()
    return {}
end

---------------------------------------------------------------------------------------------
-- 适配分辨率
---------------------------------------------------------------------------------------------
local visibleSize = cc.Director:getInstance():getOpenGLView():getVisibleSize()
function M:adaptationResolution(widget)
    widget:setContentSize(visibleSize)
    ccui.Helper:doLayout(widget)
end

---------------------------------------------------------------------------------------------
-- 返回上一个界面按钮注册
-- @widget widget派生类
---------------------------------------------------------------------------------------------
function M:registrationButtonBack(widget)
	Utils:registeredClickEvent(widget, function ()
		LayoutManager:back()
	end)
end


return M
