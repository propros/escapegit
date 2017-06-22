
GameScene11=class("GameScene11", function()
    return cc.Scene:create()
end)

GameScene11.panel = nil
local roomNumber
local chapterNumber

--table 深拷贝
function GameScene11:ctor()

    local function onNodeEvent(event)
        
        if event == "enter" then
            self:onEnter()
            elseif event == "enterTransitionFinish" then
                self:onEnterTransitionFinish()
        end
    end

    
    self:registerScriptHandler(onNodeEvent)

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

    self.studydata = PublicData.STUDY

      -- 人物和背景的位置表
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
            
            local str = json.encode(Data.FURNITURE)
            ModifyData.writeToDoc(str,"furniture")
            PublicData.FURNITURE = UItool:deepcopy(Data.FURNITURE)

        else

            local str = ModifyData.readFromDoc("furniture")
            PublicData.FURNITURE = json.decode(str)
        end
    end

    self.furnituretb = PublicData.FURNITURE

    self.director = cc.Director:getInstance()
    self.visibleSize = cc.Director:getInstance():getVisibleSize() 
    self.winsize = cc.Director:getInstance():getWinSizeInPixels()
    self.origin = cc.Director:getInstance():getVisibleOrigin()



    roomNumber = ModifyData.getRoomNum()
    chapterNumber = ModifyData.getChapterNum()

    --人物缩放
    self.girlx = 0.28
    self.girly = 0.28

    --下蹲屏蔽时间
    self.screenxiadun = 1.3
    --弯腰屏蔽时间
    self.screenwanyao = 1.2

    

    -- 家具底层
    self.panel = cc.CSLoader:createNode(Config.RES_MAINSCENE)
    self.panel:setPosition(cc.p(0,0))
    self:addChild(self.panel,4)

    --合成栏
    self.merge = Merge:createScene()
    self:addChild(self.merge,5)
    
    --主节点
    self.node =  self.panel:getChildByName("Node_left_top")
    self.node:setPosition(0, self.visibleSize.height)
    --背景
    self.bg = self.node:getChildByName("bg")
    self.bg:setPositionX(self.savedata.bgpositionx)

    -- local draw = cc.DrawNode:create()  
    -- -- local points = {cc.p(0,0), cc.p(0 + size, 0), cc.p(0 + size, 0 + size), cc.p(0, 0 + size)}  
    -- draw:drawDot(cc.p(self.bg:getPositionX(),150),50,cc.c4b(0,0,0,1))  
    -- draw:setTag("draw")  
    -- self:addChild(draw,100) 
    
    local function update(delta)  
        self:update(delta)  
        
        if UItool:getBool("pasitem") then
            --重新渲染合成界面
            UItool:setBool("pasitem",false)
            self:megerupdate()
            
        end
    end  
    self:scheduleUpdateWithPriorityLua(update,0.3)

    self:grossiniwalk()-- 人物动作
    self:fishmove() --鱼的移动 
   
    
end

function GameScene11:megerupdate()
    self.merge:removeSelf()
    self.merge = Merge:createScene()
    self:addChild(self.merge,5)
end

function GameScene11:init()
    --家具
    self.furniture = self.bg:getChildByName("furniture")

    self.scheduler = nil -- 定时器
    self.goscheduler = nil --过关定时器
    self.m_isAnimationing = nil 

    self:ontouch()
    self:AllButtons()

    -- 新手指引
    if self.studydata.study_over then
        
        else
        local cliplayers = ClipLayer:create()  
        self:addChild(cliplayers,6)
    end
    

    self.runtime = nil 

    -- self:fishmove() --鱼的移动 

    
    -- local callbackEntry
    -- local function messageupdate(delta)  
        --print("定时器作用")
    --     if UItool:getBool("message4")==false then

            -- self.jiantou = cc.Sprite:create("jiantou.png")
            -- self.jiantou:setScale(2)
            -- -- self.jiantou:setAnchorPoint(cc.p(0,0))
            -- self.jiantou:setPosition(cc.p(self.furniture:getChildByName("bed_down"):getPositionX()+40,self.furniture:getChildByName("bed_down"):getPositionY()+60))
            -- self.furniture:addChild(self.jiantou,5)

            -- local moveup = cc.OrbitCamera:create(1, 1, 0, 0, 360, 0, 0);
            -- local movedown = cc.RotateBy:create(0.5, 0)
            -- -- local sequencd = cc.Sequence:create(moveup,movedown)
            -- self.jiantou:runAction(cc.RepeatForever:create(moveup))

    --         cc.Director:getInstance():getScheduler():unscheduleScriptEntry(callbackEntry)
    --     end
    -- end  

    -- callbackEntry = cc.Director:getInstance():getScheduler():scheduleScriptFunc(messageupdate, 1, false)

    
end

function GameScene11:update( delta )

    local posdoublefish = self.doublefish:getPositionX()
    local posfeifish =self.feifish:getPositionX()
    local posfishgroup =  self.fishgroup:getPositionX()
    local posfishgroup2 = self.fishgroup2 :getPositionX()

    local poslongfish = self.longfish:getPositionX()
    local poslshark = self.lshark:getPositionX()
    local posrfish = self.rfish:getPositionX()
    local posrfish1 = self.rfish1:getPositionX()

    local posrfishgroup1 = self.rfishgroup1:getPositionX()
    local posrpianyu = self.rpianyu:getPositionX()
    local possanjiao = self.sanjiao:getPositionX()
    local possfish = self.sfish:getPositionX()

    local possshark = self.sshark:getPositionX()
    local postiaoyu = self.tiaoyu:getPositionX()
    local posfishx,posfishy = self.xiexiayu:getPosition()

    local speed = 1 
  
    posdoublefish = posdoublefish - speed  -2.5
    posfeifish = posfeifish - speed 
    posfishgroup = posfishgroup - speed -2
    posfishgroup2 = posfishgroup2 - speed *1.2

    poslongfish = poslongfish - speed -1.1
    poslshark = poslshark + speed 
    posrfish = posrfish + speed +2
    posrfish1 = posrfish1 + speed +2

    posrfishgroup1 = posrfishgroup1 + speed 
    posrpianyu = posrpianyu + speed 
    possanjiao = possanjiao - speed -2.1
    possfish = possfish - speed -1.8

    possshark = possshark + speed 
    postiaoyu = postiaoyu - speed -1.8
    posfishx = posfishx - speed -1.35
    posfishy = posfishy - speed -1.1
--
    local width = self.winsize.width 
    local height = self.winsize.height
  
    if posdoublefish < - self.doublefish:getContentSize().width * 0.6 then  
        posdoublefish = 2*width + self.doublefish:getContentSize().width *0.6
    end  

    if posfeifish < -self.feifish:getContentSize().width * 0.6 then  
        posfeifish = 2*width + self.feifish:getContentSize().width * 0.6
    end  

    if posfishgroup < -self.fishgroup:getContentSize().width * 0.6 then  
        posfishgroup = width * 2 + self.fishgroup:getContentSize().width*0.6
        
    end  
  
    if posfishgroup2 < -self.fishgroup2:getContentSize().width*0.6  then  
        posfishgroup2 = width *2 +self.fishgroup2:getContentSize().width*0.6
    end  


    if poslongfish < -self.longfish:getContentSize().width*0.6 then
        poslongfish = width *2 +self.longfish:getContentSize().width*0.6
    end

    if poslshark > width *2 + self.lshark:getContentSize().width*0.6 then
        poslshark = -self.lshark:getContentSize().width*0.6
    end

    if posrfish > width *2 + self.rfish:getContentSize().width*0.6 then
        posrfish = - self.rfish:getContentSize().width*0.6
    end

    if posrfish1 > width *2 + self.rfish1:getContentSize().width*0.6 then
        posrfish1 = - self.rfish1:getContentSize().width*0.6
    end


    if posrfishgroup1 > width *2 + self.rfishgroup1:getContentSize().width*0.6 then
        posrfishgroup1 = - self.rfishgroup1:getContentSize().width*0.6
    end

    if posrpianyu > width *2 + self.rpianyu:getContentSize().width*0.6 then
        posrpianyu = - self.rpianyu:getContentSize().width*0.6
    end

    if possanjiao < -self.sanjiao:getContentSize().width*0.6 then
        possanjiao = width *2 +self.sanjiao:getContentSize().width*0.6
    end

    if possfish < -self.sfish:getContentSize().width*0.6 then
        possfish = width *2 +self.sfish:getContentSize().width*0.6
    end


    if possshark > width *2 +self.sshark:getContentSize().width*0.6 then
        possshark = -self.sshark:getContentSize().width*0.6
    end

    if postiaoyu < -self.tiaoyu:getContentSize().width*0.6 then
        postiaoyu = width *2 +self.tiaoyu:getContentSize().width*0.6
    end

    if posfishx < -self.xiexiayu:getContentSize().width*0.7 then
        posfishx = width *2 +self.xiexiayu:getContentSize().width*0.6
    end

    if posfishy < -self.xiexiayu:getContentSize().height then
        posfishy = height +self.xiexiayu:getContentSize().height*0.6
    end

    self.doublefish:setPositionX(posdoublefish)
    self.feifish:setPositionX(posfeifish)
    self.fishgroup:setPositionX(posfishgroup)
    self.fishgroup2:setPositionX(posfishgroup2)
    self.longfish:setPositionX(poslongfish)
    self.lshark:setPositionX(poslshark)
    self.rfish:setPositionX(posrfish)
    self.rfish1:setPositionX(posrfish1)
    self.rfishgroup1:setPositionX(posrfishgroup1)
    self.rpianyu:setPositionX(posrpianyu)
    self.sanjiao:setPositionX(possanjiao)
    self.sfish:setPositionX(possfish)
    self.sshark:setPositionX(possshark)
    self.tiaoyu:setPositionX(postiaoyu)
    self.xiexiayu:setPosition(cc.p(posfishx,posfishy))

end

function GameScene11:fishmove()  
    self.doublefish = self.bg:getChildByName("doublefish")
    self.feifish = self.bg:getChildByName("feifish")
    self.fishgroup = self.bg:getChildByName("fishgroup")
    self.fishgroup2 = self.bg:getChildByName("fishgroup2")
    self.longfish = self.bg:getChildByName("longfish")
    self.lshark = self.bg:getChildByName("lshark")
    self.rfish = self.bg:getChildByName("rfish")
    self.rfish1 = self.bg:getChildByName("rfish1")
    self.rfishgroup1 = self.bg:getChildByName("rfishgroup1")
    self.rpianyu = self.bg:getChildByName("rpianyu")
    self.sanjiao = self.bg:getChildByName("sanjiao")
    self.sfish = self.bg:getChildByName("sfish")
    self.sshark = self.bg:getChildByName("sshark")
    self.tiaoyu = self.bg:getChildByName("tiaoyu")
    self.xiexiayu = self.bg:getChildByName("xieyu")
    
    local function updateFunc(dt)  
        self:update(dt)  
    end  
end 

function GameScene11:bed_up()
    --床上
    
    local bed_up_locationx ,bed_up_locationy = UItool:getitem_location(self.furniture:getChildByName("bed_up"), self.bg:getPositionX())
    GameScenemove(bed_up_locationx,bed_up_locationy ,function (  )

        self.layer=cc.Layer:create()
        local shildinglayer = Shieldingscreenmessage3:new()
        self.layer:addChild(shildinglayer)
        self.layer:addTo(self,126)
        --1.25秒消失后
        local layer =  self.layer
        local timer = TimerExBuf()
        timer:create(self.screenwanyao,1,1)
        function timer:onTime()
            layer:removeFromParent()
            timer:stop()
        end
        timer:start()

        self.grossini:getAnimation():play("stoop_1")--弯腰
        UItool:setCurrentState("wanyao")
        if self.furnituretb[1].num==1 then

            UItool:message2(" 这有个盒子，上面用缎带打了个死结，看起来很难拆开的样子。  ",30)

            self.furniture:getChildByName("bed_up"):setVisible(false)
            self.furniture:getChildByName("bed_up"):setTouchEnabled(false)
            local key_item = Data.getItemData(3)
            table.insert(PublicData.MERGEITEM, key_item.key)
            self.furnituretb[1].bool = false
             -- PublicData.MERGEITEM(key_item.key)

            self.furnituretb[1].num=self.furnituretb[1].num+1
        end

        -- local tb = PublicData.FURNITURE
        -- tb[1].num = self.furnituretb[1].num
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

    end,self.grossini,self.bg)
end

local quiltnum = 1
function GameScene11:quilt()
    --print("quilt")
        
        local quilt_locationx,quilt_locationy = UItool:getitem_location(self.furniture:getChildByName("quilt"), self.bg:getPositionX())
        GameScenemove( quilt_locationx,quilt_locationy ,function ()
            UItool:message2(" 我喜欢蓝色，它令我感到静谧舒适。",30 )

        end,self.grossini,self.bg)
end


function GameScene11:bed_down()
    --床底
    local bed_down_locationx, bed_down_locationy= UItool:getitem_location(self.furniture:getChildByName("bed_down"), self.bg:getPositionX())

    GameScenemove(bed_down_locationx ,bed_down_locationy,function (  )
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
        UItool:setCurrentState("xiadun")

        if self.furnituretb[2].num==1 then
            
            UItool:message2(" 这里有把小锤子，可能会有用。 ",30)
            local key_item = Data.getItemData(14)
            table.insert(PublicData.MERGEITEM, key_item.key)
            self.furnituretb[2].bool = false
            
            self.furnituretb[2].num=self.furnituretb[2].num+1
            self.bg:getChildByName("hammer_s"):setVisible(false)

            -- self.jiantou:setPosition(cc.p(100,90))
            else
                UItool:message2(" 什么也没有了。 ",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
    end,self.grossini,self.bg)
end 


function GameScene11:bedside_table()
    --床头柜
    --print("bedside_table_btn")
        local bedside_table_locationx, bedside_table_locationy= UItool:getitem_location(self.furniture:getChildByName("bedside_table_btn"), self.bg:getPositionX())

        GameScenemove( math.floor(bedside_table_locationx+self.grossini:getContentSize().width/6),bedside_table_locationy ,function (  )
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

            self.grossini:setScaleX(self.girlx)
            self.grossini:setScaleY(self.girly)

            self.grossini:getAnimation():play("squat_1") -- 下蹲
            UItool:setCurrentState("xiadun")
            if self.furnituretb[6].num==1 then
                
                if UItool:getBool("bedkey") then
                    self.furnituretb[6].num= 1+ self.furnituretb[6].num
                    UItool:message2(" 里面有什么东西……是一半剪刀。 ",30)

                    local key_item = Data.getItemData(12)
                    -- ModifyData.tableinsert(key_item.key)
                    table.insert(PublicData.MERGEITEM, key_item.key)

                    UItool:setBool("bedkey",false)

                    local itemnum = UItool:getInteger("bedkeynum")
                    for i=1,#PublicData.MERGEITEM do
                        if PublicData.MERGEITEM[i] == itemnum then
                            table.remove(PublicData.MERGEITEM,i) 
                            break
                        end
                    end

                    self.furniture:getChildByName("bedside_table_s"):setTexture("changesprite/GameScene11/bedside_table2.png")
                    self.furnituretb[6].ifchangesprite = true
                else
                    if UItool:getBool("elseitem") then
                        UItool:message2( Data.TALK[math.random(5)],30)
                        else
                            UItool:message2(" 它锁住了。 ",30)
                    end
                    
                end
                elseif self.furnituretb[6].num==2 then
                    UItool:message2("里面什么也没有了。",30)

                    
            end
            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()

        end,self.grossini,self.bg)
end

local teaflowernum = 1
function GameScene11:teaflower()
    --print("teaflower")
        
        local teaflower_locationx,teaflower_locationy = UItool:getitem_location(self.furniture:getChildByName("teaflower"), self.bg:getPositionX())

        GameScenemove( teaflower_locationx+self.grossini:getContentSize().width/6,teaflower_locationy ,function ()
            UItool:message2(" 我最喜欢的山茶花。",30 )
            self.grossini:setScaleX(self.girlx)
            self.grossini:setScaleY(self.girly)

        end,self.grossini,self.bg)
end

function GameScene11:bear()
    --  熊 多次点击
    --print("bear_btn")

    local bear_locationx, bear_locationy= UItool:getitem_location(self.furniture:getChildByName("bear_btn"), self.bg:getPositionX())

    GameScenemove(math.floor( bear_locationx)-math.floor(self.grossini:getContentSize().width/6),bear_locationy,function (  )

        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)

        if self.furnituretb[5].num==1 then
            UItool:message2(" 我喜欢的小熊，但和它在一起的洋娃娃不见了。 ",30)
            self.furnituretb[5].num = 1+self.furnituretb[5].num 
            elseif self.furnituretb[5].num==2 then

                self.furnituretb[5].num = 1+self.furnituretb[5].num 
                UItool:message2(" 小熊的身体里好像有什么东西，但是我要怎么取出来？ ",30)
                elseif self.furnituretb[5].num==3 then

                    if UItool:getBool("scissors") then
                        UItool:message2(" 用剪刀剪开了小熊……里面是……门钥匙？为什么会在这里……",30)
                        local key_item = Data.getItemData(19)
                        
                        table.insert(PublicData.MERGEITEM, key_item.key)
                        -- local itemnum = UItool:getInteger("scissorsnum")
                        -- for i=1,#ModifyData.getTable() do
                        --     if ModifyData.getTable()[i] == itemnum then
                        --         table.remove(ModifyData.getTable(),i) 
                        --         break
                        --     end
                        -- end

                        self.furniture:getChildByName("bear"):setTexture("changesprite/GameScene11/bear2.png")
                        self.furnituretb[5].ifchangesprite = true
                        self.merge:removeSelf()
                        self.merge = Merge:createScene()
                        self:addChild(self.merge,5)
                        self.furnituretb[5].num = 1+self.furnituretb[5].num 
                        -- UItool:setBool("scissors",false) 
                        else
                            if UItool:getBool("elseitem") then
                                UItool:message2( Data.TALK[math.random(5)],30)
                                else
                                    UItool:message2(" 小熊的身体里好像有什么东西，但是我要怎么取出来？",30)
                            end

                    end
                    else
                        UItool:message2(" 对不起，小熊... ",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        
    end,self.grossini,self.bg)
end

local lampnum = 1
function GameScene11:lamp()
    --print("lamp")
        
        local lamp_locationx,lamp_locationy = UItool:getitem_location(self.furniture:getChildByName("lamp"), self.bg:getPositionX())

        GameScenemove( math.floor( lamp_locationx)-math.floor(self.grossini:getContentSize().width/6),lamp_locationy ,function ()
            UItool:message2(" 这是房间中最明亮的地方。",30 )
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)

        end,self.grossini,self.bg)
end

function GameScene11:toilet_glass()
    --梳妆台-镜子
    --print("toilet_glass")
    local toilet_glass_locationx,toilet_glass_locationy = UItool:getitem_location(self.furniture:getChildByName("toilet_glass"), self.bg:getPositionX())
    
        GameScenemove(math.floor( toilet_glass_locationx-self.grossini:getContentSize().width/6),toilet_glass_locationy ,function (  )
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)
            if self.furnituretb[3].num==1 then
                -- 刚开始没碎第一次点击
                UItool:message3(" 镜子里面没有我的倒影……真让人害怕。 ","我不想看见它，有没有什么办法可以让它从我眼前消失... ",30)
                self.furnituretb[3].num = self.furnituretb[3].num + 1

                elseif self.furnituretb[3].num == 2 then
                    --第二次点击
                    if UItool:getBool("hammer") then
                        local key_item = Data.getItemData(1)
                        table.insert(PublicData.MERGEITEM, key_item.key)
                        UItool:message3(" 镜子里面是一行数字，奇怪的是，我移开目光后就记不清上面写的什么…… "," 我想我需要把它们写下来。 ",30)
                        local itemnum = UItool:getInteger("hammernum")
                        for i=1,#PublicData.MERGEITEM do
                            if PublicData.MERGEITEM[i] == itemnum then
                                table.remove(PublicData.MERGEITEM,i) 
                                break
                            end
                        end
                        self.bg:getChildByName("dressing_table"):setTexture("changesprite/GameScene11/dressing_table2.png")
                        self.furnituretb[3].ifchangesprite = true
                        
                        self.furnituretb[3].num = self.furnituretb[3].num + 1
                        UItool:setBool("hammer",false)
                        else
                            if UItool:getBool("elseitem") then
                                UItool:message2( Data.TALK[math.random(5)],30)
                                else
                                    UItool:message2(" 我不想看见它…… ",30)
                            end
                            

                    end
                    elseif self.furnituretb[3].num == 3 then
                        if UItool:getBool("paperpen") then
                            UItool:message2(" 用纸和笔将镜子上的数字抄写了下来。明明很短，为什么就是记不住呢…… ",30)
                            local key_item = Data.getItemData(2)
                            table.insert(PublicData.MERGEITEM, key_item.key)
                            
                            local itemnum = UItool:getInteger("paperpennum")
                            for i=1,#PublicData.MERGEITEM do
                                if PublicData.MERGEITEM[i] == itemnum then
                                    table.remove(PublicData.MERGEITEM,i) 
                                    break
                                end
                            end

                            
                            self.furnituretb[3].num = self.furnituretb[3].num + 1
                            UItool:setBool("paperpen",false)
                            
                            else
                                
                                if UItool:getBool("elseitem") then
                                    UItool:message2( Data.TALK[math.random(5)],30)
                                    else
                                        UItool:message2(" 我需要把这段数字写下来。 ",30)
                                end
                                
                        end
                        else
                            UItool:message2("一面被砸碎的镜子。",30)
            end
            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()
            
        end,self.grossini,self.bg)
end



function GameScene11:stool()
    --凳子stool
    --print("stool")
    local stool_locationx,stool_locationy = UItool:getitem_location(self.furniture:getChildByName("stool"), self.bg:getPositionX())

        GameScenemove( stool_locationx,stool_locationy ,function (  )
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
            
            self.grossini:getAnimation():play("squat_1")--下蹲
            UItool:setCurrentState("xiadun")
            if self.furnituretb[4].num==1 then
                UItool:message2(" 嘿……这凳子还挺轻的。  ",30)
                local key_item = Data.getItemData(8)
                table.insert(PublicData.MERGEITEM, key_item.key)
                
                self.furnituretb[4].bool = false
                self.furniture:getChildByName("stool"):setVisible(false)
                self.furniture:getChildByName("stool"):setTouchEnabled(false)
                self.furnituretb[4].num = self.furnituretb[4].num +1
                else
                    UItool:message2(" 嘿……凳子搬走了。 ",30)
            end
            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()
        end,self.grossini,self.bg)
end

function GameScene11:wardrobe()
    --衣柜
    --print("wardrobe")
    local wardrobe_locationx,wardrobe_locationy = UItool:getitem_location(self.furniture:getChildByName("wardrobe"), self.bg:getPositionX())

        GameScenemove( wardrobe_locationx,wardrobe_locationy ,function (  )
            if self.furnituretb[7].num==1 then
                
                if UItool:getBool("yiguikey") then
                    UItool:message2(" 打开了衣柜，里面空荡荡的，只有一个箱子。 ",30)
                    UItool:setBool("yansemima", true)

                    local itemnum = UItool:getInteger("yiguikeynum")
                    
                    for i=1,#PublicData.MERGEITEM do
                        
                        if PublicData.MERGEITEM[i] == itemnum then
                            
                            table.remove(PublicData.MERGEITEM,i)
                            local tb = PublicData.MERGEITEM
                            local str = json.encode(tb)
                            ModifyData.writeToDoc(str,"mergeitem")
                            break
                        end
                    end
                    self.furniture:getChildByName("yigui"):setTexture("changesprite/GameScene11/wardrobe2.png")
                    self.furnituretb[7].ifchangesprite = true
                    
                    self.furnituretb[7].num = self.furnituretb[7].num + 1
                    UItool:setBool("yiguikey",false) 
                    else
                        if UItool:getBool("elseitem") then
                            UItool:message2( Data.TALK[math.random(5)],30)
                            else
                                UItool:message2(" 锁住了。",30)
                        end
                        

                end

                elseif self.furnituretb[7].num>=2 and self.furnituretb[7].passpass == false then
                    UItool:password("96514",5) -- 密码四
                    self.furnituretb[7].num = self.furnituretb[7].num + 1
                else
                    UItool:message2(" 已经空了。 ",30)
            end
        
            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()
    end,self.grossini,self.bg)
end


function GameScene11:cushion()
    --靠垫
    --print("cushion")
           
    local cushion_locationx,cushion_locationy = UItool:getitem_location(self.furniture:getChildByName("cushion"), self.bg:getPositionX())
   
    GameScenemove( math.floor(cushion_locationx-self.grossini:getContentSize().width/5),cushion_locationy ,function (  )

        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)

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
        UItool:setCurrentState("wanyao")
        if self.furnituretb[8].num == 1 then
            self.furnituretb[8].ifmoved = true
            self.furniture:getChildByName("cushion"):setPosition(cc.p(self.furniture:getChildByName("cushion"):getPositionX()+30,self.furniture:getChildByName("cushion"):getPositionY()-20))
            UItool:message2(" 这有把钥匙，好像是衣柜的。",30)
            self.furnituretb[8].num = self.furnituretb[8].num+1
            elseif self.furnituretb[8].num == 2 then
                UItool:message2("拿到了钥匙。",30)
                self.furnituretb[8].ifremoved = true
                self.furniture:getChildByName("key"):removeSelf()
                local key_item = Data.getItemData(18)
                table.insert(PublicData.MERGEITEM, key_item.key)
                
                self.furnituretb[8].num = self.furnituretb[8].num+1
                else
                    UItool:message2("舒服的沙发，可是我现在没有时间休息。",30)
            
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        
    end,self.grossini,self.bg)
end

function GameScene11:B_vase()
    --大花瓶
    --print("B_vase")
    local B_vase_locationx,B_vase_locationy = UItool:getitem_location(self.furniture:getChildByName("B_vase"), self.bg:getPositionX())

    GameScenemove( math.floor(B_vase_locationx-self.grossini:getContentSize().width/6),B_vase_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[9].num==1 then
                --todo
            if UItool:getBool("redbrush") then
                local key_item = Data.getItemData(16)
                table.insert(PublicData.MERGEITEM, key_item.key)

                UItool:message2("刷成了红色，感觉好看了些，就是不知道为什么让我觉得有些恐怖。",30)
                local itemnum = UItool:getInteger("redbrushnum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end

                local function movetophonescreen()
                    --print("movetophone ")
                    local selfgrossini = self.grossini
                    self.layers=cc.Layer:create()
                    local shildinglayer = Shieldingscreenmessage3:new()
                    self.layers:addChild(shildinglayer)
                    self.layers:addTo(self,126)
                    --1.25秒消失后
                    local layers =  self.layers
                    local timer = TimerExBuf()
                    timer:create(7.95,1,1)
                    function timer:onTime()
                        layers:removeFromParent()
                        timer:stop()
                    end
                    timer:start()
                end

                self.layer=cc.Layer:create()
                local shildinglayer = Shieldingscreenmessage3:new()
                self.layer:addChild(shildinglayer)
                self.layer:addTo(self,126)
                --1.25秒消失后
                local layer =  self.layer
                
                local timer = TimerExBuf()
                timer:create(2,1,1)
                local selfbg = self.bg
                local selfvisibleSize = self.visibleSize
                local selfgrossini = self.grossini
                local phone = self.furniture:getChildByName("phone")
                
                function timer:onTime()
                    layer:removeFromParent()
                    movetophonescreen()

                    local function  phonering( ... )
                         UItool:message2("电话响了，我是不是应该去接一下？",30)
                    end

                    local srcbgpositionX = selfbg:getPositionX()
                    local srcgirlpositionX = selfgrossini:getPositionX()
                    local movetophone = cc.MoveTo:create(1.5, cc.p(selfvisibleSize.width-selfbg:getContentSize().width,selfbg:getPositionY()))
                    local movetogirl = cc.MoveTo:create(1.5, cc.p(srcbgpositionX,selfbg:getPositionY()))
                    local movedelay = cc.DelayTime:create(2)
                    local bgsqeuen = cc.Sequence:create(movetophone,movedelay,movetogirl,cc.CallFunc:create(phonering))
                    selfbg :runAction(bgsqeuen)

                    local girlmoveleft = cc.MoveTo:create(1.5, cc.p(selfbg:getContentSize().width-selfvisibleSize.width+selfbg:getPositionX(),selfgrossini:getPositionY()))
                    local girlmoveriht = cc.MoveTo:create(1.5, cc.p(srcgirlpositionX,selfgrossini:getPositionY()))
                    local girlsequence = cc.Sequence:create(girlmoveleft,movedelay,girlmoveriht)
                    selfgrossini:runAction(girlsequence)

                    movetophonescreen()
                    timer:stop()
                end
                timer:start()

                self.furniture:getChildByName("redflower"):setTexture("changesprite/GameScene11/redflower2.png")
                self.furnituretb[9].ifchangesprite = true
                
                self.furnituretb[9].num = self.furnituretb[9].num + 1
                UItool:setBool("redbrush",false)
                else
                    if UItool:getBool("elseitem") then
                        UItool:message2( Data.TALK[math.random(5)],30)
                        else
                            UItool:message2(" 白色的插花，看起来真朴素。 ",30)
                    end
                    
            end
            else
                UItool:message2(" 摘走了一些花朵，我不需要更多的花了。 ",30)

        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

    end,self.grossini,self.bg)
end

function GameScene11:linglan()
    --print("linglan")
        
        local linglan_locationx,linglan_locationy = UItool:getitem_location(self.furniture:getChildByName("linglan"), self.bg:getPositionX())

        GameScenemove( math.floor(linglan_locationx-self.grossini:getContentSize().width/6),linglan_locationy ,function ()
            UItool:message2(" 枯萎掉的铃兰。",30 )
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)

        end,self.grossini,self.bg)
end



function GameScene11:bookshelf_two()
    --书架二  多次点击
    --print("bookshelf_two")
    
    local bookshelf_two_locationx,bookshelf_two_locationy = UItool:getitem_location(self.furniture:getChildByName("bookshelf_two"), self.bg:getPositionX())

    GameScenemove( math.floor(bookshelf_two_locationx-self.grossini:getContentSize().width/6),bookshelf_two_locationy ,function ()
        
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        local flower_item = Data.getItemData(16)
        if self.furnituretb[10].num == 1 and self.furnituretb[14].redflower==false  then
           UItool:message2(" 书可真多啊 !" , 30)
           self.furnituretb[10].num = self.furnituretb[10].num + 1
           elseif  self.furnituretb[10].num == 2 then
            self.furnituretb[10].num = self.furnituretb[10].num + 1
            UItool:message2("我最喜欢的书也在上面。" , 30)
               elseif self.furnituretb[10].num == 3 then

                   self.furnituretb[10].num = self.furnituretb[10].num + 1
                   UItool:message2("书里掉出来了一张纸，上面有一串电话号码，是谁留下的呢？" , 30)
                   local key_item = Data.getItemData(9)
                    table.insert(PublicData.MERGEITEM, key_item.key)
                    
                    

                    self.layer=cc.Layer:create()
                    local shildinglayer = Shieldingscreenmessage3:new()
                    self.layer:addChild(shildinglayer)
                    self.layer:addTo(self,125)

                    local layer =  self.layer
                    local timer = TimerExBuf()
                    timer:create(self.screenxiadun+0.3,1,1)
                    function timer:onTime()
                        -- UItool:message2("一串电话号码 是谁留下的呢？",30)
                        layer:removeFromParent()
                        timer:stop()
                    end
                    timer:start()

                    self.grossini:getAnimation():play("squat_1")--下蹲
                    -- UItool:setCurrentState("xiadun")

                    else
                        UItool:message2(" 书可真多啊 ! " , 30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
    end,self.grossini,self.bg)
end

local cupnum = 1
function GameScene11:cup()
    --print("cup")
        
        local cup_locationx,cup_locationy = UItool:getitem_location(self.furniture:getChildByName("cup"), self.bg:getPositionX())

        GameScenemove( math.floor( cup_locationx-self.grossini:getContentSize().width/5),cup_locationy ,function ()
            UItool:message2(" 我最爱的茶杯。 ",30 )
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)
        end,self.grossini,self.bg)
end

function GameScene11:book()
    --纸和笔
    --print("book")
    local book_locationx,book_locationy = UItool:getitem_location(self.furniture:getChildByName("book"), self.bg:getPositionX())

    GameScenemove(math.floor( book_locationx-self.grossini:getContentSize().width/5),book_locationy ,function ()
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        
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
        UItool:setCurrentState("wanyao")
        if self.furnituretb[11].num==1 then
            UItool:message2("  我可以用它来抄一些东西。  ",30) 
            self.furnituretb[11].num = self.furnituretb[11].num+1
            local key_item = Data.getItemData(15)
            table.insert(PublicData.MERGEITEM, key_item.key)
            
            self.furnituretb[11].bool = false
            self.furniture:getChildByName("book"):setVisible(false)
            self.furniture:getChildByName("book"):setTouchEnabled(false)

        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
    end,self.grossini,self.bg)
end



function GameScene11:wardrobe_drawer_2()
    --print("wardrobe_drawer_2")
    --立柜抽屉二层
        local wardrobe_drawer_2_locationx,wardrobe_drawer_2_locationy = UItool:getitem_location(self.furniture:getChildByName("wardrobe_drawer_2"), self.bg:getPositionX())

        GameScenemove(math.floor( wardrobe_drawer_2_locationx-self.grossini:getContentSize().width/6 ),wardrobe_drawer_2_locationy ,function ()
            self.layer=cc.Layer:create()
            local shildinglayer = Shieldingscreenmessage3:new()
            self.layer:addChild(shildinglayer)
            self.layer:addTo(self,125)
            --1.8秒消失后
            local layer =  self.layer
            local timer = TimerExBuf()
            timer:create(self.screenxiadun,1,1)
            function timer:onTime()

                layer:removeFromParent()
                timer:stop()
            end
            timer:start()

            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)

            self.grossini:getAnimation():play("squat_1")--下蹲
            UItool:setCurrentState("xiadun")
            if self.furnituretb[12].num==1 then

                if UItool:getBool("liguikey") then
                    UItool:message2("  一把刷子，或许我可以用它来蘸一些有颜色的东西。 ",30) 
                    self.furnituretb[12].ifchangesprite = true
                    self.bg:getChildByName("ligui"):setTexture("changesprite/GameScene11/ligui2.png")

                    local key_item = Data.getItemData(6)
                    table.insert(PublicData.MERGEITEM, key_item.key)
                    
                    local itemnum = UItool:getInteger("liguikeynum")

                    for i=1,#PublicData.MERGEITEM do
                        if PublicData.MERGEITEM[i] == itemnum then
                            table.remove(PublicData.MERGEITEM,i) 
                            break
                        end
                    end
                    
                    
                    self.furnituretb[12].num = self.furnituretb[12].num+1
                    UItool:setBool("liguikey",false)
                    else
                        if UItool:getBool("elseitem") then
                            UItool:message2( Data.TALK[math.random(5)],30)
                            else
                                UItool:message2(" 抽屉上锁了。 ",30) 
                        end
                        
                end
                
                else
                     UItool:message2(" 抽屉里面什么都没有了。  ",30) 
                    
            end
            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()
        end,self.grossini,self.bg)
end


function GameScene11:liguiframe()
    --print("liguiframe")
    --立柜相册
        local liguiframe_locationx,liguiframe_locationy = UItool:getitem_location(self.furniture:getChildByName("liguiframe"), self.bg:getPositionX())
        GameScenemove(math.floor( liguiframe_locationx-self.grossini:getContentSize().width/6 ),liguiframe_locationy ,function ()
            --print("liguiframe_locationy")
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)
            if self.furnituretb[13].num==1 then
                if UItool:getBool("familyphoto") then
                    UItool:message2(" 看来这张照片原本应该是放在这的，有把小钥匙从相框的夹层里掉出来了。  ",30)
                    self.furnituretb[13].ifchangesprite = true
                    self.furniture:getChildByName("frame_ligui"):setTexture("changesprite/GameScene11/frame_ligui2.png")
                    local key_item = Data.getItemData(23)
                    table.insert(PublicData.MERGEITEM, key_item.key)
                    
                    local itemnum = UItool:getInteger("familyphotonum")

                    for i=1,#PublicData.MERGEITEM do
                        if PublicData.MERGEITEM[i] == itemnum then
                            table.remove(PublicData.MERGEITEM,i) 
                            break
                        end
                    end
                    
                    
                    self.furnituretb[13].num = self.furnituretb[13].num+1
                    UItool:setBool("familyphoto",false)
                    else
                        if UItool:getBool("elseitem") then
                            UItool:message2( Data.TALK[math.random(5)],30)
                            else
                                UItool:message2(" 相框是空的，或许里面原本应该有张照片？   ",30)
                        end
                        
                end
                
            else
                UItool:message2(" 爸爸……妈妈……  ",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        end,self.grossini,self.bg)
end

function GameScene11:phone()
    --print("phone")
        local phone_locationx,phone_locationy = UItool:getitem_location(self.furniture:getChildByName("phone"), self.bg:getPositionX())
        GameScenemove( math.floor(phone_locationx-self.grossini:getContentSize().width/7),phone_locationy ,function ()
            
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)

                if self.furnituretb[14].num==1  then

                   if UItool:getBool("redflower") then
                        UItool:message2(" 很好，为了表示感谢，这个给你。我想你会需要它的。 ",30)
                        local key_item = Data.getItemData(17)
                        table.insert(PublicData.MERGEITEM, key_item.key)

                        local itemnum = UItool:getInteger("redflowernum")
                        self.furnituretb[14].redflower = true 
                        
                        for i=1,#PublicData.MERGEITEM do
                            if PublicData.MERGEITEM[i] == itemnum then
                                table.remove(PublicData.MERGEITEM,i) 
                                break
                            end
                        end

                        --电话纸的key==9
                            for i=1,#PublicData.MERGEITEM do
                                if PublicData.MERGEITEM[i] == 9 then
                                    table.remove(PublicData.MERGEITEM,i) 
                                    break
                                end
                            end
                        -- end
                        
    
                        self.furnituretb[14].num = self.furnituretb[14].num + 1
                        UItool:setBool("redflower",false)

                        elseif UItool:getBool("phonepaper") then
                            
                            UItool:message2(" 你喜欢花吗？我最喜欢了，尤其是红色的。 ",30)
                            
        
                            else
                                if UItool:ifcontain(16) then
                                    UItool:message2(" 你手上有我想要的东西，可以把它给我吗？",30)
                                    else
                                        UItool:message2(" 一部电话。",30)
                                end   
                    end

                    else
                        UItool:message2(" 嘟......嘟......嘟......  ",30)

                end
                local str = json.encode(self.furnituretb)
                ModifyData.writeToDoc(str,"furniture")
                self:megerupdate()
            

        end,self.grossini,self.bg)
end

function GameScene11:modify()
    
    local tb = PublicData.ROOMTABLE
    -- print("roomtable 的表",json.encode(PublicData.ROOMTABLE))
    -- print("chapternum,roomNumber数值",chapterNumber,roomNumber)
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
    table.insert(PublicData.MERGEITEM, 11)


    ModifyData.setRoomNum(2)
    UItool:setInteger("roomNumber", 2)
    

    local scene = GameScene12.new()
    local turn = cc.TransitionFade:create(1, scene)
    cc.Director:getInstance():replaceScene(turn)
end

function GameScene11:door()
    --print("door")
    --门
        local door_locationx,door_locationy = UItool:getitem_location(self.furniture:getChildByName("door"), self.bg:getPositionX())

        GameScenemove ( door_locationx,door_locationy ,function ()
             if UItool:getBool("doorkey") then
                local itemnum = UItool:getInteger("doorkeynum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end

               

                 self.modify()
                else
                    if UItool:getBool("elseitem") then
                        UItool:message2( Data.TALK[math.random(5)],30)
                        else
                            UItool:message2(" 打不开……我需要找到钥匙。  ",30)
                    end
                    
                end
                self:megerupdate()
        end,self.grossini,self.bg)
end


function GameScene11:aocao()
    --print("Big_frame")
        
        local Big_frame_locationx,Big_frame_locationy = UItool:getitem_location(self.furniture:getChildByName("Big_frame"), self.bg:getPositionX())

        GameScenemove( math.floor(Big_frame_locationx-self.grossini:getContentSize().width/6),Big_frame_locationy  ,function ()
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)
            
            if self.furnituretb[15].num==1 then
                -- self.furniture:getChildByName("Big_frame"):setScale(2)
                UItool:message2(" 这画下面有个圆形的凹槽，好像要用什么东西插进去才能打开。 ",30)
                self.furnituretb[15].num = self.furnituretb[15].num + 1
                self.furnituretb[15].ifbigger = true
                elseif self.furnituretb[15].num==2 then
                    --todo
                    if UItool:getBool("stamp") then
                        
                        UItool:specialitem("奥拉汀女神的护身符",4)

                        -- local tb = PublicData.ROOMTABLE
                        -- tb[chapterNumber][roomNumber+1].lock=0
                        -- local str = json.encode(tb)
                        -- ModifyData.writeToDoc(str,"room")
                        local itemnum = UItool:getInteger("stampnum")
                        for i=1,#PublicData.MERGEITEM do
                            if PublicData.MERGEITEM[i] == itemnum then
                                table.remove(PublicData.MERGEITEM,i) 
                                break
                            end
                        end
                        -- self.furniture:getChildByName("Big_frame"):setScale(1)
                        self.furnituretb[15].ifbigger = false
                        self.furniture:getChildByName("Big_frame"):setTexture("changesprite/GameScene11/Big_frame2.png")
                        self.furnituretb[15].ifchangesprite = true
                        
                        self.furnituretb[15].num = self.furnituretb[15].num + 1
                        UItool:setBool("stamp",false)
                        else
                            if UItool:getBool("elseitem") then
                                UItool:message2( Data.TALK[math.random(5)],30)
                                else
                                    UItool:message2(" 这画下面有个凹槽，好像要用什么东西插进去才能打开。  ",30)
                            end
                            self.furniture:getChildByName("Big_frame"):setScale(1)
                            self.furnituretb[15].ifbigger =false
                            self.furnituretb[15].num = self.furnituretb[15].num - 1
                    end
                    else
                        UItool:message2("真奇怪，我并不知道画后面还有这样的一个空间……",30)
            end
            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()

        end,self.grossini,self.bg)
end

local hua_framenum = 1
function GameScene11:hua_frame()
    --print("hua_frame")
        
        local hua_frame_locationx,hua_frame_locationy = UItool:getitem_location(self.furniture:getChildByName("hua_frame"), self.bg:getPositionX())

        GameScenemove( hua_frame_locationx,hua_frame_locationy ,function ()
            if UItool:getBool("yansemima") then
                UItool:message2(" 这幅画上的花是粉颜色，有6朵。 ",30 )
                else
                    UItool:message2(" 画上有很多花，五颜六色的。 ",30 )
            end
        
        end,self.grossini,self.bg)
end


function GameScene11:frame_5()
    --print("frame_5")
        
        local frame_5_locationx,frame_5_locationy = UItool:getitem_location(self.furniture:getChildByName("frame_5"), self.bg:getPositionX())

        GameScenemove( frame_5_locationx,frame_5_locationy ,function ()
            if self.furnituretb[16].num==1 then

                UItool:message2(" 画的后面夹了一张照片，上面是爸爸和妈妈，没有我…… ",30)
                local key_item = Data.getItemData(22)
                table.insert(PublicData.MERGEITEM, key_item.key)
                
                self.furnituretb[16].num=self.furnituretb[16].num+1

            else
                UItool:message2(" 一张小照片。 ",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        end,self.grossini,self.bg)
end

local fang_framenum = 1
function GameScene11:fang_frame()
    --print("fang_frame")
        
        local fang_frame_locationx,fang_frame_locationy = UItool:getitem_location(self.furniture:getChildByName("fang_frame"), self.bg:getPositionX())

        GameScenemove( fang_frame_locationx,fang_frame_locationy ,function ()
            if UItool:getBool("yansemima") then
                UItool:message2(" 这幅画上的花是蓝颜色，有5朵。 ",30 )
                else
                    UItool:message2(" 画上有很多花，五颜六色的。 ",30 )
            end
        end,self.grossini,self.bg)
end

local yuan_framenum = 1
function GameScene11:yuan_frame()
    --print("yuan_frame")
        
        local yuan_frame_locationx,yuan_frame_locationy = UItool:getitem_location(self.furniture:getChildByName("yuan_frame"), self.bg:getPositionX())

        GameScenemove( yuan_frame_locationx,yuan_frame_locationy ,function ()

        if UItool:getBool("yansemima") then
                UItool:message2(" 这幅画上的花是白颜色，有9朵。",30 )
                else
                    UItool:message2(" 画上有很多花，五颜六色的。 ",30 )
            end
        end,self.grossini,self.bg)
end


function GameScene11:frame_1()
    --print("frame_1")
        local frame_locationx,frame_locationy = UItool:getitem_location(self.furniture:getChildByName("frame_1"), self.bg:getPositionX())
        GameScenemove( frame_locationx,frame_locationy ,function ()
            if UItool:getBool("yansemima") then
                UItool:message2(" 这幅画上的花是黄颜色，有4朵。 ",30 )
                else
                    UItool:message2(" 画上有很多花，五颜六色的。 ",30 )
            end
        end,self.grossini,self.bg)
end


function GameScene11:photo()
    --print("bigframe")
        
        local bigframe_locationx,bigframe_locationy = UItool:getitem_location(self.furniture:getChildByName("Big_frame"), self.bg:getPositionX())

        self:Girl_bg_move( math.floor(bigframe_locationx-self.grossini:getContentSize().width/6),bigframe_locationy ,function ()
            if UItool:getBool("yansemima") then
                UItool:message2(" 这幅画里的我拿了一朵紫色的花——那是我最喜欢的颜色。 ",30 )
                else
                    UItool:message2(" 画上有很多花，五颜六色的。 ",30 )
            end
        end,self.grossini,self.bg)
end

function GameScene11:zashu()
    --print("bigframe")
        
        local bigframe_locationx,bigframe_locationy = UItool:getitem_location(self.furniture:getChildByName("zashu"), self.bg:getPositionX())

        GameScenemove( math.floor(bigframe_locationx-self.grossini:getContentSize().width/6),bigframe_locationy ,function ()
            UItool:message2("嗯……好像没有什么帮助。",30)
        end,self.grossini,self.bg)
end

function GameScene11:Tguizi()
    --print("bigframe")
        
        local bigframe_locationx,bigframe_locationy = UItool:getitem_location(self.furniture:getChildByName("Tguizi"), self.bg:getPositionX())

        GameScenemove( math.floor(bigframe_locationx-self.grossini:getContentSize().width/6),bigframe_locationy ,function ()
            UItool:message2("奇怪，柜子里面什么都没有。",30)
        end,self.grossini,self.bg)
end

function GameScene11:Tguizi_0()
    --print("bigframe")
        
        local bigframe_locationx,bigframe_locationy = UItool:getitem_location(self.furniture:getChildByName("Tguizi_0"), self.bg:getPositionX())

        GameScenemove( math.floor(bigframe_locationx-self.grossini:getContentSize().width/6),bigframe_locationy ,function ()
            UItool:message2("奇怪，柜子里面什么都没有。",30)
        end,self.grossini,self.bg)
end

function GameScene11:Tchouti()
    --print("bigframe")
        
        local bigframe_locationx,bigframe_locationy = UItool:getitem_location(self.furniture:getChildByName("Tchouti"), self.bg:getPositionX())

        GameScenemove( math.floor(bigframe_locationx-self.grossini:getContentSize().width/6),bigframe_locationy ,function ()
            UItool:message2("抽屉是空的……里面的东西都到哪去了……",30)
        end,self.grossini,self.bg)
end

function GameScene11:doublechouti1()
    --print("bigframe")
        
        local bigframe_locationx,bigframe_locationy = UItool:getitem_location(self.furniture:getChildByName("doublechouti1"), self.bg:getPositionX())

        GameScenemove( math.floor(bigframe_locationx-self.grossini:getContentSize().width/6),bigframe_locationy ,function ()
            UItool:message2("抽屉是空的……里面的东西都到哪去了……",30)
        end,self.grossini,self.bg)
end

function GameScene11:doublechouti2()
    --print("bigframe")
        
        local bigframe_locationx,bigframe_locationy = UItool:getitem_location(self.furniture:getChildByName("doublechouti2"), self.bg:getPositionX())

        GameScenemove( math.floor(bigframe_locationx-self.grossini:getContentSize().width/6),bigframe_locationy ,function ()
            UItool:message2("抽屉是空的……里面的东西都到哪去了……",30)
        end,self.grossini,self.bg)
end

function GameScene11:Lchouti()
    --print("bigframe")
        
        local bigframe_locationx,bigframe_locationy = UItool:getitem_location(self.furniture:getChildByName("Lchouti"), self.bg:getPositionX())

        GameScenemove( math.floor(bigframe_locationx-self.grossini:getContentSize().width/6),bigframe_locationy ,function ()
            UItool:message2("里面没有什么有用的东西。",30)
        end,self.grossini,self.bg)
end

function GameScene11:kongyigui()
    --print("bigframe")
        
        local bigframe_locationx,bigframe_locationy = UItool:getitem_location(self.furniture:getChildByName("kongyigui"), self.bg:getPositionX())

        GameScenemove( math.floor(bigframe_locationx-self.grossini:getContentSize().width/6),bigframe_locationy ,function ()
            UItool:message2("都是空的，我的衣服们全都不见了……",30)
        end,self.grossini,self.bg)
end

function GameScene11:wardrobe_top()
    --衣柜顶
    --print("wardrobe_top")
        
        local yuan_frame_locationx,yuan_frame_locationy = UItool:getitem_location(self.furniture:getChildByName("wardrobe_top"), self.bg:getPositionX())

        GameScenemove( yuan_frame_locationx,yuan_frame_locationy ,function ()
        if self.furnituretb[17].num==1 then
            if UItool:getBool("stool") then
                UItool:message2(" 拿到了一个密码盒。",30)
                local key_item = Data.getItemData(10)
                table.insert(PublicData.MERGEITEM, key_item.key)
                
                local itemnum = UItool:getInteger("stoolnum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                self.furniture:getChildByName("wardrobe_top"):setTouchEnabled(false)
                self.furniture:getChildByName("wardrobe_top"):setVisible(false)
                self.furnituretb[17].bool = true
                
                self.furnituretb[17].num = self.furnituretb[17].num+1
                UItool:setBool("stool",false)
                else
                    if UItool:getBool("elseitem") then
                        UItool:message2( Data.TALK[math.random(5)],30)
                        else
                            UItool:message2(" 太高了，我够不到！ ",30)
                    end
                    
            end

            else
                UItool:message2(" 太高了，我够不到！ ",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)
end

function GameScene11:AllButtons(  )
    self.AllButtons = 
    {  
        self.furniture:getChildByName("bed_up"),
        self.furniture:getChildByName("bed_down"),
        self.furniture:getChildByName("toilet_glass"),
        self.furniture:getChildByName("bedside_table_btn"),
        self.furniture:getChildByName("stool"),
        self.furniture:getChildByName("kongyigui"),
        self.furniture:getChildByName("wardrobe"),
        self.furniture:getChildByName("cushion"),
        self.furniture:getChildByName("B_vase"),
        self.furniture:getChildByName("bookshelf_two"),
        self.furniture:getChildByName("book"),
        self.furniture:getChildByName("wardrobe_drawer_2"),
        self.furniture:getChildByName("phone"),
        self.furniture:getChildByName("door"),
        self.furniture:getChildByName("Big_frame"):getChildByName("aocao"),
        self.furniture:getChildByName("hua_frame"),
        self.furniture:getChildByName("yuan_frame"),
        self.furniture:getChildByName("fang_frame"),
        self.furniture:getChildByName("wardrobe_top"),
        self.furniture:getChildByName("frame_1"),
        self.furniture:getChildByName("bear_btn"),
        self.furniture:getChildByName("Big_frame"):getChildByName("photo"),
        self.furniture:getChildByName("frame_5"),
        self.furniture:getChildByName("liguiframe"),
        self.furniture:getChildByName("teaflower"),
        self.furniture:getChildByName("quilt"),
        self.furniture:getChildByName("cup"),
        self.furniture:getChildByName("linglan"),
        self.furniture:getChildByName("lamp"),
        self.furniture:getChildByName("Lchouti"),
        self.furniture:getChildByName("Tguizi"),
        self.furniture:getChildByName("Tchouti"),
        self.furniture:getChildByName("Tguizi_0"),
        self.furniture:getChildByName("doublechouti1"),
        self.furniture:getChildByName("doublechouti2")


    }
    --是否显示或者更换图片
    --带绳箱子
    if self.furnituretb[1].bool ==false then
            self.furniture:getChildByName("bed_up"):setVisible(false)
            self.furniture:getChildByName("bed_up"):setTouchEnabled(false)
    end

    --锤子
    if self.furnituretb[2].bool==false then
            self.bg:getChildByName("hammer_s"):setVisible(false)
    end

    --梳妆台
    if self.furnituretb[3].ifchangesprite then
        self.bg:getChildByName("dressing_table"):setTexture("changesprite/GameScene11/dressing_table2.png")
    end

    --矮凳
    if self.furnituretb[4].bool==false then
        self.furniture:getChildByName("stool"):setVisible(false)
        self.furniture:getChildByName("stool"):setTouchEnabled(false)
    end

    --小熊
    if self.furnituretb[5].ifchangesprite then
        self.furniture:getChildByName("bear"):setTexture("changesprite/GameScene11/bear2.png")
    end
    --床头柜
    if self.furnituretb[6].ifchangesprite then
        self.furniture:getChildByName("bedside_table_s"):setTexture("changesprite/GameScene11/bedside_table2.png")
    end
    --衣柜
    if  self.furnituretb[7].ifchangesprite  then
        self.furniture:getChildByName("yigui"):setTexture("changesprite/GameScene11/wardrobe2.png")
    end

    --靠垫
    if self.furnituretb[8].ifmoved then
        self.furniture:getChildByName("cushion"):setPosition(cc.p(self.furniture:getChildByName("cushion"):getPositionX()+30,self.furniture:getChildByName("cushion"):getPositionY()-20))
        
    end
    if self.furnituretb[8].ifremoved then
        self.furniture:getChildByName("key"):removeSelf()
    end

    --大花瓶
    if  self.furnituretb[9].ifchangesprite then
        self.furniture:getChildByName("redflower"):setTexture("changesprite/GameScene11/redflower2.png")
    end

    --纸和笔
    if self.furnituretb[11].bool ==false then
        self.furniture:getChildByName("book"):setVisible(false)
        self.furniture:getChildByName("book"):setTouchEnabled(false)
    end
    --立柜
    if self.furnituretb[12].ifchangesprite then
        self.bg:getChildByName("ligui"):setTexture("changesprite/GameScene11/ligui2.png")
    end
    --立柜相册
    if self.furnituretb[13].ifchangesprite then
        self.furniture:getChildByName("frame_ligui"):setTexture("changesprite/GameScene11/frame_ligui2.png")
    end
    --大相框
    if self.furnituretb[15].ifchangesprite then
        self.furniture:getChildByName("Big_frame"):setTexture("changesprite/GameScene11/Big_frame2.png")
    end
    if self.furnituretb[15].ifbigger then
        -- self.furniture:getChildByName("Big_frame"):setScale(2)
    end
    --衣柜顶
    if self.furnituretb[17] == false then
        self.furniture:getChildByName("wardrobe_top"):setTouchEnabled(false)
        self.furniture:getChildByName("wardrobe_top"):setVisible(false)
    end

    local function allButtonClick(event,eventType)
        if eventType == TOUCH_EVENT_ENDED then
            if UItool:getBool("effect") then
                AudioEngine.playEffect("gliss.mp3")
            end
            if event:getName()=="bed_up" then
                --print("bed_up")
                self:bed_up()
                elseif event:getName()=="bed_down" then
                    --print("bed_down")
                    self:bed_down()
                    elseif event:getName()=="toilet_glass" then
                        --print("toilet_glass")
                        self:toilet_glass()
                        elseif event:getName()=="bedside_table_btn" then
                            --print("bedside_table_btn")
                            self:bedside_table()
                            elseif event:getName()=="stool" then
                                --print("stool")
                                self:stool()
                                elseif event:getName()=="wardrobe" then
                                    --print("wardrobe")
                                    self:wardrobe()
                                    elseif event:getName()=="cushion" then
                                        --print("cushion")
                                        self:cushion()
                                        elseif event:getName()=="B_vase" then
                                            --print("B_vase")
                                            self:B_vase()
                                            elseif event:getName()=="bookshelf_two" then
                                                --print("··bookshelf_two·")
                                                self:bookshelf_two()
                                                elseif event:getName()=="book" then
                                                    --print("book")
                                                    self:book()
                                                    elseif event:getName()=="wardrobe_drawer_2" then
                                                        --print("·wardrobe_drawer_2··")
                                                        self:wardrobe_drawer_2()
                                                        elseif event:getName()=="phone" then
                                                            --print("··phone·")
                                                            self:phone()
                                                            elseif event:getName()=="door" then
                                                                --print("··door·")
                                                                self:door()
                                                                elseif event:getName()=="aocao" then
                                                                    --print("··Big_frame·")
                                                                    self:aocao()
                                                                    elseif event:getName()=="hua_frame" then
                                                                        --print("·hua_frame··")
                                                                        self:hua_frame()
                                                                        elseif event:getName()=="yuan_frame" then
                                                                            --print("yuan_frame")
                                                                            self:yuan_frame()
                                                                            elseif event:getName()=="fang_frame" then
                                                                                --print("fang_frame")
                                                                                self:fang_frame()
                                                                                elseif event:getName()=="wardrobe_top" then
                                                                                    --print("wardrobe_top")
                                                                                    self:wardrobe_top()
                                                                                    elseif event:getName()=="frame_1" then
                                                                                        --print("frame_1")
                                                                                        self:frame_1()
                                                                                        elseif event:getName()=="bear_btn" then
                                                                                            --print("bear")
                                                                                            self:bear()
                                                                    
                                                                                            elseif event:getName()=="photo" then
                                                                                                --print("bigframe")
                                                                                                self:photo()
                                                                                                
                                                                                                elseif event:getName()=="liguiframe" then
                                                                                                    --print("liguiframe")
                                                                                                    self:liguiframe()
                                                                                                    elseif event:getName()=="frame_5" then
                                                                                                        --print("frame_5")
                                                                                                        self:frame_5()
                                                                                                        elseif event:getName()=="teaflower" then
                                                                                                            --print("teaflower")
                                                                                                            self:teaflower()
                                                                                                            elseif event:getName()=="quilt" then
                                                                                                                --print("quilt")
                                                                                                                self:quilt()
                                                                                                                elseif event:getName()=="lamp" then
                                                                                                                    --print("lamp")
                                                                                                                    self:lamp()
                                                                                                                    elseif event:getName()=="cup" then
                                                                                                                        --print("cup")
                                                                                                                        self:cup()
                                                                                                                        elseif event:getName()=="linglan" then
                                                                                                                            --print("linglan")
                                                                                                                            self:linglan()
                                                                                                                            elseif event:getName()=="Lchouti" then
                                                                                                                                self:Lchouti()
                                                                                                                                elseif event:getName()=="Tguizi" then
                                                                                                                                    self:Tguizi()
                                                                                                                                    elseif event:getName()=="Tchouti" then
                                                                                                                                        self:Tchouti()
                                                                                                                                        elseif event:getName()=="zashu" then
                                                                                                                                            self:zashu()
                                                                                                                                            elseif event:getName()=="Tguizi_0" then
                                                                                                                                                self:Tguizi_0()
                                                                                                                                                elseif event:getName()=="doublechouti2" then
                                                                                                                                                    self:doublechouti2()
                                                                                                                                                    elseif event:getName()=="doublechouti1" then
                                                                                                                                                        self:doublechouti1()
                                                                                                                                                        elseif event:getName()=="kongyigui" then
                                                                                                                                                            self:kongyigui()
                                                                                                                
                                                                                                                 
            end
        end
    end
    for key, var in pairs(self.AllButtons) do
        if self.grossini:getNumberOfRunningActions()>0 or self.bg:getNumberOfRunningActions()>0 then
            else
                var:addClickEventListener(allButtonClick)
        end
    end
end

    --角色移动
function GameScene11:grossiniwalk()
    --骨骼动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/donghua/loli/Export/loli/loli.ExportJson") 
    self.grossini = ccs.Armature:create("loli")
    self.grossini:setScaleX(-self.girlx)
    self.grossini:setScaleY(self.girly)
    
    self.grossini:getAnimation():playWithIndex(1)
    self.grossini:getAnimation():play("stand")
    UItool:setCurrentState("stand")
    self.grossini:setPosition(cc.p(self.savedata.girlpositionx,140))
    self:addChild(self.grossini,6)
end


function GameScene11:ontouch( ... )
	--触摸
	--实现事件触发回调
	local function onTouchBegan(touch, event)
		--人物行走调用
        local rect = cc.rect(0, 150,self.bg:getContentSize().width, self.bg:getContentSize().height)  
  
        if cc.rectContainsPoint(rect, touch:getLocation()) then  
           local gril_pointx = self.grossini:getPositionX()
           local target = event:getCurrentTarget()
           local locationInNode = target:convertToNodeSpace(touch:getLocation())  
           local touchlocation = touch:getLocation()
           --点击效果

           GameScenemove(touchlocation.x,touchlocation.y,nil,self.grossini,self.bg)
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

function GameScene11:onEnterTransitionFinish ()

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
    
    
    --点击效果层
    local dianjilayer = TouchLayer:new()
    self.bg:addChild(dianjilayer,128)

    UItool:setBool("yansemima", false) -- 颜色密码箱

    
   
end

function GameScene11:onEnter()
   
    self:init()
    -- self.right = cc.Sprite:create("cn/Load/image/UI/pause.png")
    -- self.right:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))
    -- self:addChild(self.right,29)
    -- local rotate = cc.RotateBy:create(2, -30)
    -- self.right:runAction( cc.RepeatForever:create(rotate))
end

return GameScene11

















