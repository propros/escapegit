
SpecialItembg = class("SpecialItembg", function()
    return cc.Layer:create()
end)

function SpecialItembg:ctor( )
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
   
    self:touch()

    if #PublicData.SHOUCANG==0 then
        local docpath = cc.FileUtils:getInstance():getWritablePath().."shoucang.txt"
        if cc.FileUtils:getInstance():isFileExist(docpath)==false then
            local str = json.encode(PublicData.SHOUCANG)
            ModifyData.writeToDoc(str,"shoucang")
            -- PublicData.SHOUCANG = Data.CHAPTER
            print("写文件")
        else
            print("读文件")
            local str = ModifyData.readFromDoc("shoucang")
            PublicData.SHOUCANG = json.decode(str)
        end
    end

    

end

function SpecialItembg:SpecialItembgs()
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/donghua/wupinlan/wupinlan.ExportJson") 

    self.specialitembg = ccs.Armature:create("wupinlan")
    self.specialitembg:getAnimation():playWithIndex(1)
    self.specialitembg:getAnimation():play("Animation1")
    self.specialitembg:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))
    -- self.layer=cc.Layer:create()
    -- local shildinglayer = Shieldingscreenmessage3:new()
    -- self.layer:addChild(shildinglayer)
    -- self.layer:addTo(self,13)
    self:addChild(self.specialitembg,12)
end



function SpecialItembg:open( ... )
	self:openHandler(...)
	local scene = UItool:getRunningSceneObj()
    scene:addChild(self,11)
	--print("open(...)")
end

function SpecialItembg:openHandler(str,itemnum)  
    self:SpecialItembgs()
    local icon = Data.getItemData(itemnum)  

    self.sprite = cc.Sprite:create(icon.shoucangpic)
    self.sprite:setAnchorPoint(cc.p(0.5,0.5))
    self.sprite:setPosition(cc.p(self.visibleSize.width/2.8,self.visibleSize.height/2))
    self:addChild(self.sprite,13)

    local function labelcommcallback( ... )
        local label = cc.LabelTTF:create("获得收藏品", "Arial", 45)
        label:setPosition(cc.p(self.visibleSize.width/1.7,self.visibleSize.height/1.85))  
        label:setOpacity(0)
        local fadein = cc.FadeIn:create(0.3)
        label:runAction(fadein)
        self:addChild(label, 13)

        
    end

    local function labelstr( ... )
        local label = cc.LabelTTF:create(str, "Arial", 65)
        label:setPosition(cc.p(self.visibleSize.width/1.7,self.visibleSize.height/2.1))  
        label:setOpacity(0)
        local fadein = cc.FadeIn:create(0.3)
        label:runAction(fadein)
        self:addChild(label, 13)
        -- local fadein = cc.FadeIn:create(1)
        -- label:runAction(fadein)
    end

    local delaytime = cc.DelayTime:create(0.2)

    local scaltob = cc.ScaleTo:create(0.3, 1.25, 1.25)
    local scaltos = cc.ScaleTo:create(0.3, 0.75, 0.75)
    local sequence = cc.Sequence:create(scaltob,scaltos,delaytime,cc.CallFunc:create(labelcommcallback),delaytime,cc.CallFunc:create(labelstr) )
    self.sprite:runAction(sequence)

    --加入到收藏夹中
    local str = ModifyData.readFromDoc("shoucang")
    PublicData.SHOUCANG = json.decode(str)
    
    local key_item = Data.getItemData(itemnum)
    local ifcontain = false
    
    for i=1,#PublicData.SHOUCANG do
        if PublicData.SHOUCANG[i]==itemnum then
            ifcontain = true
            break
            else
                ifcontain = false
                
        end
    end
    if ifcontain then
        else
            table.insert(PublicData.SHOUCANG, key_item.key)
    end
    
    local strs = json.encode(PublicData.SHOUCANG)
    ModifyData.writeToDoc(strs,"shoucang")


end

function SpecialItembg:touch()

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
         self.specialitembg:getAnimation():play("Animation3")
         -- self:removeFromParent()
         self.sprite:removeFromParent()
            local panel = self
            local timer = TimerExBuf()
                timer:create(0,0,0)
                function timer:onTime()
                    if panel then
                        panel:removeFromParent()
                        else
                    end
                    
                    timer:stop()
                end
                timer:start()

    end, cc.Handler.EVENT_TOUCH_ENDED )  

    local eventDispatcher = self:getEventDispatcher()  
    -- 添加监听器  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self)  
end








































