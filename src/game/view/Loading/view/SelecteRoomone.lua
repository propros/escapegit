

SelecteRoomone = class("SelecteRoomone",function()
    return cc.Scene:create()
end)

function SelecteRoomone:createScene()
    local SelecteRoomone = SelecteRoomone:new()
    
    SelecteRoomone:initScene()
    return SelecteRoomone
end
SelecteRoomone.background=nil

function SelecteRoomone:initScene()
    self.director = cc.Director:getInstance()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()


    self.chapternum = ModifyData.getChapterNum()

    if #PublicData.ROOMTABLE==0 then
        local docpath = cc.FileUtils:getInstance():getWritablePath().."room.txt"
        if cc.FileUtils:getInstance():isFileExist(docpath)==false then
            local str = json.encode(Data.SCENE)
            ModifyData.writeToDoc(str,"room")
            PublicData.ROOMTABLE = Data.SCENE
        else
            local str = ModifyData.readFromDoc("room")
            PublicData.ROOMTABLE = json.decode(str)
        end
    end
    
    
    self.ROOMTABLE = PublicData.ROOMTABLE

    self:Chapterbtn()
   
end

function SelecteRoomone:scene1(  )

    self:getParent():removeFromParent()

    if #PublicData.STUDY==0 then
        local docpath = cc.FileUtils:getInstance():getWritablePath().."study_over.txt"
        ---- print("文件是否存在",cc.FileUtils:getInstance():isFileExist(docpath),docpath)
        if cc.FileUtils:getInstance():isFileExist(docpath)==false then
            local str = json.encode(Data.STUDY)
            ModifyData.writeToDoc(str,"study_over")
            PublicData.STUDY = UItool:deepcopy(Data.STUDY)  
        else
            local str = ModifyData.readFromDoc("study_over")
            PublicData.STUDY = json.decode(str)
        end
    end

    self.savedata = PublicData.STUDY

    if self.savedata.study_over==true then
        print("真的")
        else
            print("假的")
            ModifyData.removeDoc("GBposition")
            ModifyData.removeDoc("furniture")
            ModifyData.removeDoc("mergeitem")
            -- ModifyData.removeDoc("chapter")
            ModifyData.removeDoc("shoucang")
            -- ModifyData.removeDoc("room")
            PublicData.MERGEITEM={}
            PublicData.FURNITURE={}
            PublicData.SAVEDATA={}
            -- PublicData.CHAPTERTABLE = {}
            -- PublicData.ROOMTABLE = {}
            PublicData.SHOUCANG = {}
    end

    if UItool:getInteger("roomNumber")==1 and UItool:getInteger("chapterNumber")==1 then
        ModifyData.setRoomNum(1)
        UItool:setInteger("roomNumber", 1)
        UItool:setBool("ifcontinue", true) 
        self.scene = GameScene11.new()
        local turn = cc.TransitionFade:create(1, self.scene)
        cc.Director:getInstance():replaceScene(turn)
        
        else
            if UItool:getInteger("roomNumber")>1 or UItool:getInteger("chapterNumber")>1 then
                UItool:message1("你确定要删除之前的存档重新开始游戏嘛？",30,function(select)
                    if select == "yes" then
                        UItool:setBool("oneroomagain", true)
                        ModifyData.removeDoc("GBposition")
                        ModifyData.removeDoc("furniture")
                        ModifyData.removeDoc("mergeitem")
                        ModifyData.ITEM_TABLE={}
                        PublicData.MERGEITEM={}
                        PublicData.FURNITURE={}
                        PublicData.SAVEDATA={}
                        
                        ModifyData.setRoomNum(1)
                        UItool:setInteger("roomNumber", 1)
                        UItool:setBool("ifcontinue", true) 
                        self.scene = GameScene11.new()
                        local turn = cc.TransitionFade:create(1, self.scene)
                        cc.Director:getInstance():replaceScene(turn)
                        UItool:message4(" ...... "," 这里是，我的房间吗……？ ","但为什么，窗外像是海底的世界呢？","我想我应该出去看看……",30,self.scene)
                        elseif select == "no" then
                            
                    end

                end)

                else
                    ModifyData.setRoomNum(1)
                    UItool:setInteger("roomNumber", 1)
                    UItool:setBool("ifcontinue", true) 
                    self.scene = GameScene11.new()
                    local turn = cc.TransitionFade:create(1, self.scene)
                    cc.Director:getInstance():replaceScene(turn)
                    UItool:message4(" ...... "," 这里是，我的房间吗……？ ","但为什么，窗外像是海底的世界呢？","我想我应该出去看看……",30,self.scene)
            end 
    end

    
    
end

function SelecteRoomone:scene2(  )
    self:getParent():removeFromParent()
    if UItool:getInteger("roomNumber")~=2 or UItool:getInteger("chapterNumber")~=1 then
        
        UItool:message1("你确定要删除之前的存档重新开始游戏嘛？",30,function(select)
                if select == "yes" then

                    ModifyData.removeDoc("GBposition")
                    ModifyData.removeDoc("furniture")
                    ModifyData.removeDoc("mergeitem")
                    PublicData.MERGEITEM={}
                    PublicData.FURNITURE={}
                    PublicData.SAVEDATA={}
                    table.insert(PublicData.MERGEITEM, 11)
                    Data.getItemData(5).ifcontain = true
                    
                    ModifyData.setRoomNum(2)
                    UItool:setInteger("roomNumber", 2)
                    UItool:setBool("ifcontinue", true) 
                    self.scene = GameScene12.new()
                    local turn = cc.TransitionFade:create(1, self.scene)
                    cc.Director:getInstance():replaceScene(turn)
                    
                    elseif select == "no" then
                        
                end
                end)

        else
            ModifyData.setRoomNum(2)
            UItool:setInteger("roomNumber", 2)
            UItool:setBool("ifcontinue", true) 
            self.scene = GameScene12.new()
            local turn = cc.TransitionFade:create(1, self.scene)
            cc.Director:getInstance():replaceScene(turn)

    end

end

function SelecteRoomone:scene3(  )
    self:getParent():removeFromParent()
    if UItool:getInteger("roomNumber")~=3 or UItool:getInteger("chapterNumber")~=1 then
        
        UItool:message1("你确定要删除之前的存档重新开始游戏嘛？",30,function(select)
                if select == "yes" then

                    ModifyData.removeDoc("GBposition")
                    ModifyData.removeDoc("furniture")
                    ModifyData.removeDoc("mergeitem")
                    PublicData.MERGEITEM={}
                    PublicData.FURNITURE={}
                    PublicData.SAVEDATA={}
                    -- table.insert(PublicData.MERGEITEM, 11)
                    -- Data.getItemData(5).ifcontain = true
                    
                    ModifyData.setRoomNum(3)
                    UItool:setInteger("roomNumber", 3)
                    UItool:setBool("ifcontinue", true) 
                    self.scene = GameScene13.new()
                    local turn = cc.TransitionFade:create(1, self.scene)
                    cc.Director:getInstance():replaceScene(turn)
                    
                    elseif select == "no" then
                        
                end
                end)

        else
            ModifyData.setRoomNum(3)
            UItool:setInteger("roomNumber", 3)
            UItool:setBool("ifcontinue", true) 
            self.scene = GameScene13.new()
            local turn = cc.TransitionFade:create(1, self.scene)
            cc.Director:getInstance():replaceScene(turn)

    end
    print("room3")
end

function SelecteRoomone:back(  )
    print("back")
    self:removeFromParent()
end

function SelecteRoomone:Chapterbtn( )

    self.background = cc.CSLoader:createNode(Config.RES_SELECTEROOM1)
    --屏蔽层
    -- local shildinglayer = ShieldingLayerpin:new()
    -- self:addChild(shildinglayer) 
    self:addChild(self.background)

    local center = self.background:getChildByName("Node_center")
    center:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))

    -- local back = center:getChildByName("backbtn")
    -- back :addClickEventListener(function ()
    --     self:back()
    --     end)

    local allUIbtn = 
    {
    center:getChildByName("scene1"),
    center:getChildByName("scene2"),
    center:getChildByName("scene3")
    }

    local function allUIbtnclick(event,eventType)

        if eventType == TOUCH_EVENT_ENDED then
            if UItool:getBool("effect") then
                AudioEngine.playEffect("sound/gliss.mp3")
            end
            if event:getName()=="scene1" then
                
                self:scene1()
                elseif event:getName()=="scene2" then
                    
                    self:scene2()
                    elseif event:getName()=="scene3" then
                        
                        self:scene3()
            end
            
        end

    end

    for key, var in pairs(allUIbtn) do
        var:addClickEventListener(allUIbtnclick)

        if self.ROOMTABLE[self.chapternum][key].lock==1 then
            -- btn = cc.ui.UIPushButton.new({normal = chapterBtnData.pic2}, {scale9 = true})
            var:setEnabled(false)
            var:setBright(false)
        elseif self.ROOMTABLE[self.chapternum][key].lock==0 then
            -- btn = cc.ui.UIPushButton.new({normal = chapterBtnData.pic}, {scale9 = true})
            var:setEnabled(true)
            var:setBright(true)
        end

    end
    
end

function SelecteRoomone:onExit()
    
end


return SelecteRoomone
