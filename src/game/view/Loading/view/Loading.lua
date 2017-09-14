

Loading=class("Loading", function()
    return cc.Scene:create()
end)

function Loading:ctor()
    self.director = cc.Director:getInstance()
	self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    UItool:setBool("topbar",false) -- 对话框二
    -- UItool:removeUserXML( ) 
    UItool:setBool("merge", true) -- 物品栏是否可以点击

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

    for i=1,10 do
        print("cishu",i)
        for k=1,10 do
            print("次数",k)
            if k==5 then
                print("打印",k)
                break
            end
        end
    end

    self:signin() --UI
    
    self.pass1 = 1
    self.pass2 = 2
    self.pass3 = 3
    self.pass4 = 4
    self.pass5 = 5

    -- wsSendText = cc.WebSocket:create("ws://127.0.0.1:3000")

    local acount = 1
    local function settingcallback( )

        -- UItool:message2("设置",30)
        -- local PlayerLayer = PlayerLayer:createScene()
        -- print("进入拼图界面", PlayerLayer)
        -- self:addChild(PlayerLayer,125)

        -- 遮罩 
        
        --网络
        -- sendGetServer("zzzzzz", "zzzzzzz")

        --更改人物

        -- cc.Application:getInstance():openURL("http://www.baidu.com")
        
        -- UItool:specialitem(4)
        -- UItool:message("ceshi message ",30 ,function (select )
        --     if select == "yes" then
        --         print("点击确定")
        --         elseif select == "no" then
        --             print("点击取消")
        --         end
        -- end )
        self.scene = GameScene13.new()
        local turn = cc.TransitionFade:create(1, self.scene)
        cc.Director:getInstance():replaceScene(turn)
        
    end

    self.setting = cc.MenuItemImage:create("continue.png","continue2.png")
    self.setting:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))
    self.setting:setAnchorPoint(cc.p(0.5,0.5))
    self.setting:setVisible(false)
    -- self.setting:setScale(2)
    -- 对该按钮注册按键响应函数：
    self.setting:registerScriptTapHandler(settingcallback)
    
    self.menu=cc.Menu:create(self.setting)
    self.menu:setPosition(0,0) 
    self:addChild(self.menu,12)

    
    local chapternum = UItool:getIntegerdefault("chapterNumber",1)
    local roomnum = UItool:getIntegerdefault("roomNumber",1)
    --背景移动
    self.bg = cc.Sprite:create(Data.JXSCENE[chapternum][roomnum].bg)
    self.bg:setAnchorPoint(cc.p(0,0))
    self.bg:setPosition(0, 0)
    self:addChild(self.bg)

    local x
    local function update(delta) 
         
        if self.bg:getPositionX()==0 then
             x = -1
            elseif self.bg:getPositionX()==self.visibleSize.width - self.bg:getContentSize().width then
                 x = 1
        end
        
        self.bg:setPositionX(self.bg:getPositionX()+x )

    end  
    self:scheduleUpdateWithPriorityLua(update,0.1)
    
end 
function Loading:continue( )

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

    -- if self.savedata.study_over==true then
    --     print("真的")
    --     else
    --         print("假的")
    --         ModifyData.removeDoc("GBposition")
    --         ModifyData.removeDoc("furniture")
    --         ModifyData.removeDoc("mergeitem")
    --         -- ModifyData.removeDoc("chapter")
    --         ModifyData.removeDoc("shoucang")
    --         -- ModifyData.removeDoc("room")
    --         PublicData.MERGEITEM={}
    --         PublicData.FURNITURE={}
    --         PublicData.SAVEDATA={}
    --         -- PublicData.CHAPTERTABLE = {}
    --         -- PublicData.ROOMTABLE = {}
    --         PublicData.SHOUCANG = {}
    -- end

    local chapterstr = ModifyData.readFromDoc("chapter")
    PublicData.CHAPTERTABLE = json.decode(chapterstr)

    local roomstr = ModifyData.readFromDoc("room")
    PublicData.ROOMTABLE = json.decode(roomstr)

    local chapternum = UItool:getInteger("chapterNumber")
    local roomnum = UItool:getInteger("roomNumber")

    ModifyData.setChapterNum(chapternum)
    ModifyData.setRoomNum(roomnum)
    self.scene = Data.JXSCENE[chapternum][roomnum].name.new()
    local turn = cc.TransitionFade:create(1, self.scene)
    cc.Director:getInstance():replaceScene(turn)
    
end

function Loading:newgame()
    print("newgame")
    self.panel:setVisible(false)
    local scene = cc.Director:getInstance():getRunningScene()
    Chapters:createScene(scene,self.panel)
    -- self:addChild(chapters,3)
end

function Loading:shezhi()
    print("shezhi")
    local setting = Setting:createScene()
    print("shezhixuanze", setting)
    self:addChild(setting,3)
end

function Loading:shoucang()
    print("shoucang")
    local shoucang = Shoucang:createScene()
    self:addChild(shoucang,3)

end

function Loading:signin()
    print("打印输出")
    self.panel = cc.CSLoader:createNode(Config.RES_LOADING)
    self:addChild(self.panel,1)

    local chapternum = UItool:getIntegerdefault("chapterNumber",1)
    local roomnum = UItool:getIntegerdefault("roomNumber",1)
    self.center = self.panel:getChildByName("Node_center")
    local Node_logo = self.center:getChildByName("Node_logo") 
    self.center:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))
    -- changerole(chapternum,roomnum,self.center:getChildByName("role"))

    local right = self.panel:getChildByName("Node_right")
    right:setPosition(cc.p(self.visibleSize.width,self.visibleSize.height/2))
    local Node_btn = right:getChildByName("Node_btn")
    Node_btn:setVisible(false)

    local ruman = self.center:getChildByName("Node_logo"):getChildByName("ruman")
    local rotate = cc.RotateBy:create(2, -30)
    ruman:runAction( cc.RepeatForever:create(rotate))

    local shadow = self.center:getChildByName("shadow")
    shadow:addClickEventListener(function ()
        local moveto = cc.MoveTo:create(0.8, cc.p(-self.visibleSize.width/7,0))
        local scale = cc.ScaleTo:create(0.8, 0.85)
        Node_logo:runAction(cc.Spawn:create(moveto,scale))

        Node_btn:setVisible(true)
        Node_btn:setOpacity(0)
        local fadein = cc.FadeIn:create(0.8)
        Node_btn:runAction(fadein)
        shadow:setEnabled(false)
        end) 

    

    local left = self.panel:getChildByName("Node_left")
    left:setPosition(cc.p(0,self.visibleSize.height/2))
    
    if UItool:getBool("ifcontinue", false) then
        --todo
        right:getChildByName("Node_btn"):getChildByName("continue"):setVisible(true)
        else
            right:getChildByName("Node_btn"):getChildByName("continue"):setVisible(false)
    end
    
    local allUIbtn = 
    {
    right:getChildByName("Node_btn"):getChildByName("continue"),
    right:getChildByName("Node_btn"):getChildByName("chapter"),
    left:getChildByName("shezhi"),
    right:getChildByName("Node_btn"):getChildByName("handbook")
    }

    local function allUIbtnclick(event,eventType)
        if eventType == TOUCH_EVENT_ENDED then
            if UItool:getBool("effect",true) then
                AudioEngine.playEffect("sound/gliss.mp3")
            end
            
            if event:getName()=="chapter" then
                self:newgame()
                elseif event:getName()=="continue" then
                    self:continue()
                    elseif event:getName()=="handbook" then
                        print("handbook 收藏")
                        self:shoucang()
                        elseif event:getName()=="shezhi" then
                            print("设置")
                            self:shezhi()
            end 
        end
    end
    for key, var in pairs(allUIbtn) do
        var:addClickEventListener(allUIbtnclick)
    end 
end
function Loading:onEnter()
    
end





return Loading











