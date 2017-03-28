

Message2 = class("Message2", function()
    return cc.Layer:create()
end)

Message2.panel = nil

function Message2:ctor()
    self.panel = cc.CSLoader:createNode(Config.RES_MESSAGETWO)
    self.bg = self.panel:getChildByName("Node_center"):getChildByName("bg")
    
    local shildinglayer = Shieldingscreen:new()
    self:addChild(shildinglayer)
    
    self:addChild(self.panel,125)

    local closebutton = self.bg:getChildByName("back")
    closebutton:addClickEventListener(function(psender,event)
        self:removeFromParent()
    end)
end

function Message2:removeFromParents()
    print(" UItool:message2removeFromParent")
    self.panel:removeFromParent()
end

function Message2:open( ... )
    self:openHandler(...)
    --
    local scene = UItool:getRunningSceneObj()
    scene:addChild(self)
    
    print("open(...)")
end

function Message2:openHandler(str,size,callback,this)
    assert(type(str) == "string" or type(str) == "number", "提示框内容只能是字符串或者是数字类型！")
    print(str)
    self:setContent(str,size)

end

function Message2:setContent(str,size)
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
    -- alert:setPosition(cc.p( 105,185))
    -- self.bg:addChild(alert,1)
end