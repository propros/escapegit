local Loading = class("Loading", cc.load("mvc").ViewBase)

function Loading:onCreate()
    self.director = cc.Director:getInstance()
	self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
 
    self.bg = cc.Sprite:create("bg/bg.png")
    self.bg:setPosition(cc.p(0,0))
    self.bg:setAnchorPoint(cc.p(0,0))
    self.bg:addTo(self)

    local function wardrobecallback( )
    	--衣柜
        local scene = Mainscene.new()
		local turn = cc.TransitionPageTurn:create(0.5, scene, false)
		cc.Director:getInstance():replaceScene(turn)
        
    end

    local function settingcallback( )
        --衣柜
        UItool:message("设置",45)
        
    end
    
    self.wardrobe=cc.MenuItemImage:create("comm/start.png","comm/start.png")
    self.wardrobe:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))
    self.wardrobe:setAnchorPoint(cc.p(0.5,0.5))
    -- 对该按钮注册按键响应函数：
    self.wardrobe:registerScriptTapHandler(wardrobecallback)

    self.setting = cc.MenuItemImage:create("comm/setting.png","comm/setting.png")
    self.setting:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2-100))
    self.setting:setAnchorPoint(cc.p(0.5,0.5))
    -- 对该按钮注册按键响应函数：
    self.setting:registerScriptTapHandler(settingcallback)

    local menu=cc.Menu:create(self.wardrobe,self.setting)
    menu:setPosition(0,0) 
    self:addChild(menu)


    -- 随机数
    -- math.randomseed(tostring(os.time()):reverse():sub(1, 7)) --设置时间种子

    -- for i=1, 15 do
    --     print(math.random()) --产生0到1之间的随机数
    --     print(math.random(1,100)) --产生1到100之间的随机数
    -- end

end

function Loading:onEnter()
    print("onEnter() ")
end

function Loading:onExit()
    print("onExit ")
end

return Loading