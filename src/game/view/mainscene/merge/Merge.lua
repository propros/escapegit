Merge=class("Merge", function()
    return cc.Scene:create()
end)

function Merge:createScene()
    local merge = Merge:new()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    merge:initScene()
    return merge
end

function Merge:initScene()
--底层
	self.bag = cc.Sprite:create("inventory.png")
    self.bag:setAnchorPoint(cc.p(0,0))
	self.bag:setPosition(cc.p(self.visibleSize.width/6,self.visibleSize.height/8))
	local shildinglayer = Shieldingscreen:new()
    self:addChild(shildinglayer) 
	self.bag:addTo(self)
    self.content_size = self.bag:getContentSize()

    self.bag_table = {}
    self.merge_table = {}

    local pos_x, pos_y = self.bag:getPosition()
    
    for i = 1, 2 do
        for j = 1, 3 do
            self.sprite = cc.Sprite:create("icon/icon_"..i..j..".png")
            self.sprite:setName("icon/icon_"..i..j..".png")
            print("******",self.sprite:getName())
            self.sprite:setAnchorPoint(0.5, 0.5)
            self:addChild(self.sprite,2)
            self.bag_table[#self.bag_table + 1] = self.sprite
            self.sprite:setPosition(320 + pos_x + (j-1)*self.content_size.width/4, 320 + pos_y + (i-1)*self.content_size.height/3)
            

        end
    end
--进入合成界面
    local he_btn = ccui.Button:create("he_btn.png")
    he_btn:setPosition(cc.p(960,135))
    he_btn:addTo(self.bag,2)


    he_btn:addClickEventListener(function(psender,event)
        print("bag")
        self:merge()
        end)

end

function Merge:merge( ... )

    self.bag:removeFromParent()
    

    self.merge = cc.Sprite:create("combination.png")
    self.merge:setAnchorPoint(cc.p(0,0))
    self.merge:setPosition(cc.p(self.visibleSize.width/6,self.visibleSize.height/8))
    -- local shildinglayer = Shieldingscreen:new()
    -- self:addChild(shildinglayer)
    self.merge:addTo(self,3)

    for key, var in pairs(self.bag_table) do

        -- print(key,var)
        print("0000000",var:getName())
        local name = var:getName()
        local item_btn = ccui.Button:create(name)
        item_btn:setAnchorPoint(cc.p(0,0))
        item_btn:setPosition(cc.p(180+140*(key-1),220))
        item_btn:addTo(self.merge,1)
        self.merge_table[#self.merge_table + 1] = item_btn

    end

    -- 待合成的控件
    local num = 1
    self.item_1 = nil
    self.item_2 = nil
    local function merge_item(event,eventType)
        if eventType == TOUCH_EVENT_ENDED then
            print("eventsss ",event:getTag())
        print("ccui.TouchEventType.ended")
        
        local eventmove1 = cc.MoveTo:create(1,cc.p(275,450))
        local eventmove2 = cc.MoveTo:create(1, cc.p(600,450))
        if num == 1 or num == 2 then
            if num == 1 then
                self.item_1 = event:getTag()
            event:runAction(eventmove1)
            num = num+1
            elseif num==2 then
                self.item_2 = event:getTag()
                event:runAction(eventmove2)
                num = num + 1   
        end
           else end
        
        end  

    end

    for key , var in pairs(self.merge_table) do
        print(key,var)
        var:setTag(key)
        var:addClickEventListener(merge_item)
    end

--点击合成按钮
    local function clickmerge( event, eventType)

        if eventType == TOUCH_EVENT_ENDED then
            self.id=nil
            -- print("-=-=-=-=-=-=-=-",self.item_1,self.item_2)
            if self.item_1>self.item_2 then
                print("self.item_1>self.item_2")
                --删除button
                print("+++++++++++",self.merge_table[self.item_1])
                print("+++++++++++",self.merge_table[self.item_2])
                self.merge_table[self.item_1]:removeFromParent()
                self.merge_table[self.item_2]:removeFromParent()
                --从表中删除
                table.remove(self.merge_table,self.item_1)
                self.item_2 = self.item_2 + 1
                table.remove(self.merge_table,self.item_2)

                self.id=self.item_1+self.item_2
                local x = cc.Sprite:create("icon/test_"..self.id..".jpg")
                x:setPosition(cc.p(920,450))
                x:addTo(self.merge,1)

                elseif self.item_1<self.item_2 then
                    print("self.item_1<self.item_2")
                    --删除button
                    print("------------",self.merge_table[self.item_1])
                    print("------------",self.merge_table[self.item_2])
                    self.merge_table[self.item_1]:removeFromParent()
                    self.merge_table[self.item_2]:removeFromParent()
                    --从表中删除
                    table.remove(self.merge_table,self.item_2)
                    self.item_1 = self.item_1 + 1
                    table.remove(self.merge_table,self.item_1)

                    self.id=self.item_1+self.item_2
                    local x = cc.Sprite:create("icon/icon"..self.id..".png")
                    x:setPosition(cc.p(920,450))
                    x:addTo(self.merge,1)

            end
            -- self.he_btn:removeFromParent()

        end
    end

    self.he_btn = ccui.Button:create("he_btn.png")
    self.he_btn:setPosition(cc.p(630,135))
    self.he_btn:addTo(self.merge,2)
    self.he_btn:addClickEventListener(clickmerge)
    
end








return Merge

























