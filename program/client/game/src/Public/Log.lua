-----------------------------------------------------------------
--  姓名：cs
--  功能：日志
--  日期：
--  备注：
-----------------------------------------------------------------
local log
if 0 == cc.Application:getInstance():getTargetPlatform()  then
	local fileName = string.gsub(os.date("%Y %m %d",os.time())," ","-")
	fileName = fileName.." "..string.gsub(os.date("%X",os.time()),":","-")
	local dir = cc.FileUtils:getInstance():getSearchPaths()[4].."log/"
	dir = string.gsub(dir, "/", "\\")
	fileName = dir..fileName..".log"
	print("fileName = ", fileName)
	local function strSection(str,len)
		local str = str or ""
		local t = {}
		while #str > len do
			table.insert(t, string.sub(str,1, len))
			str = string.sub(str, len+1, - 1)
		end
		table.insert(t, str)
		return t
	end

	log = function(str, ...)
		str = str or ""
		str = string.format(str,...)
		assert(type(str) == "number" or type(str) == "string", "必须是字符串！")
		for k,v in pairs(strSection(str, 2048*3)) do
			print(v)
		end

		local file = io.open(fileName,"a")
		if not file then
			return
		end
		file:write("["..string.gsub(os.date("%X",os.time()),":","-").."] \n"..str.."\n")
	    file:close()
	end
else
	log = function (str, ...)
		str = string.format(str,...)
		print(str)
	end
end

return log