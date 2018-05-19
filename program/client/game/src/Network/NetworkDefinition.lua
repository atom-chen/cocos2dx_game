---------------------------------------------------------------------------------------------
-- 姓名：陈胜
-- 日期：2016年7月19日
-- 功能：网络管理
-- 备注： 
---------------------------------------------------------------------------------------------
local M
M = require("Data.Login")
NetworkManager:httpRegisteredHandle("account", handler(M, M.accountHandle))
NetworkManager:httpRegisteredHandle("token", handler(M, M.tokenHandle))

M = require("Data.PackageInfo")
NetworkManager:httpRegisteredHandle("items", handler(M, M.itemsHandle))

M = require("Data.LevelData")
NetworkManager:httpRegisteredHandle("levels", handler(M, M.levelsHandle))
NetworkManager:httpRegisteredHandle("level", handler(M, M.levelHandle))

M = require("Data.PlayerInfo")
NetworkManager:httpRegisteredHandle("user", handler(M, M.userHandle))


M = require("Data.Result")
NetworkManager:httpRegisteredHandle("summary", handler(M, M.summaryHandle))

M = require("Data.ServerTime")
NetworkManager:httpRegisteredHandle("time", handler(M, M.timeHandle))














































