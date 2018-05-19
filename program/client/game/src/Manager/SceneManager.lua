---------------------------------------------------------------------------------------------
-- 姓名：陈胜
-- 日期：2016年7月12日
-- 功能：场景管理
-- 备注： 
---------------------------------------------------------------------------------------------
local M = class("SceneManager")
M.config = require("View.Scene.SceneDefinition")
local Director = cc.Director:getInstance()
local TextureCache = cc.Director:getInstance():getTextureCache()
local SceneLoad = require("View.Scene.SceneLoad")
---------------------------------------------------------------------------------------------
-- 初始化
---------------------------------------------------------------------------------------------
function M:init()
	-- 数据
	self:initData()
end

---------------------------------------------------------------------------------------------
-- 初始化数据
---------------------------------------------------------------------------------------------
function M:initData()
	-- 老场景
	self.oldSceneName = nil
	-- 新场景
	self.newSceneName = nil
	-- 执行的场景
	self.runScene = nil
	-- 是否锁定（锁定状态下，切换场景无效）
	self.locking = false
	-- 檔在 loadingScene 界面時，彈出方法的緩存
	self.popupGameLoadingSceneFunc = nil
end
---------------------------------------------------------------------------------------------
-- 檔在 loadingScene 界面時，彈出方法的緩存
---------------------------------------------------------------------------------------------
function M:setPopupGameFunc(func)
	self.popupGameLoadingSceneFunc = func
end

---------------------------------------------------------------------------------------------
-- 获取界面对象
---------------------------------------------------------------------------------------------
function M:getObj(name, isNew)
	local info = self:getInfo(name)
	if tolua.isnull(info.obj) then
		if isNew then
			info.obj = info.class.new()
			if info.forever then
				info.obj:retain()
			end
		else
			return nil;
		end
	end
	return info.obj
end

---------------------------------------------------------------------------------------------
-- 获取界面数据
---------------------------------------------------------------------------------------------
function M:getInfo(name)
	assert(name, "场景名字？")
	local info = self.config.interfaceInfo[name]
	assert(info, "场景数据不存在"..name)
	return info
end

---------------------------------------------------------------------------------------------
-- 打开界面(外部用)
---------------------------------------------------------------------------------------------
function M:open(name, ...)
	local arg = {...}
	local obj
	-- 改变场景处理
	LayoutManager:replaceSceneHandle()
	-- 移除屏幕锁
    LockingScreen:remove()
	if self:islocking() then
		return log("当前场景未完成初始化，不能进行切换处理！")
	end
	if self.newSceneName == name then
		return log("重复进入场景，不做任何处理！")
	end
	self.oldSceneName = self.newSceneName
	self.newSceneName = name
	if self.oldSceneName then
		obj = self:getObj(self.oldSceneName)
		-- 切换场景回调
		obj:replaceSceneHandle()
		-- 关闭场景回调
		self:closeFrontHandle(self.oldSceneName)
		obj:closeCallback()
		self:closeLaterHandle(self.oldSceneName)
		if not self:getInfo(self.oldSceneName).forever then
			-- 不是永久存在就摧毁了
			obj:destroyCallback()
		end
	end
	-- 进入加载场景
	obj = SceneLoad.new() -- loadScene
	-- local isCleanup = true -- 是否清理老场景
	-- if self.oldSceneName and self:getInfo(self.oldSceneName).forever then
	-- 	isCleanup = false
	-- end
	-- print("是否清理场景：",self.oldSceneName,isCleanup)
	-- deb()
	Director:replaceScene(self:replaceSceneAnimation(obj))
	self.runScene = obj
	-- 打开场景回调
	obj:openCallback(self.oldSceneName, self.newSceneName, ...)
end

---------------------------------------------------------------------------------------------
-- 获取切换场景的动画
---------------------------------------------------------------------------------------------
function M:replaceSceneAnimation(scene)
	return cc.TransitionFade:create(0.3, scene)
end

---------------------------------------------------------------------------------------------
-- 打开界面
---------------------------------------------------------------------------------------------
function M:_open(...)
	local obj
	local arg = {...}
	obj = self:getObj(self.newSceneName, true)
	Director:replaceScene(self:replaceSceneAnimation(obj))
	-- 打开场景回调
	self.runScene = obj

	obj:registerScriptHandler(function(state)
        if state == "enter" then
        	-- print("enter")
        elseif state == "exit" then
        	-- print("exit")
        elseif state == "enterTransitionFinish" then
        	-- 过渡动画完成
        	-- print("enterTransitionFinish")
			--
			if self:getInfo(self.newSceneName).backgroundMusicId then
	        	SoundManager:playMusic(self:getInfo(self.newSceneName).backgroundMusicId)
	        end
			self:openFrontHandle(self.newSceneName, self.oldSceneName)
			obj:openCallback(unpack(arg))
			self:openLaterHandle(self.newSceneName, self.oldSceneName)
        elseif state == "exitTransitionStart" then
        	-- 退出过渡动画完成
        	-- print("exitTransitionStart")
        elseif state == "cleanup" then
        	-- print("cleanup")
        end
    end)
end

---------------------------------------------------------------------------------------------
-- 获取当前场景
---------------------------------------------------------------------------------------------
function M:getRunningScene()
	return self.runScene or cc.Director:getInstance():getRunningScene()
end

---------------------------------------------------------------------------------------------
-- 获取当前场景名字
---------------------------------------------------------------------------------------------
function M:getRunningSceneName()
	return self.newSceneName
end

---------------------------------------------------------------------------------------------
-- 设置场景锁定
-- 不能操作此函数
---------------------------------------------------------------------------------------------
function M:setlocking(is)
	self.locking = is
end

---------------------------------------------------------------------------------------------
-- 场景是否锁定
---------------------------------------------------------------------------------------------
function M:islocking()
	return self.locking
end

---------------------------------------------------------------------------------------------
-- 进入场景之前处理
---------------------------------------------------------------------------------------------
function M:openFrontHandle(name, oldName)
	print("进入场景之前处理", name, oldName)
end

---------------------------------------------------------------------------------------------
-- 进入场景之后处理
---------------------------------------------------------------------------------------------
function M:openLaterHandle(name, oldName)
	print("进入场景之后处理", name, oldName)
end

---------------------------------------------------------------------------------------------
-- 离开场景之前处理
---------------------------------------------------------------------------------------------
function M:closeFrontHandle(name)
	print("离开场景之前处理", name)
end

---------------------------------------------------------------------------------------------
-- 离开场景之后处理
---------------------------------------------------------------------------------------------
function M:closeLaterHandle(name)
	print("离开场景之后处理", name)
end

return M:init() or M