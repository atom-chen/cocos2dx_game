-----------------------------------------------------------------
--  姓名：陈胜
--  功能：更新
--  日期：2016年9月29日
--	备注：
-----------------------------------------------------------------
local M = {}

---------------------------------------------------------------------------------------------
-- 初始化
---------------------------------------------------------------------------------------------
function M:reset()
	if NetworkManager then
		-- 结束心跳
 		NetworkManager:endConnectHeartbeat()
 		-- 结束与游戏服务器连接
 		NetworkManager:closeGameSocket()
 	end

 	-- 清理场景
 	if SceneManager then
 		for k,info in pairs(SceneManager.interfaceInfo) do
 			if info.forever then
 				if info.obj then
 					info.obj:release()
 				end
 				info.forever = false
 			end
 		end
 	end

 	-- 清理界面
 	if LayoutManager then
 		for k,info in pairs(LayoutManager.interfaceInfo) do
 			if info.forever then
 				if info.obj then
 					info.obj:release()
 				end
 				info.forever = false
 			end
 		end
 	end
 
	-- 清理缓存
	-- cc.Director:getInstance():purgeCachedData()
	cc.Director:getInstance():getRunningScene():removeAllChildren()
	ccs.ArmatureDataManager:destroyInstance()
	ccs.ActionTimelineCache:destroyInstance()

	local info = SceneManager:getInfo(SceneManager:getRunningSceneName())
	local resourcesList = info.class.getResourcesList()
	for i,path in ipairs(resourcesList[TEXTURERES_TYPE_LOCAL]) do
		log("移除散图缓存帧:"..path)
		SpriteFrameCache:removeSpriteFrameByName(path)
	end
	for i,path in ipairs(resourcesList[TEXTURERES_TYPE_PLIST]) do
		log("移除合图缓存帧:"..path)
		-- 删除缓存帧
		SpriteFrameCache:removeSpriteFramesFromFile(path)
	end
	-- SpriteFrameCache:removeUnusedSpriteFrames()
	-- 删除未使用的纹理。 引用计数为 1 的纹理对象将被删除。
	TextureCache:removeUnusedTextures()
	cc.Director:getInstance():purgeCachedData()
	cc.FileUtils:getInstance():purgeCachedEntries()
	cc.FileUtils:destroyInstance()
	cc.CSLoader:destroyInstance()



	-- cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
	-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
 
	-- 进行此操作的时候，必须是没有和游戏服务器连接
	for k,v in pairs(package.loaded) do
		package.loaded[k] = DEFINITION_MODEL[k]
	end

	for k,v in pairs(_G) do
		_G[k] = DEFINITION_GLOBAL[k]
	end

	setmetatable(_G, {})
	main(true)
end



return M