local Loading = class("Loading", cc.load("mvc").ViewBase)

function Loading:onCreate()
    self.director = cc.Director:getInstance()
	self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
 
    self.bg = cc.Sprite:create("bg/bg.png")
    self.bg:setPosition(cc.p(0,0))
    self.bg:setAnchorPoint(cc.p(0,0))
    self.bg:addTo(self)
    UItool:setBool("merge", true) -- 物品栏是否可以点击
    UItool:setBool("topbar",false)

    -- local button = ccui.Button:create("bu_back1.png","bu_back1.png")
    -- button:setAnchorPoint(cc.p(1,1))
    -- button:setPosition(cc.p(self.visibleSize.width - button:getContentSize().width + 30 , self.visibleSize.height/1.03))        
    -- self:addChild(button)
    -- button:setSwallowTouches(true)

    -- for i=1,10 do
        -- ModifyData.tableinsert(13)
        -- ModifyData.tableinsert(1)
        -- ModifyData.tableinsert(12)
        -- ModifyData.tableinsert(2)
        -- ModifyData.tableinsert(5)
        -- ModifyData.tableinsert(3)
        -- ModifyData.tableinsert(6)
        -- ModifyData.tableinsert(10)


    -- end

    -- button:addClickEventListener(function ( psender,event )
    --     if  UItool:getBool("merge") then
    --         if #ModifyData.getTable() == 0    then
    --         UItool:message2("你的物品栏是空的",30)
    --         else
    --             -- UItool:setBool("merge", false)
    --             self.merge = Merge:createScene()
    --             self:addChild(self.merge,5)
    --         end
    --     end
        
    -- end)

    -- local item = ccui.Button:create("bu_back1.png","bu_back1.png")
    -- item:setAnchorPoint(cc.p(1,1))
    -- item:setPosition(cc.p(300 , 300))        
    -- self:addChild(item,10)
    -- item:setSwallowTouches(true)

    -- item:addClickEventListener(function ( psender,event )
    --     self.merge:removeSelf()
    --     local key_item = Data.getItemData(5)
    --     ModifyData.tableinsert(key_item.key)
    --     self.merge = Merge:createScene()
    --     self:addChild(self.merge,5)
    -- end)

    -- local aaa= cc.Sprite:create("comm/setting.png")
    -- aaa:setPosition(cc.p(100,100))
    -- self:addChild(aaa)
    -- local momo=cc.MoveTo:create(15, cc.p(1000,900))
    -- aaa:runAction(momo)
    
--测试物品栏
    -- for i=1,7 do
        -- ModifyData.tableinsert(11)
        --  ModifyData.tableinsert(3)
        --   -- ModifyData.tableinsert(8)
        --    ModifyData.tableinsert(9)
        --    ModifyData.tableinsert(1)
    -- end

    local function wardrobecallback( )
        UItool:setBool("topbar",false)
        local scene = Mainscene.new()
		local turn = cc.TransitionPageTurn:create(0.5, scene, false)
		cc.Director:getInstance():replaceScene(turn)
        
    end

    local acount = 1
    local function settingcallback( )
        -- local timer = TimerExBuf()
        -- timer:create(3,1,1)
        -- function timer:onTime()
        --     UItool:message("设置",45)
        --     timer:stop()
        -- end
        -- timer:start()



        -- UItool:message2("测试是否有效"..acount,30)
        -- acount = acount +1

        -- local PlayerLayer = PlayerLayer:createScene()
        -- print("进入拼图界面", PlayerLayer)
        -- self:addChild(PlayerLayer,125)
    end
    
    self.wardrobe=cc.MenuItemImage:create("comm/start.png","comm/start.png")
    self.wardrobe:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2+100))
    self.wardrobe:setAnchorPoint(cc.p(0.5,0.5))
    self.wardrobe:setScale(2)
    -- 对该按钮注册按键响应函数：
    self.wardrobe:registerScriptTapHandler(wardrobecallback)

    self.setting = cc.MenuItemImage:create("comm/setting.png","comm/setting.png")
    self.setting:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2-100))
    self.setting:setAnchorPoint(cc.p(0.5,0.5))
    self.setting:setScale(2)
    -- 对该按钮注册按键响应函数：
    self.setting:registerScriptTapHandler(settingcallback)

    local menu=cc.Menu:create(self.wardrobe,self.setting)
    menu:setPosition(0,0) 
    self:addChild(menu)

    -- for i=1,16 do
    --     print("*****",(i-1)%4)
    -- end
-- local i=3   
--     for row=4,1,-1 do
--         for col=1,4 do
--             print(",,,,,",(row-i-1)*4+col)
--         end
--         i=i-2
--     end


    -- 随机数
    -- math.randomseed(tostring(os.time()):reverse():sub(1, 7)) --设置时间种子

    -- for i=1, 15 do
    --     print(math.random()) --产生0到1之间的随机数
    --     print(math.random(1,100)) --产生1到100之间的随机数
    -- end

    -- UItool:setBool("bedkey",false)
    -- UItool:setBool("scissors",false) 
    -- UItool:setBool("hammer",false)

    -- UItool:setBool("paperpen",false)
    -- UItool:setBool("key",false) 
    -- UItool:setBool("redbrush",false)
    
    --  UItool:setBool("redflower",false)
    --  UItool:setBool("doorkey",false)
    --  UItool:setBool("stamp",false)
    --  UItool:setBool("stool",false)
    
end

return Loading







































