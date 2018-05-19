-----------------------------------------------------------------
--  姓名：陈胜
--  功能：此文件不会自动更新
--  日期：2016年11月1日
--  备注：主要用来区别渠道
-----------------------------------------------------------------
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = true

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 1280,
    height = 720,
    autoscale = "FIXED_HEIGHT",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "FIXED_WIDTH"}
        end
    end
}

-- 渠道网址
SOURCES_URL = "http://www.baidu.com/" 

-- 渠道号
CHANNEL_NO = -1

-- 版本号
VERSION_ID = "0.0"

-- md5
VERSION_FLAG = "二〇一七年四月八日 14:01:25"

-- 跳过新手引导
GAME_SKIP_GUIDE = false

-- 跳过战斗
GAME_JUMP_COMBAT = false

-- 跳过自动更新
GAME_SKIP_AUTO_UPDATE = true
