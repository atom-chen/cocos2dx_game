---------------------------------------------------------------------------------------------
-- 姓名：陈胜
-- 日期：2016年7月13日
-- 功能：声音管理
-- 备注： 
---------------------------------------------------------------------------------------------
local M = class("SoundManager")
local SimpleAudioEngine = cc.SimpleAudioEngine:getInstance()
---------------------------------------------------------------------------------------------
-- 初始化
---------------------------------------------------------------------------------------------
function M:init()
	--背景音乐名字
	self.m_backgroundMusicPath = nil
	-- 是否开启音乐
	self.m_isMusic = cc.UserDefault:getInstance():getBoolForKey("soundMusic")
	-- 是否开启音效
	self.m_isEffect = cc.UserDefault:getInstance():getBoolForKey("soundEffect")
end

---------------------------------------------------------------------------------------------
-- 播放背景音乐
-- @path 音乐文件路径
-- @id 音乐id
---------------------------------------------------------------------------------------------
function M:playMusicByPath(path)

	if self.m_backgroundMusicPath == path then
		return
	end
	self.m_backgroundMusicPath = path;
	if self.m_isMusic then
		SimpleAudioEngine:playMusic(path, true);
	end
end
function M:playMusicById(id)
	return self:playMusicByPath(self:getPath(id))
end
M.playMusic = M.playMusicById

function M:playMusicById(id)
	return self:playMusicByPath(self:getPath(id))
end
M.playMusic = M.playMusicById

---------------------------------------------------------------------------------------------
-- 暂停播放背景音乐
---------------------------------------------------------------------------------------------
function M:stopMusic()
	return SimpleAudioEngine:pauseMusic()
end
---------------------------------------------------------------------------------------------
-- 恢复播放背景音乐
---------------------------------------------------------------------------------------------
function M:resumeMusic()
	return SimpleAudioEngine:resumeMusic()
end

---------------------------------------------------------------------------------------------
-- 播放音效
-- @path 音乐文件路径
-- @id 音乐id
---------------------------------------------------------------------------------------------
function M:playEffectByPath(path)
	if self.m_isEffect then
		SimpleAudioEngine:playEffect(path)
	end
end
function M:playEffectById(id)
	if id == 0 then
		return -- 0就是不播放音效
	end
	return self:playEffectByPath(self:getPath(id))
end
M.playEffect = M.playEffectById

---------------------------------------------------------------------------------------------
-- 开启背景音乐
---------------------------------------------------------------------------------------------
function M:openMusic()
	self.m_isMusic = true
	if self.m_backgroundMusicPath then
		SimpleAudioEngine:playBackgroundMusic(self.m_backgroundMusicPath, true)
	end
end

---------------------------------------------------------------------------------------------
-- 关闭背景音乐
---------------------------------------------------------------------------------------------
function M:closeMusic()
	self.m_isMusic = false
	SimpleAudioEngine:stopMusic(true)
end

---------------------------------------------------------------------------------------------
-- 是否打开背景音乐
---------------------------------------------------------------------------------------------
function M:isOpenMusic()
	return self.m_isMusic
end

---------------------------------------------------------------------------------------------
-- 开启音效
---------------------------------------------------------------------------------------------
function M:openEffect()
	self.m_isEffect = true;
end

---------------------------------------------------------------------------------------------
-- 关闭音效
---------------------------------------------------------------------------------------------
function M:closeEffect()
	self.m_isEffect = false;
	SimpleAudioEngine:stopAllEffects();
end

---------------------------------------------------------------------------------------------
-- 停止音效
---------------------------------------------------------------------------------------------
function M:stopEffect()
	SimpleAudioEngine:stopAllEffects();
end

---------------------------------------------------------------------------------------------
-- 是否打开音效
---------------------------------------------------------------------------------------------
function M:isOpenEffect()
	return self.m_isEffect
end

---------------------------------------------------------------------------------------------
-- 获取路径
---------------------------------------------------------------------------------------------
function M:getPath(id)
	-- 临时处理，木有配置婊
	local cfgSound = {
			[10001] = {path = "sound/zeromixer.mp3"}, -- 战斗音乐
			[10002] = {path = "sound/bg2.mp3"}, -- 主界面音乐
			[10003] = {path = "sound/bg3.mp3"}, -- 主界面背景音乐
			[10004] = {path = "sound/bg4.mp3"}, -- 主界面背景音乐
			[20001] = {path = "sound/button.mp3"}, -- 按钮音乐
		}
	if not cfgSound[id] then
		log("音乐文件不存在id=%s",id)
		return 
	end
	return cfgSound[id].path
end

return M:init() or M