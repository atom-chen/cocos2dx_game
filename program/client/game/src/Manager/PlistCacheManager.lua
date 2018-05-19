---------------------------------------------------------------------------------------------
-- 姓名：陈胜
-- 日期：2018年3月26日
-- 功能：合图缓存管理
-- 备注： 
---------------------------------------------------------------------------------------------
local M = class("PlistCacheManager")
local SpriteFrameCache = cc.SpriteFrameCache:getInstance()

---------------------------------------------------------------------------------------------
-- 初始化
---------------------------------------------------------------------------------------------
function M:init()
	-- 合图列表
	self.list = {}
end

---------------------------------------------------------------------------------------------
-- 增加合图
---------------------------------------------------------------------------------------------
function M:add(name)
	if not self.list[name] then
		self.list[name] = 0
		-- 添加合图
		SpriteFrameCache:addSpriteFrames(name)
	end
	self.list[name] = self.list[name] + 1
end

---------------------------------------------------------------------------------------------
-- 移除合图
---------------------------------------------------------------------------------------------
function M:remove(name)
	-- 合图列表
	if not self.list[name] then
		log("警告：没有合图%s还想移除它？")
		return
	end
	self.list[name] = self.list[name] - 1
	if self.list[name] <= 0 then
		self.list[name] = nil
		SpriteFrameCache:removeSpriteFramesFromFile(name)
	end
	dump(self.list)
end

---------------------------------------------------------------------------------------------
-- 移除所有合图
---------------------------------------------------------------------------------------------
function M:removeAll()
	for name, count in pairs(self.list) do
		SpriteFrameCache:removeSpriteFramesFromFile(name)
	end
	self.list = {}
end

return M:init() or M