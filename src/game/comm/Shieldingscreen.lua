--特殊的   屏蔽界面层  可以更新颜色，透明度，触摸事件  
Shieldingscreen = class("Shieldingscreen", function ()  
    return cc.LayerColor:create(cc.c4b(0,0,0,0))  
end)   

--初始化  
function Shieldingscreen:ctor(isset)  

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
        if isset == true then
        else
            self:removeFromParent()
        end
        
        print("EVENT_TOUCH_ENDED")  
    end, cc.Handler.EVENT_TOUCH_ENDED )  

    local eventDispatcher = self:getEventDispatcher()  
    -- 添加监听器  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self)  

end  

Shieldingscreenpas = class("Shieldingscreenpas", function ()  
    return cc.LayerColor:create(cc.c4b(0,0,0,0))  
end)  

--初始化  
function Shieldingscreenpas:ctor(isset)  

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
        if isset == true then
        else
            self:getParent():removeFromParent()
        end
        
        print("EVENT_TOUCH_ENDED")  
    end, cc.Handler.EVENT_TOUCH_ENDED )  

    local eventDispatcher = self:getEventDispatcher()  
    -- 添加监听器  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self)  

end  

--特殊的   屏蔽界面层  可以更新颜色，透明度，触摸事件  
ShieldingLayerTe = class("ShieldingLayerTe", function ()  
    return cc.LayerColor:create(cc.c4b(0,0,0,0))  
end)  

--初始化  
function ShieldingLayerTe:ctor()  

    -- 创建一个事件监听器类型为 OneByOne 的单点触摸  
    local  listenner = cc.EventListenerTouchOneByOne:create()  

    -- ture 吞并触摸事件,不向下级传递事件;  
    -- fasle 不会吞并触摸事件,会向下级传递事件;  
    -- 设置是否吞没事件，在 onTouchBegan 方法返回 true 时吞没  
    listenner:setSwallowTouches(false)  

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
        --print("EVENT_TOUCH_ENDED")
    end, cc.Handler.EVENT_TOUCH_ENDED )  

    local eventDispatcher = self:getEventDispatcher()  
    -- 添加监听器  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self)  

end  

ShieldingLayerpin = class("ShieldingLayerpin", function ()  
    return cc.LayerColor:create(cc.c4b(0,0,0,0))  
end)  

--初始化  
function ShieldingLayerpin:ctor()  

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
        --print("EVENT_TOUCH_ENDED")
    end, cc.Handler.EVENT_TOUCH_ENDED )  

    local eventDispatcher = self:getEventDispatcher()  
    -- 添加监听器  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self)  

end  

