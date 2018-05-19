-----------------------------------------------------------------
--  姓名：陈胜
--  功能：主场景
--  日期：2018年3月20日
--  备注：
-----------------------------------------------------------------

local M = class("SceneMain", SceneBase)

---------------------------------------------------------------------------------------------
-- 初始化(需要派生类实现，一个对象只执行一次)
---------------------------------------------------------------------------------------------
function M:ctorCallback()
    self:initData()
    self:initNode()
    GuideManager:nextStep(1)
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
    local node = cc.CSLoader:createNode("csb/scene/SceneMain.csb")
    self.node = node
    self:adaptationResolution(node)
    self:addChild(node)
    -- 进入编辑
    Utils:registeredClickEvent(ccui.Helper:seekNodeByName(node, "Button_1_0_0"), self.buttonEnterEditHandle, self)
   
    -- 进入游戏
    Utils:registeredClickEvent(ccui.Helper:seekNodeByName(node, "Button_1_0"), self.buttonEnterGameHandle, self)
   
    -- 返回登录
    Utils:registeredClickEvent(ccui.Helper:seekNodeByName(node, "Button_1_1"), function ()
        LayoutManager:open("PopupTest", "爱爱爱", "啊啊啊")
    end)
    
    -- 设置按钮
    Utils:registeredClickEvent(ccui.Helper:seekNodeByName(node, "Button_1"), function ()
        LayoutManager:open("LayoutBattleReward", "啦啦啦", "哦也")
    end)

    -- 商城
    Utils:registeredClickEvent(ccui.Helper:seekNodeByName(node, "btnShop"), function ()
        LayoutManager:open("LayoutShop")
    end)

    -- 滚动
    self.scroll = require("Scene.SceneMain.SceneMainScroll").new(
            {
                ccui.Helper:seekNodeByName(node, "Image_1_2"),
                ccui.Helper:seekNodeByName(node, "Image_1_2_0"),
                ccui.Helper:seekNodeByName(node, "Image_1_2_1"),
                ccui.Helper:seekNodeByName(node, "Image_1_2_2"),
            },
            ccui.Helper:seekNodeByName(node, "Particle_2"))
    self:addChild(self.scroll)

    -- 左按钮
    Utils:registeredClickEvent(ccui.Helper:seekNodeByName(node, "Button_1_2_0"), function ()
        self.scroll:rotateTo(self.scroll:getSelectIdx() + 1)
    end)

    -- 右按钮
    Utils:registeredClickEvent(ccui.Helper:seekNodeByName(node, "Button_1_2_1"), function ()
        self.scroll:rotateTo(self.scroll:getSelectIdx() - 1)
    end)

end

---------------------------------------------------------------------------------------------
-- 返回登录
---------------------------------------------------------------------------------------------
function M:buttonBackLoginHandle()
    return SceneManager:open("SceneLogin")
end

---------------------------------------------------------------------------------------------
-- 进入编辑
---------------------------------------------------------------------------------------------
function M:buttonEnterEditHandle()
    return SceneManager:open("SceneTest")
end

---------------------------------------------------------------------------------------------
-- 进入游戏
---------------------------------------------------------------------------------------------
function M:buttonEnterGameHandle()
    return SceneManager:open("SceneBattle")
end


---------------------------------------------------------------------------------------------
-- 打开回调(需要派生类实现, 每次打开将会调用)
---------------------------------------------------------------------------------------------
function M:openCallback()
end

---------------------------------------------------------------------------------------------
-- 关闭回调(需要派生类实现, 每次关闭将会调用)
---------------------------------------------------------------------------------------------
function M:closeCallback()
end

---------------------------------------------------------------------------------------------
-- 销毁回调(需要派生类实现, 一个对象执行一次)
---------------------------------------------------------------------------------------------
function M:destroyCallback()
    self.scroll.animation:release()
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

return M