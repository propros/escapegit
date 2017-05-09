

Chapters = class("Chapters",function()
    return cc.Scene:create()
end)

function Chapters:createScene()
    local Chapters = Chapters:new()
    
    Chapters:initScene()
    return Chapters
end
Chapters.background=nil
local center

function Chapters:initScene()
    self.director = cc.Director:getInstance()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    if #PublicData.CHAPTERTABLE==0 then
        local docpath = cc.FileUtils:getInstance():getWritablePath().."chapter.txt"
        if cc.FileUtils:getInstance():isFileExist(docpath)==false then
            local str = json.encode(Data.CHAPTER)
            ModifyData.writeToDoc(str,"chapter")
            PublicData.CHAPTERTABLE = Data.CHAPTER
            print("写文件")
        else
            print("读文件")
            local str = ModifyData.readFromDoc("chapter")
            PublicData.CHAPTERTABLE = json.decode(str)
        end
    end

    self.Chaptertb = PublicData.CHAPTERTABLE

    self:Chapterbtn()
end

local room1num = 1
local SelecteRoom1
function Chapters:room1(  )
    print("room1")

    local room2 = center:getChildByName("room2")
    local room3 = center:getChildByName("room3")
    if room1num==1 then
        center:getChildByName("room1"):setScale(2)
        SelecteRoom1 = SelecteRoomone:createScene()
        self:addChild(SelecteRoom1,3)
        ModifyData.setChapterNum(1)
        self.back:setVisible(false)
        room2:setPositionX(room2:getPositionX()+300)
        room3:setPositionX(room3:getPositionX()+300)
        room1num=room1num+1

        UItool:getBool("room2")
        if UItool:getBool("room2") then
            room2:setTouchEnabled(false)
            room2:setBright(false)
            else
                --todo
        end

        if UItool:getBool("room3") then
            room3:setTouchEnabled(false)
            room3:setBright(false)
            else
                --todo
        end
        
        else
            --todo
            center:getChildByName("room1"):setScale(1)
            if UItool:getBool("room2") then
                room2:setTouchEnabled(true)
                room2:setBright(true)
                else
                    --todo
            end

            if UItool:getBool("room3") then
                room3:setTouchEnabled(true)
                room3:setBright(true)
                else
                    --todo
            end

            SelecteRoom1:removeFromParent()
            self.back:setVisible(true)
            room1num = room1num - 1
            room2:setPositionX(room2:getPositionX()-300)
            room3:setPositionX(room3:getPositionX()-300)
    end

end

local room2num = 1
local SelecteRoom2
function Chapters:room2(  )
    print("room2")
    local room1 = center:getChildByName("room1")
    local room3 = center:getChildByName("room3")
    if room2num==1 then
        center:getChildByName("room2"):setScale(2)
        SelecteRoom2 = SelecteRoomtwo:createScene()
        self:addChild(SelecteRoom2,3)
        ModifyData.setChapterNum(2)
        self.back:setVisible(false)
        
        room3:setPositionX(room3:getPositionX()+300)
        room2num=room2num+1
        room1:setTouchEnabled(false)
        room1:setBright(false)

        if UItool:getBool("room3") then
            room3:setTouchEnabled(false)
            room3:setBright(false)
            else
                --todo
        end

        else
            center:getChildByName("room2"):setScale(1)
            if UItool:getBool("room3") then
                room3:setTouchEnabled(true)
                room3:setBright(true)
                else
                    --todo
            end

            room1:setTouchEnabled(true)
            room1:setBright(true)

            SelecteRoom2:removeFromParent()
            self.back:setVisible(true)
            room2num = room2num - 1
            room3:setPositionX(room3:getPositionX()-300)
    end

end

local SelecteRoom3
local room3num = 1
function Chapters:room3( )
    local room1 = center:getChildByName("room1")
    local room2 = center:getChildByName("room2")

    if room3num==1 then
        center:getChildByName("room3"):setScale(2)
        SelecteRoom3 = SelecteRoomthree:createScene()
        
            SelecteRoom3:setOpacity(2)
        
        self:addChild(SelecteRoom3,3)
        ModifyData.setChapterNum(3)
        self.back:setVisible(false)
        room3num=room3num+1
        room1:setTouchEnabled(false)
        room1:setBright(false)
        room2:setTouchEnabled(false)
        room2:setBright(false)

        else
            center:getChildByName("room3"):setScale(1)
            room1:setTouchEnabled(true)
            room1:setBright(true)
            room2:setTouchEnabled(true)
            room2:setBright(true)

            SelecteRoom3:removeFromParent()
            self.back:setVisible(true)
            room3num = room3num - 1

    end
end

function Chapters:Chapterbtn( )

    self.background = cc.CSLoader:createNode(Config.RES_CHAPTERS)
    --屏蔽层
    local shildinglayer = ShieldingLayerpin:new()
    self:addChild(shildinglayer) 
    self:addChild(self.background)

    center = self.background:getChildByName("Node_center")
    center:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))

    local function back(  )
    print("back")
        self:removeFromParent()
    end
    self.back = center:getChildByName("back")
    self.back :addClickEventListener(function ()
        if UItool:getBool("effect") then
            AudioEngine.playEffect("gliss.mp3")
        end
        back()
        end)

    local allUIbtn = 
    {
    center:getChildByName("room1"),
    center:getChildByName("room2"),
    center:getChildByName("room3")
    
    }

    local function allUIbtnclick(event,eventType)

        if eventType == TOUCH_EVENT_ENDED then
            if UItool:getBool("effect") then
                AudioEngine.playEffect("gliss.mp3")
            end
            if event:getName()=="room1" then
                self:room1()
                elseif event:getName()=="room2" then
                    -- UItool:message2("room2",30)
                    self:room2()
                    elseif event:getName()=="room3" then
                        -- UItool:message2("room3",30)
                        self:room3()
                        
            end
            
        end

    end

    for key, var in pairs(allUIbtn) do
        var:addClickEventListener(allUIbtnclick)

        if self.Chaptertb[key].lock==1 then
            -- btn = cc.ui.UIPushButton.new({normal = chapterBtnData.pic2}, {scale9 = true})
            UItool:setBool(var:getName(), false)
            var:setEnabled(false)
            var:setBright(false)
        elseif self.Chaptertb[key].lock==0 then
            UItool:setBool(var:getName(), true)
            var:setEnabled(true)
            var:setBright(true)
        end
    end
    
end

function Chapters:onExit()
    
end


return Chapters
