
GameScene12=class("GameScene12", function()
    return cc.Scene:create()
end)

GameScene12.panel = nil
local roomNumber
local chapterNumber


function GameScene12:ctor()

    local function onNodeEvent(event)
        
        if event == "enter" then
            self:onEnter()
            elseif event == "enterTransitionFinish" then
                self:onEnterTransitionFinish()
        end
    end
    self:registerScriptHandler(onNodeEvent)

    self.director = cc.Director:getInstance()
    self.visibleSize = cc.Director:getInstance():getVisibleSize() 
    self.winsize = cc.Director:getInstance():getWinSizeInPixels()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    if #PublicData.SAVEDATA==0 then
        local docpath = cc.FileUtils:getInstance():getWritablePath().."GBposition.txt"
        ---- print("文件是否存在",cc.FileUtils:getInstance():isFileExist(docpath),docpath)
        if cc.FileUtils:getInstance():isFileExist(docpath)==false then
            local str = json.encode(Data.SAVEDATA)
            ModifyData.writeToDoc(str,"GBposition")
            PublicData.SAVEDATA = UItool:deepcopy(Data.SAVEDATA)
            
        else
            
            local str = ModifyData.readFromDoc("GBposition")
            PublicData.SAVEDATA = json.decode(str)
        end
    end


    self.savedata = PublicData.SAVEDATA
    

      -- 家具状态
    if #PublicData.FURNITURE==0 then
        local docpath = cc.FileUtils:getInstance():getWritablePath().."furniture.txt"
        ---- print("文件是否存在",cc.FileUtils:getInstance():isFileExist(docpath),docpath)
        if cc.FileUtils:getInstance():isFileExist(docpath)==false then
            local str = json.encode(Data.FURNITURE12)
            ModifyData.writeToDoc(str,"furniture")
            
            PublicData.FURNITURE = UItool:deepcopy(Data.FURNITURE12)
        else
            local str = ModifyData.readFromDoc("furniture")
            PublicData.FURNITURE = json.decode(str)
        end
    end

    self.furnituretb = PublicData.FURNITURE
    roomNumber = ModifyData.getRoomNum()
    chapterNumber = ModifyData.getChapterNum()

    --人物缩放
    self.girlx = 0.28
    self.girly = 0.28

    --下蹲屏蔽时间
    self.screenxiadun = 1.3
    --弯腰屏蔽时间
    self.screenwanyao = 1.2

    self.director = cc.Director:getInstance()
    self.visibleSize = cc.Director:getInstance():getVisibleSize() 
    self.winsize = cc.Director:getInstance():getWinSizeInPixels()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    -- 家具底层
    self.panel = cc.CSLoader:createNode(Config.RES_GAMESCENE12)
    self.panel:setPosition(cc.p(0,0))
    self:addChild(self.panel,4)

    --合成条
    self.merge = Merge:createScene()
    self:addChild(self.merge,5)

    --主节点
    self.node =  self.panel:getChildByName("Node_left_top")
    self.node:setPosition(0, self.visibleSize.height)
    --背景
    self.bg = self.node:getChildByName("bg")
    self.yuyan = self.bg:getChildByName("yuyan")
    --家具层
    self.furniture = self.bg:getChildByName("furniture")

    --返回按钮
    local mainback = self.node:getChildByName("back")
    mainback:addClickEventListener(function ()
        if UItool:getBool("effect") then
            AudioEngine.playEffect("gliss.mp3")
        end
        --返回loading

        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("res/donghua/huolu/huolu.ExportJson") 
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("res/donghua/weiniang/weiniang.ExportJson") 
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("res/donghua/mao/mao.ExportJson") 

        local scene = Loading.new()
        local turn = cc.TransitionFade:create(1,scene)
        cc.Director:getInstance():replaceScene(turn)
        end)

        local shezhi = self.panel:getChildByName("Node_right_top"):getChildByName("shezhi")
        shezhi:addClickEventListener(function ()
        if UItool:getBool("effect") then
            AudioEngine.playEffect("gliss.mp3")
        end
        --返回loading
        local setting = Setting:createScene()
        self:addChild(setting,13)
        end)
    
    
    
    
    self.grossini = GIRL:new()
    self.grossini:setScaleX(-self.girlx)
    self.grossini:setScaleY(self.girly)
    self.grossini:stand()
    self:addChild(self.grossini,12)

    self.bg:setPositionX(self.savedata.bgpositionx)
    self.grossini:setPosition(cc.p(self.savedata.girlpositionx,140))

    local function update(delta)  
        self:update(delta)  
        
        if UItool:getBool("pasitem") then
            --重新渲染合成界面
            UItool:setBool("pasitem",false)

            self:megerupdate()
            
        end
    end  
    self:scheduleUpdateWithPriorityLua(update,0.3)

    self:fishmove() --鱼的移动 
    self:fire_weiniang_mao()
end

function GameScene12:megerupdate()
    self.merge:removeSelf()
    self.merge = Merge:createScene()
    self:addChild(self.merge,5)
end

function GameScene12:wanyao()
    self.layer=cc.Layer:create()
    local shildinglayer = Shieldingscreenmessage3:new()
    self.layer:addChild(shildinglayer)
    self.layer:addTo(self,126)
    --1.8秒消失后
    local layer =  self.layer
    local timer = TimerExBuf()
    timer:create(self.screenwanyao,1,1)
    function timer:onTime()
        layer:removeFromParent()
        timer:stop()
    end
    timer:start()
    
    self.grossini:getAnimation():play("stoop_1")--弯腰
end 


function GameScene12:xiadun()
    self.layer=cc.Layer:create()
    local shildinglayer = Shieldingscreenmessage3:new()
    self.layer:addChild(shildinglayer)
    self.layer:addTo(self,126)
    --1.8秒消失后
    local layer =  self.layer
    local timer = TimerExBuf()
    timer:create(self.screenxiadun,1,1)
    function timer:onTime()
        layer:removeFromParent()
        timer:stop()
    end
    timer:start()
    self.grossini:getAnimation():play("squat_1") -- 下蹲
end


function GameScene12:init()
    self:ontouch()
    
    self:AllButtons()
    -- self:fishmove() --鱼的移动 
end

function GameScene12:fire_weiniang_mao( )
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/donghua/huolu/huolu.ExportJson") 
    self.huolu = ccs.Armature:create("huolu")
    self.huolu:setAnchorPoint(cc.p(0.5,0.4))
    self.huolu:getAnimation():playWithIndex(0,1,1)
    self.huolu:setPosition(cc.p(self.furniture:getChildByName("stove"):getPositionX()+10,self.furniture:getChildByName("stove"):getPositionY()+10))
    self.bg:addChild(self.huolu,16)
    
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/donghua/weiniang/weiniang.ExportJson") 
    self.weiniang = ccs.Armature:create("weiniang")
    
    self.weiniang:setAnchorPoint(cc.p(0.5,0.4))
    self.weiniang:getAnimation():playWithIndex(0,1,1)
    self.weiniang:getAnimation():play("Animation1")
    
    self.weiniang:setPosition(cc.p(self.furniture:getChildByName("weiniang"):getPositionX(),self.furniture:getChildByName("weiniang"):getPositionY()-10))
    self.bg:addChild(self.weiniang,16)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/donghua/mao/mao.ExportJson") 
    self.mao = ccs.Armature:create("mao")
    self.mao:setAnchorPoint(cc.p(0.5,0))
    self.mao:getAnimation():playWithIndex(0,1,1)
    self.mao:getAnimation():play("Animation2")
    self.mao:setPosition(cc.p(self.furniture:getChildByName("cat"):getPositionX(),self.furniture:getChildByName("cat"):getPositionY()-5))
    self.bg:addChild(self.mao,16)
end
function GameScene12:update( delta )

    local fish1 = self.fish1:getPositionX()
    local fish2 =self.fish2:getPositionX()
    local fish3 =  self.fish3:getPositionX()
    local fish4 = self.fish4 :getPositionX()

    local fish5 = self.fish5:getPositionX()
    local fish6 = self.fish6:getPositionX()
    local fish7 = self.fish7:getPositionX()
    local fish8x = self.fish8:getPositionX()
    local fish8y = self.fish8:getPositionY()

    local fish9 = self.fish9:getPositionX()

    local speed = 1 
  
    fish1 = fish1 + speed  
    fish2 = fish2 - speed - 1
    fish3 = fish3 - speed -2
    fish4 = fish4 + speed *1.2

    fish5 = fish5 + speed +1.1
    fish6 = fish6 - speed -2.5
    fish7 = fish7 - speed 
    fish8x = fish8x - speed -1.8
    fish8y = fish8y - speed -1.1

    fish9 = fish9 - speed 
    
    local width = self.winsize.width 
    local height = self.winsize.height
  
    if fish1 > width *2 + self.fish1:getContentSize().width*0.6 then
        fish1 = -self.fish1:getContentSize().width*0.6
    end

    if fish2 < -self.fish2:getContentSize().width * 0.6 then  
        fish2 = 2*width + self.fish2:getContentSize().width * 0.6
    end  

    if fish3 < -self.fish3:getContentSize().width * 0.6 then  
        fish3 = width * 2 + self.fish3:getContentSize().width*0.6
        
    end  
  
    if fish6 < -self.fish6:getContentSize().width*0.6  then  
        fish6 = width *2 +self.fish6:getContentSize().width*0.6
    end  


    if fish7 < -self.fish7:getContentSize().width*0.6 then
        fish7 = width *2 +self.fish7:getContentSize().width*0.6
    end

    if fish4 > width *2 + self.fish4:getContentSize().width*0.6 then
        fish4 = -self.fish4:getContentSize().width*0.6
    end

    if fish5 > width *2 + self.fish5:getContentSize().width*0.6 then
        fish5 = - self.fish5:getContentSize().width*0.6
    end


    if fish9 < -self.fish9:getContentSize().width*0.6 then
        fish9 = width *2 +self.fish9:getContentSize().width*0.6
    end

    if fish8x < -self.fish8:getContentSize().width*0.7 then
        fish8x = width *2 +self.fish8:getContentSize().width*0.6
    end

    if fish8y < -self.fish8:getContentSize().height then
        fish8y = height +self.fish8:getContentSize().height*0.6
    end

    self.fish1:setPositionX(fish1)
    self.fish2:setPositionX(fish2)
    self.fish3:setPositionX(fish3)
    self.fish4:setPositionX(fish4)
    self.fish5:setPositionX(fish5)
    self.fish6:setPositionX(fish6)
    self.fish7:setPositionX(fish7)
    self.fish9:setPositionX(fish9)
    self.fish8:setPosition(cc.p(fish8x,fish8y))

end

function GameScene12:fishmove()  
    self.fish1 = self.bg:getChildByName("fish1")
    self.fish2 = self.bg:getChildByName("fish2")
    self.fish3 = self.bg:getChildByName("fish3")
    self.fish4 = self.bg:getChildByName("fish4")
    self.fish5 = self.bg:getChildByName("fish5")
    self.fish6 = self.bg:getChildByName("fish6")
    self.fish7 = self.bg:getChildByName("fish7")
    self.fish8 = self.bg:getChildByName("fish8")
    self.fish9 = self.bg:getChildByName("fish9")
    
    
    local function updateFunc(dt)  
        self:update(dt)  
    end  
end 

function GameScene12:frontdoor()
    print("前门")
    local frontdoor_locationx,frontdoor_locationy = UItool:getitem_location(self.furniture:getChildByName("frontdoor"), self.bg:getPositionX())
    
    GameScenemove(math.floor( frontdoor_locationx),frontdoor_locationy ,function (  )
        UItool:message2("我不需要回去。",30)
        end,self.grossini,self.bg)

end

function GameScene12:biaopan()
    print("表盘")
    
    local bell6_locationx,bell6_locationy = UItool:getitem_location(self.furniture:getChildByName("bell6"), self.bg:getPositionX())
    
        GameScenemove(math.floor( bell6_locationx-self.grossini:getContentSize().width/4),bell6_locationy ,function (  )
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)
            if self.furnituretb[19].num==1 then
                UItool:message2("盖子上没有把手，我没有办法就这样打开它……得找个东西把它撬开才行。",30)
                self.furnituretb[19].num= self.furnituretb[19].num +1
                    elseif self.furnituretb[19].num==2 then
                        if UItool:getBool("scissors") then
                            UItool:message2(" 不行……剪刀有点钝了，插不进去……",30)
                            -- UItool:setBool("scissors", false)
                            elseif UItool:getBool("knife") then

                                local itemnum = UItool:getInteger("knifenum")
                                for i=1,#PublicData.MERGEITEM do
                                    if PublicData.MERGEITEM[i] == itemnum then
                                        table.remove(PublicData.MERGEITEM,i) 
                                        break
                                    end
                                end
                                UItool:setBool("knife",false)
                                UItool:message2("刚刚好插进去，应该可以撬开它……",30)
                                
                                self.layers=cc.Layer:create()
                                local shildinglayer = Shieldingscreenmessage3:new()
                                self.layers:addChild(shildinglayer)
                                self.layers:addTo(self,126)
                                --1.25秒消失后
                                local layers =  self.layers

                                local selfs =  self
                                local timer = TimerExBuf()
                                timer:create(1,1,1)

                                function timer:onTime()
                                    --音效
                                    layers:removeFromParent()
                                    selfs:megerupdate()
                                    UItool:message2("小刀断掉了，不过好在钟表的罩子也打开了。",30)
                                    timer:stop()
                                end
                                timer:start()

                                
                                
                                self.furnituretb[19].num=self.furnituretb[19].num+1
                                self.furnituretb[19].open = true
                                if self.furnituretb[17].open then
                                    self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell4.png")
                                    else
                                        self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell1.png")        
                                end
                                else
                                    UItool:message2("得找个东西把它撬开。",30)
                                
                            
                        end
                        elseif self.furnituretb[19].num==3 then
                            if UItool:getBool("zhizhen") then
                                UItool:message2("安上去了！现在可以拨动指针调整时间了。",30)
                                local itemnum = UItool:getInteger("zhizhennum")
                                for i=1,#PublicData.MERGEITEM do
                                    if PublicData.MERGEITEM[i] == itemnum then
                                        table.remove(PublicData.MERGEITEM,i) 
                                        break
                                    end
                                end
                                self.furnituretb[19].zhizhenhad = true
                                
                                self.furnituretb[19].num = self.furnituretb[19].num+1
                                UItool:setBool("zhizhen",false)
                                if self.furnituretb[17].open then
                                    self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell5.png")
                                    else
                                        self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell2.png")        
                                end
                                elseif UItool:getBool("handsclock") or UItool:getBool("fenzhen")then
                                    UItool:message2("只有一根指针没有什么用，我最好还是把时针和分针都找到了再安上比较好。",30)
                                    else
                                        UItool:message2("这个钟表盘上没有指针。",30)
                            end

                            elseif self.furnituretb[19].num==4 then
                                UItool:message2("要把它调到几点呢？",30)
                                self.panel_clock = cc.CSLoader:createNode(Config.RES_CLOCK)
                                local shildinglayer = Shieldingscreen:new()
                                self:addChild(shildinglayer,12)
                                shildinglayer:addChild(self.panel_clock,12)
                                self.node_center_clock = self.panel_clock:getChildByName("Node_center")
                                self.commdi=self.node_center_clock:getChildByName("commdi")
                                self.clockdi=self.commdi:getChildByName("clockdi")

                                self.fen_btn = self.commdi:getChildByName("fen_btn")
                                self.shi_btn = self.commdi:getChildByName("shi_btn")

                                self.fenzhen = self.clockdi:getChildByName("fenzhen")
                                self.shizhen = self.clockdi:getChildByName("shizhen")
                                self.fen_num = 0
                                self.shi_num = 0
                                self.fen_bool = false
                                self.shi_bool = false
                                self:zhizhenzhuandong()

            end
            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()

            end,self.grossini,self.bg)
        

end

function GameScene12:zhizhenzhuandong( )

    self.fen_btn:addClickEventListener(function ()
        local fenrotate = cc.RotateBy:create(0.01, -30)
        self.fenzhen:runAction(fenrotate)

        if self.furnituretb[17].door==false then
            self.fen_num = self.fen_num - 5
            if self.fen_num<0 then
                self.fen_num=55
            end
            if self.furnituretb[17].putname=="yaoshi" and self.fen_num== 50 then
                self.fen_bool=true
                elseif self.furnituretb[17].putname=="taowa" and self.fen_num== 0 then
                    self.fen_bool=true
                    else
                        self.fen_bool=false
            end
            else
                self.fen_num = 0
        end

        if self.fen_bool  and self.shi_bool  then
            UItool:message2("密码正确提示",30)
        end

        -- print("分针数字:",self.fen_num)
        
        end)

    self.shi_btn:addClickEventListener(function ()
        local shirotate = cc.RotateBy:create(0.01, -30)
        self.shizhen:runAction(shirotate)
        
        if self.furnituretb[17].door==false then
            self.shi_num = self.shi_num - 1
            if self.shi_num<0 then
                self.shi_num=11
            end
            if self.furnituretb[17].putname=="yaoshi" and self.shi_num== 8 then
                self.shi_bool=true
                elseif self.furnituretb[17].putname=="taowa" and self.shi_num== 9 then
                    self.shi_bool=true
                    else
                        self.shi_bool=false
            end
            else
                self.shi_num=0

        end

        if self.fen_bool and self.shi_bool  then
            UItool:message2("密码正确提示",30)
        end

        -- print("时针数字",self.shi_num)
        
        end)

end

function GameScene12:canmeger( shi,fen )

    if shi==self.shi_num and fen == self.fen_num then
        return true

        else
            return false
    end
end

function GameScene12:biaoshen()
    print("表身")
    local bell6_locationx,bell6_locationy = UItool:getitem_location(self.furniture:getChildByName("bell6"), self.bg:getPositionX())
    
        GameScenemove(math.floor( bell6_locationx-self.grossini:getContentSize().width/3),bell6_locationy ,function (  )
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)
        if self.furnituretb[17].num==1 then
            UItool:message2("它好像卡住了……不过我觉得用点力气的话，应该可以拉开它。",30)
            self.furnituretb[17].num=self.furnituretb[17].num+1
            elseif self.furnituretb[17].num==2 then
                UItool:message4("嘿！","打开了！不过里面什么都没有，钟摆也没有在摆动的样子。","……不过这个钟还真是奇怪，外面看起来明明还很新，钟身里面却已经很旧了……","感觉就好像钟内和钟外的时间并不同步一样。",30)
                if self.furnituretb[19].open then
                    if self.furnituretb[19].zhizhenhad then
                        self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell5.png")
                        else
                            self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell4.png")
                    end
                    
                    else
                         self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell3.png")   
                end
                self.furnituretb[17].num=self.furnituretb[17].num+1
                print("音效")
                self.furnituretb[17].open = true
                elseif self.furnituretb[17].num==3 then
                    --把物品放进去
                    if UItool:getBool("rongyaoshi") then    
                        UItool:message2("放进了熔化的钥匙。",30)
                        local itemnum = UItool:getInteger("rongyaoshinum")
                        self.furniture:getChildByName("bell6"):getChildByName("bad_key"):setVisible(true)
                        self.furnituretb[17].putin=true 
                        for i=1,#PublicData.MERGEITEM do
                            if PublicData.MERGEITEM[i] == itemnum then
                                table.remove(PublicData.MERGEITEM,i) 
                                break
                            end
                        end
                        
                        

                        self.furnituretb[17].num = self.furnituretb[17].num+1
                        self.furnituretb[17].shi = 8
                        self.furnituretb[17].fen = 50
                        self.furnituretb[17].putname="yaoshi"
                        self.furnituretb[17].door=true
                        self.furniture:getChildByName("bell6"):getChildByName("biaoshen_men"):setEnabled(true)
                        UItool:setBool("rongyaoshi",false)

                        elseif UItool:getBool("taowa") then
                            UItool:message2("放进了套娃。",30)
                            local itemnum = UItool:getInteger("taowanum")
                            self.furniture:getChildByName("bell6"):getChildByName("taowa"):setVisible(true)
                            self.furnituretb[17].putin=true
                            for i=1,#PublicData.MERGEITEM do
                                if PublicData.MERGEITEM[i] == itemnum then
                                    table.remove(PublicData.MERGEITEM,i) 
                                    break
                                end
                            end
                            
                            

                            self.furnituretb[17].num = self.furnituretb[17].num+1
                            self.furnituretb[17].shi = 9
                            self.furnituretb[17].fen = 0
                            self.furnituretb[17].putname="taowa"
                            self.furnituretb[17].door=true
                            self.furniture:getChildByName("bell6"):getChildByName("biaoshen_men"):setEnabled(true)
                            UItool:setBool("taowa",false)
                            else
                                if UItool:getBool("elseitem") then
                                    UItool:message2( Data.COMMTALK[math.random(5)],30)
                                    else
                                        UItool:message2("里面似乎曾经放过什么东西。",30)
                                end
                                
                    end

                    elseif self.furnituretb[17].num==4 then
                        self.furnituretb[17].open = true
                        
                        self.furniture:getChildByName("bell6"):getChildByName("biaoshen_men"):setEnabled(true)
                        if self.furnituretb[17].door==false then
                            self.furnituretb[17].num = self.furnituretb[17].num-1

                            if self.furnituretb[19].open then
                                if self.furnituretb[19].zhizhenhad then
                                    self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell5.png")
                                    else
                                        self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell4.png")
                                end
                                
                                else
                                     self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell3.png")   
                            end

                            if self:canmeger(self.furnituretb[17].shi,self.furnituretb[17].fen) then
                                if self.furnituretb[17].putname=="yaoshi" then
                                    self.furnituretb[17].putin=false
                                    UItool:message2(" 获得了墙柜钥匙。 ",30)
                                    self.furnituretb[17].putname=""
                                    local key_item = Data.getItemData(46)
                                    table.insert(PublicData.MERGEITEM, key_item.key)
                                   
                                    self.furnituretb[17].door=true
                                    self.furniture:getChildByName("bell6"):getChildByName("biaoshen_men"):setEnabled(true)
                                    elseif self.furnituretb[17].putname=="taowa" then
                                        self.furnituretb[17].putname=""
                                        self.furnituretb[17].putin=false
                                        UItool:message2(" ……是我的洋娃娃！它怎么会在这……",30)
                                        local key_item = Data.getItemData(50)
                                        table.insert(PublicData.MERGEITEM, key_item.key)
                                        
                                        self.furnituretb[17].door=true
                                        self.furniture:getChildByName("bell6"):getChildByName("biaoshen_men"):setEnabled(true)
                                end
                                else
                                    self.furnituretb[17].door=true
                                    if self.furnituretb[17].putname=="yaoshi" then
                                        local itemnum = UItool:getInteger("rongyaoshinum")
                                        self.furniture:getChildByName("bell6"):getChildByName("bad_key"):setVisible(true)
                                        elseif self.furnituretb[17].putname=="taowa" then
                                            local itemnum = UItool:getInteger("taowanum")
                                            self.furniture:getChildByName("bell6"):getChildByName("taowa"):setVisible(true)
                                    end
                            end
                            
                        end
                        
                        
            else
                
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        end,self.grossini,self.bg)
end

function GameScene12:biaoshen_men()
    print("表身门 是否放入了东西",self.furnituretb[17].putin)
    self.furnituretb[17].num = 4
    self.furnituretb[17].door=false
    self.furniture:getChildByName("bell6"):getChildByName("bad_key"):setVisible(false)
    self.furniture:getChildByName("bell6"):getChildByName("taowa"):setVisible(false)
    self.furniture:getChildByName("bell6"):getChildByName("biaoshen_men"):setEnabled(false)
    if self.furnituretb[17].putin==true then
        -- self:disapperitem()
        self.furnituretb[17].open = false
        if self.furnituretb[19].open then
                if self.furnituretb[19].zhizhenhad then
                    self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell2.png")
                    else
                        self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell1.png")
                end
                
                else
                     self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell6.png")   
            end
        else
            if self.furnituretb[19].open then
                if self.furnituretb[19].zhizhenhad then
                    self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell2.png")
                    else
                        self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell1.png")
                end
                
                else
                     self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell6.png")   
            end
    end

end

function GameScene12:changji()
    print("唱机")
    local changji_locationx,changji_locationy = UItool:getitem_location(self.furniture:getChildByName("phonograph"), self.bg:getPositionX())
    
        GameScenemove(math.floor( changji_locationx-self.grossini:getContentSize().width/6),changji_locationy ,function (  )
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)
        if self.furnituretb[15].num==1 then
            if UItool:getBool("changpian") then
                UItool:message2(" 播放唱片后，留声机里长出了一根……芽？ ",30)
                
                local itemnum = UItool:getInteger("changpiannum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                self.furniture:getChildByName("phonograph"):setTexture("changesprite/GameScene12/phonograph.png")
                self.furnituretb[15].ifchangesprite = true
                
                self.furnituretb[15].num = self.furnituretb[15].num+1
                UItool:setBool("changpian",false)
                else
                    if UItool:getBool("elseitem") then
                        UItool:message2( Data.COMMTALK[math.random(5)],30)
                        else
                            UItool:message2(" 留声机。如果我有唱片的话，就可以让它播放出美妙的音乐。 ",30)
                    end
                    
            end
            elseif self.furnituretb[15].num==2 then
                UItool:message2("芽上有一颗种子，我把它摘了下来。",30)
                self.furnituretb[15].num = self.furnituretb[15].num+1
                local key_item = Data.getItemData(35)
                table.insert(PublicData.MERGEITEM, key_item.key)
                self.furniture:getChildByName("phonograph"):setTexture("changesprite/GameScene12/phonograph2.png")
                
            else
                if UItool:getBool("elseitem") then
                    UItool:message2( Data.COMMTALK[math.random(5)],30)
                    else
                        UItool:message2(" 留声机，可以播放出美妙的音乐。 ",30)
                end
                
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)
end

function GameScene12:jigui()
    print("机柜") 
    local jigui_locationx,jigui_locationy = UItool:getitem_location(self.furniture:getChildByName("phonograph"), self.bg:getPositionX())

        GameScenemove( math.floor( jigui_locationx-self.grossini:getContentSize().width/6),jigui_locationy ,function ()

            self:xiadun()--

        if self.furnituretb[14].num==1 then
                --todo
            if UItool:getBool("jigui_key") then
                
                UItool:message2(" 打开了，里面可能会有有用的东西？ ",30)
                
                local itemnum = UItool:getInteger("jigui_keynum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                self.furniture:getChildByName("phonograph"):setTexture("changesprite/GameScene12/phonograph2.png")
                self.furnituretb[14].ifchangesprite = true
                
                self.furnituretb[14].num = self.furnituretb[14].num+1
                UItool:setBool("jigui_key",false)
                else
                    if UItool:getBool("elseitem") then
                        UItool:message2( Data.COMMTALK[math.random(5)],30)
                        else
                            UItool:message2(" 锁住了，打不开……",30)
                    end

                    
            end
            elseif self.furnituretb[14].num==2 then
                self.furnituretb[14].num = self.furnituretb[14].num+1
                UItool:message2("都是空盒子，只有这一张了。",30)
                local key_item = Data.getItemData(34)
                table.insert(PublicData.MERGEITEM, key_item.key)
                

            else
                UItool:message2(" 里面的盒子都是空的了。 ",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)

end

function GameScene12:stove()
    print("火炉")
    local stove_locationx,stove_locationy = UItool:getitem_location(self.furniture:getChildByName("stove"), self.bg:getPositionX())

        GameScenemove( math.floor( stove_locationx-self.grossini:getContentSize().width/6),stove_locationy ,function ()
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[7].num==1 then 
            UItool:message2( "壁炉烧着火，里面似乎有什么东西？",30)
            self.furnituretb[7].num=self.furnituretb[7].num+1
            elseif self.furnituretb[7].num==2 then

                if UItool:getBool("huoqian") then
                    self:xiadun() -- 下蹲

                    UItool:setBool("huoqian",false)
                    UItool:message2(" 是把熔化了的钥匙，如果不把它恢复原状的话是没有办法使用的。",30)
                    local key_item = Data.getItemData(29)
                    table.insert(PublicData.MERGEITEM, key_item.key)
                    self.furniture:getChildByName("badkey"):setVisible(false)
                    self.furnituretb[7].bool=false
                    local itemnum = UItool:getInteger("huoqiannum")
                    for i=1,#PublicData.MERGEITEM do
                        if PublicData.MERGEITEM[i] == itemnum then
                            table.remove(PublicData.MERGEITEM,i) 
                            break
                        end
                    end
                    
                    
                    self.furnituretb[7].num = self.furnituretb[7].num+1
                    UItool:setBool("stool",false)
                    else
                        
                        if UItool:getBool("elseitem") then
                            UItool:message2( Data.COMMTALK[math.random(5)],30)
                            else
                                UItool:message2(" 就这样伸手去拿会烫伤的，我不要…… ",30)
                        end
                end

            else
                UItool:message2(" 壁炉烧着火，真暖和啊。 ",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)

end

function GameScene12:dabihua()
    print("大壁画")
    local bihua_locationx,bihua_locationy = UItool:getitem_location(self.furniture:getChildByName("dabihua"), self.bg:getPositionX())

        GameScenemove( bihua_locationx,bihua_locationy ,function (  )
            print("开大图")
            UItool:message2("壁画上面的钟指向了九点",30)

        end,self.grossini,self.bg)

end

function GameScene12:statuecat()
    print("雕塑猫")

     local statuecat_locationx,statuecat_locationy= UItool:getitem_location(self.furniture:getChildByName("statuecat"), self.bg:getPositionX())

        GameScenemove( math.floor( statuecat_locationx-self.grossini:getContentSize().width/6),statuecat_locationy ,function ()

        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[8].num==1 then
            if UItool:getBool("maoyan") then
                UItool:message2(" 猫雕塑下面的抽屉弹出来了，里面有一条……小鱼饼？",30)
                local key_item = Data.getItemData(28)
                table.insert(PublicData.MERGEITEM, key_item.key)
                UItool:setBool("maoyan",false)
                local itemnum = UItool:getInteger("maoyannum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                self.furniture:getChildByName("statuecat"):loadTextures("changesprite/GameScene12/statuecat.png","changesprite/GameScene12/statuecat.png")
                
                
                self.furnituretb[8].num = self.furnituretb[8].num+1
                self.furnituretb[8].ifchangesprite = true
                else
                    if UItool:getBool("elseitem") then
                        UItool:message2( Data.COMMTALK[math.random(5)],30)
                        else
                            UItool:message2(" 这只猫雕塑没有眼睛。 ",30)
                    end
                    
            end

            else
                UItool:message2(" 一座猫雕塑。 ",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)

end

function GameScene12:ligui()
    print("立柜")
    local ligui_locationx,ligui_locationy = UItool:getitem_location(self.bg:getChildByName("ligui"), self.bg:getPositionX())

        GameScenemove( math.floor( ligui_locationx-self.grossini:getContentSize().width/6),ligui_locationy ,function (  )

        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)

            self:wanyao() --弯腰
            self.bg:getChildByName("ligui"):loadTextures("changesprite/GameScene12/ligui.png","changesprite/GameScene12/ligui.png")
            if self.furnituretb[6].num==1 then
                UItool:message2("这是什么？钳子？为什么客厅的柜子里会有这种东西啊……",30)
                local key_item = Data.getItemData(27)
                table.insert(PublicData.MERGEITEM, key_item.key)
                
                self.furnituretb[6].ifchangesprite=true
                self.furnituretb[6].bool = false
                self.furnituretb[6].num = self.furnituretb[6].num +1
                else
                    UItool:message2("里面什么都没有了。",30)
                
            end
            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()
        end,self.grossini,self.bg)

end

function GameScene12:letter()
    print("信件")
    local letter_locationx,letter_locationy = UItool:getitem_location(self.furniture:getChildByName("letter"), self.bg:getPositionX())

        GameScenemove( math.floor( letter_locationx-self.grossini:getContentSize().width/6),letter_locationy ,function (  )

        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
            self:wanyao()--弯腰

            if self.furnituretb[3].num==1 then
                UItool:message2("亲爱的……我诚挚邀请您参加我们家族的聚会，请务必光临 ",30)
                local key_item = Data.getItemData(24)
                table.insert(PublicData.MERGEITEM, key_item.key)
                
                self.furnituretb[3].bool = false
                self.furniture:getChildByName("letter"):setVisible(false)
                self.furniture:getChildByName("qingjian"):setTouchEnabled(false)
                self.furnituretb[3].num = self.furnituretb[3].num +1
                
            end

            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()

        end,self.grossini,self.bg)
end

function GameScene12:teatable()
    print("茶几")
    
    local teatable_locationx,teatable_locationy = UItool:getitem_location(self.furniture:getChildByName("teatable"), self.bg:getPositionX())
    GameScenemove( math.floor( teatable_locationx-self.grossini:getContentSize().width/6),teatable_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        UItool:message2("……可以踩上去吗？",30)
        end,self.grossini,self.bg)

end

function GameScene12:cat()
    print("cat猫")
    local cat_locationx,cat_locationy = UItool:getitem_location(self.furniture:getChildByName("cat"), self.bg:getPositionX())

        GameScenemove( math.floor( cat_locationx-self.grossini:getContentSize().width/6),cat_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
            
            if self.furnituretb[13].num==1 then
                self.furnituretb[13].num=self.furnituretb[13].num+1
                UItool:message2("桌上有只看起来很凶的猫，它的爪子下似乎有什么东西。",30)
                elseif self.furnituretb[13].num==2 then
                    --todo
                if UItool:getBool("xiaoyubing") then
                    UItool:message2("现在那只猫应该没工夫理我了，我得赶紧把指针拿走。",30)
                    local itemnum = UItool:getInteger("xiaoyubingnum")
                    for i=1,#PublicData.MERGEITEM do
                        if PublicData.MERGEITEM[i] == itemnum then
                            table.remove(PublicData.MERGEITEM,i) 
                            break
                        end
                    end
                    self.mao:getAnimation():playWithIndex(0,1,1)
                    self.mao:getAnimation():play("Animation1")
                    self.furnituretb[13].foodhad = true
                    UItool:setBool("xiaoyubing",false)
                    
                    self.furnituretb[13].num=self.furnituretb[13].num+1

                    else
                        if UItool:getBool("elseitem") then
                            UItool:message2( Data.COMMTALK[math.random(5)],30)
                            else
                                UItool:message2("它看起来太凶了，我不敢靠近……",30)
                        end
                        
                end
                else
                    UItool:message2("猫在吃东西。最好还是不要去打扰它。",30)
            end
            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()
        end,self.grossini,self.bg)
end

function GameScene12:handsclock()
    print("handsclock")
    local handsclock_locationx,handsclock_locationy = UItool:getitem_location(self.furniture:getChildByName("handsclock"), self.bg:getPositionX())

    GameScenemove( math.floor(handsclock_locationx-self.grossini:getContentSize().width/6),handsclock_locationy ,function ()
        
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)

        if self.furnituretb[13].foodhad  then --猫获取到了食物
            self:wanyao() --弯腰

            UItool:message2("拿到了钟表的时针。",30)
            local key_item = Data.getItemData(36)
            table.insert(PublicData.MERGEITEM, key_item.key)
            
            self.furnituretb[16].bool=false
            self.furniture:getChildByName("handsclock"):setVisible(false)
            self.furniture:getChildByName("handsclock_btn"):setEnabled(false)
            else
                UItool:message2("桌上有只看起来很凶的猫，它的爪子下似乎有什么东西。",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
    end,self.grossini,self.bg)

end

function GameScene12:dengzhao()
    print("灯罩")

    local dengzhao_locationx,dengzhao_locationy = UItool:getitem_location(self.furniture:getChildByName("dengzhao"), self.bg:getPositionX())

    GameScenemove( math.floor(dengzhao_locationx-self.grossini:getContentSize().width/6),dengzhao_locationy ,function ()
        
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)

        if self.furnituretb[5].num == 1   then
            self.furniture:getChildByName("floor_lamp"):setTexture("changesprite/GameScene12/floor_lamp.png")
            UItool:message2("这个灯怎么发出的是绿光？我记得以前不是啊……难道是灯泡出了什么问题么……" , 30)
            self.furnituretb[5].ifchangesprite=true 
            self.furnituretb[5].num = self.furnituretb[5].num + 1
            elseif  self.furnituretb[5].num == 2 then
                self.furnituretb[5].num = self.furnituretb[5].num + 1
                self.furniture:getChildByName("floor_lamp"):setTexture("changesprite/GameScene12/floor_lamp2.png")
                UItool:message2("……一双石头猫眼？是它们在发光？" , 30)
                local key_item = Data.getItemData(26)
                table.insert(PublicData.MERGEITEM, key_item.key)
                

            else
                UItool:message2(" 这盏灯坏了! " , 30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
    end,self.grossini,self.bg)
end

local gaytalknum = 1
function GameScene12:weiniangcallback()
    print("伪娘")
    local weiniang_locationx,weiniang_locationy = UItool:getitem_location(self.furniture:getChildByName("weiniang"), self.bg:getPositionX())

    GameScenemove( math.floor(weiniang_locationx-self.grossini:getContentSize().width/6),weiniang_locationy ,function ()
        
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)

        if UItool:getBool("flower_ring") then

            UItool:setBool("qinghua",false)
            UItool:setBool("zihua",false)
            UItool:setBool("fenhua",false)
            UItool:setBool("zi_qing",false)
            UItool:setBool("fen_qing",false)
            UItool:setBool("zi_fen",false)

            UItool:message2("这个花环真漂亮呀，我收下了，作为回报，这个小水壶就送给你了。",30)
            UItool:setBool("flower_ring",false)
            local itemnum = UItool:getInteger("flower_ringnum")
            for i=1,#PublicData.MERGEITEM do
                if PublicData.MERGEITEM[i] == itemnum then
                    table.remove(PublicData.MERGEITEM,i) 
                    break
                end
            end
            local key_item = Data.getItemData(42)
            table.insert(PublicData.MERGEITEM, key_item.key)
            

            elseif UItool:getBool("letter") then
                UItool:message2("这是给我的东西呀，谢谢，这个小刀给你。",30)
                UItool:setBool("letter",false)
                local itemnum = UItool:getInteger("letternum")
                    for i=1,#PublicData.MERGEITEM do
                        if PublicData.MERGEITEM[i] == itemnum then
                            table.remove(PublicData.MERGEITEM,i) 
                            break
                        end
                    end
                    local key_item = Data.getItemData(43)
                    table.insert(PublicData.MERGEITEM, key_item.key)
                    
                elseif UItool:getBool("daocao") then
                    UItool:message2("谢谢……虽然我想要的并不是这样没有美感的东西。",30)
                    UItool:setBool("daocao",false)
                    local itemnum = UItool:getInteger("daocaonum")
                        for i=1,#PublicData.MERGEITEM do
                            if PublicData.MERGEITEM[i] == itemnum then
                                table.remove(PublicData.MERGEITEM,i) 
                                break
                            end
                        end
                        local key_item = Data.getItemData(44)
                        table.insert(PublicData.MERGEITEM, key_item.key)
                        
                    elseif UItool:getBool("hair") then
                        self.weiniang:getAnimation():playWithIndex(0,1,1)
                        self.weiniang:getAnimation():play("Animation2")
                        self.furnituretb[20].heihua = true

                        UItool:message3("谢谢，这个头发很漂亮，我收下了。","不过果然，我还是想要你的头发啊。",30)
                        UItool:setBool("hair",false)
                        local itemnum = UItool:getInteger("hairnum")
                        for i=1,#PublicData.MERGEITEM do
                            if PublicData.MERGEITEM[i] == itemnum then
                                table.remove(PublicData.MERGEITEM,i) 
                                break
                            end
                        end
                        local key_item = Data.getItemData(49)
                        table.insert(PublicData.MERGEITEM, key_item.key)
                        
                        elseif UItool:getBool("doll") then
                            UItool:message2("她的头发好漂亮能给我嘛？",30)
                            elseif UItool:getBool("qinghua") or UItool:getBool("zihua") or UItool:getBool("fenhua") or UItool:getBool("zi_qing") or UItool:getBool("fen_qing") or UItool:getBool("zi_fen")  then
                                UItool:message2("谢谢，但这些花太少了。",30)
                                elseif UItool:getBool("doll") then
                                    UItool:message2("她的头发真漂亮呀，能给我吗？",30)
                        
                    else
                        
                        if self.furnituretb[20].heihua then
                            UItool:message2("不过果然，我还是想要你的头发啊。",30)
                            else
                                if UItool:getBool("elseitem") then
                                    UItool:message2( "我不想要这个。",30)
                                    else
                                        UItool:message2( Data.GAYTALK[gaytalknum],30)
                                        gaytalknum = gaytalknum + 1
                                        if gaytalknum==5 then
                                            gaytalknum=1
                                        end
                                end
                                
                        end
        end

        
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
    end,self.grossini,self.bg)
end

function GameScene12:key_up()
    print("key_up 上面的钥匙")

    local key_up_locationx,key_up_locationy = UItool:getitem_location(self.furniture:getChildByName("key_up"), self.bg:getPositionX())

        GameScenemove( key_up_locationx,key_up_locationy ,function (  )

            if self.furnituretb[9].num==1 and self.furnituretb[13].foodhad == false then
                UItool:message2("茶几正上方的吊灯上吊着一把钥匙，可是茶几上的那只猫太凶了，我不敢贸然踩上去。 ",30)
                self.furnituretb[9].num = self.furnituretb[3].num +1
                elseif self.furnituretb[13].foodhad == true then
                    local key_item = Data.getItemData(33)
                    table.insert(PublicData.MERGEITEM, key_item.key)
                    UItool:message2(" 趁着它在吃东西，取走了钥匙。 ",30)

                    self.furnituretb[9].bool = false
                    self.furniture:getChildByName("key_up"):setVisible(false)
                    self.furniture:getChildByName("key_up"):setTouchEnabled(false)
                    self.furnituretb[9].num = self.furnituretb[3].num +1
                else
                    UItool:message2("那只猫太凶了…… ",30)
            end
            
            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()
        end,self.grossini,self.bg)

end

function GameScene12:built_in()
    print("壁橱")
    local built_in_locationx,built_in_locationy = UItool:getitem_location(self.furniture:getChildByName("built_in"), self.bg:getPositionX())
    GameScenemove( built_in_locationx,built_in_locationy ,function ()
        if self.furnituretb[21].num==1 then
            if UItool:getBool("qianggui_key") then
                UItool:message2(" 是个套娃，它看起来长得好像我的洋娃娃。",30)
                
                local itemnum = UItool:getInteger("qianggui_keynum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                
                self.furniture:getChildByName("built_in"):loadTextures("changesprite/GameScene12/built_in.png","changesprite/GameScene12/built_in.png")
                
                
                self.furnituretb[21].num = self.furnituretb[21].num+1
                else
                    if UItool:getBool("elseitem") then
                        UItool:message2( Data.COMMTALK[math.random(5)],30)
                        else
                            UItool:message2("被锁上了，打不开。",30)
                    end
            end

            elseif self.furnituretb[21].num==2 then
                UItool:message2(" 得到了套娃！",30)
                self.furnituretb[21].num = self.furnituretb[21].num + 1
                self.furniture:getChildByName("built_in"):loadTextures("changesprite/GameScene12/built_in_empty.png","changesprite/GameScene12/built_in_empty.png")
                local key_item = Data.getItemData(48)
                table.insert(PublicData.MERGEITEM, key_item.key)
                UItool:setBool("qianggui_key",false)
                
                else
                    -- UItool:message2(" 先去找钥匙好吗！！！",30)
                
        end

        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        end,self.grossini,self.bg)
end

local daocaonum = 0
function GameScene12:flowerpot()
    print("flowerpot花盆")
    local dengzhao_locationx,dengzhao_locationy = UItool:getitem_location(self.furniture:getChildByName("flowerpot"), self.bg:getPositionX())

    GameScenemove( math.floor(dengzhao_locationx-self.grossini:getContentSize().width/6),dengzhao_locationy ,function ()
        
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)

        if self.furnituretb[18].num == 1   then
            if UItool:getBool("seed") then
                UItool:message2("埋入了种子。",30)
                UItool:setBool("seed",false)
                local itemnum = UItool:getInteger("seednum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                
            
                self.furnituretb[18].num=self.furnituretb[18].num+1
                local str = json.encode(self.furnituretb)
                ModifyData.writeToDoc(str,"furniture")
                else
                    if UItool:getBool("elseitem") then
                        UItool:message2( Data.COMMTALK[math.random(5)],30)
                        else
                            UItool:message2("空的花盆。很适合用来种花。",30)
                    end
            end
            
            elseif  self.furnituretb[18].num == 2 then
                if UItool:getBool("shuihu") then
                    UItool:message2("种子浇了水之后迅速地生长成了……稻草？",30)
                    self.furniture:getChildByName("flowerpot"):setScaleY(2)
                    UItool:setBool("shuihu",false)
                    self.furniture:getChildByName("flowerpot2"):setTexture("changesprite/GameScene12/flowerpot1.png")

                    local itemnum = UItool:getInteger("shuihunum")
                    for i=1,#PublicData.MERGEITEM do
                        if PublicData.MERGEITEM[i] == itemnum then
                            table.remove(PublicData.MERGEITEM,i) 
                            break
                        end
                    end
                    
                    self.furnituretb[18].num=self.furnituretb[18].num+1
                    local str = json.encode(self.furnituretb)
                    ModifyData.writeToDoc(str,"furniture")
                    else
                        if UItool:getBool("elseitem") then
                            UItool:message2( Data.COMMTALK[math.random(5)],30)
                            else
                                UItool:message2("种下了种子的花盆，但是如果不做点别的什么的话，它是不会长出来的。",30)
                        end
                        
                end
                elseif  self.furnituretb[18].num == 3 then
                    daocaonum = daocaonum + 1
                    if UItool:getBool("scissors") then
                        UItool:message2(" 把稻草剪了下来，不过可以用来做什么？",30)
                        self.furniture:getChildByName("flowerpot"):setScaleY(1)
                        local key_item = Data.getItemData(41)
                        table.insert(PublicData.MERGEITEM, key_item.key)
                        UItool:setBool("scissors",false)
                        
                        self.furnituretb[18].num=self.furnituretb[18].num+1
                        self.furniture:getChildByName("flowerpot2"):setTexture("changesprite/GameScene12/flowerpot2.png")
                        else
                            if UItool:getBool("elseitem") then
                                UItool:message2( Data.COMMTALK[math.random(5)],30)
                                else
                                    if daocaonum%2==1 then
                                        UItool:message2("金黄色的稻草，颜色和我的头发还挺像的。",30)
                                        elseif daocaonum%2==0 then
                                            UItool:message2("用拔的应该不太行……",30)
                                    end
                            end
                            
                    end
                    
                    local str = json.encode(self.furnituretb)
                    ModifyData.writeToDoc(str,"furniture")
            else
                
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
    end,self.grossini,self.bg)
end

function GameScene12:qinghua()
    print("绿花")
     local qinghua_locationx,qinghuap_locationy = UItool:getitem_location(self.furniture:getChildByName("qinghua"), self.bg:getPositionX())

        GameScenemove( math.floor(qinghua_locationx-self.grossini:getContentSize().width/6),qinghua_locationy ,function (  )
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)
            
            if self.furnituretb[10].num==1 then
                -- if UItool:getBool("scissors") then
                    UItool:message2(" 绿色的花朵。看起来很好看，就拿了几支。",30)
                    local key_item = Data.getItemData(30)
                    table.insert(PublicData.MERGEITEM, key_item.key)
                    -- UItool:setBool("scissors",false)
                    
                    self.furnituretb[10].num=self.furnituretb[10].num+1
                -- end
                else
                    UItool:message2("绿色的花朵，看起来很好看。",30)
            end
            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()

        end,self.grossini,self.bg)
end

function GameScene12:zihua()
    print("紫色花")
    local zihua_locationx,zihua_locationy = UItool:getitem_location(self.furniture:getChildByName("zihua"), self.bg:getPositionX())
        GameScenemove( math.floor(zihua_locationx-self.grossini:getContentSize().width/6),zihua_locationy ,function (  )
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)

            if self.furnituretb[11].num==1 then
                -- if UItool:getBool("scissors") then
                    UItool:message2(" 紫色的花朵。看起来很好看，就拿了几支。",30)
                    local key_item = Data.getItemData(31)
                    table.insert(PublicData.MERGEITEM, key_item.key)
                    -- UItool:setBool("scissors",false)
                    
                    self.furnituretb[11].num=self.furnituretb[11].num+1
                -- end
                else
                    UItool:message2("紫色的花朵，看起来很好看。",30)
                
                
            end
            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()

        end,self.grossini,self.bg)
end

function GameScene12:fenhua()
    print("粉色花")
    local chenghua_locationx,chenghua_locationy = UItool:getitem_location(self.furniture:getChildByName("fenhua"), self.bg:getPositionX())

        GameScenemove( math.floor(chenghua_locationx-self.grossini:getContentSize().width/6),chenghua_locationy ,function (  )

            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)
            if self.furnituretb[12].num==1 then
                -- if UItool:getBool("scissors") then
                    UItool:message2(" 粉色的花朵。看起来很好看，就拿了几支。",30)
                    local key_item = Data.getItemData(32)
                    table.insert(PublicData.MERGEITEM, key_item.key)
                    -- UItool:setBool("scissors",false)
                    
                    self.furnituretb[12].num=self.furnituretb[12].num+1
                -- end
                else
                    UItool:message2("粉色的花朵，看起来很好看。",30)
            end

            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()

        end,self.grossini,self.bg)
end

function GameScene12:yifu()
    print("衣服")

    local yifu_locationx,yifu_locationy = UItool:getitem_location(self.furniture:getChildByName("yifu"), self.bg:getPositionX())

    GameScenemove( math.floor(yifu_locationx-self.grossini:getContentSize().width/6),yifu_locationy ,function ()
        
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)

        if self.furnituretb[4].num == 1   then
           UItool:message2(" 漂亮的大衣，和一般的衣服一样，它被挂在衣架上。衣服的兜里似乎有些什么。" , 30)
           self.furnituretb[4].num = self.furnituretb[4].num + 1
           elseif  self.furnituretb[4].num == 2 then
            self.furnituretb[4].num = self.furnituretb[4].num + 1
            UItool:message2("是一块坏了的怀表，表链和衣服缝在了一起，取不下来。" , 30)
            self.panel = cc.CSLoader:createNode(Config.RES_POCKET_WATCH)
            self.center = self.panel:getChildByName("Node_center")
            self.commdi = self.center:getChildByName("commdi")
            self.commdi:setEnabled(false)
            local shildinglayer = Shieldingscreen:new()
            self:addChild(shildinglayer,12)
            shildinglayer:addChild(self.panel,12)
                            
            -- elseif self.furnituretb[4].num == 3 then
            --     self.panel = cc.CSLoader:createNode(Config.RES_POCKET_WATCH)
            --     self:addChild(self.panel,12)
            --     self.layer=cc.Layer:create()
            --     local shildinglayer = Shieldingscreenmessage3:new()
            --     self.layer:addChild(shildinglayer)
            --     self.layer:addTo(self,11)
            --     -- self.panel:setPosition(cc.p(self.visiblesize.width/2,self.visiblesize.height/2))
            --     self.center = self.panel:getChildByName("Node_center")
            --     self.commdi = self.center:getChildByName("commdi")
            --     local function callback(event,eventType)
            --         if eventType == TOUCH_EVENT_ENDED then
            --             UItool:message2("音效（待定）----- 表链和衣服缝在了一起取不下来",30)
            --             self.panel:removeFromParent()
            --             self.layer:removeFromParent()
            --         end
            --     end
            --     self.commdi:addClickEventListener(callback)
               elseif self.furnituretb[4].num == 3 then

                    if UItool:getBool("scissors") then
                        UItool:setBool("scissors",false)
                        UItool:message2(" 我不想破坏这件衣服，它还挺好看的",30)
                        else
                            self.furnituretb[4].num = self.furnituretb[4].num+1
                            UItool:message2("一块坏了的怀表。",30)
                            self.panel = cc.CSLoader:createNode(Config.RES_POCKET_WATCH)
                            self.center = self.panel:getChildByName("Node_center")
                            self.commdi = self.center:getChildByName("commdi")
                            self.commdi:setEnabled(false)
                            local shildinglayer = Shieldingscreen:new()
                            self:addChild(shildinglayer,12)
                            shildinglayer:addChild(self.panel,12)
                    end

                    else
                        if UItool:getBool("scissors") then
                            UItool:setBool("scissors",false)
                            UItool:message2(" 我不想破坏这件衣服，它还挺好看的",30)
                            else
                                UItool:message2("一块坏了的怀表。",30)
                                
                                self.panel = cc.CSLoader:createNode(Config.RES_POCKET_WATCH)
                                self.center = self.panel:getChildByName("Node_center")
                                self.commdi = self.center:getChildByName("commdi")
                                self.commdi:setEnabled(false)
                                local shildinglayer = Shieldingscreen:new()
                                self:addChild(shildinglayer,12)
                                shildinglayer:addChild(self.panel,12)
                        end
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
    end,self.grossini,self.bg)

end

function GameScene12:modify()
    local tb = PublicData.ROOMTABLE
    tb[chapterNumber][roomNumber+1].lock=0
    local str = json.encode(tb)
    ModifyData.writeToDoc(str,"room")
    UItool:setBool("topbar",false)

    ModifyData.removeDoc("GBposition")
    ModifyData.removeDoc("furniture")
    ModifyData.removeDoc("mergeitem")
    PublicData.MERGEITEM={}
    PublicData.FURNITURE={}
    PublicData.SAVEDATA={}
    -- table.insert(PublicData.MERGEITEM, 11)
    ModifyData.setRoomNum(3)
    UItool:setInteger("roomNumber", 3)

    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("res/donghua/huolu/huolu.ExportJson") 
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("res/donghua/weiniang/weiniang.ExportJson") 
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("res/donghua/mao/mao.ExportJson") 
    
    local scene = GameScene13.new()
    local turn = cc.TransitionFade:create(1, scene)
    cc.Director:getInstance():replaceScene(turn)

end

function GameScene12:backdoor()
    --print("door")
    --门
        local backdoor_locationx,backdoor_locationy = UItool:getitem_location(self.furniture:getChildByName("backdoor"), self.bg:getPositionX())
        GameScenemove( math.floor( backdoor_locationx-self.grossini:getContentSize().width/6),backdoor_locationy  ,function ()
             if UItool:getBool("door_key") then
                local itemnum = UItool:getInteger("door_keynum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                UItool:setBool("door_key",false)
                -- UItool:message2("闯关完成，",30)
                 self.modify()
                else
                    if UItool:getBool("elseitem") then
                        UItool:message2( Data.COMMTALK[math.random(5)],30)
                        else
                            UItool:message2(" 打不开……我需要找到钥匙。  ",30)
                    end
                    
                end
                self:megerupdate()
        end,self.grossini,self.bg)
end

function GameScene12:hongjiu()
    print("红酒")
    
    local hongjiu_locationx,hongjiu_locationy = UItool:getitem_location(self.furniture:getChildByName("hongjiu"), self.bg:getPositionX())
    GameScenemove( math.floor( hongjiu_locationx-self.grossini:getContentSize().width/6),hongjiu_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)

                UItool:message2("我不太喜欢酒的味道……",30)
        
        end,self.grossini,self.bg)

end

function GameScene12:lu()
    print("鹿")
    
    local lu_locationx,lu_locationy = UItool:getitem_location(self.furniture:getChildByName("lu"), self.bg:getPositionX())
    GameScenemove( math.floor( lu_locationx-self.grossini:getContentSize().width/6),lu_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        UItool:message2("一对鹿的雕像，雕工很精致，看上去好可爱啊。",30)
        
        end,self.grossini,self.bg)

end

function GameScene12:zhutai()
    print("烛台")
    
    local zhutai_locationx,zhutai_locationy = UItool:getitem_location(self.furniture:getChildByName("zhutai"), self.bg:getPositionX())
    GameScenemove( math.floor( zhutai_locationx-self.grossini:getContentSize().width/6),zhutai_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        UItool:message2("这个屋子足够亮了，应该没必要把这个烛台点燃。",30)

        end,self.grossini,self.bg)

end

function GameScene12:cup()
    print("茶杯")
    
    local cup_locationx,cup_locationy = UItool:getitem_location(self.furniture:getChildByName("cup"), self.bg:getPositionX())
    GameScenemove( math.floor( cup_locationx-self.grossini:getContentSize().width/6),cup_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
    
                UItool:message2("普通的茶杯。",30)

        end,self.grossini,self.bg)

end

function GameScene12:teabook()
    print("teabook")
    
    local teabook_locationx,teabook_locationy = UItool:getitem_location(self.furniture:getChildByName("teabook"), self.bg:getPositionX())
    GameScenemove( math.floor( teabook_locationx-self.grossini:getContentSize().width/6),teabook_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
            UItool:message2("一摞书，都是些我看不懂的内容……",30)
        end,self.grossini,self.bg)

end

function GameScene12:zhuangshi()
    print("zhuangshi")
    
    local zhuangshi_locationx,zhuangshi_locationy = UItool:getitem_location(self.furniture:getChildByName("zhuangshi"), self.bg:getPositionX())
    GameScenemove( math.floor( zhuangshi_locationx-self.grossini:getContentSize().width/6),zhuangshi_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
            UItool:message2("用来装饰的瓶子，好像没什么用。",30)
        end,self.grossini,self.bg)

end

function GameScene12:xiangkuang()    
    local xiangkuang_locationx,xiangkuang_locationy = UItool:getitem_location(self.furniture:getChildByName("xiangkuang"), self.bg:getPositionX())
    GameScenemove( math.floor( xiangkuang_locationx-self.grossini:getContentSize().width/6),xiangkuang_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
            UItool:message2("这些相框里面什么都没有。",30)
        end,self.grossini,self.bg)

end


function GameScene12:AllButtons(  )
    self.AllButtons = 
    {  
        self.furniture:getChildByName("bell6"):getChildByName("biaopan"),
        self.furniture:getChildByName("bell6"):getChildByName("biaoshen"),
        self.furniture:getChildByName("phonograph"):getChildByName("changji"),
        self.furniture:getChildByName("phonograph"):getChildByName("jigui"),
        self.furniture:getChildByName("stove"),
        self.furniture:getChildByName("statuecat"),
        self.bg:getChildByName("ligui"),
        self.furniture:getChildByName("qingjian"),
        self.furniture:getChildByName("teatable"),
        self.furniture:getChildByName("cat"),
        self.furniture:getChildByName("dengzhao"),
        self.furniture:getChildByName("key_up"),
        self.furniture:getChildByName("built_in"),
        self.furniture:getChildByName("qinghua"),
        self.furniture:getChildByName("fenhua"),
        self.furniture:getChildByName("zihua"),
        self.furniture:getChildByName("yifu"),
        self.furniture:getChildByName("dabihua"),
        self.furniture:getChildByName("weiniang"),
        self.furniture:getChildByName("handsclock_btn"),
        self.furniture:getChildByName("flowerpot"),
        self.furniture:getChildByName("bell6"):getChildByName("biaoshen_men"),
        self.furniture:getChildByName("hongjiu"),
        self.furniture:getChildByName("lu"),
        self.furniture:getChildByName("cup"),
        self.furniture:getChildByName("teabook"),
        self.furniture:getChildByName("zhutai"),
        self.furniture:getChildByName("zhuangshi"),
        self.furniture:getChildByName("xiangkuang"),
        self.furniture:getChildByName("backdoor")
        

    }


    if self.furnituretb[3].bool==false then -- 信件
        self.furniture:getChildByName("letter"):setVisible(false)
        self.furniture:getChildByName("qingjian"):setTouchEnabled(false)
    end

    if self.furnituretb[6].ifchangesprite then --立柜
        self.bg:getChildByName("ligui"):loadTextures("changesprite/GameScene12/ligui.png","changesprite/GameScene12/ligui.png")
    end
    if self.furnituretb[5].ifchangesprite then -- 地灯
        if self.furnituretb[5].num==2 then
            self.furniture:getChildByName("floor_lamp"):setTexture("changesprite/GameScene12/floor_lamp.png")
            elseif self.furnituretb[5].num==3 then
                self.furniture:getChildByName("floor_lamp"):setTexture("changesprite/GameScene12/floor_lamp2.png")
        end
        
    end

    if self.furnituretb[7].bool==false then --火炉
        self.furniture:getChildByName("badkey"):setVisible(false)
    end

    if self.furnituretb[8].ifchangesprite then --雕塑猫
        self.furniture:getChildByName("statuecat"):loadTextures("changesprite/GameScene12/statuecat.png","changesprite/GameScene12/statuecat.png")
    end

    if self.furnituretb[9].bool == false then
        self.furniture:getChildByName("key_up"):setVisible(false)
        self.furniture:getChildByName("key_up"):setTouchEnabled(false)
    end

    if self.furnituretb[15].ifchangesprite then --唱机
        self.furniture:getChildByName("phonograph"):setTexture("changesprite/GameScene12/phonograph2.png")
                
    end

    if self.furnituretb[14].ifchangesprite then --机柜
        self.furniture:getChildByName("phonograph"):setTexture("changesprite/GameScene12/phonograph.png")
                
    end

    if self.furnituretb[13].foodhad  then --猫获取到食物
        self.mao:getAnimation():playWithIndex(0,1,1)
        self.mao:getAnimation():play("Animation1")
    end

    if self.furnituretb[16].bool==false  then --时针
        self.furniture:getChildByName("handsclock"):setVisible(false)
        self.furniture:getChildByName("handsclock_btn"):setEnabled(false)
        
    end

    if self.furnituretb[18].num==3 then --花盆
        self.furniture:getChildByName("flowerpot2"):setTexture("changesprite/GameScene12/flowerpot1.png")
        self.furniture:getChildByName("flowerpot"):setScaleY(2)
        elseif self.furnituretb[18].num==4 then
            self.furniture:getChildByName("flowerpot2"):setTexture("changesprite/GameScene12/flowerpot2.png")
            self.furniture:getChildByName("flowerpot"):setScaleY(1)
    end

    if self.furnituretb[20].heihua then
        self.weiniang:getAnimation():playWithIndex(0,1,1)
        self.weiniang:getAnimation():play("Animation2")
    end

    if self.furnituretb[21].num==2 then --墙柜
        self.furniture:getChildByName("built_in"):loadTextures("changesprite/GameScene12/built_in.png","changesprite/GameScene12/built_in.png")
        elseif self.furnituretb[21].num==3 then
            self.furniture:getChildByName("built_in"):loadTextures("changesprite/GameScene12/built_in_empty.png","changesprite/GameScene12/built_in_empty.png")
    end

    if self.furnituretb[17].open then
        if self.furnituretb[19].open then
            if self.furnituretb[19].zhizhenhad then
                self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell5.png")
                else
                self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell4.png")   
            end
            else
                self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell3.png")
        end
        else
            if self.furnituretb[19].open then
                if self.furnituretb[19].zhizhenhad then
                    self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell2.png")
                    else
                    self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell1.png")   
                end
                else
                    self.furniture:getChildByName("bell6"):setTexture("changesprite/GameScene12/bell6.png")
            end
    end

    if self.furnituretb[17].door then
        self.furniture:getChildByName("bell6"):getChildByName("biaoshen_men"):setEnabled(true)

        else
            self.furniture:getChildByName("bell6"):getChildByName("biaoshen_men"):setEnabled(false)
    end

    if self.furnituretb[17].open==true then
        if self.furnituretb[17].putname=="yaoshi" then
            print("放钥匙")
            self.furniture:getChildByName("bell6"):getChildByName("bad_key"):setVisible(true)
            self.furniture:getChildByName("bell6"):getChildByName("taowa"):setVisible(false)
            elseif self.furnituretb[17].putname=="taowa" then
                print("放套娃")
                self.furniture:getChildByName("bell6"):getChildByName("taowa"):setVisible(true)
                self.furniture:getChildByName("bell6"):getChildByName("bad_key"):setVisible(false)
                else
                    self.furniture:getChildByName("bell6"):getChildByName("bad_key"):setVisible(false)
                    self.furniture:getChildByName("bell6"):getChildByName("taowa"):setVisible(false)
        end
        else
                    self.furniture:getChildByName("bell6"):getChildByName("bad_key"):setVisible(false)
                    self.furniture:getChildByName("bell6"):getChildByName("taowa"):setVisible(false)
    end
        
    
    

    local function allButtonClick(event,eventType)
        if eventType == TOUCH_EVENT_ENDED then
            if UItool:getBool("effect") then
                AudioEngine.playEffect("gliss.mp3")
            end
            if event:getName()=="biaopan" then
                self:biaopan()
                elseif event:getName()=="biaoshen" then
                    self:biaoshen()
                    elseif event:getName()=="changji" then
                        self:changji()
                        elseif event:getName()=="jigui" then
                            self:jigui()
                            elseif event:getName()=="stove" then
                                self:stove()
                                elseif event:getName()=="statuecat" then
                                    self:statuecat()
                                    elseif event:getName()=="ligui" then
                                        self:ligui()
                                        elseif event:getName()=="qingjian" then
                                            self:letter()
                                            elseif event:getName()=="teatable" then
                                                self:teatable()
                                                elseif event:getName()=="cat" then
                                                    self:cat()
                                                    elseif event:getName()=="dengzhao" then
                                                        self:dengzhao()
                                                        elseif event:getName()=="key_up" then
                                                            self:key_up()
                                                            elseif event:getName()=="built_in" then
                                                                self:built_in()
                                                                elseif event:getName()=="qinghua" then
                                                                    self:qinghua()
                                                                    elseif event:getName()=="fenhua" then
                                                                        self:fenhua()
                                                                        elseif event:getName()=="zihua" then
                                                                            self:zihua()
                                                                            elseif event:getName()=="yifu" then
                                                                                self:yifu()
                                                                                elseif event:getName()=="dabihua" then
                                                                                    self:dabihua()
                                                                                    elseif event:getName()=="weiniang" then
                                                                                        self:weiniangcallback()
                                                                                        elseif event:getName()=="handsclock_btn" then
                                                                                            self:handsclock()
                                                                                            elseif event:getName()=="flowerpot" then
                                                                                                self:flowerpot()
                                                                                                elseif event:getName()=="biaoshen_men" then
                                                                                                    self:biaoshen_men()
                                                                                                    elseif event:getName()=="backdoor" then
                                                                                                        self:backdoor()
                                                                                                        elseif event:getName()=="frontdoor" then
                                                                                                            self:frontdoor()
                                                                                                            elseif event:getName()=="hongjiu" then
                                                                                                                self:hongjiu()
                                                                                                                elseif event:getName()=="zhutai" then
                                                                                                                    self:zhutai()
                                                                                                                    elseif event:getName()=="lu" then
                                                                                                                        self:lu()
                                                                                                                        elseif event:getName()=="cup" then
                                                                                                                            self:cup()
                                                                                                                            elseif event:getName()=="teabook" then
                                                                                                                                self:teabook()
                                                                                                                                elseif event:getName()=="zhuangshi" then
                                                                                                                                    self:zhuangshi()
                                                                                                                                    elseif event:getName()=="xiangkuang" then
                                                                                                                                        self:xiangkuang()
                                                                                                                





            end
        end
    end


    for key, var in pairs(self.AllButtons) do
        var:addClickEventListener(allButtonClick)
    end

end

function GameScene12:ontouch( ... )
    --触摸
    --实现事件触发回调
    local function onTouchBegan(touch, event)
        --人物行走调用
        local rect = cc.rect(0, 145,self.bg:getContentSize().width, self.bg:getContentSize().height)  
  
        if cc.rectContainsPoint(rect, touch:getLocation()) then  
           local gril_pointx = self.grossini:getPositionX()
           local target = event:getCurrentTarget()
           local locationInNode = target:convertToNodeSpace(touch:getLocation())  
           local touchlocation = touch:getLocation()
           --点击效果]
           print("鱼眼的位置,和背景和人物",self.yuyan:getPositionX(),self.bg:getPositionX(),self.grossini:getPositionX())

           GameScenemove(touchlocation.x,touchlocation.y,nil,self.grossini,self.bg)

           else
        end  
        self:megerupdate()
         
        return true
        
    end

    local function onTouchMoved(touch, event)   
    end

    local function onTouchEnded(touch, events)
        -- if self.bg:getPositionX()< then
        --     --todo
        -- end
    end
    
    local listener = cc.EventListenerTouchOneByOne:create() -- 创建一个事件监听器
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispatcher = self:getEventDispatcher() -- 得到事件派发器
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.bg) -- 将监听器注册到派发器中

end

function GameScene12:onEnterTransitionFinish ()
    -- self.right:removeFromParent()
    --点击效果层
    local dianjilayer = TouchLayer:new()
    self.bg:addChild(dianjilayer,128)
   
end

function GameScene12:onEnter()
    self:init()
    
    -- self.right = cc.Sprite:create("cn/Load/image/UI/pause.png")
    -- self.right:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))
    -- self:addChild(self.right,29)
    -- local rotate = cc.RotateBy:create(2, -30)
    -- self.right:runAction( cc.RepeatForever:create(rotate))
     
end

return GameScene12

















