---------------------------------------------------------------------------------------------
-- 姓名：陈胜
-- 日期：2016年7月22日
-- 功能：锁定屏幕，不让玩家有操作
-- 备注： 
---------------------------------------------------------------------------------------------
local M = class("LockingScreen")
-- 出现的时间
local appearTime = 1
-- 背景颜色
local bgColor = cc.c3b(0,0,0)
local bgOpacity = 128
---------------------------------------------------------------------------------------------
-- 锁定屏幕
---------------------------------------------------------------------------------------------
function M:init()
	self:initData()
	self:initView()
end

---------------------------------------------------------------------------------------------
-- 初始化数据
---------------------------------------------------------------------------------------------
function M:initData()
	-- 计数
	self._count = 0
	-- 总层
	self._mask = cc.Layer:create()
	self._mask:retain()
	self._mask:setLocalZOrder(LayoutManager.config.ZORDER_MAX)
	self._mask:setCascadeOpacityEnabled(true);
end

---------------------------------------------------------------------------------------------
-- 初始化视图
---------------------------------------------------------------------------------------------
function M:initView()
	local _node
	-- 背景
	_node = self:createBackground()
	self._mask:addChild(_node)

	-- 动画
	_node = self:createAnimation()
	self._mask:addChild(_node)
end

---------------------------------------------------------------------------------------------
-- 创建背景
---------------------------------------------------------------------------------------------
function M:createBackground()
	local node = cc.Sprite:create()
	node:setTextureRect(cc.rect(0,0,display.width, display.height))
	node:setColor(bgColor)
	node:setOpacity(bgOpacity)
	node:setPosition(display.cx, display.cy)

	-- 触摸
	local listener = cc.EventListenerTouchOneByOne:create() -- 创建一个事件监听器
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(function (touch, event)
		-- 拦截触摸
		return true
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node) -- 将监听器注册到派发器中

	return node
end

---------------------------------------------------------------------------------------------
-- 创建精灵动画
---------------------------------------------------------------------------------------------
function M:createAnimation()
	-- local node = ccui.Text:create()
	-- node:setString("转菊花")
	-- node:setFontSize(50)
	-- node:setPosition(display.cx, display.cy)

	local node = ccui.ImageView:create("image/zjh.png")
	-- node:setString("转菊花")
	-- node:setFontSize(50)
	node:setPosition(display.cx, display.cy)

	local rotateto = cc.RotateBy:create(0.6, 360);
	local seq = CCSequence:create(rotateto);
	local repeatForever = cc.RepeatForever:create(seq);
	node:runAction(repeatForever);
	return node
end
---------------------------------------------------------------------------------------------
-- 加锁
---------------------------------------------------------------------------------------------
function M:lock()
	self._count = self._count + 1
	local scene = SceneManager:getRunningScene()
	if not self._mask:getParent() then
		-- 重新添加的
		local delaytime = cc.DelayTime:create(1)
		local callback = cc.CallFunc:create(function ()
			self._mask:setOpacity(255)
		end)
		local seq = cc.Sequence:create(delaytime, callback)
		self._mask:runAction(seq)
		self._mask:setOpacity(0)
		scene:addChild(self._mask)
	else
		-- 已经在里面了，就不管了
	end

end

---------------------------------------------------------------------------------------------
-- 解锁
---------------------------------------------------------------------------------------------
function M:unLock()
	self._count = self._count > 0 and self._count - 1 or 0
	if not self:isLock() then
		self._mask:removeFromParent(false)
		-- 清理动作
		self._mask:stopAllActions()
	end
end

---------------------------------------------------------------------------------------------
-- 移除锁
---------------------------------------------------------------------------------------------
function M:remove()
	if self:isLock() then
		self._count = 1
		self:unLock()
	end
end

---------------------------------------------------------------------------------------------
-- 是否加锁
---------------------------------------------------------------------------------------------
function M:isLock()
	if self._count == 0 then
		return false
	end
	return true
end

return M:init() or M