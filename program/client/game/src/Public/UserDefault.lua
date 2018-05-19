---------------------------------------------------------------------------------------------
-- 姓名：陈胜
-- 日期：2016年7月20日
-- 功能：用户默认数据定义
-- 备注：新加的字段不会改变原来的字段
---------------------------------------------------------------------------------------------
local UserDefault = cc.UserDefault:getInstance()

---------------------------------------------------------------------------------------------
-- 默认值（在这里写）
---------------------------------------------------------------------------------------------
local Default = {
	soundMusic = true, -- 音乐
	soundEffect = true,-- 音效
	uname = "", -- 账号
	pwd = "", -- 密码
    step = 0, -- 引导完成步数
}

---------------------------------------------------------------------------------------------
-- 设置默认值
---------------------------------------------------------------------------------------------
for k, v in pairs(Default) do
	if type(v) == "boolean" then
		Default[k] = UserDefault:getBoolForKey(k, v)
	elseif type(v) == "number" then
		Default[k] = UserDefault:getFloatForKey(k, v)
	elseif type(v) == "string" then
		Default[k] = UserDefault:getStringForKey(k, v)
	else
		error("保存未知的类型？")
	end
end

---------------------------------------------------------------------------------------------
-- 写入默认值
---------------------------------------------------------------------------------------------
for k,v in pairs(Default) do
	if type(v) == "boolean" then
		UserDefault:setBoolForKey(k, v)
	elseif type(v) == "number" then
		UserDefault:setFloatForKey(k, v)
	elseif type(v) == "string" then
		UserDefault:setStringForKey(k, v)
	else
		error("保存未知的类型？")
	end
end

UserDefault:flush()