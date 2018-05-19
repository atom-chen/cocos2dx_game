-----------------------------------------------------------------
--  姓名：陈胜
--  功能：登录场景
--  日期：2018年3月23日
--	备注：
-- 
-----------------------------------------------------------------

local M = class("SceneLogin", SceneBase)
local isPlayVideo = false

---------------------------------------------------------------------------------------------
-- 初始化(需要派生类实现，一个对象只执行一次)
---------------------------------------------------------------------------------------------
function M:ctorCallback()
    self:initData()
    self:initNode()
end

---------------------------------------------------------------------------------------------
-- 初始化
---------------------------------------------------------------------------------------------
function M:initData()
end

---------------------------------------------------------------------------------------------
-- 初始化
---------------------------------------------------------------------------------------------
function M:initNode()
    local node = cc.CSLoader:createNode("csb/scene/SceneLogin.csb")
    self.node = node
    self:adaptationResolution(node)
    self:addChild(node)
    -- 快速注册
    Utils:registeredClickEvent(ccui.Helper:seekNodeByName(node, "Button_1_0"), self.buttonQuickRegistrationHandle, self)
    Utils:registeredClickEvent(ccui.Helper:seekNodeByName(node, "Button_1_1"), self.buttonLoginHandle, self)
    -- 登录
    Utils:registeredClickEvent(ccui.Helper:seekNodeByName(node, "Button_1"), self.buttonLoginHandle, self)
    -- 当前版本号
    ccui.Helper:seekNodeByName(node, "Text_version"):setString(VERSION_FLAG)

    if not isPlayVideo then
        self.node:setVisible(false)
    end

    --NetworkManager:initWebsocket()
end



---------------------------------------------------------------------------------------------
-- 快速注册
---------------------------------------------------------------------------------------------
function M:buttonQuickRegistrationHandle()
    -- return SceneManager:open("SceneStart")
    
    Utils:prompt("快速注册")
    -- Utils:promptById(2)
    -- Utils:promptByTipId(100000)

	--LayoutManager:open("LayoutbattleResult", {fontsize = 60, targetNbr = 200})

    -- netMessageHandle[01020001] = "test_sendToClient3"
    -- netMessageProto[01020001] = "data1"

    --[[net.test_sendToServer2(
    {
        _string = "这是字符串",
        _bool = true,
        _double = 0.333,
        _float = 555,
        _int32 = 5666,
        _int64 = 67777,
        _uint32 = 7555,
        _uint64 = 888888,
        _sint32 = 9999,
        profile = {
            {
                nick_name = "name1",
                icon = "123456",
            },
            {
                nick_name = "name2",
                icon = "123",
            },
            {
                nick_name = "name3",
                icon = "456",
            },
        }
    })
	--]]

    -- net.testa_sendToServer1()
    -- local stringbuffer = protobuf.encode("data1", 
    --   {
    --     _string = "我是字符串11";
    --     _bool = true,
    --     _double = 111111111,
    --     _float = 22222.333333,

    --     _int32 = -1,
    --     _int64 = 666666,
    --     _uint32 = 9999932,
    --     _uint64 = 99999,
    --     _sint32 = -1,


    --     profile = {
    --         {
    --             nick_name = "name1",
    --             icon = "123456",
    --         },
    --         {
    --             nick_name = "name2",
    --             icon = "123",
    --         },
    --         {
    --             nick_name = "name3",
    --             icon = "456",
    --         },
    --     }
    --   })
    -- print("发送消息===============================")
    -- dump(stringbuffer)
    -- print("发送消息===============================")
    -- self.wsSendText:sendString(stringbuffer)
end

---------------------------------------------------------------------------------------------
-- 登录
---------------------------------------------------------------------------------------------
function M:buttonLoginHandle()
    moduleData:rqLogin();
end


---------------------------------------------------------------------------------------------
-- 打开回调(需要派生类实现, 每次打开将会调用)
---------------------------------------------------------------------------------------------
function M:openCallback()
    if not isPlayVideo then
        self:playVideo()
        isPlayVideo = true
    end
end

---------------------------------------------------------------------------------------------
-- 关闭回调(需要派生类实现, 每次关闭将会调用)
---------------------------------------------------------------------------------------------
function M:closeCallback()
end

---------------------------------------------------------------------------------------------
-- 获取资源纹理列表资源
---------------------------------------------------------------------------------------------
function M:getResourcesList()
    return {
        [RESOURCES_TYPE.LOCAL] = {},
        [RESOURCES_TYPE.PLIST] = {
            "plist/test.plist",
        },
    }
end


---------------------------------------------------------------------------------------------
-- 播放CG视频
---------------------------------------------------------------------------------------------
function M:playVideo()
    if ccexp.VideoPlayer then
        SoundManager:closeMusic() --
        local videoPlayer = ccexp.VideoPlayer:create()
        local function onVideoEventCallback(sener, eventType)
            if eventType == ccexp.VideoPlayerEvent.PLAYING then
                -- Utils:prompt("PLAYING")
                -- self:changeCartonState(CARTON_VEDIO)
            elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
                -- Utils:prompt("PAUSED")
                self:videoPlayerCompleted()
            elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
                -- Utils:prompt("STOPPED")
                self:videoPlayerCompleted()
            elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
                -- Utils:prompt("COMPLETED")
                self:videoPlayerCompleted()
            end
        end
        -- Utils:prompt("display.width, display.height = "..display.width.." "..display.height)
        
        local visibleRect = cc.Director:getInstance():getOpenGLView():getVisibleRect()
        local centerPos   = cc.p(visibleRect.x + visibleRect.width / 2,visibleRect.y + visibleRect.height /2)
        videoPlayer:setPosition(centerPos)
        videoPlayer:setAnchorPoint(cc.p(0.5, 0.5))

        videoPlayer:setContentSize(cc.size(display.width, display.height))
        videoPlayer:addEventListener(onVideoEventCallback)

        self:addChild(videoPlayer)
        local videoFullPath = cc.FileUtils:getInstance():fullPathForFilename("mp4/cg.mp4")
        videoPlayer:setFileName(videoFullPath)
        videoPlayer:play()
        self.videoPlayer = videoPlayer
    else
        self.node:setVisible(true)
    end
end

---------------------------------------------------------------------------------------------
-- 播放完毕
---------------------------------------------------------------------------------------------
function M:videoPlayerCompleted()
    local ac1 = cc.DelayTime:create(0)
    local ac2 = cc.CallFunc:create(function()
            self.videoPlayer:removeFromParent()
            self.videoPlayer = nil
            SoundManager:openMusic()
            self.node:setVisible(true)
    end)
    self.videoPlayer:runAction(cc.Sequence:create(ac1, ac2))
end
return M