-----------------------------------------------------------------
--  姓名：陈胜
--  功能：require文件
--  日期：
--	备注：
-----------------------------------------------------------------
require "Config"
require "StaticConfig"
require "cocos.init"

-- 加载配置文件
require("Config.RequireConfig")
cc.exports.LayoutBase = require("View.Layout.LayoutBase")
cc.exports.PopupBase = require("View.Layout.PopupBase")
cc.exports.SceneBase = require("View.Scene.SceneBase")

------------------------------------公共方法------------------------------------
require("Public.Global")
require("Public.EventDefinition")
cc.exports.Animation = require("Public.Animation")

------------------------------------模块----------------------------------------

------------------------------------消息注册------------------------------------
require "network.pb.register" -- 外部直接用 protobuf.xxxx

------------------------------------模块----------------------------------------
require("Public.UserDefault")
cc.exports.Utils = require("Public.Utils")

------------------------------------各种管理------------------------------------
cc.exports.LayoutManager = require("Manager.LayoutManager") -- 界面管理
cc.exports.SceneManager = require("Manager.SceneManager") -- 场景管理
cc.exports.SoundManager = require("Manager.SoundManager") -- 声音管理
cc.exports.NetworkManager = require("Manager.NetworkManager") -- 网络管理
-- require("Manager.Network.NetworkDefinition") -- 网络消息处理方法注册
-- require("Manager.Network.NetworkMsg") -- 网络消息处理方法注册
cc.exports.PlistCacheManager = require("Manager.PlistCacheManager") -- 合图管理

------------------------------------公共方法------------------------------------
cc.exports.LockingScreen = require("Public.LockingScreen")-- 锁定屏幕
