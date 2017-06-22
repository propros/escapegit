
GameScene13=class("GameScene13", function()
    return cc.Scene:create()
end)

GameScene13.panel = nil
local roomNumber
local chapterNumber


function GameScene13:ctor()

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
    --家具层
    self.furniture = self.bg:getChildByName("furniture")



    --返回按钮
    local mainback = self.node:getChildByName("back")
    mainback:addClickEventListener(function ()
        if UItool:getBool("effect") then
            AudioEngine.playEffect("gliss.mp3")
        end
        --返回loading
        local scene = Loading.new()
        local turn = cc.TransitionFade:create(1,scene)
        cc.Director:getInstance():replaceScene(turn)
        end)

    local shezhi = self.node:getChildByName("shezhi")
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

function GameScene13:megerupdate()
    self.merge:removeSelf()
    self.merge = Merge:createScene()
    self:addChild(self.merge,5)
end


function GameScene13:init()
    self:ontouch()
    
    self:AllButtons()
    -- self:fishmove() --鱼的移动 
end

function GameScene13:fire_weiniang_mao( )
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
function GameScene13:update( delta )

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

function GameScene13:fishmove()  
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




function GameScene13:AllButtons(  )
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
        self.furniture:getChildByName("xiangkuang")
        

    }

    local function allButtonClick(event,eventType)
        if eventType == TOUCH_EVENT_ENDED then
            if UItool:getBool("effect") then
                AudioEngine.playEffect("gliss.mp3")
            end
        end
    end


    for key, var in pairs(self.AllButtons) do
        var:addClickEventListener(allButtonClick)
    end

end

function GameScene13:ontouch( ... )
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
           --点击效果

           self:Girl_bg_move(touchlocation.x,touchlocation.y)
           else
        end  
        self.merge:removeSelf()
        self.merge = Merge:createScene()
        self:addChild(self.merge,5)
         
        return true
        
    end

    local function onTouchMoved(touch, event)   
    end

    local function onTouchEnded(touch, events)
        
    end
    
    local listener = cc.EventListenerTouchOneByOne:create() -- 创建一个事件监听器
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispatcher = self:getEventDispatcher() -- 得到事件派发器
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.bg) -- 将监听器注册到派发器中

end

function GameScene13:Girl_bg_move(X, Y,event)

    --点击位置
        local apoint = X
        local gril_pointx = self.grossini:getPositionX()
        local delta =  X - gril_pointx

        -- 继续点击的时候是否连续
        if self.grossini:getScaleX()>0  and X < gril_pointx then
            ---- print("self.grossini:getScaleX() > 0 , 脸是左朝向 点击左边")
            if self.grossini:getNumberOfRunningActions()>0  then
                self.grossini:stopAction(self.sequence)
                self.bg:stopAction(self.bgsequence)
            else
                self.grossini:walk()
                
            end

            elseif self.grossini:getScaleX() > 0  and X > gril_pointx then
                ---- print("self.grossini:getScaleX() > 0 ，脸是左朝向  点击右边")
                if self.grossini:getNumberOfRunningActions()>0  then
                    self.grossini:stopAction(self.sequence)
                    self.bg:stopAction(self.bgsequence)
                else
                    self.grossini:walk()
                    
                end

                elseif self.grossini:getScaleX() < 0  and X > gril_pointx then
                    ---- print("self.grossini:getScaleX() < 0 ，脸是右朝向  点击右边")
                    if self.grossini:getNumberOfRunningActions()>0  then
                        self.grossini:stopAction(self.sequence)
                        self.bg:stopAction(self.bgsequence)
                    else
                        self.grossini:walk()
                    end

                    elseif self.grossini:getScaleX() < 0  and X < gril_pointx then
                        
                        if self.grossini:getNumberOfRunningActions()>0  then
                            self.grossini:stopAction(self.sequence)
                            self.bg:stopAction(self.bgsequence)
                        else
                            
                            self.grossini:walk()
                    end
            end
    --人物位置
        local gril_pointx =math.floor( self.grossini:getPositionX())
        local delta =  apoint - gril_pointx
        --距离
        local x = apoint-self.visibleSize.width/2
        local x2 = self.bg:getContentSize().width + self.bg:getPositionX() - self.visibleSize.width
    --速度
        local speed = 390
    --时间
        self.time = delta / speed  --普通距离
        self.time1 = math.abs((math.abs(delta)-math.abs(x)))/speed -- 人物到中间的时候
        self.time2 = math.abs( self.bg:getPositionX() ) / speed  --地图最左边的时候
        self.time3 = x2 /speed --地图到最右边的时候
        self.time4 = x / speed 
        self.time5 = (x-x2)/speed
        self.time6 = ( -delta + self.bg:getPositionX() )/speed
        
        --一步
        local function onestep()
            
            --面部朝向
            if delta>=0 then
                self.grossini:setScaleX(-self.girlx)
                self.grossini:setScaleY(self.girly)
                else
                    self.grossini:setScaleX(self.girlx)
                    self.grossini:setScaleY(self.girly)
            end
           if UItool:getCurrentState()=="stand" then
            
                UItool:setCurrentState("stand")
                -- self.delaystand = cc.DelayTime:create(0)
            end
        end

        local function threestep()
            
            -- self.grossini:getAnimation():play("stand")
            self.grossini:stand()
            event = event or nil 
            if event ~= nil  then
                event()
                
                else
            end

            --更新数据表里面的位置数据
            local girlpositionx = self.grossini:getPositionX()
            local bgpositionx = self.bg:getPositionX()
            
            local tb = PublicData.SAVEDATA
            tb.girlpositionx=girlpositionx
            tb.bgpositionx=bgpositionx
            local str = json.encode(tb)
            
            local docpath = cc.FileUtils:getInstance():getWritablePath().."GBposition.txt"
        ---- print("文件是否存在",cc.FileUtils:getInstance():isFileExist(docpath),docpath)
            if cc.FileUtils:getInstance():isFileExist(docpath)==true then
               
                ModifyData.writeToDoc(str,"GBposition")
                else
                 
                    PublicData.SAVEDATA = {}
            end
            

        end

        if apoint<self.visibleSize.width/2 then
            --点击在左边的时候
            ---- print("l点击在左边的时候")
            if self.grossini:getPositionX()<self.visibleSize.width/2 then
                --人物在左边的时候
                ---- print("l人物在左边的时候")
                if self.bg:getPositionX()==0 then
                    ---- print("l地图在原点")
                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                    self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
                    
                end
                
                elseif self.grossini:getPositionX()>self.visibleSize.width/2 then
                    --人物在右边的时候
                    ---- print("l人物在右边的时候")

                    self.bgmove=cc.MoveBy:create( math.abs(self.time4), cc.p(-x,self.bg:getPositionY()))
                    local delaybg = cc.DelayTime:create(math.abs(self.time1))
                    self.bgsequence = cc.Sequence:create(delaybg,self.bgmove)
                    self.bg:runAction(self.bgsequence)

                    local delaygirl = cc.DelayTime:create(math.abs(self.time4))
                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time1), cc.p(self.visibleSize.width/2 ,self.grossini:getPositionY()))
                    self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,delaygirl,cc.CallFunc:create(threestep))

                    elseif self.grossini:getPositionX()==self.visibleSize.width/2 then
                        --人物在中间的时候
                        ---- print("l人物在中间的时候")
                        if self.bg:getPositionX()<0  then
                            
                            if self.bg:getPositionX()<delta  then
                                ---- print("l地图小于")
                                --print("点击在左边 ，背景向右走")
                                self.bgmove=cc.MoveBy:create( math.abs(self.time), cc.p(-delta,self.bg:getPositionY()))
                                self.bgsequence = cc.Sequence:create(self.bgmove)
                                self.bg:runAction(self.bgsequence)
                                else
                                    ---- print("l地图大于")
                                    --print("点击在左边 ，背景走到最右")
                                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time6), cc.p( apoint - self.bg:getPositionX(),self.grossini:getPositionY()))
                                    self.bgmove=cc.MoveTo :create( math.abs(self.time2), cc.p(0,self.bg:getPositionY()))
                                    self.bgsequence = cc.Sequence:create(self.bgmove)
                                    self.bg:runAction(self.bgsequence)
                            end
                            elseif self.bg:getPositionX()==0 then
                                self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                        end
            end

            elseif apoint>self.visibleSize.width/2 then
                --点击在右边的时候
                ---- print("r点击在右边的时候")
                if self.grossini:getPositionX()<self.visibleSize.width/2 then
                    --人物在左边的时候
                    ---- print("r人物在左边的时候")
                    if self.bg:getPositionX()==0 then
                        ---- print("r地图在原点")
                        self.girlmoveto = cc.MoveTo:create(math.abs(self.time1), cc.p(self.visibleSize.width/2 ,self.grossini:getPositionY()))
                        self.bgmove=cc.MoveBy:create( math.abs(self.time4), cc.p(-x,self.bg:getPositionY()))

                        local delaybg = cc.DelayTime:create(math.abs(self.time1))
                        self.bgsequence = cc.Sequence:create(delaybg,self.bgmove)
                        self.bg:runAction(self.bgsequence)
                        
                        local delaygirl = cc.DelayTime:create(self.time4)
                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,delaygirl,cc.CallFunc:create(threestep))

                    end
                
                    elseif self.grossini:getPositionX()>self.visibleSize.width/2 then
                        --人物在右边的时候
                        ---- print("r人物在右边的时候")
                        self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))

                         elseif self.grossini:getPositionX()==self.visibleSize.width/2 then
                            ---- print("r人物在中间的时候")
                            if self.bg:getPositionX() <= 0 and self.bg:getPositionX() > self.visibleSize.width-self.bg:getContentSize().width then

                                if self.bg:getContentSize().width + self.bg:getPositionX() - self.visibleSize.width > apoint-self.visibleSize.width/2 then

                                    self.bgmove=cc.MoveBy:create( math.abs(self.time), cc.p(-delta,self.bg:getPositionY()))
                                    self.bgsequence = cc.Sequence:create(self.bgmove)
                                    self.bg:runAction(self.bgsequence)

                                    else
                                        ------
                                        self.girlmoveto = cc.MoveTo:create(math.abs(self.time5), cc.p(apoint-(self.bg:getContentSize().width-self.visibleSize.width+self.bg:getPositionX()),self.grossini:getPositionY()))

                                        self.bgmove=cc.MoveTo:create( math.abs(self.time3), cc.p(self.visibleSize.width-self.bg:getContentSize().width,self.bg:getPositionY()))
                                        self.bgsequence = cc.Sequence:create(self.bgmove)
                                        self.bg:runAction(self.bgsequence)
                                end
                                elseif self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width then
                                    ---- print("r画面在最左的时候")
                                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                                    
                            end
            end
            
        end

        local delay = cc.DelayTime:create(math.abs(self.time))
        local delay1 = cc.DelayTime:create(math.abs(self.time1))
        local delay2 = cc.DelayTime:create(math.abs(self.time2))-- zuo
        local delay3 = cc.DelayTime:create(math.abs(self.time3))--you
        --人物在中间
        if self.grossini:getPositionX() == self.visibleSize.width/2 then
            --背景在原点，且点击在右边
            if self.bg:getPositionX() == 0 and apoint > self.visibleSize.width/2  then
                self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                -- 背景在原点 点击在左边
                elseif self.bg:getPositionX() == 0 and apoint < self.visibleSize.width/2 then
                    self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delaystand,self.girlmoveto,cc.CallFunc:create(threestep))
                    -- 背景在最左边
                    elseif self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width and 
                    apoint >self.visibleSize.width/2  then
                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
                        elseif self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width and
                    apoint < self.visibleSize.width/2 then
                            self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                            
            end
            --背景不在边上的时候
            if self.bg:getPositionX()~=0 and self.bg:getPositionX() ~= self.visibleSize.width-self.bg:getContentSize().width then

                if apoint>self.visibleSize.width/2 then

                    if self.bg:getContentSize().width + self.bg:getPositionX() - self.visibleSize.width >apoint-self.visibleSize.width/2 then
                        ------
                        --print("人物在中间，点击在右边，背景向左走")
                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                        
                        else
                            --print("人物在中间，点击在右边，背景走到最左")
                            self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay3,self.girlmoveto,cc.CallFunc:create(threestep))
                            
                    end
                    else

                        if self.bg:getPositionX()<delta then
                            --print("********")
                            self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                            
                            else
                                --print("&&&&&&&&")
                                self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay2,self.girlmoveto,cc.CallFunc:create(threestep))
                        end
                end
                else
            end

            else

        end
        self.grossini:runAction(self.sequence)
end


function GameScene13:onEnterTransitionFinish ()
    
  
    
    -- self.right:removeFromParent()
    --点击效果层
    local dianjilayer = TouchLayer:new()
    self.bg:addChild(dianjilayer,128)

    
   
end

function GameScene13:onEnter()
    self:init()
    
    -- self.right = cc.Sprite:create("cn/Load/image/UI/pause.png")
    -- self.right:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))
    -- self:addChild(self.right,29)
    -- local rotate = cc.RotateBy:create(2, -30)
    -- self.right:runAction( cc.RepeatForever:create(rotate))
     
end

return GameScene13

















