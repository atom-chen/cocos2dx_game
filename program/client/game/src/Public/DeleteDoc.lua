-----------------------------------------------------------------
--  姓名：陈胜
--  功能：删除更新文件
--  日期：2017年4月5日
--	备注：
-----------------------------------------------------------------
local M = {}
local MANIFEST_FILENAME = "project.manifest"
if 0 == cc.Application:getInstance():getTargetPlatform()  then
    MANIFEST_FILENAME = "/project.manifest"
end

local KEY_OF_VERSION_FLAG = "VERSION_FLAG"
local KEY_OF_VERSION =                  "current-version-code"
---------------------------------------------------------------------------------------------
-- 删除文件
---------------------------------------------------------------------------------------------
function M:split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

---------------------------------------------------------------------------------------------
-- 删除文件
---------------------------------------------------------------------------------------------
function M:deleteFile()
    -- 新包，删除更新目录
    require "config"
    require "static_config"
    local UserDefault = cc.UserDefault:getInstance()
    if #UserDefault:getStringForKey(KEY_OF_VERSION, "") == 0 then
        UserDefault:setStringForKey(KEY_OF_VERSION, VERSION_ID)
    end
    UserDefault:flush()
	if 0 == cc.Application:getInstance():getTargetPlatform()  then
		return -- windows不处理
	end

    if VERSION_FLAG == UserDefault:getStringForKey(KEY_OF_VERSION_FLAG, "") then
        return
    end
    cc.FileUtils:getInstance():removeDirectory(SAVE_SEARCH_PATHS[2])
    cc.FileUtils:getInstance():removeDirectory(SAVE_SEARCH_PATHS[3])
    UserDefault:setStringForKey(KEY_OF_VERSION_FLAG, VERSION_FLAG or "")
    UserDefault:setStringForKey(KEY_OF_VERSION, VERSION_ID or "")
    UserDefault:flush()
end

return M