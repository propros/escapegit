
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

    --返回button 
    local button = ccui.Button:create("bu_back1.png","bu_back2.png")
    button:setAnchorPoint(cc.p(1,1))
    button:setPosition(cc.p(-button:getContentSize().width , self.visibleSize.height/3))        
    self.bag:addChild(button)

    button:addClickEventListener(function ( psender,event )
        self:removeFromParent();
    end)
    
    local onetextdata = Data.gettextData(2)
    print("test onetextdata",onetextdata)


    local pos_x, pos_y = self.bag:getPosition()


-- 排列得到的item 
    for key,var in pairs(ModifyData.getTable()) do
        local icon = Data.getItemData(var)
        self.sprite = cc.Sprite:create(icon.pic)
        local y = self.bag:getContentSize().height-(math.floor((key-1)/3)+1)*275
        self.sprite:setPosition(((key-1)%3)*320 + 320 ,y)
        self.bag:addChild(self.sprite,2) 
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

function Merge:merge( )

print("Merge:merge")
    self.bag:removeFromParent()
    self.merge = cc.Sprite:create("combination.png")
    self.merge:setAnchorPoint(cc.p(0,0))
    self.merge:setPosition(cc.p(self.visibleSize.width/6,self.visibleSize.height/8))
    local shildinglayer = Shieldingscreen:new()
    self:addChild(shildinglayer)
    self.merge:addTo(self,3)

    for key, var in pairs(ModifyData.getTable()) do
        local icon = Data.getItemData(var)
        local item_btn = ccui.Button:create(icon.pic)
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
        
        local eventmove1 = cc.MoveTo:create(0.3, cc.p(275,450))
        local eventmove2 = cc.MoveTo:create(0.3, cc.p(600,450))
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
           else
            num = nil 
            print(" num ~= 1 or 2 ")
           end
        
        end
    end

    for key , var in pairs(self.merge_table) do
        var:setTag(key)
        var:addClickEventListener(merge_item)
    end

    --点击合成按钮
    local function clickmerge( event, eventType)

        if eventType == TOUCH_EVENT_ENDED then
            self.id=nil
            if self.item_1>self.item_2 then
                print("self.item_1>self.item_2")
                --删除button
                self.merge_table[self.item_1]:removeFromParent()
                self.merge_table[self.item_2]:removeFromParent()

                print("self.item_1: %f  self.item_2: %f ",self.item_1,self.item_2)
                local alltable = ModifyData.getTable()
                print("ModifyData.getTable()(self.item_2).key",alltable[self.item_2])

                for i=1,7 do
                     local merged = Data.getMergeData(i) 
                     print("id1 %f ,id2 %f", merged.id[1],merged.id[2])
                     if merged.id[1] == alltable[self.item_2] and merged.id[2] == alltable[self.item_1] then
                        print("merged.nid",merged.nid)
                        self.id=self.item_1+self.item_2
                        local x = cc.Sprite:create(Data.getItemData(merged.nid).pic)
                        x:setAnchorPoint(cc.p(0,0))
                        x:setPosition(cc.p(900,450))
                        x:addTo(self.merge,1)
                        break
                     end
                 end

                --从self.merge_table表中删除 
                table.remove(self.merge_table,self.item_1)
                --从ModifyData.getTable() 表中删除
                table.remove(ModifyData.getTable(),self.item_1)
                
                table.remove(self.merge_table,self.item_2)
                table.remove(ModifyData.getTable(),self.item_2)

                elseif self.item_1<self.item_2 then
                    print("self.item_1<self.item_2")

                    print("self.item_1: %f  self.item_2: %f ",self.item_1,self.item_2)
                    local alltable = ModifyData.getTable()
                    print("ModifyData.getTable()(self.item_2).key",alltable[self.item_2])

                    for i=1,7 do
                        local merged = Data.getMergeData(i) 
                        print("id1 %f ,id2 %f", merged.id[1],merged.id[2])
                        if merged.id[2] == alltable[self.item_2] and merged.id[1] == alltable[self.item_1] then
                            print("merged.nid",merged.nid)
                            self.id=self.item_1+self.item_2
                            local x = cc.Sprite:create(Data.getItemData(merged.nid).pic)
                            x:setAnchorPoint(cc.p(0,0))
                            x:setPosition(cc.p(900,450))
                            x:addTo(self.merge,1)
                            break
                        end
                    end

                    --删除button
                    self.merge_table[self.item_1]:removeFromParent()
                    self.merge_table[self.item_2]:removeFromParent()
                    --从表中删除
                    table.remove(self.merge_table,self.item_2)
                    table.remove(ModifyData.getTable(),self.item_2)
                    
                    table.remove(self.merge_table,self.item_1)
                    table.remove(ModifyData.getTable(),self.item_1)

                    
                    
            end
            self.he_btn:removeFromParent()
        end
    end

    self.he_btn = ccui.Button:create("he_btn.png")
    self.he_btn:setPosition(cc.p(630,135))
    self.he_btn:addTo(self.merge,2)
    self.he_btn:addClickEventListener(clickmerge)


    local button = ccui.Button:create("bu_back1.png","bu_back2.png")
    button:setAnchorPoint(cc.p(1,1))
    button:setPosition(cc.p(-button:getContentSize().width , self.visibleSize.height/2))        
    self.merge:addChild(button)

    button:addClickEventListener(function ( psender,event )
        self:removeFromParent();
    end)
    
end

function table.removebyvalue(array, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then break end
        end
        i = i + 1
    end
    return c
end


function Merge:onEnter()
    print("onEnter")
end

function Merge:onExit()
    print("onExit")
end

return Merge

























