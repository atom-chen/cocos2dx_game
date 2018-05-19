---------------------------------------------------------------------------------------------
-- 姓名：
-- 日期：2016年7月12日09:50:56
-- 功能：常用的方法
-- 备注： 
---------------------------------------------------------------------------------------------
local M = class("Utils")
local cfgLanguage = cfgLanguage
local cfgTip = cfgTip
local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
local CUSTOM_COLOR_QUA = CUSTOM_COLOR_QUA
---------------------------------------------------------------------------------------------
-- 初始化方法
---------------------------------------------------------------------------------------------
function M:init()
    self.glRedToWhiteProgram = cc.GLProgram:createWithByteArrays(GL_VERT_RED_CHANGE_WHITE_SOURCE, GL_FSH_RED_CHANGE_WHITE_SOURCE)
    if self.glRedToWhiteProgram then
        cc.GLProgramCache:getInstance():addGLProgram(self.glRedToWhiteProgram, GL_RED_CHANGE_WHITE_SHADER_NAME)
        self.glRedToWhiteProgram = cc.GLProgramState:getOrCreateWithGLProgramName(GL_RED_CHANGE_WHITE_SHADER_NAME)
    else
        print("create grey shader failure!")
    end
    self.glWhiteToRedProgram = cc.GLProgram:createWithByteArrays(GL_VERT_WHITE_CHANGE_RED_SOURCE, GL_FSH_WHITE_CHANGE_RED_SOURCE)
    if self.glWhiteToRedProgram then
        cc.GLProgramCache:getInstance():addGLProgram(self.glWhiteToRedProgram, GL_WHITE_CHANGE_RED_SHADER_NAME)
        self.glWhiteToRedProgram = cc.GLProgramState:getOrCreateWithGLProgramName(GL_WHITE_CHANGE_RED_SHADER_NAME)
    else
        print("create grey shader failure!")
    end
    self.glGreyProgram = cc.GLProgram:createWithByteArrays(GL_VERT_GREY_SOURCE, GL_FSH_GREY_SOURCE)
    if self.glGreyProgram then
        cc.GLProgramCache:getInstance():addGLProgram(self.glGreyProgram, GL_GREY_SHADER_NAME)
    else
        print("create grey shader failure!")
    end
    self.glBrightProgram = cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")
end

---------------------------------------------------------------------------------------------
-- 注册滚动层 按钮点击 在Scorllview
-- button 按钮
-- @callback 回调
-- @this callback的self
---------------------------------------------------------------------------------------------
local app = cc.Application:getInstance()
local target = app:getTargetPlatform()
if target == cc.PLATFORM_OS_IPHONE or target == cc.PLATFORM_OS_IPAD then
    function M:registeredButtonClickInScrollView(button, scorllview, callback, this, soundId)
        local function touchEvent(sender)        
            local beganPos = sender:getTouchBeganPosition()
            local endPos = sender:getTouchEndPosition()
            if not Utils:inCircular(beganPos, endPos, 24) then            
                return --"有移动"
            end
            if Utils:inTableViewByPoint(scorllview, endPos) then   
                SoundManager:playEffect(soundId or BUTTON_SOUND)         
                if callback then
                    if this then
                        callback(this, sender)
                    else                    
                        callback(sender)
                    end
                end
            end
        end
        Utils:registeredClickEvent(button, touchEvent, nil, 0)
    end

    function M:registeredButtonClickInListView(button, listlview, callback, this, soundId)
        local function touchEvent(sender)        
            local beganPos = sender:getTouchBeganPosition()
            local endPos = sender:getTouchEndPosition()
            if not Utils:inCircular(beganPos, endPos, 24) then            
                return --"有移动"
            end
            if Utils:inListViewByPoint(listlview, endPos) then            
                SoundManager:playEffect(soundId or BUTTON_SOUND)
                if callback then
                    if this then                    
                        callback(this, sender)
                    else                    
                        callback(sender)
                    end
                end
            end
        end
        Utils:registeredClickEvent(button, touchEvent, nil, 0)
    end

    function M:registeredImageClickInPageView(button, scorllview, callback, this, soundId)
        local function touchEvent(sender)        
            local beganPos = sender:getTouchBeganPosition()
            local endPos = sender:getTouchEndPosition()
            if not Utils:inCircular(beganPos, endPos, 24) then            
                return --"有移动"
            end
            SoundManager:playEffect(soundId or BUTTON_SOUND)
            -- if Utils:inTableViewByPoint(scorllview, endPos) then            
                if callback then
                    if this then                    
                        callback(this, sender)
                    else                    
                        callback(sender)
                    end
                end
            -- end
        end
        Utils:registeredImageCheckAction(button, touchEvent, nil, 0)
    end

    function M:registeredImageCheckActionInTableView(image, scorllview, callback, this, soundId)
        local function touchEvent(sender)        
            local beganPos = sender:getTouchBeganPosition()
            local endPos = sender:getTouchEndPosition()
            if not Utils:inCircular(beganPos, endPos, 24) then            
                return --"有移动"
            end
            if Utils:inTableViewByPoint(scorllview, endPos) then     
                SoundManager:playEffect(soundId or BUTTON_SOUND)       
                if callback then
                    if this then                    
                        callback(this, sender)
                    else                    
                        callback(sender)
                    end
                end
            end
        end
        Utils:registeredImageCheckAction(image, touchEvent, nil, 0)
    end

    function M:registeredImageCheckActionInListView1(touchArea, image, scorllview, callback, this, soundId)
        local function touchEvent(sender)        
            local beganPos = sender:getTouchBeganPosition()
            local endPos = sender:getTouchEndPosition()
            if not Utils:inCircular(beganPos, endPos, 24) then            
                return --"有移动"
            end
            if Utils:inListViewByPoint(scorllview, endPos) then      
                SoundManager:playEffect(soundId or BUTTON_SOUND)             
                if callback then
                    if this then                    
                        callback(this, sender)
                    else                    
                        callback(sender)
                    end
                end
            end
        end
        Utils:registeredImageCheckAction1(touchArea, image, touchEvent, nil, 0)
    end

    function M:registeredImageCheckActionInListView2(image, scorllview, callback, this, soundId)
        local function touchEvent(sender)        
            local beganPos = sender:getTouchBeganPosition()
            local endPos = sender:getTouchEndPosition()
            if not Utils:inCircular(beganPos, endPos, 24) then            
                return --"有移动"
            end
            if Utils:inListViewByPoint(scorllview, endPos) then
                SoundManager:playEffect(soundId or BUTTON_SOUND)
                if callback then
                    if this then                    
                        callback(this, sender)
                    else                    
                        callback(sender)
                    end
                end
            end
        end
        Utils:registeredImageCheckAction(image, touchEvent, nil, 0)
    end
else
    function M:registeredButtonClickInScrollView(button, scorllview, callback, this, soundId)
        local function touchEvent(sender)        
            local beganPos = sender:getTouchBeganPosition()
            local endPos = sender:getTouchEndPosition()
            if not Utils:inCircular(beganPos, endPos, 16) then            
                return --"有移动"
            end
            if Utils:inTableViewByPoint(scorllview, endPos) then
                SoundManager:playEffect(soundId or BUTTON_SOUND)
                if callback then
                    if this then                    
                        callback(this, sender)
                    else                    
                        callback(sender)
                    end
                end
            end
        end
        Utils:registeredClickEvent(button, touchEvent, nil, 0)
    end

    function M:registeredButtonClickInListView(button, scorllview, callback, this, soundId)
        local function touchEvent(sender)        
            local beganPos = sender:getTouchBeganPosition()
            local endPos = sender:getTouchEndPosition()
            if not Utils:inCircular(beganPos, endPos, 16) then            
                return --"有移动"
            end
            if Utils:inListViewByPoint(scorllview, endPos) then
                SoundManager:playEffect(soundId or BUTTON_SOUND)
                if callback then
                    if this then                    
                        callback(this, sender)
                    else                    
                        callback(sender)
                    end
                end
            end
        end
        Utils:registeredClickEvent(button, touchEvent, nil, 0)
    end

    function M:registeredImageClickInPageView(button, scorllview, callback, this, soundId)
        local function touchEvent(sender)        
            local beganPos = sender:getTouchBeganPosition()
            local endPos = sender:getTouchEndPosition()
            if not Utils:inCircular(beganPos, endPos, 16) then            
                return --"有移动"
            end
            -- if Utils:inTableViewByPoint(scorllview, endPos) then         
                SoundManager:playEffect(soundId or BUTTON_SOUND)   
                if callback then
                    if this then                    
                        callback(this, sender)
                    else                    
                        callback(sender)
                    end
                end
            -- end
        end
        Utils:registeredImageCheckAction(button, touchEvent, nil, 0)
    end

    function M:registeredImageCheckActionInTableView(image, scorllview, callback, this, soundId)
        local function touchEvent(sender)        
            local beganPos = sender:getTouchBeganPosition()
            local endPos = sender:getTouchEndPosition()
            if not Utils:inCircular(beganPos, endPos, 16) then            
                return --"有移动"
            end
            if Utils:inTableViewByPoint(scorllview, endPos) then      
                SoundManager:playEffect(soundId or BUTTON_SOUND)      
                if callback then
                    if this then                    
                        callback(this, sender)
                    else                    
                        callback(sender)
                    end
                end
            end
        end
        Utils:registeredImageCheckAction(image, touchEvent, nil, 0)
    end


    function M:registeredImageCheckActionInListView1(touchArea, image, scorllview, callback, this, soundId)
        local function touchEvent(sender)        
            local beganPos = sender:getTouchBeganPosition()
            local endPos = sender:getTouchEndPosition()
            if not Utils:inCircular(beganPos, endPos, 16) then            
                return --"有移动"
            end
            if Utils:inListViewByPoint(scorllview, endPos) then         
                SoundManager:playEffect(soundId or BUTTON_SOUND)   
                if callback then
                    if this then                    
                        callback(this, sender)
                    else                    
                        callback(sender)
                    end
                end
            end
        end
        Utils:registeredImageCheckAction1(touchArea, image, touchEvent, nil, 0)
    end

    function M:registeredImageCheckActionInListView2(image, scorllview, callback, this, soundId)
        local function touchEvent(sender)        
            local beganPos = sender:getTouchBeganPosition()
            local endPos = sender:getTouchEndPosition()
            if not Utils:inCircular(beganPos, endPos, 16) then            
                return --"有移动"
            end
            if Utils:inListViewByPoint(scorllview, endPos) then     
                SoundManager:playEffect(soundId or BUTTON_SOUND)       
                if callback then
                    if this then                    
                        callback(this, sender)
                    else                    
                        callback(sender)
                    end
                end
            end
        end
        Utils:registeredImageCheckAction(image, touchEvent, nil, 0)
    end
end

---------------------------------------------------------------------------------------------
-- 注册 图片点击
-- image 图片
-- @callback 回调
-- @this callback的self
---------------------------------------------------------------------------------------------
function M:registeredImageCheckAction1(touchArea, image, callback, this, soundId)
    local originalScale = 1
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.began then
            originalScale = image:getScale()
            image:setScale(1.1 * originalScale)
        elseif eventType == ccui.TouchEventType.moved then
        else
            image:setScale(1.0 * originalScale)
            SoundManager:playEffect(soundId or BUTTON_SOUND)
            if callback then
                if this then
                    callback(this, sender)
                else
                    callback(sender)
                end
            end
        end
    end
    touchArea:setTouchEnabled(true)
    touchArea:addTouchEventListener(touchEvent)
end

---------------------------------------------------------------------------------------------
-- 注册 图片点击
-- image 图片
-- @callback 回调
-- @this callback的self
---------------------------------------------------------------------------------------------
function M:registeredImageCheckAction(image, callback, this, soundId)
    local originalScale = 1
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.began then
            originalScale = image:getScale()
        	image:setScale(1.1 * originalScale)
        elseif eventType == ccui.TouchEventType.moved then
        else
        	image:setScale(1.0 * originalScale)
            SoundManager:playEffect(soundId or BUTTON_SOUND)
        	if callback then
        		if this then
        			callback(this, sender)
        		else
        			callback(sender)
        		end
        	end
        end
    end
    image:setTouchEnabled(true)
    image:addTouchEventListener(touchEvent)
end

---------------------------------------------------------------------------------------------
-- 注册复选框点击事件
-- @widget
-- @callback 回调
-- @this callback的self
-- @notSound 没有声音
---------------------------------------------------------------------------------------------
function M:registeredCheckBoxEvent(widget, callback, this, soundId)
	return widget:addEventListener(function (sender, eventType)
		SoundManager:playEffect(soundId or BUTTON_SOUND)
		if callback then
			if this then
				return callback(this, sender, eventType)
			end
			return callback(sender, eventType)
		end
	end)
end

---------------------------------------------------------------------------------------------
-- 注册Slider 事件
-- @widget
-- @callback 回调
-- @this callback的self
-- @notSound 没有声音
---------------------------------------------------------------------------------------------
function M:registeredSliderEvent(widget, callback, this)
	return widget:addEventListener(function (sender, eventType)
		if callback then
			if this then
				return callback(this, sender, eventType)
			end
			return callback(sender, eventType)
		end
	end)
end

---------------------------------------------------------------------------------------------
-- 注册点击事件
-- @widget
-- @callback 回调
-- @this callback的self
-- @notSound 没有声音
---------------------------------------------------------------------------------------------
function M:registeredClickEvent(widget, callback, this, soundId)
	return widget:addClickEventListener(function (sender)
        SoundManager:playEffect(soundId or BUTTON_SOUND)
		if callback then
			if this then
				return callback(this,sender)
			end
			return callback(sender) 
		end
	end)
end


---------------------------------------------------------------------------------------------
-- 提示框
-- @str 文本字符串
-- @callback 回调
-- @tagId 标签的id
-- @time 打开的时间（倒计时）
-- @buttonText 默认 YES按钮的文字 {}
---------------------------------------------------------------------------------------------
function M:promptMsgBox1(str, callback, time, buttonText, datas)
    return LayoutManager:open("popup_msgbox1", str, callback, time, buttonText, datas)
end
function M:promptMsgBox2(str, callback, time, buttonText)
    return LayoutManager:open("popup_msgbox2", str, callback, time, buttonText)
end
function M:promptMsgBox3(str, callback, time, buttonText, datas)
    return LayoutManager:open("popup_msgbox3", str, callback, time, buttonText, datas)
end

---------------------------------------------------------------------------------------------
-- 判断元宝是否足够
---------------------------------------------------------------------------------------------
function M:isIngotsEnough(number)
	if number > Player:getData().tre then
		Utils:promptMsgBox2(Utils:getLanguageByTipId(10034), function (event)
			if event == POPUP_SELECT_EVENT_TYPE_YES then
				-- Utils:prompt("前往买元宝！")
                -- if isBack then
                --     LayoutManager:back()
                -- end
                if LayoutManager:isOpen("layout_vip") then
                    LayoutManager:getObj("layout_vip"):selectPage(1)
                else
                    LayoutManager:backTo("layout_vip", 1)
                end
	        elseif event == POPUP_SELECT_EVENT_TYPE_NO then
	        end
		end)
		-- Utils:prompt("元宝不足！")
        return false
    end
	return true
end

---------------------------------------------------------------------------------------------
-- 购买前往购买vip
---------------------------------------------------------------------------------------------
function M:promptBuyVIP(nextAddCount)
    local vip = Player:getData().vip
    if VipManager:isMax() then
        -- 今日次数已耗尽，请明日再来
        Utils:promptByTipId(10538)
    else
        Utils:promptMsgBox1(Utils:getLanguageByTipIdFormat(10539, vip, vip + 1, nextAddCount or 0), function (event)
            if event == POPUP_SELECT_EVENT_TYPE_YES then
                LayoutManager:backTo("layout_vip")
            elseif event == POPUP_SELECT_EVENT_TYPE_NO then
            end
        end)
    end
end


-------------------------------------------------------------------
-- 返回语言文字
-- @id id
-------------------------------------------------------------------
function M:getLanguageById(id)
	return getLanguageById(id)
end

-------------------------------------------------------------------
-- 返回tip文字
-- @id id
-------------------------------------------------------------------
function M:getLanguageByTipId(id)
    return getLanguageById(cfgTip[id].language)
end

function M:getLanguageByTipIdFormat(id, ...)
    return string.format(getLanguageById(cfgTip[id].language), ...)
end

function M:getLanguageByErrorId(id, ...)
    return string.format(getLanguageById(cfgErrorcode[id].msg), ...)
end

---------------------------------------------------------------------------------------------
-- 获取/设置服务器时间
---------------------------------------------------------------------------------------------
local timeInterval = 0
function M:getServerTime()
	return os.time() - timeInterval
end
---------------------------------------------------------------------------------------------
-- 设置服务器时间
-- @time 毫秒级
---------------------------------------------------------------------------------------------
function M:setServerTime(time)
	timeInterval = os.time() - math.floor(time/1000)
end

-------------------------------------------------------------------
-- 返回一个枚举函数，枚举第一个数为number，默认为1
-------------------------------------------------------------------
function M:getEnumFunction(number)
	local n = number or 0
	if number == n then
		n = n - 1
	end
	return function ()
		n = n + 1
		return n
	end
end

---------------------------------------------------------------------------------------------
-- 将 Sprite 变灰
-- @spr cc.Sprite
---------------------------------------------------------------------------------------------
function M:greySprite(spr)
    if self.glGreyProgram then
        spr:setGLProgram(self.glGreyProgram)
    end
end

---------------------------------------------------------------------------------------------
-- 将 Sprite 变亮
-- @spr cc.Sprite
---------------------------------------------------------------------------------------------
function M:brightSprite(spr)
    if self.glBrightProgram then
        spr:setGLProgram(self.glBrightProgram)
    end
end

---------------------------------------------------------------------------------------------
-- 触发自定义事件
--@evtName  事件名字
--@data     事件携带的数据
---------------------------------------------------------------------------------------------
function M:triggerEventCustom(evtName, userData)
  --  local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    local event = cc.EventCustom:new(evtName)
    event.userData = data
    eventDispatcher:dispatchEvent(event)
end

---------------------------------------------------------------------------------------------
-- 将时间转化为 时分秒 00:00:00
-- t 时间 s
---------------------------------------------------------------------------------------------
function M:frmtTimeHHMMSS(t)
    local min = math.floor(t / 60)
    local sec = math.floor(t - min * 60)
    local hour = math.floor(min / 60)
    min = math.floor(min - hour * 60)
    return string.format("%02d:%02d:%02d", hour, min, sec)
end

---------------------------------------------------------------------------------------------
-- 将时间转化为 分秒 00:00
-- t 时间 s
---------------------------------------------------------------------------------------------
function M:frmtTimeMMSS(t)
    local min = math.floor(t / 60)
    local sec = math.floor(t - min * 60)
    local hour = math.floor(min / 60)
    min = math.floor(min - hour * 60) + hour * 60
    return string.format("%02d:%02d", min, sec)
end

---------------------------------------------------------------------------------------------
-- 将时间转化为 时分 00:00
-- t 时间 s
---------------------------------------------------------------------------------------------
function M:frmtTimeHHMM(t)
    local min = math.floor(t / 60)
    local hour = math.floor(min / 60)
    min = math.floor(min - hour * 60)
    return string.format("%02d:%02d", hour, min)
end

---------------------------------------------------------------------------------------------
-- 将时间转化为 时分 00:00
-- t 时间 s
---------------------------------------------------------------------------------------------
function M:frmtTimeHHMMChinese(t)
    local min = math.floor(t / 60)
    local hour = math.floor(min / 60)
    min = math.floor(min - hour * 60)
    return string.format(Utils:getLanguageByTipId(10881), hour, min)
end


---------------------------------------------------------------------------------------------
-- 将时间转化为 分，时，天返回
-- t 时间 s
---------------------------------------------------------------------------------------------
function M:changeTimeToMinHourDay(t)
    local min = math.floor(t / 60)
    local sec = math.floor(t - min * 60)
    local hour = math.floor(min / 60)
    min = min - hour * 60
    local day = math.floor(hour / 24)
    hour = hour - day * 24
    min = math.floor(min - hour * 60) + hour * 60
    return min, hour, day
end

---------------------------------------------------------------------------------------------
-- 将时间转化为 秒 分，时，天返回
-- t 时间 s
---------------------------------------------------------------------------------------------
function M:changeTimeToSecMinHourDay(t)
    local min = math.floor(t / 60)
    local sec = math.floor(t - min * 60)
    local hour = math.floor(min / 60)
    min = min - hour * 60
    local day = math.floor(hour / 24)
    hour = hour - day * 24
    min = math.floor(min - hour * 60) + hour * 60
    return sec, min, hour, day
end

---------------------------------------------------------------------------------------------
-- 获取倒计时时间 大于一天则(1天23:59) 小于一天(23:59:59)
---------------------------------------------------------------------------------------------
function M:frmtTimeCountdown1(t)
    local sec, min, hour, day = self:changeTimeToSecMinHourDay(t)

    if day > 0 then
        return string.format(self:getLanguageByTipId(10130), day, hour, min)
    elseif hour > 0 then
        return string.format(self:getLanguageByTipId(10131),hour, min, sec)
    elseif min > 0 then
        return string.format(self:getLanguageByTipId(10485), min, sec)
    else
        return string.format(self:getLanguageByTipId(10486), sec)
    end
end

---------------------------------------------------------------------------------------------
-- 获取倒计时时间 大于一天则(1天23:59) 小于一天(23:59:59)
---------------------------------------------------------------------------------------------
local min, sec, hour, day
function M:frmtTimeCountdown(t)
	if t < 0 then
		t = 0
	end
    min = math.floor(t / 60)
    sec = math.floor(t - min * 60)
    hour = math.floor(min / 60)
    min = math.floor(min - hour * 60)
    day = math.floor(hour/24)
    hour = hour - day*24
    if day > 0 then
    	return string.format(self:getLanguageByTipId(10130), day, hour, min)
    end
    return string.format(self:getLanguageByTipId(10131),hour, min, sec)
end

---------------------------------------------------------------------------------------------
-- 将时间转化为 年月日时分秒
-- return 年，月，日，时，分，秒。
---------------------------------------------------------------------------------------------
function M:getTimeDetails(serverTime)
	serverTime = math.floor(serverTime/1000)
	return {
		year = os.date("%Y", serverTime),
		month = os.date("%m", serverTime),
		day = os.date("%d", serverTime),
		hour = os.date("%H", serverTime),
		minute = os.date("%M", serverTime),
		second = os.date("%S", serverTime),
	}  
end

---------------------------------------------------------------------------------------------
-- 判断点是否在园内
---------------------------------------------------------------------------------------------
function M:inCircular(point1, point2, r)
	return (point1.x - point2.x)^2 + (point1.y - point2.y)^2 <= r^2
end


---------------------------------------------------------------------------------------------
-- 获取utf8字符串每个字
---------------------------------------------------------------------------------------------
function M:getUTF8StrTable(str)
    local t = {}
    local i = 1
    local c = string.byte(str, i)
    while c do
        c = string.byte(str, i)
        if not c then
            break
        end
        if (c<=0x7f) then -- 英文
            table.insert(t, string.sub(str,i,i))
            i = i + 1
        elseif bit.band(c, 0xE0) == 0xC0 then
            table.insert(t, string.sub(str,i,i+1))
            i = i + 2
        elseif bit.band(c, 0xF0) == 0xE0 then --中文
            table.insert(t, string.sub(str,i,i+2))
            i = i + 3
        elseif bit.band(c, 0xF8) == 0xF0 then
            table.insert(t, string.sub(str,i,i+3))
            i = i + 4
        else
            return error("不是utf8") --不是utf8 
        end
    end
    return t
end

---------------------------------------------------------------------------------------------
-- 获取utf8字符串宽，英文是1 中文是2
---------------------------------------------------------------------------------------------
function M:getUTF8StrWidth(str)
	local count = 0
	local i = 1
	local c = string.byte(str, i)
	while c do
		c = string.byte(str, i)
		if not c then
			break
		end
		count = count + 1
		if (c<=0x7f) then -- 英文
			i = i + 1
		elseif bit.band(c, 0xE0) == 0xC0 then
			i = i + 2
		elseif bit.band(c, 0xF0) == 0xE0 then --中文
			i = i + 3
			count = count + 1
		elseif bit.band(c, 0xF8) == 0xF0 then
			i = i + 4
		else
			return error("不是utf8") --不是utf8 
		end
	end
	return count
end
---------------------------------------------------------------------------------------------
-- 获取utf8字符串宽，英文是1 中文是2
---------------------------------------------------------------------------------------------
function M:insertLineToStr(str, len)
    local count = 0
    local i = 1
    local c = string.byte(str, i)
    local strs = {}
    local oldIdx = i
    while c do
        c = string.byte(str, i)
        if not c then
            table.insert(strs, string.sub(str, oldIdx, i))
            break
        end
        if count + 2 > len then
            table.insert(strs, string.sub(str, oldIdx, i-1))
            oldIdx = i
            count = 0
        end

        count = count + 1
        if (c<=0x7f) then -- 英文
            i = i + 1
        elseif bit.band(c, 0xE0) == 0xC0 then
            i = i + 2
        elseif bit.band(c, 0xF0) == 0xE0 then --中文
            i = i + 3
            count = count + 1
        elseif bit.band(c, 0xF8) == 0xF0 then
            i = i + 4
        else
            return error("不是utf8") --不是utf8 
        end
    end
    return table.concat(strs, "\n"), #strs
end

---------------------------------------------------------------------------------------------
-- return 正数 +1, 负数-1
---------------------------------------------------------------------------------------------
function M:getNumberString(number)
	if number >= 0 then
		return "+"..number
	end
	return tostring(number)
end


---------------------------------------------------------------------------------------------
-- 条件筛选
---------------------------------------------------------------------------------------------
function M:pick(table,find)
    local ret = {}
    for k,v in pairs(table) do
        local isPick = find(k,v)
        if isPick then
            ret[#ret + 1] = v
        end
    end
    return ret
end
---------------------------------------------------------------------------------------------
-- 折半查找
---------------------------------------------------------------------------------------------
function M:serch(table,checker,startIndex,endIndex)
    if startIndex == nil then
        startIndex = 1
    end
    if endIndex == nil then
        endIndex = #table
    end
    local  m = math.ceil((startIndex + endIndex)/2)
    local ret = checker(table[m])
    if m == endIndex and ret ~= 0 then
        if checker(table[startIndex])  == 0  then
            return startIndex,table[startIndex]
        else
            return nil
        end
    end
    if ret == 0 then
        return m,table[m]
    elseif ret == -1 then
        return self:serch(table,checker,startIndex,m)
    elseif ret == 1 then
        return self:serch(table,checker,m,endIndex)
    end
end

---------------------------------------------------------------------------------------------
-- 退出游戏
---------------------------------------------------------------------------------------------
function M:exit()
    Utils:promptMsgBox2(Utils:getLanguageByTipId(10152), function (event)
        if event == POPUP_SELECT_EVENT_TYPE_YES then
            Utils:endGameWithOutSdkExitUI()
        elseif event == POPUP_SELECT_EVENT_TYPE_NO then
        end
    end)
end

---------------------------------------------------------------------------------------------
-- 结束游戏
---------------------------------------------------------------------------------------------
function M:endGame()
    return cc.Director:getInstance():endToLua()
end


---------------------------------------------------------------------------------------------
-- 获取星期几
---------------------------------------------------------------------------------------------
function M:getWeek()
    return tonumber(os.date("%w", self:getServerTime()))
end

---------------------------------------------------------------------------------------------
-- 获取网络图片存放地址
---------------------------------------------------------------------------------------------
cc.FileUtils:getInstance():createDirectory(SAVE_SEARCH_PATHS[1].."webImage/");--web图片用
function M:getWebImageSavePath()
    return SAVE_SEARCH_PATHS[1].."/webImage/"
end

---------------------------------------------------------------------------------------------
-- 设置网络图片
---------------------------------------------------------------------------------------------
local webImageDefault = "gongneng/hdtb_dqz.png"
local ImagetransparentDefault = "gongneng/transparent.png"
local webImageDefaultName = "webImageDefaultName"
function M:setWebImageToImageView(imageView, fileName, func)
    if #fileName == 0 then
        print("网络图片名字为nil")
        return 
    end
    local strType = string.sub(fileName, -4)
    if not (strType == ".png" or strType == ".jpg") then
        print("网络图片名字类型错误，只能是png或者jpg")
        return
    end
    imageView:removeChildByName(webImageDefaultName)
    local saveToPath = Utils:getWebImageSavePath()..fileName
    if cc.FileUtils:getInstance():isFileExist(saveToPath) then
        imageView:loadTexture(saveToPath)
        if func then
            func()
        end
    else
        -- 从网上下载
        local image = ccui.ImageView:create(webImageDefault)
        image:setName(webImageDefaultName)
        imageView:addChild(image)
        image:setPosition(cc.p(imageView:getContentSize().width/2, imageView:getContentSize().height/2))

        imageView:loadTexture(ImagetransparentDefault)
        ImageDownloaderCreate(GAME_RESOURCES_SERVER_PORT..fileName, function (statusCode, image)
            if statusCode==200 then
                --直接创建请求的网络图片精灵，不用再保存到本地，很方便的
                if not cc.FileUtils:getInstance():isFileExist(saveToPath) then
                    image:saveToFile(saveToPath)
                end
                if not tolua.isnull(imageView) then
                    imageView:removeChildByName(webImageDefaultName)
                    imageView:loadTexture(saveToPath)
                    if func then
                        func()
                    end
                end
            end
        end)
    end
end

---------------------------------------------------------------------------------------------
-- 根据名字返回节点
---------------------------------------------------------------------------------------------
function M:initChild(root,target)
    local children = target:getChildren()
    for k,v in pairs(children) do
        local name = v:getName()
        if name and name ~="" then
            root[name] = v
            self:initChild(v,v)
        end
    end
end

---------------------------------------------------------------------------------------------
-- 公共提示框
---------------------------------------------------------------------------------------------
function M:messageBox1(strContent, callback, buttonTextTab)
    LayoutManager:open("PopupMsg1", strContent, callback, buttonTextTab)
end

function M:messageBox2(strContent, callback, buttonTextTab)
    LayoutManager:open("PopupMsg2", strContent, callback, buttonTextTab)
end

function M:messageBox3(strContent, callback, buttonTextTab)
    LayoutManager:open("PopupMsg3", strContent, callback, buttonTextTab)
end

---------------------------------------------------------------------------------------------
-- 提示
-- @text 文字
---------------------------------------------------------------------------------------------
function M:prompt(text, color, lineColor, time)
    local scene = SceneManager:getRunningScene()
    local lable = ccui.Text:create(text,"font/default.ttf", 35)
    lable:setAnchorPoint(cc.p(0.5,0.5))
    lable:setLocalZOrder(LayoutManager.config.ZORDER_MAX)  -- 弹窗会把提示文字盖住。所以设置 z order
    lable:setPosition(cc.p(display.cx,  display.cy))
    lable:setTextColor(color or COLOR.TIP)
    lable:enableOutline(lineColor or cc.c4b(0,0,0,255),2) -- cc.c4b(89,10,10,255)
    -- local moveAct = cc.EaseExponentialOut:create(cc.MoveBy:create(1.5, cc.p(0, 300)))
    -- local fadeAct = cc.FadeOut:create(1)
    -- local function actionEnd( ... )
    --  lable:removeFromParent(true)
    -- end
    -- local actionsq = cc.Sequence:create(moveAct,cc.CallFunc:create(actionEnd))
    -- lable:runAction(actionsq)
    -- lable:runAction(fadeAct)

    local time = time or 1
    lable:runAction(cc.Sequence:create(
                            cc.Show:create(),
                            cc.DelayTime:create(time),
                            cc.Spawn:create(
                                cc.MoveBy:create(0.5,cc.p(0,50)),
                                cc.FadeOut:create(0.5)
                            ),
                            cc.CallFunc:create(function() 
                                lable:removeFromParent(true)
                            end)
                            -- cc.RemoveSelf:create(true)
    ))

    -- if scene.__cname == "LoadScene" then
    --     lable:retain()
    --     table.insert(promptList, lable)
    -- else
    --     scene:addMessageTip(lable)
    -- end
    scene:addMessageTip(lable)
end

function M:promptById(id, ...)
    return self:prompt(string.format(self:getLanguageById(id), ...))
end
function M:promptByTipId(id, ...)
    return self:prompt(string.format(self:getLanguageByTipId(id), ...))
end
function M:promptByErrorCode(id)
    local str = Utils:getLanguageByErrorId(id)
    return self:prompt(str)
end

return M:init() or M