

Message3 = class("Message3", function()
    return cc.Layer:create()
end)

Message3.panel = nil

function Message3:ctor()
    print("message3.lua  ...")
    self.panel = cc.CSLoader:createNode(Config.RES_MESSAGETWO)
    self.topbar = self.panel:getChildByName("Node_top"):getChildByName("bg")
    
    -- local shildinglayer = Shieldingscreenmessage3:new()
    -- self:addChild(shildinglayer)
    
    self:addChild(self.panel,125)

    local visiblesize = cc.Director:getInstance():getVisibleSize()

    local movedown = cc.MoveTo:create(0.8, cc.p(0,0-self.topbar:getContentSize().height))
    local moveup = cc.MoveTo:create(0.8, cc.p(0,0))
    local delay = cc.DelayTime:create(2.5)
    local se = cc.Sequence:create(movedown,delay)
    self.topbar:runAction(movedown)
    
    self.touchnum = 0

end

function Message3:touch(str1,str2,size)

    -- 创建一个事件监听器类型为 OneByOne 的单点触摸  
    local  listenner = cc.EventListenerTouchOneByOne:create()  

    -- ture 吞并触摸事件,不向下级传递事件;  
    -- fasle 不会吞并触摸事件,会向下级传递事件;  
    -- 设置是否吞没事件，在 onTouchBegan 方法返回 true 时吞没  
    listenner:setSwallowTouches(true)  

    -- 实现 onTouchBegan 事件回调函数  
    listenner:registerScriptHandler(function(touch, event)  
        local location = touch:getLocation()  

        --print("EVENT_TOUCH_BEGAN")  
        return true  
    end, cc.Handler.EVENT_TOUCH_BEGAN )  

    -- 实现 onTouchMoved 事件回调函数  
    listenner:registerScriptHandler(function(touch, event)  
        local locationInNodeX = self:convertToNodeSpace(touch:getLocation()).x       

        --print("EVENT_TOUCH_MOVED")  
    end, cc.Handler.EVENT_TOUCH_MOVED )  

    -- 实现 onTouchEnded 事件回调函数  
    listenner:registerScriptHandler(function(touch, event)  
        local locationInNodeX = self:convertToNodeSpace(touch:getLocation()).x  
        
        --点击屏蔽层，返回，相当于返回按钮
        self.touchnum = 1 + self.touchnum
        self:openHandler(str1,str2,size)
        if self.touchnum ==2 then
            self.touchnum = 1 + self.touchnum
            local moveup = cc.MoveTo:create(0.8, cc.p(0,0))
            self.topbar:runAction(moveup)

            local panel = self
            local timer = TimerExBuf()
                timer:create(0.8,1,1)
                function timer:onTime()
                    if panel then
                        panel:removeFromParent()
                        else

                    end
                    
                    timer:stop()
                end
                timer:start()
            
        end
        print("EVENT_TOUCH_ENDED")  
    end, cc.Handler.EVENT_TOUCH_ENDED )  

    local eventDispatcher = self:getEventDispatcher()  
    -- 添加监听器  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self)  
end

function Message3:removeFromParents()
    self.panel:removeFromParent()
end

function Message3:open( str1,str2,size )
    self:openHandler(str1,str2,size)
    --
    local scene = UItool:getRunningSceneObj()
    scene:addChild(self)
end

function Message3:openHandler(str1,str2,size)
    -- assert(type(str1) == "string" or type(str) == "number", "提示框内容只能是字符串或者是数字类型！")
    -- print(str)
    self:setContent(str1,str2,size)
    self:touch(str1,str2,size)

end

function Message3:setContent(str1,str2,size)

    local str1 = str1 or "警告"
    local str2 = str2 or nil

    self.alert = self.topbar:getChildByName("Text_1")
    if self.touchnum==0 then
        self.alert:setString(str1)
        elseif self.touchnum==1 then
            self.alert:setString(str2)
    end

    print("__________",str1,str2,size)
    
    self.alert:setFontName(Zapfino)
    self.alert:setFontSize(size+10)
    -- alert:setColor(cc.c3b(251, 138, 38))
    -- alert:setPosition(cc.p( 105,185))
    -- self.topbar:addChild(alert,1)
end