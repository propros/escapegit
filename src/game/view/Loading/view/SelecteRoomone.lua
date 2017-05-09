

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
    ModifyData.setRoomNum(1)
    self.scene = Mainscene.new()
    local turn = cc.TransitionFade:create(1, self.scene)
    cc.Director:getInstance():replaceScene(turn)
    -- UItool:message4(" ...... "," “这里是，我的房间吗……？” ","“但为什么，窗外像是海底的世界呢？”","“我想我应该出去看看……”",30,self.scene)
end

function SelecteRoomone:scene2(  )
    ModifyData.setRoomNum(2)
    print("room2")
end

function SelecteRoomone:scene3(  )
    ModifyData.setRoomNum(3)
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
                AudioEngine.playEffect("gliss.mp3")
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
