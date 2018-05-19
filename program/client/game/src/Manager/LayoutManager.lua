---------------------------------------------------------------------------------------------
-- 姓名：陈胜
-- 日期：2018年3月26日
-- 功能：界面管理
-- 备注： 
---------------------------------------------------------------------------------------------
local M = class("LayoutManager")
M.config = require("View.Layout.LayoutDefinition")
local Director = cc.Director:getInstance()
local EventDispatcher = cc.Director:getInstance():getEventDispatcher()
local TextureCache = Director:getTextureCache()
---------------------------------------------------------------------------------------------
-- 初始化
---------------------------------------------------------------------------------------------
function M:init()
	self:initData()
end

---------------------------------------------------------------------------------------------
-- 初始化数据
---------------------------------------------------------------------------------------------
function M:initData()
	-- 历史记录
	self.history = {}
	-- 打开的历史记录
	self.openAllHistory = {}
end

---------------------------------------------------------------------------------------------
-- 加载资源
---------------------------------------------------------------------------------------------
function M:addResources(name)
	local resourcesList = self:getInfo(name).class.getResourcesList()
	local scene = SceneManager:getRunningScene()
	-- 加载 plist
	for i,plistName in ipairs(resourcesList) do
		if not cc.FileUtils:getInstance():isFileExist(plistName) then
			error(string.format("加载界面 %s 错误：不存在文件 %s", name, plistName))
		end
		log("界面 %s 加载资源：%s", name, plistName)
		PlistCacheManager:add(plistName)
	end
end

---------------------------------------------------------------------------------------------
-- 移除资源
---------------------------------------------------------------------------------------------
function M:removeResources(name)
	local info = self:getInfo(name)
	local resourcesList = info.class.getResourcesList()
	for i,path in ipairs(resourcesList) do
		log("移除合图缓存帧:"..path)
		-- 删除缓存帧
		PlistCacheManager:remove(path)
	end
end

---------------------------------------------------------------------------------------------
-- 获取界面对象
---------------------------------------------------------------------------------------------
function M:getObj(name)
	local info = self:getInfo(name)
	if tolua.isnull(info.obj) then
		info.obj = nil
	end
	return info.obj
end

---------------------------------------------------------------------------------------------
-- 获取界面类
---------------------------------------------------------------------------------------------
function M:getClass(name)
	return self:getInfo(name).class
end

---------------------------------------------------------------------------------------------
-- 获取界面数据
---------------------------------------------------------------------------------------------
function M:getInfo(name)
	assert(name, "界面名字？")
	return self.config.interfaceInfo[name] or error ("界面数据不存在"..name)
end

---------------------------------------------------------------------------------------------
-- 更改场景做的处理（场景管理调用）
---------------------------------------------------------------------------------------------
function M:replaceSceneHandle()
	self:closeAll()
end

---------------------------------------------------------------------------------------------
-- 隐藏非顶层的全屏界面
---------------------------------------------------------------------------------------------
function M:updateLayoutVisible()
	local name, class, obj
	local is = true
	for i = #self.history, 1, -1 do
		name = self.history[i]
		class = self:getClass(name)
		if class:isLayout() then
			obj = self:getObj(name)
			obj:setVisible(is)
			is = false
		end
	end
end

---------------------------------------------------------------------------------------------
-- 关闭界面
---------------------------------------------------------------------------------------------
function M:close(name)
	local info = self:getInfo(name)
	local obj = self:getObj(name)
	-- assert(obj:getParent(), "父节点都没有，关你妹啊？")
	if obj and obj:getParent() then
		self:closeFrontHandle(name)
		obj:closeCallback()
		self:closeLaterHandle(name)
		self:updateLayoutVisible()
		if self:getInfo(name).forever then
			obj:removeFromParent(false)
		else
			obj:destroyCallback()
			obj:removeFromParent(true)
			obj:release()
			self:removeResources(name)
			info.obj = nil
		end
		TextureCache:removeUnusedTextures()
		TextureCache:dumpCachedTextureInfo()
		-- collectgarbage("collect")
		print("lua 内存: "..string.format("%0.2f MB",(collectgarbage("count")/1024)))
	else
		log("关闭不存在的界面！ name = "..name)
	end
end

---------------------------------------------------------------------------------------------
-- 获取预创建界面的信息
---------------------------------------------------------------------------------------------
function M:getPreloadingInfoResourcesList()
	local t  ={}
	for name, info in pairs(self.config.interfaceInfo) do
		if info.forever and info.precreate then
			for _, resources in pairs(info.class.getResourcesList()) do
				table.insert(t, resources)
			end
		end
	end
	return t
end


---------------------------------------------------------------------------------------------
-- 检测主场景是否显示
---------------------------------------------------------------------------------------------
local is, name
function M:checkMainViewVisible()
    local event = cc.EventCustom:new(EVENT_MAIN_SCENE_VISIBLE)
    is = true
    name = nil
	for i,_name in ipairs(self.history) do
		if self:getObj(_name):isLayout() then
			is = false
			name = _name
			break
		end
	end
    event.is = is
    event.name = name
    return EventDispatcher:dispatchEvent(event)
end

--[[
*********************************************************************************************************************
**************************************************上面是内部用*******************************************************
**************************************************下面是外部用*******************************************************
*********************************************************************************************************************
--]]

---------------------------------------------------------------------------------------------
-- 打开界面之前处理
---------------------------------------------------------------------------------------------
function M:openFrontHandle(name)
	print("打开界面之前处理", name)
	table.insert(self.openAllHistory, 1, name) -- 保留最近100条数据
	if #self.openAllHistory > 100 then
		table.remove(self.openAllHistory)
	end
end

---------------------------------------------------------------------------------------------
-- 打开界面之后处理
---------------------------------------------------------------------------------------------
function M:openLaterHandle(name)
	print("打开界面之后处理", name)
	self:checkMainViewVisible()
end

---------------------------------------------------------------------------------------------
-- 关闭界面之前处理
---------------------------------------------------------------------------------------------
function M:closeFrontHandle(name)
	print("关闭界面之前处理", name)
	self:checkMainViewVisible()
end

---------------------------------------------------------------------------------------------
-- 关闭界面之后处理
---------------------------------------------------------------------------------------------
function M:closeLaterHandle(name)
	print("关闭界面之后处理", name)
end

---------------------------------------------------------------------------------------------
-- 获取最顶上名字
---------------------------------------------------------------------------------------------
function M:getTopName()
	return self.history[#self.history]
end

---------------------------------------------------------------------------------------------
-- 获取历史
---------------------------------------------------------------------------------------------
function M:getHistory()
	return clone(self.history)
end

---------------------------------------------------------------------------------------------
-- 关闭所有打开的界面 顺序是栈
---------------------------------------------------------------------------------------------
function M:closeAll()
	for i=1, #self.history do
		self:back()
	end
end

---------------------------------------------------------------------------------------------
-- 返回到name界面，如果没有name界面则打开name界面
---------------------------------------------------------------------------------------------
function M:backTo(name, ...)
	while #self.history > 0 do
		if self.history[#self.history] == name then
			return
		else
			self:back()
		end
	end
	self:open(name, ...)
end

---------------------------------------------------------------------------------------------
-- 返回到上一个打开的全屏界面
---------------------------------------------------------------------------------------------
-- function M:backToFull()
-- 	local class
-- 	local topName = self:getTopName()
-- 	for i, name in ipairs(self.openAllHistory) do
-- 		class = self:getClass(name)
-- 		if class:isLayout() and name ~= topName then
-- 			-- 是全屏
-- 			for _=1, i-1 do
-- 				-- 移除历史
-- 				table.remove(self.openAllHistory, 1)
-- 			end
-- 			return self:backTo(name)
-- 		end
-- 	end
-- 	return self:closeAll()
-- end

---------------------------------------------------------------------------------------------
-- 关闭最上面的一个界面
---------------------------------------------------------------------------------------------
function M:back()
	-- 移除当前
	local localName = table.remove(self.history)
	if localName then
		log("移除界面：%s", localName)
		self:close(localName)
	else
		-- 退出游戏
        -- error("测试报错！")
        Utils:messageBox2("确定要退出游戏吗?", function (event)
	        if event == POPUP_SELECT_EVENT_TYPE_YES then
	            cc.Director:getInstance():endToLua()
	        end
	    end)
	end
end

---------------------------------------------------------------------------------------------
-- 打开界面
---------------------------------------------------------------------------------------------
function M:open(name, ...)
	assert(name, "打开什么界面？")
	local is, errStr = self:canOpen(name)
	if not is then
		return Utils:prompt(errStr)
	end
	self:_open(name, ...)
	return true
end

---------------------------------------------------------------------------------------------
-- 是否已经打开
---------------------------------------------------------------------------------------------
function M:isOpen(name)
	local obj = self:getObj(name)
	if obj and obj:getParent() then
		return true
	end
	return false
end

---------------------------------------------------------------------------------------------
-- 能否打开
---------------------------------------------------------------------------------------------
function M:canOpen(name)
	local info = self:getInfo(name)
	if info.functionId and not FunctionManager:isOpen(info.functionId) then
		return false, Utils:getLanguage(cfgFunctionType[info.functionId].tips)
	end
	return true
end

---------------------------------------------------------------------------------------------
-- 打开界面
---------------------------------------------------------------------------------------------
function M:_open(name, ...)
	local obj = self:getObj(name)
	if not obj then
		-- 如果没有有对象
		obj = self:createObj(name)
	end
	self:openHandl(name, ...)
end

---------------------------------------------------------------------------------------------
-- 创建界面对象
---------------------------------------------------------------------------------------------
function M:createObj(name, callback)
	local info = self:getInfo(name)
	assert(tolua.isnull(info.obj), "有对象了，还想找一个？")
	self:addResources(name)
	info.obj = info.class.new()
	info.obj:retain()
	return info.obj
end

---------------------------------------------------------------------------------------------
-- 打开界面处理
---------------------------------------------------------------------------------------------
local info,obj,scene,idx
function M:openHandl(name, ...)
	info = self:getInfo(name)
	obj = self:getObj(name)
	scene = SceneManager:getRunningScene()
	assert(obj, "打开哪个界面？")
	assert(scene, "场景都没有，打开个毛线！")
	if obj:getParent() then
		-- 在历史记录里清除
		-- idx = nil -- 历史记录索引
		-- for i,_name in ipairs(self.history) do
		-- 	if name == _name then
		-- 		idx = i
		-- 		break
		-- 	end
		-- end
		-- assert(idx, "历史记录索引并没有！")
		-- table.remove(self.history, idx)
		-- self:closeFrontHandle(name)
		-- obj:closeCallback()
		-- self:closeLaterHandle(name)
		-- obj:removeFromParent(false)
		return
	end
	scene:addChild(obj, info.zorder or self.config.ZORDER_UI)
	table.insert(self.history, name)
	self:openFrontHandle(name)
	obj:openCallback(...)
	self:openLaterHandle(name)
	self:updateLayoutVisible()
end

return M:init() or M