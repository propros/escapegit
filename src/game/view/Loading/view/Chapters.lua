

Chapters = class("Chapters",function()
    return cc.Layer:create()
end)

function Chapters:createScene(layer,panel)
    local Chapters = Chapters:new()
    
    Chapters:initScene(layer,panel)
    return Chapters
end
Chapters.background=nil
local center
local bottom
local left_top

function Chapters:initScene(layer,panel)
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

    -- self.chapternum = ModifyData.getChapterNum()

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

    self:Chapterbtn(layer,panel)
end

function Chapters:room2( num )
    print("room2s")
    -- ModifyData.setRoomNum(num+1)
    -- UItool:setInteger("roomNumber", num+1)
    -- UItool:setBool("ifcontinue", true) 
    -- self.scene = Data.JXSCENE[ModifyData.getChapterNum()][event:getTag()+1].name.new()
    -- local turn = cc.TransitionFade:create(1, self.scene)
    -- cc.Director:getInstance():replaceScene(turn)

    if UItool:getInteger("roomNumber")~=num+1 or UItool:getInteger("chapterNumber")~=ModifyData.getChapterNum() then
        
        UItool:message1("你确定要删除之前的存档重新开始游戏嘛？",30,function(select)
            if select == "yes" then

                ModifyData.removeDoc("GBposition")
                ModifyData.removeDoc("furniture")
                ModifyData.removeDoc("mergeitem")
                PublicData.MERGEITEM={}
                PublicData.FURNITURE={}
                PublicData.SAVEDATA={}
                if num+1==2 and ModifyData.getChapterNum()==1 then
                    table.insert(PublicData.MERGEITEM, 11)
                end
                
                ModifyData.setRoomNum(num+1)
                UItool:setInteger("roomNumber", num+1)
                UItool:setBool("ifcontinue", true) 
                local scene = Data.JXSCENE[ModifyData.getChapterNum()][num+1].name.new()
                local turn = cc.TransitionFade:create(1, scene)
                cc.Director:getInstance():replaceScene(turn)
                
                elseif select == "no" then
                    
            end
            end)

        else
            ModifyData.setRoomNum(num+1)
            UItool:setInteger("roomNumber", num+1)
            UItool:setBool("ifcontinue", true) 
            local scene = Data.JXSCENE[ModifyData.getChapterNum()][num+1].name.new()
            local turn = cc.TransitionFade:create(1, scene)
            cc.Director:getInstance():replaceScene(turn)

    end

end

local SelecteRoom3

function Chapters:room3( num )
    print("room3")
    -- ModifyData.setRoomNum(num+1)
    -- UItool:setInteger("roomNumber", num+1)
    -- UItool:setBool("ifcontinue", true) 
    -- self.scene = Data.JXSCENE[ModifyData.getChapterNum()][event:getTag()+1].name.new()
    -- local turn = cc.TransitionFade:create(1, self.scene)
    -- cc.Director:getInstance():replaceScene(turn)

    if UItool:getInteger("roomNumber")~=num+1 or UItool:getInteger("chapterNumber")~=ModifyData.getChapterNum() then
        
        UItool:message1("你确定要删除之前的存档重新开始游戏嘛？",30,function(select)
            if select == "yes" then

                ModifyData.removeDoc("GBposition")
                ModifyData.removeDoc("furniture")
                ModifyData.removeDoc("mergeitem")
                PublicData.MERGEITEM={}
                PublicData.FURNITURE={}
                PublicData.SAVEDATA={}
                
                ModifyData.setRoomNum(num+1)
                UItool:setInteger("roomNumber", num+1)
                UItool:setBool("ifcontinue", true) 
                local scene = Data.JXSCENE[ModifyData.getChapterNum()][num+1].name.new()
                local turn = cc.TransitionFade:create(1, scene)
                cc.Director:getInstance():replaceScene(turn)
                
                elseif select == "no" then
                    
            end
            end)

        else
            ModifyData.setRoomNum(num+1)
            UItool:setInteger("roomNumber", num+1)
            UItool:setBool("ifcontinue", true) 
            local scene = Data.JXSCENE[ModifyData.getChapterNum()][num+1].name.new()
            local turn = cc.TransitionFade:create(1, scene)
            cc.Director:getInstance():replaceScene(turn)

    end
end
local pagenums
function Chapters:Chapterbtn(layer ,panel)
    --local ziji = self
    local background = cc.CSLoader:createNode(Config.RES_CHAPTERS)
    background:setName("background") 
    layer:addChild(background)

    center = background:getChildByName("Node_center")
    center:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))
    bottom = background:getChildByName("Node_bottom")
    bottom:setPosition(cc.p(self.visibleSize.width/2,0))
    left_top = background:getChildByName("Node_left_top")
    left_top:setPosition(cc.p(0,self.visibleSize.height))

    local back = left_top:getChildByName("back")
    back:addClickEventListener(function ()
        if UItool:getBool("effect") then
            AudioEngine.playEffect("sound/gliss.mp3")
        end
        --self.background:removeFromParentAndCleanup()
        if layer:getChildByName("background") then
            layer:getChildByName("background"):removeFromParent()
            panel:setVisible(true)
        end
    end)

    local dian = {
    bottom:getChildByName("Node_dian"):getChildByName("dian_1"),
    bottom:getChildByName("Node_dian"):getChildByName("dian_2"),
    bottom:getChildByName("Node_dian"):getChildByName("dian_3")
    }   
    local page = center:getChildByName("PageView_1")
    pagenums = page:getCurPageIndex()+1
    print("lalala",pagenums)
    page:setClippingType(1) 
    for k,v in pairs(dian) do
        if k==page:getCurPageIndex()+1 then
            ModifyData.setChapterNum(k)
            v:setTexture("comm/xuanzhong.png")
            else
                v:setTexture("cn/Load/image/UI/dian.png")
        end
    end

    local function onPageViewevent(sender,eventType)
        if eventType == 0 then
            local pageindex = page:getCurPageIndex()
            print("··页码·",pageindex)
            pagenums = pageindex+1
            print("·hahaha··",pagenums)
            for k,v in pairs(dian) do 
                if k==page:getCurPageIndex()+1 then
                    v:setTexture("comm/xuanzhong.png")
                    ModifyData.setChapterNum(k)
                    else
                        v:setTexture("cn/Load/image/UI/dian.png")
                end
            end
        end

    end
    
    page:addEventListener(onPageViewevent)
    self:addChildpageNode()
    
end
--添加子pageview
function Chapters:addChildpageNode()
    local pagenum = pagenums
    local page = center:getChildByName("PageView_1")
    local num = 3
    local falg = false
    for i=1,num do
        local zinode = cc.CSLoader:createNode(Config.RES_PAGEITEM)
        local zipanel = page:getChildByName("Panel_"..i)
        zipanel:removeAllChildren()
        zipanel:addChild(zinode)

        local room = zinode:getChildByName("room1")
        if i==1 then
            else
                room:setTexture(Data.SCENE[i][1].changerolepic)
        end
        
        local roombtn = {
        room:getChildByName("room2"),
        room:getChildByName("room3")
    }
        room:getChildByName("room2"):setVisible(false)
        room:getChildByName("room3"):setVisible(false)

        local start = zinode:getChildByName("Button_1")
        local jiancha = zinode:getChildByName("Button_2")

        if self.Chaptertb[i].lock==1 then
            start:setEnabled(false)
            start:setBright(false)
            jiancha:setEnabled(false)
            jiancha:setBright(false)
        elseif self.Chaptertb[i].lock==0 then
            start:setEnabled(true)
            start:setBright(true)
            jiancha:setEnabled(true)
            jiancha:setBright(true)
        end
        local function eventTouch1(event,eventType)
            if eventType == TOUCH_EVENT_ENDED then
                 UItool:setInteger("chapterNumber", pagenums)
                if UItool:getInteger("roomNumber")==1 and UItool:getInteger("chapterNumber")==ModifyData.getChapterNum() then
                    ModifyData.setRoomNum(1)
                    UItool:setInteger("roomNumber", 1)
                    UItool:setBool("ifcontinue", true) 
                    local scene = Data.JXSCENE[ModifyData.getChapterNum()][1].name.new()
                    local turn = cc.TransitionFade:create(1, scene)
                    cc.Director:getInstance():replaceScene(turn)
                    
                    else
                        if UItool:getInteger("roomNumber")>1 or UItool:getInteger("chapterNumber")~=ModifyData.getChapterNum() then
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
                                    local scene = Data.JXSCENE[ModifyData.getChapterNum()][1].name.new()
                                    local turn = cc.TransitionFade:create(1, scene)
                                    cc.Director:getInstance():replaceScene(turn)
                                    if  UItool:getInteger("chapterNumber")==ModifyData.getChapterNum() then
                                        UItool:message4(" ...... "," 这里是，我的房间吗……？ ","但为什么，窗外像是海底的世界呢？","我想我应该出去看看……",30,scene)
                                    end
                                    elseif select == "no" then
                                        
                                end

                            end)

                            else
                                ModifyData.setRoomNum(1)
                                UItool:setInteger("roomNumber", 1)
                                UItool:setBool("ifcontinue", true) 
                                local scene = Data.JXSCENE[ModifyData.getChapterNum()][1].name.new()
                                local turn = cc.TransitionFade:create(1, scene)
                                cc.Director:getInstance():replaceScene(turn)
                                if  UItool:getInteger("chapterNumber")==ModifyData.getChapterNum() then
                                    UItool:message4(" ...... "," 这里是，我的房间吗……？ ","但为什么，窗外像是海底的世界呢？","我想我应该出去看看……",30,scene)
                                end
                                
                        end 
                end

                
            end
        end
        local visible = false
        local function eventTouch2(event,eventType)
            if eventType == TOUCH_EVENT_ENDED then
                if visible==false then
                    visible=true
                    room:getChildByName("room2"):setVisible(true)
                    room:getChildByName("room3"):setVisible(true)
                    else
                        visible=false
                        room:getChildByName("room2"):setVisible(false)
                        room:getChildByName("room3"):setVisible(false)
                end
                
            end
        end
        start:addClickEventListener(eventTouch1)
        jiancha:addClickEventListener(eventTouch2)

        local function roomeventTouch(event,eventType)
            if eventType == TOUCH_EVENT_ENDED then
                if UItool:getBool("effect") then
                    AudioEngine.playEffect("sound/gliss.mp3")
                end
                if event:getName()=="room2" then
                    print("room2")
                    local num = event:getTag()
                    Chapters:room2(num)
                    print("·编码,", pagenums)
                    UItool:setInteger("chapterNumber", pagenums)
                    elseif event:getName()=="room3" then
                        print("room3")
                        Chapters:room3(event:getTag())
                        print("·编码,", pagenums)
                        UItool:setInteger("chapterNumber", pagenums)
                end
            end
        end

        for key, var in pairs(roombtn) do
            var:loadTextures(Data.SCENE[i][key+1].changerolepic,Data.SCENE[i][key+1].changerolepic,Data.SCENE[i][key+1].changerolepican)
            var:setTag(key)
            var:addClickEventListener(roomeventTouch)
            if self.ROOMTABLE[ModifyData.getChapterNum()][key+1].lock==1 then
                var:setEnabled(false)
                var:setBright(false)
            elseif self.ROOMTABLE[ModifyData.getChapterNum()][key+1].lock==0 then
                var:setEnabled(true)
                var:setBright(true)
            end

        end
    end
end

function Chapters:onExit()

    if self.Chaptertb[key].lock==1 then
        UItool:setBool(var:getName(), false)
        var:setEnabled(false)
        var:setBright(false)
    elseif self.Chaptertb[key].lock==0 then
        UItool:setBool(var:getName(), true)
        var:setEnabled(true)
        var:setBright(true)
    end


    if i==1 then
        else
            if self.ROOMTABLE[ModifyData.getChapterNum()][i].lock==1 then
                room:getChildByName("room"..i):setEnabled(false)
                room:getChildByName("room"..i):setBright(false)
            elseif self.ROOMTABLE[ModifyData.getChapterNum()][i].lock==0 then
                room:getChildByName("room"..i):setEnabled(true)
                room:getChildByName("room"..i):setBright(true)
            end
    end
    
end


return Chapters

















