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
    
    self.wardrobe=cc.MenuItemImage:create("furniture/left/wardrobe.png","furniture/left/wardrobe.png")
    self.wardrobe:setPosition(display.cx,display.cy)
    self.wardrobe:setAnchorPoint(cc.p(0.5,0))
    -- 对该按钮注册按键响应函数：
    self.wardrobe:registerScriptTapHandler(wardrobecallback)

    local menu=cc.Menu:create(self.wardrobe)
    menu:setPosition(0,0) 
    self:addChild(menu)





end

function Loading:onEnter()
    print("onEnter() ")
end

function Loading:onExit()
    print("onExit ")
end

return Loading