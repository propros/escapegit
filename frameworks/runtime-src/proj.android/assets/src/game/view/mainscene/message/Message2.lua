

Message2 = class("Message2", function()
    return cc.Layer:create()
end)

Message2.panel = nil

function Message2:ctor()
    self.panel = cc.CSLoader:createNode(Config.RES_MESSAGETWO)
    self.topbar = self.panel:getChildByName("Node_top"):getChildByName("bg")
    
    local shildinglayer = ShieldingLayerTe:new()
    self:addChild(shildinglayer)
    
    self:addChild(self.panel,125)
    local visiblesize = cc.Director:getInstance():getVisibleSize()

    local movedown = cc.MoveTo:create(0.8, cc.p(0,0-self.topbar:getContentSize().height))
    local moveup = cc.MoveTo:create(0.8, cc.p(0,0))
    local delay = cc.DelayTime:create(2.5)
    local se = cc.Sequence:create(movedown,delay,moveup)
    self.topbar:runAction(se)

    -- local panel = self
    -- local timer = TimerExBuf()
    --     timer:create(4.3,1,1)
    --     function timer:onTime()
    --         -- if panel then
    --         --     panel:removeFromParent()
    --             -- UItool:setBool("topbar",false)
    --         --     else

    --         -- end
            
    --         timer:stop()
    --     end
    --     timer:start()

end



function Message2:removeFromParents()
    self.panel:removeFromParent()
end

function Message2:open( ... )
    self:openHandler(...)
    --
    local scene = UItool:getRunningSceneObj()
    scene:addChild(self)
end

function Message2:openHandler(str,size,callback,this)
    assert(type(str) == "string" or type(str) == "number", "提示框内容只能是字符串或者是数字类型！")
    -- print(str)
    self:setContent(str,size)

end

function Message2:setContent(str,size)
    --  print("设置显示内容 = ", utils.wrap(str, 30))
    --local str = utils.wrap(str, 34)
    local str = str or "警告"
    local alert = self.topbar:getChildByName("Text_1")
    -- alert:setAnchorPoint(cc.p(0,0))
    -- alert:setContentSize(cc.size(300, 400))
    alert:setString(str)
    alert:setFontName(Zapfino)
    alert:setFontSize(size+10)
    -- alert:setColor(cc.c3b(251, 138, 38))
    -- alert:setPosition(cc.p( 105,185))
    -- self.topbar:addChild(alert,1)
end













