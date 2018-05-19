local print = print
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local tostring = tostring
local next = next
 
 local M = {}
function M:write(root, savePath)
	local cache = {}
	tinsert(cache, "\n\n\nlocal M = {")
	local function _dump(t,idx,name)
		local temp = {}
		local interval = ""
		for i = 1, idx or 1 do
			interval = interval .."\t"
		end
		for k,v in pairs(t) do
			local key = tostring(k)
			local keyString = ""
			if type(k) == "string" then
				keyString = key .. " = "
			else
				keyString = "[" .. key .. "] = "
			end

			if type(v) == "table" then
				tinsert(temp, interval .. keyString .. "{\n" ..  _dump(v, idx+1) .. "\n".. interval .. "},")
			elseif type(v) == "string" then
				tinsert(temp, interval .. keyString .."\"".. tostring(v) .. "\",")
			else
				tinsert(temp, interval .. keyString .. tostring(v) .. ",")
			end
		end
		return tconcat(temp,"\n")
	end
	tinsert(cache, _dump(root, 1))
	tinsert(cache, "}\nreturn M")

	local file = io.open(savePath,"w+")
	if not file then
		-- 写入失败
		error("写入失败, 不存在路径 savePath = ".. savePath)
		return
	end
	file:write(tconcat(cache, "\n"))
    file:close()

	-- print(tconcat(cache, "\n"))
end

return M