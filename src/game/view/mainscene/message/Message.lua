

Message = class("Message", function()
	return cc.Layer:create()
end)

Message.callback=nil
Message.paramster=nil

function Message:ctor()

	print("Message ")
	self.bg = cc.Sprite:create("Menu/talk.png")
	self.bg:setPosition(cc.p(700,600))
	local shildinglayer = Shieldingscreen:new()
    self:addChild(shildinglayer)
	self:addChild(self.bg,15)

	local closebutton = ccui.Button:create("Menu/bu_x.png")
	closebutton:setPosition(cc.p(100,100))
	closebutton:addTo(self.bg,2)


	closebutton:addClickEventListener(function(psender,event)
        print("关闭")
        self:removeFromParent()
    end)

	self.callback = function () end
	self.paramster = nil



end

function Message:open( ... )
	self:openHandler(...)
	--
	local scene = UItool:getRunningSceneObj()
    scene:addChild(self)
	
	print("open(...)")
end

function Message:openHandler(str,size,callback,this)
	assert(type(str) == "string" or type(str) == "number", "提示框内容只能是字符串或者是数字类型！")
	print(str)
	self:setContent(str,size)
	self:setCallback(callback, this)

end

function Message:setCallback(callback,this)
	-- self:removeFromParent()
	self.callback = callback
	self.paramster = this
end

function Message:setContent(str,size)
    --  print("设置显示内容 = ", utils.wrap(str, 30))
    --local str = utils.wrap(str, 34)
    local str = str or "警告"
    local alert = ccui.Text:create()
    alert:setAnchorPoint(cc.p(0,0))
    alert:setContentSize(cc.size(300, 400))
    alert:setString(str)
    alert:setFontName(Zapfino)
    alert:setFontSize(size)
    alert:setColor(cc.c3b(251, 138, 38))
    alert:setPosition(cc.p(	105,185))
    self.bg:addChild(alert,1)
end










