---------------------------------------------------------------------------------------------
-- 姓名：动画
-- 日期：2016年10月9日
-- 功能：动画相关的
-- 备注： 
---------------------------------------------------------------------------------------------
local M = class("Animation")
local cfgLayoutAnimotion = cfgLayoutAnimotion
local configInfo = {}


---------------------------------------------------------------------------------------------
-- 配置表分离
---------------------------------------------------------------------------------------------
-- local _type
-- for id, info in pairs(cfgLayoutAnimotion) do
-- 	_type = info.type
-- 	configInfo[_type] = configInfo[_type] or {}
-- 	table.insert(configInfo[_type], info)
-- end

---------------------------------------------------------------------------------------------
-- 添加动画
-- Animation:addActionScaleToNode(nodes.imageUpgrade)
---------------------------------------------------------------------------------------------
function M:addToNode(node, _type, position)
	local nodeAnimation, actionAnimation
	local FileUtils = cc.FileUtils:getInstance()
	for i, data in ipairs(configInfo[_type] or {}) do
		if not FileUtils:isFileExist(data.csb) then
			error("error:动画文件不存在:"..data.csb)
			return 
		end
		log("添加动画 type = %s,= %s", _type, data.csb)
		nodeAnimation = cc.CSLoader:createNode(data.csb)
	   	actionAnimation = cc.CSLoader:createTimeline(data.csb) -- ccs.ActionTimeline
		nodeAnimation:setLocalZOrder(data.z)
	    nodeAnimation:setPosition(cc.p(data.x - position.x, data.y - position.y))
	    -- print("data.id = ",data.id)
	    nodeAnimation:setName(data.csb)
		node:addChild(nodeAnimation)
	    nodeAnimation:runAction(actionAnimation)
	   	if data.forever == 1 then
	    	actionAnimation:gotoFrameAndPlay(0, true)
	    else
	    	actionAnimation:gotoFrameAndPlay(0, false)
	    end
	    nodeAnimation:setScaleX(data.scaleX)
	end
end

---------------------------------------------------------------------------------------------
-- 获取csb路径
---------------------------------------------------------------------------------------------
function M:getCsbPath(id)
	return cfgLayoutAnimotion[id].path
end
function M:getCsbPathByGroup(id)
	local t = {}
	for i,data in ipairs(configInfo[id] or {}) do
		table.insert(t, data.path)
	end
	return t
end
---------------------------------------------------------------------------------------------
-- 创建一个动画 播放一次就自动移除节点
-- local node = Animation:createAnimationPlayOne("animotion_zizhi_xiulian.csb")
-- self:addChild(node)
---------------------------------------------------------------------------------------------
function M:createAnimationPlayOne(csb, callback)
	log("创建动画 = %s", csb)
	local nodeAnimation = cc.CSLoader:createNode(csb)
	local actionAnimation = cc.CSLoader:createTimeline(csb) -- ccs.ActionTimeline
    local function onFrameEvent()
    	if callback then
    		callback()
    	end
    	nodeAnimation:removeFromParent()
    end
    actionAnimation:setLastFrameCallFunc(onFrameEvent)
	nodeAnimation:runAction(actionAnimation)
	actionAnimation:gotoFrameAndPlay(0, false)
	return nodeAnimation
end
function M:createAnimationPlayOneById(idx, callback)
	local data = cfgLayoutAnimotion[idx]
	local node = self:createAnimationPlayOne(data.csb, callback)
	node:setPosition(cc.p(data.x, data.y))
	return node
end

---------------------------------------------------------------------------------------------
-- 创建一个动画
---------------------------------------------------------------------------------------------
function M:createAnimationPlay(csb)
	log("创建动画 = %s", csb)
	local nodeAnimation = cc.CSLoader:createNode(csb)
	local actionAnimation = cc.CSLoader:createTimeline(csb) -- ccs.ActionTimeline
	nodeAnimation:runAction(actionAnimation)
	actionAnimation:gotoFrameAndPlay(0, true)
	return nodeAnimation
end
function M:createAnimationPlayById(idx)
	local data = cfgLayoutAnimotion[idx]
	local node = self:createAnimationPlay(data.csb)
	node:setPosition(cc.p(data.x, data.y))
	return node
end

---------------------------------------------------------------------------------------------
-- 创建一个动画
---------------------------------------------------------------------------------------------
function M:createAnimationPlay1(csb)
	log("创建动画 = %s", csb)
	local nodeAnimation = cc.CSLoader:createNode(csb)
	local actionAnimation = cc.CSLoader:createTimeline(csb) -- ccs.ActionTimeline
	nodeAnimation:runAction(actionAnimation)
	actionAnimation:gotoFrameAndPlay(0, false)
	return nodeAnimation
end
function M:createAnimationPlayById1(idx)
	local data = cfgLayoutAnimotion[idx]
	local node = self:createAnimationPlay1(data.csb)
	node:setPosition(cc.p(data.x, data.y))
	return node
end

---------------------------------------------------------------------------------------------
-- 添加动画 放大还原动画
---------------------------------------------------------------------------------------------
local sp1, sp2, seq, scaleTo, repeatForever, actionbyback
function M:addActionScaleToNodeByTip(node)
	local sp1 = node:getChildByName("Sprite_1")
	local sp2 = node:getChildByName("Sprite_2")
	if not sp1 or not sp2 then
		return
	end
	sp1:runAction(cc.Sequence:create(
						cc.DelayTime:create(math.random(0, 0)/100), 
						cc.CallFunc:create(function ()
							sp1:runAction(cc.RepeatForever:create(cc.Sequence:create(
								cc.ScaleTo:create(0.15, 0.58), 
								cc.ScaleTo:create(0.1, 0.7),
								cc.ScaleTo:create(0.15, 0.81),
								cc.ScaleTo:create(0.25, 0.93),
								cc.ScaleTo:create(0.4, 1),
								cc.ScaleTo:create(0.2, 0.93),
								cc.ScaleTo:create(0.15, 0.88),
								cc.ScaleTo:create(0.1, 1)
							)))
							sp2:runAction(cc.RepeatForever:create(cc.Sequence:create(
								cc.ScaleTo:create(0.65, 0.88),
								cc.ScaleTo:create(0.4, 0.93),
								cc.ScaleTo:create(0.1, 1)
							)))
						end)));
end
function M:addActionScaleToNodeByChat(node)
	scaleTo = cc.ScaleTo:create(0.5, 1.5);
	actionbyback = cc.ScaleTo:create(0.5, 1);
	seq = cc.Sequence:create(scaleTo, actionbyback)
	repeatForever = cc.RepeatForever:create(seq)
	return node:runAction(repeatForever);
end
function M:addActionScaleToNode(node)
	scaleTo = cc.ScaleTo:create(0.5, 1.1);
	actionbyback = cc.ScaleTo:create(0.5, 1);
	seq = cc.Sequence:create(scaleTo, actionbyback)
	repeatForever = cc.RepeatForever:create(seq)
	return node:runAction(repeatForever);
end
function M:addActionMoveUpAndDownNode(node)
	local ac1 = cc.MoveBy:create(1.2, cc.p(0, 5));
	local ac2 = cc.MoveBy:create(1.2, cc.p(0, -5));
	seq = cc.Sequence:create(ac1, ac2)
	repeatForever = cc.RepeatForever:create(seq)
	return node:runAction(repeatForever);
end

function M:addActionMoveUpAndDownNode1(node)
	local ac1 = cc.MoveBy:create(0.7, cc.p(0, 5));
	local ac2 = cc.MoveBy:create(1.2, cc.p(0, -5));
	seq = cc.Sequence:create(ac1, ac2)
	repeatForever = cc.RepeatForever:create(seq)
	return node:runAction(repeatForever);
end

function M:addActionFightforceChange(node)
	local ac1 = cc.MoveBy:create(0.3, cc.p(0, 10));
	local ac2 = cc.MoveBy:create(0.3, cc.p(0, -10));
	seq = cc.Sequence:create(ac1, ac2)
	repeatForever = cc.RepeatForever:create(seq)
	return node:runAction(repeatForever);
end

function M:addActionMoveUpAndDownNode2(node)
	local ac1 = cc.MoveBy:create(0.5, cc.p(0, -6));
	local ac2 = cc.MoveBy:create(0.5, cc.p(0, 6));
	seq = cc.Sequence:create(ac1, ac2)
	repeatForever = cc.RepeatForever:create(seq)
	return node:runAction(repeatForever);
end

function M:addActionMoveUpAndDownNode3(node)
	local ac1 = cc.MoveBy:create(0.4, cc.p(0, 8));
	local ac2 = cc.MoveBy:create(0.6, cc.p(0, -8));
	seq = cc.Sequence:create(ac1, ac2)
	repeatForever = cc.RepeatForever:create(seq)
	return node:runAction(repeatForever);
end
---------------------------------------------------------------------------------------------
-- 添加 装备动画
---------------------------------------------------------------------------------------------
local equipEffectAnimationName = "equipEffectAnimationName"
local showLv1 = 5
local showLv2 = 9
local animation
local equipEffectId = {
	{87, 88},--绿色
	{85, 86},--蓝色
	{89, 90},--紫色
	{81, 82},--橙色
	{83, 84},--红色
}
local ids
function M:equipEffectAddToNode(item, node)
	node:removeChildByName(equipEffectAnimationName)
	ids = equipEffectId[item:getQua()]
	if item:getStrongLevel() >= showLv2 then
    	animation = Animation:createAnimationPlayById(ids[2])
	elseif item:getStrongLevel() >= showLv1 then
    	animation = Animation:createAnimationPlayById(ids[1])
    else
    	animation = nil
	end
	if animation then
		animation:setName(equipEffectAnimationName)
	    animation:setPosition(cc.p(node:getContentSize().width/2, node:getContentSize().height/2))
	    node:addChild(animation)
	end
end

---------------------------------------------------------------------------------------------
-- 创建动画
---------------------------------------------------------------------------------------------
function M:createSpine(json, atlas, animationName)
	local skeletonNode = sp.SkeletonAnimation:create(json, atlas)
	if animationName then
		skeletonNode:setAnimation(0, animationName, true)
	end
	return skeletonNode
end

---------------------------------------------------------------------------------------------
-- 创建动画
---------------------------------------------------------------------------------------------
local animation, size, level, _type, jhAttCount, grade
function M:addEquipEffect(node, item)
	node:removeChildByName(ANIMATION_EQUIP_TUNSHI)
	node:removeChildByName(ANIMATION_EQUIP_JINGHUA)
	if not item then
		return
	end
	--吞噬满级时
	_type = item:getEquipMagicAttType()
	if _type and _type ~= 0 then
		level = item:getEquipMagicLevel()
		if level >= 0 and level <= 10 then
        	animation = Animation:createAnimationPlayById(100)
		elseif level >= 11 and level <= 20 then
        	animation = Animation:createAnimationPlayById(101)
		elseif level >= 21 and level <= 30 then
        	animation = Animation:createAnimationPlayById(102)
        else
        	animation = Animation:createAnimationPlayById(113)
		end
		if animation then
	        node:addChild(animation)
	        size = node:getContentSize()
	        animation:setPosition(size.width/2, size.height/2)
	        animation:setName(ANIMATION_EQUIP_TUNSHI)
	    end
	end

	--净化满级时
	animation = nil
	jhAttCount = #item:getEquipJhAtt()
	if jhAttCount == 4 then
		grade = item:getEquipGrade()
		if grade == 1 then
			animation = Animation:createAnimationPlayById(103)
		elseif grade == 2 then
			animation = Animation:createAnimationPlayById(104)
		elseif grade == 3 then
			animation = Animation:createAnimationPlayById(105)
		else
			animation = Animation:createAnimationPlayById(112)
		end
		node:addChild(animation)
	    size = node:getContentSize()
	    animation:setPosition(size.width/2, size.height/2)
	    animation:setName(ANIMATION_EQUIP_JINGHUA)
	end
end
function M:removeEquipEffect(node)
	node:removeChildByName(ANIMATION_EQUIP_TUNSHI)
	node:removeChildByName(ANIMATION_EQUIP_JINGHUA)
end

---------------------------------------------------------------------------------------------
-- 创建动画
---------------------------------------------------------------------------------------------
function M:createSpine(json, atlas, animationName)
	local skeletonNode = sp.SkeletonAnimation:create(json, atlas)
	if animationName then
		skeletonNode:setAnimation(0, animationName, true)
	end
	return skeletonNode
end


---------------------------------------------------------------------------------------------
-- 创建动画
---------------------------------------------------------------------------------------------
local names = {"wuping1", "wuping2", "wuping3", "wuping4", "wuping5", "wuping6", "wuping7", "wuping8"}
local nodeItem, item, animation
local rowMax = 4
local intervalX = 58 -- 间隔
local width = 146*0.61 --宽
local centerX = 8
local pos = LayoutBase:getCenterPos()
function M:createGetItemAnimation(items, callback)
	local itemCount = #items
	if itemCount > 8 then
		itemCount = 8
	end
	local even = itemCount%2 == 0
	if itemCount <= rowMax then
    	animation = Animation:createAnimationPlayOneById(99, callback)
    	for i=1, itemCount do
    		nodeItem = animation:getChildByName(names[i])
    		nodeItem:setPositionX((width + intervalX)*(i - itemCount) + centerX + (width + intervalX)/2*(itemCount - 1))
    	end
	else
    	animation = Animation:createAnimationPlayOneById(25, callback)
    	itemCount = itemCount - rowMax
    	for i = 1, itemCount do
    		-- nodeItem = animation:getChildByName(names[i + rowMax])
    		nodeItem = animation:getChildByName(names[i + rowMax] or names[#names])
    		nodeItem:setPositionX((width + intervalX)*(i - itemCount) + centerX + (width + intervalX)/2*(itemCount - 1))
    	end
	end
    for i, name in ipairs(names) do
    	nodeItem = animation:getChildByName(name)
    	item = items[i]
    	if nodeItem then
	    	if item then
		    	nodeItem:loadTexture(item:getQuaIcon())
		    	item:updateGrid(nodeItem)
		    	nodeItem:getChildByName("Text_1"):setString(item:getName())
		    	-- nodeItem:getChildByName("shuliang"):setString(item:getCount())
		    	-- nodeItem:getChildByName("mingzi"):setString(item:getName())
		    else
		    	nodeItem:setVisible(false)
		    end
		end
    end

    local nodeBg = animation:getChildByName("Panel_1")
    nodeBg:setTouchEnabled(true)
    animation:runAction(cc.Sequence:create(cc.DelayTime:create(0.8), cc.CallFunc:create(function()
            Utils:registeredClickEvent(nodeBg, function ()
            	if callback then
            		callback()
            	end
            	animation:removeFromParent()
            end)
        end)))
    SoundManager:playEffect(32)

    local scene = SceneManager:getRunningScene()
    if scene then
    	scene:addChild(animation)
    	animation:setPosition(pos)
    	animation:setLocalZOrder(LayoutManager.ZORDER_UI_TOP_GUIDE2)
    end

    -- return animation
end

---------------------------------------------------------------------------------------------
-- 添加动画到背包格子里
---------------------------------------------------------------------------------------------
local effectId
function M:addGoodsEffect(node, item)
	if item then
		effectId = item:getEffectId()
	else
		effectId = nil
	end
	node:removeChildByName(ANIMATION_BACKPACK_ITEM)
	if not effectId then -- 没有特效
		return
	end
    local animation = Animation:createAnimationPlayById(effectId)
    node:addChild(animation)
    local size = node:getContentSize()
    animation:setPosition(size.width/2, size.height/2)
    animation:setName(ANIMATION_BACKPACK_ITEM)
end
function M:removeGoodsEffect(node)
	node:removeChildByName(ANIMATION_BACKPACK_ITEM)
end


---------------------------------------------------------------------------------------------
-- 领取按钮特效
-- @node
-- @is 添加 or 删除
---------------------------------------------------------------------------------------------
function M:addReceiveGoodsEffect(node, is)
	node:removeChildByName(ANIMATION_RECEIVE_GOODS)
    if is then
        local animation = Animation:createAnimationPlayById(107)
        node:addChild(animation)
        local size = node:getContentSize()
        animation:setPosition(size.width/2, size.height/2)
        local animationSize = animation:getChildByName("Sprite_1"):getContentSize()
        animation:setName(ANIMATION_RECEIVE_GOODS)
        -- animation:setScaleX(size.width/animationSize.width + 13/70)
        -- animation:setScaleY(size.height/animationSize.height + 15/40)

        animation:setScaleX((size.width + 22)/animationSize.width)
        animation:setScaleY((size.height + 26)/animationSize.height)
    end
end


---------------------------------------------------------------------------------------------
-- 领取按钮特效 大
-- @node
-- @is 添加 or 删除
---------------------------------------------------------------------------------------------
function M:addReceiveGoodsEffect1(node, is)
	node:removeChildByName(ANIMATION_RECEIVE_GOODS)
    if is then
        local animation = Animation:createAnimationPlayById(107)
        node:addChild(animation)
        local size = node:getContentSize()
        animation:setPosition(size.width/2, size.height/2)
        animation:setName(ANIMATION_RECEIVE_GOODS)
    end
end

---------------------------------------------------------------------------------------------
-- 特殊战斗胜利
---------------------------------------------------------------------------------------------
local fight_shengli_winpin_names = {"wupin1", "wupin2", "wupin3", "wupin4", "wupin5", "wupin6", "wupin7", "wupin8"}
local name_count = #fight_shengli_winpin_names
function M:specialFightSuccess(FightOverPOD, items)
	-- 将经验、银两、真气、声望当物品处理
    if FightOverPOD.exp and FightOverPOD.exp > 0 then -- 经验
    	table.insert(items, ItemManager:createStaticItem(10207001, FightOverPOD.exp))
    end
    if FightOverPOD.money and FightOverPOD.money > 0 then -- 金币
    	table.insert(items, ItemManager:createStaticItem(10204001, FightOverPOD.money))
    end
    if FightOverPOD.zhenqi and FightOverPOD.zhenqi > 0 then -- 真气
    	table.insert(items, ItemManager:createStaticItem(10208001, FightOverPOD.zhenqi))
    end
    if FightOverPOD.prestige and FightOverPOD.prestige > 0 then -- 获得声望
    	table.insert(items, ItemManager:createStaticItem(10211001, FightOverPOD.prestige))
    end

	local itemCount = math.min(#items, name_count)
	-- local animationNode = Animation:createAnimationPlayById1(110)
	local animationNode = Animation:createAnimationPlayOneById(110, function ()
		-- body
    	 Combat:specialFightBackPreUI(true)
	end)

	-- 显示物品
    for i = 1, itemCount do
    	local itemNode = animationNode:getChildByName(fight_shengli_winpin_names[i])
    	itemNode:setVisible(true)
    	items[i]:updateGrid(itemNode)
    	-- 设置名字
    	local txtName = itemNode:getChildByName("mingzi_0")
    	txtName:setString(items[i]:getName())
    	itemNode:runAction(cc.Sequence:create(cc.DelayTime:create(0.25), cc.CallFunc:create(function ()
    		-- body
    		itemNode:setOpacity(255)
    	end)))
    end
    local itemNode = nil
    -- 显示排名
    local txtTip = animationNode:getChildByName("Text_19")
    if FightOverPOD.pvprank and FightOverPOD.pvprank > 0 then -- 竞技场排名
        txtTip:setString(Utils:getLanguageByTipId(10417)..FightOverPOD.pvprank)
        txtTip:setVisible(true)
    elseif FightOverPOD.jobPvpRank and FightOverPOD.jobPvpRank > 0 then -- 职业竞技场排名
        txtTip:setString(Utils:getLanguageByTipId(10418)..FightOverPOD.jobPvpRank)
        txtTip:setVisible(true)
    elseif FightOverPOD.society_score and FightOverPOD.society_score > 0 then -- 帮派会战积分
        txtTip:setString(Utils:getLanguageByTipId(10421)..FightOverPOD.society_score)
        txtTip:setVisible(true)    
    elseif FightOverPOD.ladderScore then 	-- 武林大会
		local str = Utils:getLanguageByTipId(10906)
    	if FightOverPOD.ladderScore < 0 then
    		str = Utils:getLanguageByTipId(10907)
    	end
		txtTip:setString(str..math.abs(FightOverPOD.ladderScore))
        txtTip:setVisible(true)
    else
    	txtTip:setVisible(false)
    end

    if itemCount > 0 then
    	-- 调整物品的位置
    	local row = itemCount / 4
    	if row < 1 then
    		local item_padding = 16		-- 物体间的间隔
    		local item_width = animationNode:getChildByName(fight_shengli_winpin_names[1]):getContentSize().width -- 物体的宽度
    		-- 不足一行才处理。
    		-- 大于等于一行默认的排序就可以了
    		local even = itemCount % 2
    		if even > 0 then
    			-- 奇数个物体
    			local padding_width_sum = item_padding + item_width
    			-- 第一个单独处理
				itemNode = animationNode:getChildByName(fight_shengli_winpin_names[1])
				itemNode:setPositionX(0)
				-- 处理其余的
    			for i = 2, itemCount, 2 do
    				itemNode = animationNode:getChildByName(fight_shengli_winpin_names[i])
    				itemNode:setPositionX((i - 1) * padding_width_sum )

    				itemNode = animationNode:getChildByName(fight_shengli_winpin_names[i + 1])
    				itemNode:setPositionX(-(i - 1) * padding_width_sum)
    			end
    		else
    			-- 偶数个物体
    			local half_padding_width_sum = (item_padding + item_width) * 0.5
    			local idx = 0
    			for i = 1, itemCount, 2 do
    				idx = 2 * (i - 1) + 1
    				itemNode = animationNode:getChildByName(fight_shengli_winpin_names[i])
    				itemNode:setPositionX(-idx * half_padding_width_sum)

    				itemNode = animationNode:getChildByName(fight_shengli_winpin_names[i + 1])
    				itemNode:setPositionX(idx * half_padding_width_sum)
    			end
    		end
    	end
    elseif itemCount <= 0 then
    	-- 隐藏获得奖励的图片
    	local png = animationNode:getChildByName("qi")
    	png:setVisible(false)
	end

    -- 隐藏物品
    for i = itemCount + 1, name_count do
    	itemNode = animationNode:getChildByName(fight_shengli_winpin_names[i])
    	itemNode:setVisible(false)
    end

    -- 添加背景触摸
    local nodeBg = animationNode:getChildByName("Panel_1")
    nodeBg:setTouchEnabled(true)
    animationNode:runAction(cc.Sequence:create(cc.DelayTime:create(0.8), cc.CallFunc:create(function()
            Utils:registeredClickEvent(nodeBg, function ()
            	Combat:specialFightBackPreUI(true)
            	animationNode:removeFromParent()
            end)
        end)))
    SoundManager:playEffect(32)

    -- 节点添加到场景
    local scene = SceneManager:getRunningScene()
    if scene then
    	scene:addChild(animationNode)
    	animationNode:setPosition(pos)
    	animationNode:setLocalZOrder(LayoutManager.ZORDER_UI_TOP_GUIDE2)
    end
end

---------------------------------------------------------------------------------------------
-- 特殊战斗失败
---------------------------------------------------------------------------------------------
function M:specialFightFailure(FightOverPOD)

	-- local animationNode = Animation:createAnimationPlayById1(111)
	local animationNode = Animation:createAnimationPlayOneById(111, function ()
		-- body
    	 Combat:specialFightBackPreUI(false)
	end)
    -- 显示排名
    local txtTip = animationNode:getChildByName("Text_19")
    if FightOverPOD.pvprank and FightOverPOD.pvprank > 0 then -- 竞技场排名
        txtTip:setString(Utils:getLanguageByTipId(10417)..FightOverPOD.pvprank)
        txtTip:setVisible(true)
    elseif FightOverPOD.jobPvpRank and FightOverPOD.jobPvpRank > 0 then -- 职业竞技场排名
        txtTip:setString(Utils:getLanguageByTipId(10418)..FightOverPOD.jobPvpRank)
        txtTip:setVisible(true)
    elseif FightOverPOD.society_score and FightOverPOD.society_score > 0 then -- 帮派会战积分
        txtTip:setString(Utils:getLanguageByTipId(10421)..FightOverPOD.society_score)
        txtTip:setVisible(true)
    elseif FightOverPOD.ladderScore then 	-- 武林大会
		local str = Utils:getLanguageByTipId(10906)
    	if FightOverPOD.ladderScore < 0 then
    		str = Utils:getLanguageByTipId(10907)
    	end
		txtTip:setString(str..math.abs(FightOverPOD.ladderScore))
        txtTip:setVisible(true)
    else
    	txtTip:setVisible(false)
    end

    if FightOverPOD.type == Combat.CB_TYPE_SOCIETY_WAR then
    	local nodeStrong = animationNode:getChildByName("Node_1")
    	local pngStrong = animationNode:getChildByName("qi")
    	nodeStrong:setVisible(false)
    	pngStrong:setVisible(false)
    end

    -- 添加背景触摸
    local nodeBg = animationNode:getChildByName("Panel_1")
    nodeBg:setTouchEnabled(true)
    animationNode:runAction(cc.Sequence:create(cc.DelayTime:create(0.8), cc.CallFunc:create(function()
            Utils:registeredClickEvent(nodeBg, function ()
            	Combat:specialFightBackPreUI(false)
            	animationNode:removeFromParent()
            end)
        end)))
    SoundManager:playEffect(32)

    -- 节点添加到场景
    local scene = SceneManager:getRunningScene()
    if scene then
    	scene:addChild(animationNode)
    	animationNode:setPosition(pos)
    	animationNode:setLocalZOrder(LayoutManager.ZORDER_UI_TOP_GUIDE2)
    end
end

return M