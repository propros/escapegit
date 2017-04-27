
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
    self.m_srcItem = nil  
    -- self.m_destItem = nil   
    self.m_isTouchEnable = true
    self.touhitem = true 
    self.bag_table = {}
    self.capyitem = {}
    -- self.itemtouchnum = true 
--底层
    self.panel = cc.CSLoader:createNode(Config.RES_MERGE)
    self.bag = self.panel:getChildByName("Node_center"):getChildByName("bg")
    
    self:addChild(self.panel)
    self.content_size = self.bag:getContentSize()

    self:initMatrix()
    self:itemtouch()
    self:touchpoint()

    for key,var in pairs(self.bag_table) do
        local key_items = Data.getItemData(var:getTag())

        if key_item== var:getTag()then
            
            else
                key_items.appear = true
                UItool:setBool(key_items.inname, false)
        end
     end
end

function Merge:initMatrix()
    -- 初始化item 
    for key,var in pairs(ModifyData.getTable()) do
        local icon = Data.getItemData(var)
        self.sprite = cc.Sprite:create(icon.pic)
        local y = 80 
        self.sprite:setTag(var)
        self.sprite:setAnchorPoint(cc.p(0.5,0.5))
        self.sprite:setPosition((key-1)*self.sprite:getContentSize().width*1.05 + 80 ,y)
        -- print("坐标",self.sprite:getPositionX())
        self.bag:addChild(self.sprite,2) 
        self.bag_table[key] = self.sprite

    end
end

function Merge:itemshake( item )
    
    if #self.capyitem==1 then
        
        elseif #self.capyitem==2 then
            
            if self.capyitem[1]==self.capyitem[2] then
                -- print("两个是相同的")
                local inname = Data.getItemData(self.capyitem[1]:getTag())
                UItool:setBool(inname.inname, false)
                self.capyitem[1]:removeFromParent()
                table.remove(self.capyitem,2)
                table.remove(self.capyitem,1)
                else
                    -- print("不相同")
                    self.capyitem[1]:removeFromParent()
                    table.remove(self.capyitem,1)
            end
            
    end

    local moveup = cc.MoveTo:create(0.5, cc.p(self.srcitemx , self.srcitemy+10))
    local movedown = cc.MoveTo:create(0.5, cc.p(self.srcitemx , self.srcitemy))
    local sequencd= cc.Sequence:create(moveup,movedown)
    print("个数",#self.capyitem)
    if #self.capyitem==0 then

        else
            local inname = Data.getItemData(self.capyitem[1]:getTag())
            UItool:setBool(inname.inname, true)
            UItool:setInteger(inname.inname.."num",self.capyitem[1]:getTag())
            self.capyitem[1]:runAction( cc.RepeatForever:create(sequencd))
            local key_item = Data.getItemData(self.capyitem[1]:getTag())
            -- self:itemname(key_item.name, 30,self.capyitem[1]:getPositionX(), self.capyitem[1]:getPositionY()+100,self.capyitem[1])
    end
end

function Merge:touchpoint()
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/dianji/Export/dianji/dianji.ExportJson") 
    self.dianji = ccs.Armature:create("dianji")
    self.dianji:getAnimation():playWithIndex(0,-1,-1)
    self.dianji:setPosition(cc.p(-200,-200))
    
    self.bag:addChild(self.dianji,13)
end

function Merge:clone( sprite )
    local icon = sprite:getTag()
    local name = sprite:getName()
    local  filename= Data.getItemData(icon)
    local newsprite = cc.Sprite:create(filename.pic)
    newsprite:setName(name)
    newsprite:setTag(icon)
    newsprite:setPosition(cc.p(sprite:getPositionX(),sprite:getPositionY()))
    self.bag:addChild(newsprite,3)
    return newsprite

end

function Merge:itemname(str,size,x,y,parente)
    print("显示文字")
    local alert = cc.LabelTTF:create()
    alert:setAnchorPoint(cc.p(0,0))
    alert:setContentSize(cc.size(300, 400))
    alert:setString(str)
    alert:setFontName(Zapfino)
    alert:setFontSize(size+5)
    alert:setColor(cc.c3b(251, 138, 38))
    alert:setPosition(cc.p( 10,parente:getContentSize().height+10))
    parente:addChild(alert,12)
end

function Merge:OnTouchBegan(touch, event)
    
    self.dianji:getAnimation():playWithIndex(0,-1,-1)
    self.dianji:setPosition(cc.p(touch:getLocation().x,touch:getLocation().y))

    local target = event:getCurrentTarget()  
    self.m_isTouchEnable = true
    local locationInNode = target:convertToNodeSpace(touch:getLocation())  
    local s = target:getContentSize()  
    local rect = cc.rect(0, 0, s.width, s.height) 

    if cc.rectContainsPoint(rect, locationInNode) then
        
        self.m_srcItem = nil  
        if self.m_isTouchEnable then  
            local location = touch:getLocation()
            self.m_srcItem = self:itempoint(location) 
            if self.m_srcItem then

                local key_item = Data.getItemData(self.m_srcItem:getTag())
                if key_item.appear == true then
                    -- print("11111111")
                    self.new_srcItem = self:clone(self.m_srcItem)
                    
                    table.insert(self.capyitem, self.new_srcItem)
                    self.srcitemx , self.srcitemy =  self.new_srcItem:getPosition()
                    self.m_srcItem:setVisible(false)
                    for key,var in pairs(self.bag_table) do
                        local key_items = Data.getItemData(var:getTag())
                        -- key_item.appear = true
                        if key_item== var:getTag()then
                            
                            else
                                key_items.appear = true
                                UItool:setBool(key_items.inname, false)
                        end
                     end
                    key_item.appear = false
                    elseif key_item.appear == false then
                        -- print("2222222222")
                        table.insert(self.capyitem, self.new_srcItem)
                        self.m_srcItem:setVisible(true)
                        key_item.appear = true
                end
            end
        end
        return self.m_isTouchEnable
          
    end  
    
    return false 
end

function Merge:itemtouch()
    

    local function onTouchBegan(touch, event)
        
        return self:OnTouchBegan(touch, event)
         
    end

    local function onTouchMoved(touch, event)
        if not self.m_isTouchEnable or not self.m_srcItem then  
            return  
        end

        local location = touch:getLocation()
        -- self.new_srcItem:setPosition(cc.p(touch:getLocation().x,self.srcitemy))
        
        local rects = cc.rect(0, 0,self.bag:getContentSize().width, self.bag:getContentSize().height)
        local halfSushiWidth = self.m_srcItem:getContentSize().width * 0.5  
        local halfSushiHeight = self.m_srcItem:getContentSize().height * 0.5 

        local zuoRect = cc.rect(  
        self.m_srcItem:getPositionX() - 17* halfSushiWidth,  
        self.m_srcItem:getPositionY() - halfSushiHeight,  
        self.m_srcItem:getContentSize().width*8,  
        self.m_srcItem:getContentSize().height  
        )  
        local youRect = cc.rect(  
        self.m_srcItem:getPositionX() + halfSushiWidth,  
        self.m_srcItem:getPositionY() - halfSushiHeight,  
        self.m_srcItem:getContentSize().width*8,  
        self.m_srcItem:getContentSize().height  
        ) 

        if cc.rectContainsPoint(rects, location) then
           if cc.rectContainsPoint(zuoRect,location) then
            
            self.new_srcItem:setPosition(cc.p(touch:getLocation().x,self.srcitemy))
            -- self:moveitem()
            return
            end  

            if cc.rectContainsPoint(youRect,location) then
           
            self.new_srcItem:setPosition(cc.p(touch:getLocation().x,self.srcitemy))
            -- self:moveitem()
            return
            end 
           
           else
        end  
    end

    local function onTouchEnded(touch, events)
        -- self:moveitem()
        local location = touch:getLocation()

        if self.new_srcItem and self.m_srcItem then
                self:moveitem()
                self:itemshake(self.new_srcItem)
            end

            
        -- local rects = cc.rect(0, 0,self.bag:getContentSize().width, self.bag:getContentSize().height)
        -- if cc.rectContainsPoint(rects, location) then
            
        --     if self.new_srcItem and self.m_srcItem then
        --         self:moveitem()
        --         self:itemshake(self.new_srcItem)
        --     end
        -- end

    end
    
    local listener = cc.EventListenerTouchOneByOne:create() -- 创建一个事件监听器
    listener:setSwallowTouches(true )
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispatcher = self:getEventDispatcher() -- 得到事件派发器
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.bag) -- 将监听器注册到派发器中
end

function Merge:itempoint( location )
    local item 
    local rect = cc.rect(0,0,0,0)  
    for key,var in pairs(self.bag_table) do
        -- local key_item = Data.getItemData(var:getTag())
        -- key_item.appear = true
        var:setVisible(true)
         var:setName(key)
     end
    for key,var in pairs(self.bag_table) do
         item = self.bag_table[key]  
         -- item:setSwallowTouches(true)
        if item then
           rect.x = item:getPositionX() - item:getContentSize().width * 0.5  
           rect.y = item:getPositionY() - item:getContentSize().height * 0.5  
           rect.width = item:getContentSize().width  
           rect.height = item:getContentSize().height  
           if cc.rectContainsPoint(rect,location) then
            self.itemnumber = key
            return item  
               
           end  
        end  
    end 

    return nil  
end

function Merge:moveitem( ... )
    for key,var in pairs(self.bag_table) do
       
        if key==self.itemnumber then
            else
                local rec1 = self.new_srcItem:getBoundingBox()
                local srcid = self.new_srcItem:getTag()
                local destid = var:getTag()
                local srcname = self.m_srcItem:getName()
                local destname = var:getName()
               
                local rec2 = var:getBoundingBox()
                if cc.rectIntersectsRect(rec1,rec2) then

                    for i=1,#Data.getdestMergeTable() do
                        local merged = Data.getMergeData(i) 
                         
                        if merged.id[1]==srcid and merged.id[2]==destid or merged.id[2]==srcid and merged.id[1]==destid  then
                            if srcname > destname then
                                table.remove(ModifyData.getTable(),tonumber(srcname))
                                table.remove(ModifyData.getTable(),tonumber(destname))
                                -- print("srcname > destname  srcname :%s , destname : %s",srcname,destname)
                                else
                                    -- print("srcname < destname  srcname :%s , destname : %s",srcname,destname)
                                    table.remove(ModifyData.getTable(),tonumber(destname))
                                    table.remove(ModifyData.getTable(),tonumber(srcname))
                            end
                            local src_item=Data.getItemData(srcid)
                            local dest_item=Data.getItemData(destid)
                            local padlock_item = Data.getItemData(merged.nid)
                            ModifyData.tableinsert(padlock_item.key)
                             UItool:setBool("pasitem", true)
                             UItool:setBool("touchend", false)
                             UItool:message2(src_item.name.." 和 "..dest_item.name.." 合成了 "..padlock_item.name,30)

                            break

                            else
                                local src_item=Data.getItemData(srcid)
                                local dest_item=Data.getItemData(destid)
                                UItool:message2(src_item.name.." 和 "..dest_item.name.." 合成失败 ",30)
                                UItool:setBool("touchend", true)
                                
                        end
                    end

                    else
                end
        end
    end

end


-- function table.removebyvalue(array, value, removeall)
--     local c, i, max = 0, 1, #array
--     while i <= max do
--         if array[i] == value then
--             table.remove(array, i)
--             c = c + 1
--             i = i - 1
--             max = max - 1
--             if not removeall then break end
--         end
--         i = i + 1
--     end
--     return c
-- end

return Merge

























