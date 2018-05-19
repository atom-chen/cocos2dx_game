-----------------------------------------------------------------
--  姓名：陈胜
--  功能：入口
--  日期：
--	备注：
-----------------------------------------------------------------
--                            _ooOoo_  
--                           o8888888o  
--                           88" . "88  
--                           (| -_- |)  
--                            O\ = /O  
--                        ____/`---'\____  
--                      .   ' \\| |// `.  
--                       / \\||| : |||// \  
--                     / _||||| -:- |||||- \  
--                       | | \\\ - /// | |  
--                     | \_| ''\---/'' | |  
--                      \ .-\__ `-` ___/-. /  
--                   ___`. .' /--.--\ `. . __  
--                ."" '< `.___\_<|>_/___.' >'"".  
--               | | : `- \`.;`\ _ /`;.`/ - ` : | |  
--                 \ \ `-. \_ __\ /__ _/ .-` / /  
--         ======`-.____`-.___\_____/___.-`____.-'======  
--                            `=---='  
--  
--         .............................................  
--                  佛祖保佑             永无BUG 
--          佛曰:  
--                  写字楼里写字间，写字间里程序员；  
--                  程序人员写程序，又拿程序换酒钱。  
--                  酒醒只在网上坐，酒醉还来网下眠；  
--                  酒醉酒醒日复日，网上网下年复年。  
--                  但愿老死电脑间，不愿鞠躬老板前；  
--                  奔驰宝马贵者趣，公交自行程序员。  
--                  别人笑我忒疯癫，我笑自己命太贱；  
--                  不见满街漂亮妹，哪个归得程序员？  
-----------------------------------------------------------------
-- require 
-----------------------------------------------------------------
SAVE_SEARCH_PATHS = {
	cc.FileUtils:getInstance():getWritablePath(),
	cc.FileUtils:getInstance():getWritablePath().."/src/",
	cc.FileUtils:getInstance():getWritablePath().."/res/",
	"",
	"src/",
	"res/",
}
cc.FileUtils:getInstance():setSearchPaths(SAVE_SEARCH_PATHS)

log = require("src.Public.Log")
update =require("src.Public.Update")
deb = deb or function ( ... )
end


-----------------------------------------------------------------
-- This function will be called when the app is inactive. When comes a phone call,it's be invoked too
-----------------------------------------------------------------
function applicationDidEnterBackground()
	print("进入后台")
end

-----------------------------------------------------------------
-- this function will be called when the app is active again
-----------------------------------------------------------------
function applicationWillEnterForeground()
	print("从后台切换回来了")
    -- return net_user and net_user.ping()
end


-----------------------------------------------------------------
-- 入口
-----------------------------------------------------------------
function main(isUpdate)
	require "Config"
	require "StaticConfig"
	require "cocos.init"

	cc.FileUtils:getInstance():setPopupNotify(false)
	cc.FileUtils:getInstance():setSearchPaths(SAVE_SEARCH_PATHS)
	cc.Director:getInstance():setDisplayStats(CC_SHOW_FPS)

	require "RequireLua"
	math.randomseed(os.time())

	if isUpdate then
		-- 更新完毕
		return SceneManager:open("SceneLogin")
	else
		if GAME_SKIP_AUTO_UPDATE then
			-- 跳过更新
			return SceneManager:open("SceneLogin")
		else
			-- 进入更新
			return SceneManager:open("updateScene")
		end
	end
end

DEFINITION_MODEL = {} -- 定义的初始模块
for k,v in pairs(package.loaded) do
	DEFINITION_MODEL[k] = v
end

DEFINITION_GLOBAL = {} -- 定义的全局变量
DEFINITION_GLOBAL.DEFINITION_GLOBAL = DEFINITION_GLOBAL
for k,v in pairs(_G) do
	DEFINITION_GLOBAL[k] = v
end


-----------------------------------------------------------------
-- lua错误的回调
-----------------------------------------------------------------
function __G__TRACKBACK__(msg)
    local msg = debug.traceback(msg, 3)
    log(msg)
    deb()
	local target = cc.Application:getInstance():getTargetPlatform()
	if target ~= cc.PLATFORM_OS_WINDOWS  then -- 不是windows，就显示到屏幕内
		if DEBUG == 0 then
			-- local str = "============================begin============================\n"
			-- str = str.."\n"..msg.."@\n"
			-- -- 设备数据
			-- str = str.."设备类型:"..device.platform.."\n"
			-- str = str.."设备名字:"..device.model.."\n"
			-- str = str.."系统版本:"..device.systemVersion.."\n"
			-- if target == cc.PLATFORM_OS_ANDROID then
			-- 	str = str.."设备mac地址:"..device.mac.."\n"
			-- elseif target == cc.PLATFORM_OS_MAC then
			-- 	str = str.."设备唯一标识:"..device.idfa.."\n"
			-- end
			-- str = str.."网络类型:"..device.networkType.."\n"
			-- str = str.."SDK_ID:"..(SDK_ID or "").."\n"
			-- if Player then
			-- 	-- 玩家数据
			-- 	local playerData = Player:getData()
			-- 	for k,v in pairs(playerData or {}) do
			-- 		str = str..string.format("%s  %s\n", k, v)
			-- 	end
			-- end
			-- str = str.."\n".."============================end============================"
			-- -- 发送到日志服务器 
			-- return  require("model.login"):sendLog(str)
		end
		local size = cc.Director:getInstance():getWinSize()
		local item = ccui.Text:create(msg,"ui/font/default.ttf",24)
		item:enableOutline(cc.c4b(255, 0, 0, 255))
		local scene
		if SceneManager then
			scene = SceneManager:getRunningScene()
		end
		if not scene then
			scene = cc.Scene:create()
			cc.Director:getInstance():replaceScene(scene)
		end
		item:setColor(cc.c3b(26, 226, 222))
		scene:addChild(item)
		item:setLocalZOrder(99999999)
		item:setTextAreaSize(size)
		item:setPosition(cc.p(size.width/2, size.height/2))
	end

    return msg
end


xpcall(main, __G__TRACKBACK__)
