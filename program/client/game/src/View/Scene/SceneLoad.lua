-----------------------------------------------------------------
--  姓名：陈胜
--  功能：加载进度的场景
--  日期：2016年7月27日
--	备注：
-----------------------------------------------------------------
local M = class("SceneLoad", SceneBase)
local SpriteFrameCache = cc.SpriteFrameCache:getInstance()
local TextureCache = cc.Director:getInstance():getTextureCache()
local isInitData = false
---------------------------------------------------------------------------------------------
-- 初始化数据
---------------------------------------------------------------------------------------------
function M:initData()
    -- 打开其他界面的参数
    self.agrs = {}
    -- 新场景名字
    self.newSceneName = nil
    -- 老场景名字
    self.oldSceneName = nil
    -- 当前进度
    self.loadCount = 0
	-- 总进度
	self.loadMax = 1
	-- 添加资源列表
	self.addResourcesList = {}
	-- 移除资源列表
	self.removeResourcesList = {}
	-- 预加载资源列表
	self.precreate = LayoutManager:getPreloadingInfoResourcesList()
end
---------------------------------------------------------------------------------------------
-- 初始化视图
---------------------------------------------------------------------------------------------
function M:initView()
	local node = cc.CSLoader:createNode("Csb/Scene/SceneLoad.csb")
    self:adaptationResolution(node)
    self:addChild(node)
    -- 进度条
    self.nodeLoadingBar = ccui.Helper:seekNodeByName(node, "LoadingBar_1") 
    -- 进度条百分比
    self.nodeLoadingNum = ccui.Helper:seekNodeByName(node, "Text_1")
end

---------------------------------------------------------------------------------------------
-- 设置进度
---------------------------------------------------------------------------------------------
function M:setPercent(percent)
	self.nodeLoadingNum:setString(percent.."%")

    self.nodeLoadingBar:setPercent(percent)
end

---------------------------------------------------------------------------------------------
-- 初始化事件
---------------------------------------------------------------------------------------------
function M:initEventListener()
    self:registerScriptHandler(function(state)
        if state == "enter" then
        	-- print("enter")
        elseif state == "exit" then
        	-- print("exit")
        elseif state == "enterTransitionFinish" then
        	-- 过渡动画完成
        	-- print("enterTransitionFinish")
			self:addResources()
        elseif state == "exitTransitionStart" then
        	-- 退出过渡动画完成
        	-- print("exitTransitionStart")
        elseif state == "cleanup" then
        	-- print("cleanup")
        end
    end)
end

---------------------------------------------------------------------------------------------
-- 初始化(需要派生类实现，一个对象只执行一次)
---------------------------------------------------------------------------------------------
function M:ctorCallback()
	self:addSelfResources()
    self:initData()
    self:initView()
	self:initEventListener()
    self:removeKeyBackHandler()
end

---------------------------------------------------------------------------------------------
-- 当前进度
---------------------------------------------------------------------------------------------
function M:setPercentMin(count)
	self.loadCount = count
	return self:updatePercent()
end

---------------------------------------------------------------------------------------------
-- 总进度
---------------------------------------------------------------------------------------------
function M:setPercentMax(count)
	self.loadMax = count
	return self:updatePercent()
end

---------------------------------------------------------------------------------------------
-- 添加进度
---------------------------------------------------------------------------------------------
function M:addPercent(count)
	self.loadCount = self.loadCount + (count or 1)
	return self:updatePercent()
end

---------------------------------------------------------------------------------------------
-- 设置进度 0-100
-- @percent 进度
---------------------------------------------------------------------------------------------
function M:updatePercent()
	local percent = math.floor(self.loadCount/self.loadMax*100)
	-- self.nodeLoadingBar:setPercent(percent)
	self:setPercent(percent)

	if self.loadCount >= self.loadMax then
		self.loadCount = 0
		self.loadMax = 1
		return self:LoadedHandle()
	end
end

---------------------------------------------------------------------------------------------
-- 获取交集
---------------------------------------------------------------------------------------------
function M:getIntersection(a, b)
	local t = {}
	for k,v in pairs(a) do
		for k1,v1 in pairs(b) do
			if v == v1 then
				table.insert(t, v1)
			end
		end
	end
	return t
end

---------------------------------------------------------------------------------------------
-- 获取补集 a - b
---------------------------------------------------------------------------------------------
function M:getComplement(a, b)
	local t = {}
	local count
	for k,v in pairs(a) do
		count = false
		for k1,v1 in pairs(b) do
			if v == v1 then
				count = true
				break
			end
		end
		if not count then
			table.insert(t, v)
		end
	end
	return t
end

---------------------------------------------------------------------------------------------
-- 移除资源
---------------------------------------------------------------------------------------------
function M:removeResources()
	for i,path in ipairs(self.removeResourcesList[RESOURCES_TYPE.PLIST]) do
		log("移除合图缓存帧:"..path)
		-- 删除缓存帧
		PlistCacheManager:remove(path)
	end

	for i,path in ipairs(self.removeResourcesList[RESOURCES_TYPE.LOCAL]) do
		log("移除散图缓存帧:"..path)
		SpriteFrameCache:removeSpriteFrameByName(path)
	end

	-- SpriteFrameCache:removeUnusedSpriteFrames()
	-- 删除未使用的纹理。 引用计数为 1 的纹理对象将被删除。
	TextureCache:removeUnusedTextures()
end

---------------------------------------------------------------------------------------------
-- 加载资源
---------------------------------------------------------------------------------------------
function M:addResources()
	-- 添加资源列表
	local newSceneResourcesList = SceneManager:getInfo(self.newSceneName).class.getResourcesList()

	
	-- 先移除资源
	if self.oldSceneName then
		local oldSceneResourcesList = SceneManager:getInfo(self.oldSceneName).class.getResourcesList()
		-- 移除资源列表
		local info = SceneManager:getInfo(self.oldSceneName)
		self.removeResourcesList = {}
		self.removeResourcesList[RESOURCES_TYPE.LOCAL] = self:getComplement(oldSceneResourcesList[RESOURCES_TYPE.LOCAL], newSceneResourcesList[RESOURCES_TYPE.LOCAL])
		self.removeResourcesList[RESOURCES_TYPE.PLIST] = self:getComplement(oldSceneResourcesList[RESOURCES_TYPE.PLIST], newSceneResourcesList[RESOURCES_TYPE.PLIST])

		self.addResourcesList = {}
		self.addResourcesList[RESOURCES_TYPE.LOCAL] = self:getComplement(newSceneResourcesList[RESOURCES_TYPE.LOCAL], oldSceneResourcesList[RESOURCES_TYPE.LOCAL])
		self.addResourcesList[RESOURCES_TYPE.PLIST] = self:getComplement(newSceneResourcesList[RESOURCES_TYPE.PLIST], oldSceneResourcesList[RESOURCES_TYPE.PLIST])

		self:removeResources()
	else
		self.addResourcesList = newSceneResourcesList
	end


	if self.precreate then
		-- 预加载资源
		for k,v in pairs(self.precreate) do
			table.insert(self.addResourcesList[RESOURCES_TYPE.PLIST], v)
		end
		self.precreate = nil
	end

	-- 再加载
	self.precreate = {}
	self:setPercentMin(0)
	self:setPercentMax(#self.addResourcesList[RESOURCES_TYPE.LOCAL] + #self.addResourcesList[RESOURCES_TYPE.PLIST] + 1)

	-- 加载 图片
	local imageName, spriteFrame
	local function imageLoaded(texture)
		if texture then
			log("添加散图缓存帧:"..imageName)
			spriteFrame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0,0,texture:getPixelsWide(),texture:getPixelsHigh()))
			SpriteFrameCache:addSpriteFrame(spriteFrame, imageName)
			self:addPercent()
		end
		imageName = table.remove(self.addResourcesList[RESOURCES_TYPE.LOCAL])
		if not imageName then
			-- 加载完毕
			return -- self:precreateLayout()
		end
		if not cc.FileUtils:getInstance():isFileExist(imageName) then
			error(string.format("加载散图错误： %s 不存在文件 %s", self.newSceneName, imageName))
		end

    	local delaytime = cc.DelayTime:create(0);
		local funcall= cc.CallFunc:create(function ()
    		TextureCache:addImageAsync(imageName, imageLoaded)
		end)
		self:runAction(cc.Sequence:create(delaytime, funcall));
	end

	-- 加载 plist 逐帧加载
	local plistName, action;
	local delaytime = cc.DelayTime:create(0);
	local funcall= cc.CallFunc:create(function ()
		plistName = table.remove(self.addResourcesList[RESOURCES_TYPE.PLIST])
		if plistName then
			if not cc.FileUtils:getInstance():isFileExist(plistName) then
				error(string.format("加载合图错误： %s 不存在文件 %s", self.newSceneName, plistName))
			end
			PlistCacheManager:add(plistName)
			log("加载合图缓存帧:"..plistName)
			self:addPercent()
		else
			imageLoaded()
			self:stopAction(action)
		end
	end)
	action = cc.RepeatForever:create(cc.Sequence:create(delaytime, funcall))

	self:addPercent()
	self:runAction(action)
end

---------------------------------------------------------------------------------------------
-- 加载完毕处理
---------------------------------------------------------------------------------------------
function M:LoadedHandle()
	local delaytime = cc.DelayTime:create(0.2);
	local funcall= cc.CallFunc:create(function ()
		-- self:removeAllChildren()
		self:removeSelfResources()
		SceneManager:_open(unpack(self.agrs))
		self:closeCallback()
		collectgarbage("collect")           --执行一次全垃圾收集循环
	end)
	self:runAction(cc.Sequence:create(delaytime, funcall));
end

---------------------------------------------------------------------------------------------
-- 打开回调(需要派生类实现, 每次打开将会调用)
-- @resourcesList 需要加载的纹理
---------------------------------------------------------------------------------------------
function M:openCallback(oldSceneName, newSceneName, ...)
	assert(newSceneName, "加载哪个界面的数据呢？")
	self.agrs = {...}
	self.oldSceneName = oldSceneName
	self.newSceneName = newSceneName
	self:updatePercent()
	SceneManager:setlocking(true)
end

---------------------------------------------------------------------------------------------
-- 关闭回调(需要派生类实现, 每次关闭将会调用)
---------------------------------------------------------------------------------------------
function M:closeCallback()
	SceneManager:setlocking(false)
end

---------------------------------------------------------------------------------------------
-- 添加自己界面的资源
---------------------------------------------------------------------------------------------
function M:addSelfResources()
	print("添加加载界面的资源")
	-- SpriteFrameCache:addSpriteFrames("ui_plist/jiazai/plist.plist")
end

---------------------------------------------------------------------------------------------
-- 移除自己界面的资源
---------------------------------------------------------------------------------------------
function M:removeSelfResources()
	print("移除加载界面的资源")
	-- SpriteFrameCache:removeSpriteFramesFromFile("ui_plist/jiazai/plist.plist")
	TextureCache:removeUnusedTextures()
end

return M
