---------------------------------------------------------------------------------------------
-- 姓名：陈胜
-- 日期：2018年3月20日
-- 功能：界面定义
-- 备注： 
---------------------------------------------------------------------------------------------
local M = {}

-- 最高层级
M.ZORDER_MAX = 255
-- UI层级
M.ZORDER_UI = 1
-- UI层级之上
M.ZORDER_UI_TOP = 2
-- UI层级之下
M.ZORDER_UI_BOTTOM = 0

---------------------------------------------------------------------------------------------
-- 静态数据
-- @name 界面名字
-- @class 类名
-- @forever 永久存在
-- @precreate 预创建  forever为false 预创建无效
-- @functionId 功能id
-- @obj字段不能用
-- @zorder 层级 默认 ZORDER_UI
---------------------------------------------------------------------------------------------
M.interfaceInfo = {
	LayoutTest = {class = require("View.Layout.LayoutTest"), forever = false, precreate = false, functionId = nil},    -- 战斗结算
	PopupMsg1 = {class = require("View.Layout.PopupMsg.PopupMsg1"), forever = true, precreate = false, functionId = nil},    -- 公共提示框
	PopupMsg2 = {class = require("View.Layout.PopupMsg.PopupMsg2"), forever = true, precreate = false, functionId = nil},    -- 公共提示框	
	PopupMsg3 = {class = require("View.Layout.PopupMsg.PopupMsg3"), forever = true, precreate = false, functionId = nil},    -- 公共提示框		
}

return M