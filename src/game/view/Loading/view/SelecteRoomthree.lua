

SelecteRoomthree = class("SelecteRoomthree",function()
    return cc.Scene:create()
end)

function SelecteRoomthree:createScene()
    local SelecteRoomthree = SelecteRoomthree:new()
    
    SelecteRoomthree:initScene()
    return SelecteRoomthree
end
SelecteRoomthree.background=nil

function SelecteRoomthree:initScene()
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

function SelecteRoomthree:scene1(  )
    
    -- self.scene = Mainscene.new()
    -- local turn = cc.TransitionFade:create(1, self.scene)
    -- cc.Director:getInstance():replaceScene(turn)
    -- UItool:message4(" ...... "," “这里是，我的房间吗……？” ","“但为什么，窗外像是海底的世界呢？”","“我想我应该出去看看……”",30,self.scene)
end

function SelecteRoomthree:scene2(  )
    print("room2")
end

function SelecteRoomthree:scene3(  )
    print("room3")
end

function SelecteRoomthree:back(  )
    print("back")
    self:removeFromParent()
end

function SelecteRoomthree:Chapterbtn( )

    self.background = cc.CSLoader:createNode(Config.RES_SELECTEROOM3)
    --屏蔽层
    -- local shildinglayer = ShieldingLayerpin:new()
    -- self:addChild(shildinglayer) 
    self:addChild(self.background)

    local center = self.background:getChildByName("Node_center")
    center:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))

    local allUIbtn = 
    {
    center:getChildByName("scene1"),
    center:getChildByName("scene2"),
    center:getChildByName("scene3"),
    center:getChildByName("backbtn")
    }

    local function allUIbtnclick(event,eventType)

        if eventType == TOUCH_EVENT_ENDED then
            if UItool:getBool("effect") then
                AudioEngine.playEffect("gliss.mp3")
            end
            if event:getName()=="scene1" then
                -- UItool:message2("room1",30)
                self:scene1()
                elseif event:getName()=="scene2" then
                    -- UItool:message2("room2",30)
                    self:scene2()
                    elseif event:getName()=="scene3" then
                        -- UItool:message2("room3",30)
                        self:scene3()
                        elseif event:getName()=="backbtn" then
                            self:back()
                        
            end
            
        end

    end

    for key, var in pairs(allUIbtn) do
        var:addClickEventListener(allUIbtnclick)
        if self.ROOMTABLE[self.chapternum][key].lock==1 then
            var:setEnabled(false)
            var:setBright(false)
        elseif self.ROOMTABLE[self.chapternum][key].lock==0 then
            var:setEnabled(true)
            var:setBright(true)
        end
    end
    
end

function SelecteRoomthree:onExit()
    
end


return SelecteRoomthree
