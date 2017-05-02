

local Loading = class("Loading", cc.load("mvc").ViewBase)



-- require "cocos.network.DeprecatedNetworkFunc"

function Loading:onCreate()
    self.director = cc.Director:getInstance()
	self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
 
    self.bg = cc.Sprite:create("bg_mainscene.png")
    self.bg:setPosition(cc.p(0,0))
    self.bg:setAnchorPoint(cc.p(0,0))
    self.bg:addTo(self)

    UItool:setBool("merge", true) -- 物品栏是否可以点击
    UItool:setBool("topbar",false)

    
    
    
    local function began( )
        UItool:setBool("topbar",false)

        self.scene = Mainscene.new()
		local turn = cc.TransitionFade:create(1, self.scene)
		cc.Director:getInstance():replaceScene(turn)
        
        
    end

    local acount = 1
    local function settingcallback( )

        UItool:message2("设置",30)
        -- local PlayerLayer = PlayerLayer:createScene()
        -- print("进入拼图界面", PlayerLayer)
        -- self:addChild(PlayerLayer,125)
        
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

    local menu=cc.Menu:create(self.start,self.setting)
    menu:setPosition(0,0) 
    self:addChild(menu,2)

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

    self:signin(self.scene)

    
end

function Loading:signin( parent ,num)
    self.panel = cc.CSLoader:createNode(Config.RES_LOADING)
    self.password_bg = self.panel:getChildByName("password_bg")
    self:addChild(self.panel)

    local function textFieldEvent(sender, eventType)
        -- print("点击输入框")
        self.acc = self.password_bg:getChildByName("TextField_1_0"):getString() 
        self.pwd = self.password_bg:getChildByName("TextField_1"):getString() 
        print("shuru")
    end

        self.password_bg:getChildByName("TextField_1"):addEventListener(textFieldEvent) 

        local denglubtn = self.password_bg:getChildByName("denglu")
        denglubtn:addClickEventListener(function(psender,event)

            sendGetServer(self.acc , self.pwd ,parent)
            end)

        local zhucebtn = self.password_bg:getChildByName("zhuce")
        zhucebtn:addClickEventListener(function(psender,event)
            print("注册地")
            -- sendGetServer(self.acc , self.pwd ,parent)
            end)
    
end

function Loading:onExit()
    UItool:message4(" ...... "," “这里是，我的房间吗……？” ","“但为什么，窗外像是海底的世界呢？”","“我想我应该出去看看……”",30,self.scene)
end



return Loading











