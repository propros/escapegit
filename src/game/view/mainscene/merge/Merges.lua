
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
    self.panel = cc.CSLoader:createNode(Config.RES_MERGE)
    self.bag = self.panel:getChildByName("Node_center"):getChildByName("bg")
    
    self:addChild(self.panel,125)
    self.content_size = self.bag:getContentSize()

    self.bag_table = {}
    
    local onetextdata = Data.gettextData(2)
    print("test onetextdata",onetextdata)
    local pos_x, pos_y = self.bag:getPosition()
-- 排列得到的item 
    for key,var in pairs(ModifyData.getTable()) do
        
        local icon = Data.getItemData(var)
        self.sprite = cc.Sprite:create(icon.pic)
        -- local y = self.bag:getContentSize().height-(math.floor((key-1)/3)+1)*275
        local y = 10 
        self.sprite:setAnchorPoint(cc.p(0,0))
        self.sprite:setPosition((key-1)*150+50  ,y)
        self.bag:addChild(self.sprite,2) 
    end
--进入合成界面
    local he_btn = ccui.Button:create("merge/he_btn.png")
    he_btn:setPosition(cc.p(960,135))
    he_btn:addTo(self.bag,2)
    he_btn:addClickEventListener(function(psender,event)
        print("bag")
        self:merges()
        end)

end

function Merge:merges()

    print("Merge:merge")
    self.merge_table = {}
    self.merge = cc.Sprite:create("merge/combination.png")
    self.merge:setAnchorPoint(cc.p(0,0))
    self.merge:setPosition(cc.p(self.visibleSize.width/6,self.visibleSize.height/8))
    local shildinglayer = Shieldingscreen:new()
    self:addChild(shildinglayer)
    self.merge:addTo(shildinglayer)

    for key, var in pairs(ModifyData.getTable()) do
        local icon = Data.getItemData(var)
        self.item_btn = ccui.Button:create(icon.pic)
        self.item_btn:setTag(var)
        self.item_btn:setAnchorPoint(cc.p(0,0))
        self.item_btn:setPosition(cc.p(180+140*(key-1),220))
        self.item_btn:addTo(self.merge,1)
        -- self.merge_table[#self.merge_table + 1] = self.item_btn
        table.insert(self.merge_table, self.item_btn)
    end 

    -- 待合成的控件
    self.itemnum = 0
    self.item_1 = nil
    self.item_2 = nil
    self.locationtable = {} -- 位置table
    local function merge_item(event,eventType)
        if eventType == TOUCH_EVENT_ENDED then
            print("num等于",self.itemnum )
            
            local eventmove1 = cc.MoveTo:create(0.3, cc.p(275,450))
            local eventmove2 = cc.MoveTo:create(0.3, cc.p(600,450))
            local srcX , srcY = event:getPosition()

            local srclocation = self.locationtable[tonumber(event:getName())]--原来的世界坐标
            local nodelation = self.merge:convertToNodeSpace(srclocation) -- 转换为节点坐标
            self.eventsrcmove = cc.MoveTo:create(0.3,{x=nodelation.x,y=nodelation.y})
            if self.itemnum <=2  then
                Data.getItemData(event:getTag()).appear = false
                if Data.getItemData(event:getTag()).appear == false then
                    if self.itemnum == 0 then
                        self.item_1 = tonumber(event:getName())
                        event:runAction(eventmove1)
                        self.itemnum = self.itemnum+1
                        Data.getItemData(event:getTag()).appear = true
                    elseif self.itemnum==1 then
                        self.item_2 = tonumber(event:getName())
                        event:runAction(eventmove2)
                        self.itemnum = self.itemnum + 1   
                        Data.getItemData(event:getTag()).appear = true
                        else
                            --todo
                    end
                    else
                        event:runAction(self.eventsrcmove)
                        self.itemnum = self.itemnum - 1
                        Data.getItemData(event:getTag()).appear = false
                end
            end
            
        end

    end

    for key , var in pairs(self.merge_table) do
        print(key, var)
        var:addClickEventListener(merge_item)
        var:setName(key)
        local x,y = var:getPosition()
        self.worldlocation= self.merge:convertToWorldSpace(cc.p(x,y)) -- 转换为世界坐标
        table.insert(self.locationtable,self.worldlocation)

    end

    --点击合成按钮
    local function clickmerge( event, eventType)
        print("合成按钮 ")
        if eventType == TOUCH_EVENT_ENDED then
            if self.item_1 == nil or self.item_2 == nil  then
                 UItool:message2("一个物品不能合成，")
                else
                   self.id=nil
                if self.item_1>self.item_2 then
                    local alltable = ModifyData.getTable()
                    for i=1,#Data.getdestMergeTable() do
                         local merged = Data.getMergeData(i) 
                         print("id1 %f ,id2 %f", merged.id[1],merged.id[2])
                         if (merged.id[1] == alltable[self.item_2] and merged.id[2] == alltable[self.item_1]) or (merged.id[2] == alltable[self.item_2] and merged.id[1] == alltable[self.item_1]) then
                            print("merged.nid",merged.nid)
                            self.id=self.item_1+self.item_2
                            local x = cc.Sprite:create(Data.getItemData(merged.nid).pic)
                            x:setAnchorPoint(cc.p(0,0))
                            x:setPosition(cc.p(900,450))
                            x:addTo(self.merge,1)
                            local padlock_item = Data.getItemData(merged.nid)
                            ModifyData.tableinsert(padlock_item.key)
                            -- print("得到的item的数字 ",padlock_item.key)
                             --删除button
                            self.merge_table[self.item_1]:removeFromParent()
                            self.merge_table[self.item_2]:removeFromParent()
                            --从self.merge_table表中删除 
                            table.remove(self.merge_table,self.item_1)
                            --从ModifyData.getTable() 表中删除
                            table.remove(ModifyData.getTable(),self.item_1)
                            table.remove(self.merge_table,self.item_2)
                            table.remove(ModifyData.getTable(),self.item_2)
                            self.itemnum = 0
                            UItool:setBool("pasitem", true)
                            break
                            else
                                UItool:message2("物品不符不能合成",30)
                         end
                     end
                    elseif self.item_1<self.item_2 then
                        local alltable = ModifyData.getTable()
                        for i=1, #Data.getdestMergeTable() do
                            local merged = Data.getMergeData(i) 
                            if (merged.id[2] == alltable[self.item_2] and merged.id[1] == alltable[self.item_1]) or (merged.id[1] == alltable[self.item_2] and merged.id[2] == alltable[self.item_1]) then
                                self.id=self.item_1+self.item_2
                                local x = cc.Sprite:create(Data.getItemData(merged.nid).pic)
                                x:setAnchorPoint(cc.p(0,0))
                                x:setPosition(cc.p(900,450))
                                x:addTo(self.merge,1)
                                local padlock_item = Data.getItemData(merged.nid)
                                ModifyData.tableinsert(padlock_item.key)
                                print("得到的item的数字 ",padlock_item.key)
                                --删除button
                                self.merge_table[self.item_1]:removeFromParent()
                                self.merge_table[self.item_2]:removeFromParent()
                                --从表中删除
                                table.remove(self.merge_table,self.item_2)
                                table.remove(ModifyData.getTable(),self.item_2)
                                table.remove(self.merge_table,self.item_1)
                                table.remove(ModifyData.getTable(),self.item_1)
                                self.itemnum = 0
                                UItool:setBool("pasitem", true)
                                break
                                else
                                    -- print("####不能合成####")
                                    UItool:message2("物品不符不能合成",30)
                                    -- break
                            end
                        end
                end
                self.he_btn:removeFromParent()
            end
        end
    end

    self.he_btn = ccui.Button:create("he_btn.png")
    self.he_btn:setPosition(cc.p(630,135))
    self.he_btn:addTo(self.merge,5)
    self.he_btn:addClickEventListener(clickmerge)

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

return Merge

























