
Message = class("Message", function()
	return cc.Layer:create()
end)

Message.callback=nil
Message.paramster=nil
Message.panel = nil 

function Message:ctor()
	self.visibleSize = cc.Director:getInstance():getVisibleSize()

	print("Message ")
	self.panel = cc.CSLoader:createNode(Config.RES_MESSAGE)
    local shildinglayer = Shieldingscreen:new()
    self:addChild(shildinglayer)
    self:addChild(self.panel,125)
    self.bg = self.panel:getChildByName("Node_center"):getChildByName("bg")

 	--回调函数
	self.callback = function () end
	--参数
	self.paramster = nil

	--按钮
	self.buttons = {}


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

	self:addButton({
        yes = "yes",
        no = "no",
    })

end

function Message:setCallback(callback,this)
	-- self:removeFromParent()
	self.callback = callback
	self.paramster = this
end

function  Message:addButton(info)
    local button
    for name, buttonName in pairs(info) do
    	button = self.bg:getChildByName(buttonName)
        assert(button, "没找到 "..buttonName.." 控件！")
        button:setName(name)
        self.buttons[name] = button
        local function handler(sender,eventType)
            if eventType==TOUCH_EVENT_ENDED then
                --有注册回调函数
                if type(self.callback) == "function" then
                    if self.parameters then
                    	print("yyyyyyyyyyyy")
                        self.callback(self.parameters, sender:getName())
                    else
                    	print("nnnnnnnnnnnnnn")
                        self.callback(sender:getName())
                    end
                end
                self:close()
            end
        end
        button:addClickEventListener(handler)
    end
end

function Message:close()
	self:removeFromParent()
end


function Message:setContent(str,size)
    --  print("设置显示内容 = ", utils.wrap(str, 30))
    --local str = utils.wrap(str, 34)
    local str = str or "警告"
    local alert = self.bg:getChildByName("Text_1")
    -- alert:setAnchorPoint(cc.p(0,0))
    -- alert:setContentSize(cc.size(300, 400))
    alert:setString(str)
    alert:setFontName(Zapfino)
    alert:setFontSize(size)
    -- alert:setColor(cc.c3b(251, 138, 38))
    -- alert:setPosition(cc.p(50,	self.bg:getContentSize().height/1.7))
    -- self.bg:addChild(alert,125)
end










