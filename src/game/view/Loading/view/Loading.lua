

Loading=class("Loading", function()
    return cc.Scene:create()
end)

function Loading:ctor()

    
    
    self.director = cc.Director:getInstance()
	self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
 
    self.bg = cc.Sprite:create("bg_mainscene.png")
    self.bg:setPosition(cc.p(0,0))
    self.bg:setAnchorPoint(cc.p(0,0))
    self.bg:addTo(self)

    UItool:setBool("topbar",false) -- 对话框二
    UItool:setBool("merge", true) -- 物品栏是否可以点击
    -- ModifyData.tableinsert(19)

    self:signin() --UI
    
    local function began( )
        -- UItool:setBool("topbar",false)
        self.scene = Mainscene.new()
        local turn = cc.TransitionFade:create(1, self.scene)
        cc.Director:getInstance():replaceScene(turn)
        UItool:message4(" ...... "," “这里是，我的房间吗……？” ","“但为什么，窗外像是海底的世界呢？”","“我想我应该出去看看……”",30,self.scene)
        
        
    end

    local acount = 1
    local function settingcallback( )

        UItool:message2("设置",30)
        -- local PlayerLayer = PlayerLayer:createScene()
        -- print("进入拼图界面", PlayerLayer)
        -- self:addChild(PlayerLayer,125)

        local cliplayers = ClipLayer:create()  
        cliplayers:createClip(self.menu,1)
        self:addChild(cliplayers,5)
        
    end
    
    self.start=cc.MenuItemImage:create("comm/start.png","comm/start.png")
    self.start:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2+100))
    self.start:setAnchorPoint(cc.p(0.5,0.5))
    self.start:setScale(2)
    -- 对该按钮注册按键响应函数：
    self.start:registerScriptTapHandler(began)

    self.setting = cc.MenuItemImage:create("comm/setting.png","comm/setting.png")
    self.setting:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2-100))
    self.setting:setAnchorPoint(cc.p(0.5,0.5))
    self.setting:setScale(2)
    -- 对该按钮注册按键响应函数：
    self.setting:registerScriptTapHandler(settingcallback)

    -- self.menu=cc.Menu:create(self.start,self.setting)
    -- self.menu:setPosition(0,0) 
    -- self:addChild(self.menu,2)

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

    
    
    
end

function Loading:newgame(  )
    print("newgame")

end

function Loading:kaishi(  )
    print("kaishi")
    local chapters = Chapters:createScene()
    print("章节选择", chapters)
    self:addChild(chapters,3)
end

function Loading:shezhi(  )
    print("shezhi")
    local setting = Setting:createScene()
    print("shezhixuanze", setting)
    self:addChild(setting,3)

end

function Loading:shoucang(  )
    print("shoucang")
end

function Loading:likai(  )
    print("likai")

end

function Loading:signin( parent ,num)
    self.panel = cc.CSLoader:createNode(Config.RES_LOADING)
    self:addChild(self.panel)

    local center = self.panel:getChildByName("Node_center")
    center:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))

    local left = self.panel:getChildByName("Node_left")
    left:setPosition(cc.p(0,self.visibleSize.height/2))
    
    left:getChildByName("newgame"):setVisible(false)
    local allUIbtn = 
    {
    left:getChildByName("newgame"),
    left:getChildByName("began"),
    left:getChildByName("shoucang"),
    left:getChildByName("shezhi"),
    left:getChildByName("likai")
    }

    local function allUIbtnclick(event,eventType)
        if eventType == TOUCH_EVENT_ENDED then
            if UItool:getBool("effect") then
                AudioEngine.playEffect("gliss.mp3")
            end
            
            if event:getName()=="newgame" then
                self:newgame()
                elseif event:getName()=="began" then
                    self:kaishi()
                    elseif event:getName()=="shoucang" then
                        self:shoucang()
                        elseif event:getName()=="shezhi" then
                            self:shezhi()
                            elseif event:getName()=="likai" then
                                self:likai()
            end
            
        end

    end

    for key, var in pairs(allUIbtn) do
        
        var:addClickEventListener(allUIbtnclick)

    end


    
end



function Loading:onEnter()
    
end



return Loading











