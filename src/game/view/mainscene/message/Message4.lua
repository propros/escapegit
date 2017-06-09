--只是为了开头剧情



Message4 = class("Message4", function()
    return cc.Layer:create()
end)

Message4.panel = nil


function Message4:ctor()
    -- print("Message4.lua  ...")
    UItool:setBool("message4", true)
    self.panel = cc.CSLoader:createNode(Config.RES_MESSAGETWO)
    self.topbar = self.panel:getChildByName("Node_top"):getChildByName("bg")
    
    self:addChild(self.panel,11)

    local visiblesize = cc.Director:getInstance():getVisibleSize()

    local movedown = cc.MoveTo:create(0.5, cc.p(0,0-self.topbar:getContentSize().height))
    local moveup = cc.MoveTo:create(0.5, cc.p(0,0))
    local delay = cc.DelayTime:create(2.5)
    local se = cc.Sequence:create(movedown,delay)
    self.topbar:runAction(movedown)

    --屏蔽时间
    self.screen = 2

    
    
    self.touchnum = 0

end

function Message4:touch(str1,str2,str3,str4,size)

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
        self:openHandler(str1,str2,str3,str4,size)
        local num 
        if str4 == nil then
            num = 3
            elseif str4 ~= nil then
                num = 4
        end
        if self.touchnum ==num then
            self.touchnum = 1 + self.touchnum
            local moveup = cc.MoveTo:create(0.5, cc.p(0,0))
            self.topbar:runAction(moveup)

            local panel = self
            local timer = TimerExBuf()
                timer:create(0.1,1,1)
                function timer:onTime()
                    if panel then
                        panel:removeFromParent()
                        UItool:setBool("message4", false)
                        else
                    end
                    
                    timer:stop()
                end
                timer:start()
            
        end 
    end, cc.Handler.EVENT_TOUCH_ENDED )  

    local eventDispatcher = self:getEventDispatcher()  
    -- 添加监听器  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self)  
end

function Message4:removeFromParents()
    self.panel:removeFromParent()
end

function Message4:open( str1,str2,str3,str4,size ,parente)
    parente = parente or nil 
    self:openHandler(str1,str2,str3,str4,size)
    --

    local scene = UItool:getRunningSceneObj()

    if parente then
         parente:addChild(self,15)
         else
             scene:addChild(self,15)
    end
   
end

function Message4:openHandler(str1,str2,str3,str4,size)

    self:setContent(str1,str2,str3,str4,size)
    self:touch(str1,str2,str3,str4,size)

end

function Message4:setContent(str1,str2,str3,str4,size)
    -- print("message4",str1,str2,str3,str4,size)
    local str1 = str1 or "警告"
    local str2 = str2 or nil

    self.alert = self.topbar:getChildByName("Text_1")
    if self.touchnum==0 then
        self.alert:setString(str1)

        self.layer=cc.Layer:create()
        local shildinglayer = Shieldingscreenmessage3:new()
        self.layer:addChild(shildinglayer)
        self.layer:addTo(self,126)
        local layer =  self.layer

        local timer = TimerExBuf()
        timer:create(self.screen,1,1)
        function timer:onTime()
            
            layer:removeSelf()
            timer:stop()
        end
        timer:start()
        elseif self.touchnum==1 then
            self.alert:setString(str2)
            
            self.layer=cc.Layer:create()
            local shildinglayer = Shieldingscreenmessage3:new()
            self.layer:addChild(shildinglayer)
            self.layer:addTo(self,12)
            local layer =  self.layer

            local timer = TimerExBuf()
            timer:create(self.screen,1,1)
            function timer:onTime()
                layer:removeFromParent()
                timer:stop()
            end
            timer:start()
            elseif self.touchnum==2 then
	            self.alert:setString(str3)
	            
	            self.layer=cc.Layer:create()
	            local shildinglayer = Shieldingscreenmessage3:new()
	            self.layer:addChild(shildinglayer)
	            self.layer:addTo(self,12)
	            local layer =  self.layer

	            local timer = TimerExBuf()
	            timer:create(self.screen,1,1)
	            function timer:onTime()
	                layer:removeFromParent()
	                timer:stop()
	            end
	            timer:start()
	            elseif self.touchnum==3 then

                    if str4 == nil then
                        elseif str4 ~= nil then
                            self.alert:setString(str4)
                            
                            self.layer=cc.Layer:create()
                            local shildinglayer = Shieldingscreenmessage3:new()
                            self.layer:addChild(shildinglayer)
                            self.layer:addTo(self,12)
                            local layer =  self.layer

                            local timer = TimerExBuf()
                            timer:create(self.screen,1,1)
                            function timer:onTime()
                                layer:removeFromParent()
                                timer:stop()
                            end
                            timer:start()
                    end
		            


    end
    
    self.alert:setFontName(Zapfino)
    self.alert:setFontSize(size+10)
    -- alert:setColor(cc.c3b(251, 138, 38))
    -- alert:setPosition(cc.p( 105,185))
    -- self.topbar:addChild(alert,1)
end