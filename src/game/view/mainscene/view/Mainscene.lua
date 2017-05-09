
Mainscene=class("Mainscene", function()
    return cc.Scene:create()
end)

Mainscene.panel = nil
local roomNumber
local chapterNumber

function Mainscene:ctor()

    if #PublicData.SAVEDATA==0 then
        local docpath = cc.FileUtils:getInstance():getWritablePath().."savedata.txt"
        print("文件是否存在",cc.FileUtils:getInstance():isFileExist(docpath),docpath)
        if cc.FileUtils:getInstance():isFileExist(docpath)==false then
            local str = json.encode(Data.SAVEDATA)
            ModifyData.writeToDoc(str,"savedata")
            PublicData.SAVEDATA = Data.SAVEDATA
            print("写文件")
        else
            print("读文件")
            local str = ModifyData.readFromDoc("savedata")
            PublicData.SAVEDATA = json.decode(str)
        end
    end

    self.savedata = PublicData.SAVEDATA

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
    self.panel = cc.CSLoader:createNode(Config.RES_MAINSCENE)
    self.panel:setPosition(cc.p(0,0))
    self:addChild(self.panel,4)

    --合成条
    self.merge = Merge:createScene()
    self:addChild(self.merge,5)
    
    UItool:setBool("yansemima", false) -- 颜色密码箱
    
    --主节点
    self.node =  self.panel:getChildByName("Node_left_bottom")
    self.node:setPosition(0, self.visibleSize.height)
    --背景
    self.bg = self.node:getChildByName("bg")
    self.bg:setPositionX(self.savedata.bgpositionx)
    local mainback = self.bg:getChildByName("back")
    mainback:addClickEventListener(function ()
        if UItool:getBool("effect") then
            AudioEngine.playEffect("gliss.mp3")
        end
        --返回loading
        local scene = Loading.new()
        local turn = cc.TransitionFade:create(1,scene)
        cc.Director:getInstance():replaceScene(turn)
        end)
    
    
    --点击效果层
    local dianjilayer = TouchLayer:new()
    self.bg:addChild(dianjilayer,128)

    -- local draw = cc.DrawNode:create()  
    -- -- local points = {cc.p(0,0), cc.p(0 + size, 0), cc.p(0 + size, 0 + size), cc.p(0, 0 + size)}  
    -- draw:drawDot(cc.p(self.bg:getPositionX(),150),50,cc.c4b(0,0,0,1))  
    -- -- draw:setTag("draw")  
    -- self:addChild(draw,100)  

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

    --家具
    self.furniture = self.bg:getChildByName("furniture")

    
    --合成条
    
    
    local function update(delta)  
        self:update(delta)  
        
        if UItool:getBool("pasitem") then
            --重新渲染合成界面
            self.merge:removeSelf()
            self.merge = Merge:createScene()
            self:addChild(self.merge,5)
            UItool:setBool("pasitem",false)
        end
    end  
    self:scheduleUpdateWithPriorityLua(update,0.3)

    

    self:init()
   
    
    
end

function Mainscene:init()
    self:touchpoint() --点击效果
    self:grossiniwalk()-- 人物动作

    self.scheduler = nil -- 定时器
    self.goscheduler = nil --过关定时器
    self.m_isAnimationing = nil 

    self:ontouch()
    self:AllButtons()

    self.runtime = nil 

    self:fishmove() --鱼的移动 

    
    local callbackEntry
    local function messageupdate(delta)  
        -- print("定时器作用")
        if UItool:getBool("message4")==false then

            self.jiantou = cc.Sprite:create("jiantou.png")
            self.jiantou:setScale(2)
            -- self.jiantou:setAnchorPoint(cc.p(0,0))
            self.jiantou:setPosition(cc.p(self.furniture:getChildByName("bed_down"):getPositionX()+40,self.furniture:getChildByName("bed_down"):getPositionY()+60))
            self.furniture:addChild(self.jiantou,5)

            local moveup = cc.OrbitCamera:create(1, 1, 0, 0, 360, 0, 0);
            local movedown = cc.RotateBy:create(0.5, 0)
            -- local sequencd = cc.Sequence:create(moveup,movedown)
            self.jiantou:runAction(cc.RepeatForever:create(moveup))

            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(callbackEntry)
        end
    end  

    callbackEntry = cc.Director:getInstance():getScheduler():scheduleScriptFunc(messageupdate, 1, false)

    
end


function Mainscene:update( delta )

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

function Mainscene:fishmove()  
    local function updateFunc(dt)  
        self:update(dt)  
    end  
end 

local bed_upnum = 1
function Mainscene:bed_up()
    --床上
    
    local bed_up_locationx ,bed_up_locationy = UItool:getitem_location(self.furniture:getChildByName("bed_up"), self.bg:getPositionX())
    self:Girl_bg_move(bed_up_locationx,bed_up_locationy ,function (  )

        self.layer=cc.Layer:create()
        local shildinglayer = ShieldingLayerpin:new()
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
        if bed_upnum==1 then
            print("有个盒子")
            UItool:message2(" “有个盒子，绳子太紧了，我解不开。需要什么东西把绳子割开。”  ",30)
            print("太紧了")
            self.furniture:getChildByName("bed_up"):setVisible(false)
            self.furniture:getChildByName("bed_up"):setTouchEnabled(false)
            local key_item = Data.getItemData(3)
            ModifyData.tableinsert(key_item.key)
            
            self.merge:removeSelf()
            print("解不开")
            self.merge = Merge:createScene()
            self:addChild(self.merge,5)
            bed_upnum=bed_upnum+1
            else
                UItool:message2(" “这是我的床。” ",30)
        end
    end)
end

local quiltnum = 1
function Mainscene:quilt()
    print("quilt")
        
        local quilt_locationx,quilt_locationy = UItool:getitem_location(self.furniture:getChildByName("quilt"), self.bg:getPositionX())

        self:Girl_bg_move( quilt_locationx,quilt_locationy ,function ()
            UItool:message2(" “我喜欢蓝色，它令我感到静谧舒适。”",30 )

        end)
end

local bed_downnum = 1
function Mainscene:bed_down()
    --床底
    local bed_down_locationx, bed_down_locationy= UItool:getitem_location(self.furniture:getChildByName("bed_down"), self.bg:getPositionX())

    self:Girl_bg_move(bed_down_locationx ,bed_down_locationy,function (  )
        self.layer=cc.Layer:create()
        local shildinglayer = ShieldingLayerpin:new()
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

        if bed_downnum==1 then
            
            UItool:message2(" “这里有把小锤子，可能会有用。” ",30)
            local key_item = Data.getItemData(14)
            ModifyData.tableinsert(key_item.key)
            self.merge:removeSelf()
            self.merge = Merge:createScene()
            self:addChild(self.merge,5)
            bed_downnum=bed_downnum+1
            self.bg:getChildByName("hammer_s"):setVisible(false)
            self.jiantou:setPosition(cc.p(100,90))
            else
                UItool:message2(" 什么也没有了。 ",30)
        end

    end)
end 

local bedside_tablenum= 1
function Mainscene:bedside_table()
    --床头柜
    print("bedside_table_btn")
        local bedside_table_locationx, bedside_table_locationy= UItool:getitem_location(self.furniture:getChildByName("bedside_table_btn"), self.bg:getPositionX())

        self:Girl_bg_move( math.floor(bedside_table_locationx+self.grossini:getContentSize().width/6),bedside_table_locationy ,function (  )
            self.layer=cc.Layer:create()
            local shildinglayer = ShieldingLayerpin:new()
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
            if bedside_tablenum==1 then
                
                if UItool:getBool("bedkey") then
                    bedside_tablenum= 1+ bedside_tablenum
                    UItool:message2(" “这是什么东西……一半剪刀？” ",30)

                    local key_item = Data.getItemData(12)
                    ModifyData.tableinsert(key_item.key)

                    UItool:setBool("bedkey",false)

                    local itemnum = UItool:getInteger("bedkeynum")
                    for i=1,#ModifyData.getTable() do
                        if ModifyData.getTable()[i] == itemnum then
                            table.remove(ModifyData.getTable(),i) 
                            break
                        end
                    end

                    self.merge:removeSelf()
                    self.merge = Merge:createScene()
                    self:addChild(self.merge,5)

                    self.furniture:getChildByName("bedside_table_s"):setTexture("changesprite/bedside_table2.png")

                else
                    UItool:message2(" 它锁住了。 ",30)
                end
                    
            end
            

        end)
end

local teaflowernum = 1
function Mainscene:teaflower()
    print("teaflower")
        
        local teaflower_locationx,teaflower_locationy = UItool:getitem_location(self.furniture:getChildByName("teaflower"), self.bg:getPositionX())

        self:Girl_bg_move( teaflower_locationx+self.grossini:getContentSize().width/6,teaflower_locationy ,function ()
            UItool:message2(" “我最喜欢的山茶花。”",30 )
            self.grossini:setScaleX(self.girlx)
            self.grossini:setScaleY(self.girly)

        end)
end

local bearnum = 1
function Mainscene:bear()
    --  熊 多次点击
    print("bear_btn")

    local bear_locationx, bear_locationy= UItool:getitem_location(self.furniture:getChildByName("bear_btn"), self.bg:getPositionX())
    print("xion位置",math.floor(bear_locationx-self.grossini:getContentSize().width/6))
    print("···人位置",math.floor(self.grossini:getPositionX()))

    self:Girl_bg_move(math.floor( bear_locationx)-math.floor(self.grossini:getContentSize().width/6),bear_locationy,function (  )

        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)

        if bearnum==1 then
            UItool:message2(" “我喜欢的小熊，但和它在一起的洋娃娃不见了。” ",30)
            bearnum = 1+bearnum 
            elseif bearnum==2 then

                bearnum = 1+bearnum 
                UItool:message2(" “小熊的身体里好像有什么东西，但是我要怎么取出来？ ”",30)
                elseif bearnum==3 then

                    if UItool:getBool("scissors") then
                        UItool:message2(" “门钥匙？为什么会在这里… ”",30)
                        local key_item = Data.getItemData(19)
                        ModifyData.tableinsert(key_item.key)
                        
                        -- local itemnum = UItool:getInteger("scissorsnum")
                        -- for i=1,#ModifyData.getTable() do
                        --     if ModifyData.getTable()[i] == itemnum then
                        --         table.remove(ModifyData.getTable(),i) 
                        --         break
                        --     end
                        -- end

                        self.furniture:getChildByName("bear"):setTexture("changesprite/bear2.png")
                        self.merge:removeSelf()
                        self.merge = Merge:createScene()
                        self:addChild(self.merge,5)
                        bearnum = 1+bearnum 
                        -- UItool:setBool("scissors",false) 
                        else
                            UItool:message2(" “小熊的身体里好像有什么东西，但是我要怎么取出来？”",30)

                    end
                    else
                        UItool:message2(" “对不起，小熊... ”",30)
        end
        
    end)
end

local lampnum = 1
function Mainscene:lamp()
    print("lamp")
        
        local lamp_locationx,lamp_locationy = UItool:getitem_location(self.furniture:getChildByName("lamp"), self.bg:getPositionX())

        self:Girl_bg_move( math.floor( lamp_locationx)-math.floor(self.grossini:getContentSize().width/6),lamp_locationy ,function ()
            UItool:message2(" 这是房间中最明亮的地方。",30 )
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)

        end)
end

local toilet_glassnum = 1
function Mainscene:toilet_glass()
    --梳妆台-镜子
    print("toilet_glass")
    local toilet_glass_locationx,toilet_glass_locationy = UItool:getitem_location(self.furniture:getChildByName("toilet_glass"), self.bg:getPositionX())
    
        self:Girl_bg_move(math.floor( toilet_glass_locationx-self.grossini:getContentSize().width/6),toilet_glass_locationy ,function (  )
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)
            if toilet_glassnum == 1 then
                -- 刚开始没碎第一次点击
                UItool:message4(" “梳妆台的镜子。”","“我能从里面看到桌子和凳子的倒影，但是看不见我自己。” "," “这让我觉得有点邪门。“","“我不想看见它，有没有什么办法可以让它从我眼前消失...” ",30)
                toilet_glassnum = toilet_glassnum + 1

                elseif toilet_glassnum == 2 then
                    --第二次点击
                    if UItool:getBool("hammer") then
                        local key_item = Data.getItemData(1)
                        ModifyData.tableinsert(key_item.key)
                        UItool:message4(" “镜子被砸碎了，碎片看起来很锋利。镜子里面写了四个数字。” "," “……奇怪的是，当我移开目光之后，就记不清上面究竟写了些什么……” ","“我需要把这段数字写下来。”",nil,30)
                        local itemnum = UItool:getInteger("hammernum")
                        for i=1,#ModifyData.getTable() do
                            if ModifyData.getTable()[i] == itemnum then
                                table.remove(ModifyData.getTable(),i) 
                                break
                            end
                        end
                        self.bg:getChildByName("dressing_table"):setTexture("changesprite/dressing_table2.png")
                        self.merge:removeSelf()
                        self.merge = Merge:createScene()
                        self:addChild(self.merge,5)
                        toilet_glassnum = toilet_glassnum + 1
                        UItool:setBool("hammer",false)
                        else
                            UItool:message2(" “我不想看见它…… ”",30)

                    end
                    elseif toilet_glassnum == 3 then
                        if UItool:getBool("paperpen") then
                            UItool:message2(" 获得了密码纸。 ",30)
                            local key_item = Data.getItemData(2)
                            ModifyData.tableinsert(key_item.key)
                            
                            local itemnum = UItool:getInteger("paperpennum")
                            for i=1,#ModifyData.getTable() do
                                if ModifyData.getTable()[i] == itemnum then
                                    table.remove(ModifyData.getTable(),i) 
                                    break
                                end
                            end

                            self.merge:removeSelf()
                            self.merge = Merge:createScene()
                            self:addChild(self.merge,5)
                            toilet_glassnum = toilet_glassnum + 1
                            UItool:setBool("paperpen",false)
                            
                            else
                                UItool:message2(" 你需要纸把它记录下来。 ",30)
                                
                        end

            end
            
            
        end)
end


local stoolnum = 1
function Mainscene:stool()
    --凳子
    print("stool")
    local stool_locationx,stool_locationy = UItool:getitem_location(self.furniture:getChildByName("stool"), self.bg:getPositionX())

        self:Girl_bg_move( stool_locationx,stool_locationy ,function (  )
            self.layer=cc.Layer:create()
            local shildinglayer = ShieldingLayerpin:new()
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
            if stoolnum==1 then
                UItool:message2(" “嘿……这凳子还挺轻的。”  ",30)
                local key_item = Data.getItemData(8)
                ModifyData.tableinsert(key_item.key)
                self.merge:removeSelf()
                self.merge = Merge:createScene()
                self:addChild(self.merge,5)
                self.furniture:getChildByName("stool"):setVisible(false)
                self.furniture:getChildByName("stool"):setTouchEnabled(false)
                stoolnum = stoolnum +1
                else
                    UItool:message2(" “嘿……凳子搬走了。” ",30)
            end
            

        end)
end

local wardrobenum=1
function Mainscene:wardrobe()
    --衣柜
    print("wardrobe")
    local wardrobe_locationx,wardrobe_locationy = UItool:getitem_location(self.furniture:getChildByName("wardrobe"), self.bg:getPositionX())

        self:Girl_bg_move( wardrobe_locationx,wardrobe_locationy ,function (  )
            if wardrobenum==1 then
                
                if UItool:getBool("key") then
                    UItool:message2(" “里面有个密码箱子。” ",30)
                    UItool:setBool("yansemima", true)
                    local itemnum = UItool:getInteger("keynum")
                    for i=1,#ModifyData.getTable() do
                        if ModifyData.getTable()[i] == itemnum then
                            table.remove(ModifyData.getTable(),i) 
                            break
                        end
                    end
                    self.furniture:getChildByName("yigui"):setTexture("changesprite/wardrobe2.png")
                    self.merge:removeSelf()
                    self.merge = Merge:createScene()
                    self:addChild(self.merge,5)
                    wardrobenum = wardrobenum + 1
                    UItool:setBool("key",false) 
                    else
                        UItool:message2(" 衣柜锁住了。",30)

                end

                elseif wardrobenum>=2 and Data.getItemData(5).ifcontain == true then
                    UItool:password("96514",5) -- 密码四
                    wardrobenum = wardrobenum + 1
                else
                    UItool:message2(" 已经空了。 ",30)
            end
    end)
end

local cushionnum = 0
function Mainscene:cushion()
    --靠垫
    print("cushion")
           
    local cushion_locationx,cushion_locationy = UItool:getitem_location(self.furniture:getChildByName("cushion"), self.bg:getPositionX())
   
    self:Girl_bg_move( math.floor(cushion_locationx-self.grossini:getContentSize().width/5),cushion_locationy ,function (  )

        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)

        self.layer=cc.Layer:create()
        local shildinglayer = ShieldingLayerpin:new()
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
        if cushionnum == 0 then
            self.furniture:getChildByName("cushion"):setPosition(cc.p(self.furniture:getChildByName("cushion"):getPositionX()+30,self.furniture:getChildByName("cushion"):getPositionY()-20))
            UItool:message2(" “这有把钥匙。” ",30)
            cushionnum = cushionnum+1
            elseif cushionnum == 1 then
                -- UItool:message2(" 衣柜钥匙 ",30)
                self.furniture:getChildByName("key"):removeSelf()
                local key_item = Data.getItemData(18)
                ModifyData.tableinsert(key_item.key)
                self.merge:removeSelf()
                self.merge = Merge:createScene()
                self:addChild(self.merge,5)
                cushionnum = cushionnum+1

            
        end
        
        
    end)
end


local B_vasenum = 1
function Mainscene:B_vase()
    --大花瓶
    print("B_vase")
    local B_vase_locationx,B_vase_locationy = UItool:getitem_location(self.furniture:getChildByName("B_vase"), self.bg:getPositionX())

    self:Girl_bg_move( math.floor(B_vase_locationx-self.grossini:getContentSize().width/6),B_vase_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if B_vasenum==1 then
                --todo
            if UItool:getBool("redbrush") then
                local key_item = Data.getItemData(16)
                ModifyData.tableinsert(key_item.key)

                UItool:message2("“刷成了红色，感觉好看了些，就是不知道为什么让我觉得有些恐怖。”",30)
                local itemnum = UItool:getInteger("redbrushnum")
                for i=1,#ModifyData.getTable() do
                    if ModifyData.getTable()[i] == itemnum then
                        table.remove(ModifyData.getTable(),i) 
                        break
                    end
                end

                local function movetophonescreen()
                    print("movetophone ")
                    local selfgrossini = self.grossini
                    self.layers=cc.Layer:create()
                    local shildinglayer = ShieldingLayerpin:new()
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
                local shildinglayer = ShieldingLayerpin:new()
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
                         UItool:message2("“电话响了，我是不是应该去接一下？”",30)
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

                self.furniture:getChildByName("redflower"):setTexture("changesprite/redflower2.png")
                
                self.merge:removeSelf()
                self.merge = Merge:createScene()
                self:addChild(self.merge,5)
                B_vasenum = B_vasenum + 1
                UItool:setBool("redbrush",false)
                else
                    UItool:message2(" 白色的插花。 ",30)
            end
            else
                UItool:message2(" “摘走了一些花朵，我不需要更多的花了。” ",30)

        end
        

    end)
end

local linglannum = 1
function Mainscene:linglan()
    print("linglan")
        
        local linglan_locationx,linglan_locationy = UItool:getitem_location(self.furniture:getChildByName("linglan"), self.bg:getPositionX())

        self:Girl_bg_move( math.floor(linglan_locationx-self.grossini:getContentSize().width/6),linglan_locationy ,function ()
            UItool:message2(" 枯萎掉的铃兰。",30 )
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)

        end)
end


local bookshelf_twonum = 1
function Mainscene:bookshelf_two()
    --书架二  多次点击
    print("bookshelf_two")
    
        local bookshelf_two_locationx,bookshelf_two_locationy = UItool:getitem_location(self.furniture:getChildByName("bookshelf_two"), self.bg:getPositionX())

        self:Girl_bg_move( math.floor(bookshelf_two_locationx-self.grossini:getContentSize().width/6),bookshelf_two_locationy ,function ()
            
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)
            local flower_item = Data.getItemData(16)
            if bookshelf_twonum == 1 and flower_item.use==false  then
               UItool:message2(" “书可真多啊 !”" , 30)
               bookshelf_twonum = bookshelf_twonum + 1
               elseif  bookshelf_twonum == 2 then
                bookshelf_twonum = bookshelf_twonum + 1
                UItool:message2("“我最喜欢的书也在上面。”" , 30)
                   elseif bookshelf_twonum == 3 then

                       bookshelf_twonum = bookshelf_twonum + 1
                       UItool:message2("“咦，有东西掉出来了。一串电话号码，是谁留下的呢？”" , 30)
                       local key_item = Data.getItemData(9)
                        ModifyData.tableinsert(key_item.key) 
                        
                        self.merge:removeSelf()
                        self.merge = Merge:createScene()
                        self:addChild(self.merge,5)

                        self.layer=cc.Layer:create()
                        local shildinglayer = ShieldingLayerpin:new()
                        self.layer:addChild(shildinglayer)
                        self.layer:addTo(self,125)

                        local layer =  self.layer
                        local timer = TimerExBuf()
                        timer:create(self.screenxiadun+0.3,1,1)
                        function timer:onTime()
                            -- UItool:message2("“一串电话号码 是谁留下的呢？”",30)
                            layer:removeFromParent()
                            timer:stop()
                        end
                        timer:start()

                        self.grossini:getAnimation():play("squat_1")--下蹲
                        -- UItool:setCurrentState("xiadun")

                        else
                            UItool:message2(" “书可真多啊 !” " , 30)
            end
            
    end)
        
    
    
end

local cupnum = 1
function Mainscene:cup()
    print("cup")
        
        local cup_locationx,cup_locationy = UItool:getitem_location(self.furniture:getChildByName("cup"), self.bg:getPositionX())

        self:Girl_bg_move( math.floor( cup_locationx-self.grossini:getContentSize().width/5),cup_locationy ,function ()
            UItool:message2(" “我最爱的茶杯。” ",30 )
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)
        end)
end



local booknum = 1
function Mainscene:book()
    --纸和笔
    print("book")
    local book_locationx,book_locationy = UItool:getitem_location(self.furniture:getChildByName("book"), self.bg:getPositionX())

    self:Girl_bg_move(math.floor( book_locationx-self.grossini:getContentSize().width/5),book_locationy ,function ()
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        
        self.layer=cc.Layer:create()
        local shildinglayer = ShieldingLayerpin:new()
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
        if booknum==1 then
            UItool:message2(" “ 我可以用它来抄一些东西。 ” ",30) 
            booknum = booknum+1
            local key_item = Data.getItemData(15)
            ModifyData.tableinsert(key_item.key) 
            self.merge:removeSelf()
            self.merge = Merge:createScene()
            self:addChild(self.merge,5)
            self.furniture:getChildByName("book"):setVisible(false)
            self.furniture:getChildByName("book"):setTouchEnabled(false)

        end
    end)
end


local wardrobe_drawer_2num = 1
function Mainscene:wardrobe_drawer_2()
    print("wardrobe_drawer_2")
    --立柜抽屉二层
        local wardrobe_drawer_2_locationx,wardrobe_drawer_2_locationy = UItool:getitem_location(self.furniture:getChildByName("wardrobe_drawer_2"), self.bg:getPositionX())

        self:Girl_bg_move(math.floor( wardrobe_drawer_2_locationx-self.grossini:getContentSize().width/6 ),wardrobe_drawer_2_locationy ,function ()
            self.layer=cc.Layer:create()
            local shildinglayer = ShieldingLayerpin:new()
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
            if wardrobe_drawer_2num==1 then

                if UItool:getBool("liguikey") then
                    UItool:message2(" “ 一把刷子，或许我可以用它来蘸一些有颜色的东西。” ",30) 
                    self.bg:getChildByName("ligui"):setTexture("changesprite/ligui2.png")
                    local key_item = Data.getItemData(6)
                    ModifyData.tableinsert(key_item.key)
                    
                    local itemnum = UItool:getInteger("liguikeynum")

                    for i=1,#ModifyData.getTable() do
                        if ModifyData.getTable()[i] == itemnum then
                            table.remove(ModifyData.getTable(),i) 
                            break
                        end
                    end
                    
                    self.merge:removeSelf()
                    self.merge = Merge:createScene()
                    self:addChild(self.merge,5)
                    wardrobe_drawer_2num = wardrobe_drawer_2num+1
                    UItool:setBool("liguikey",false)

                    

                    else
                        UItool:message2(" 抽屉上锁了。 ",30) 
                end
                
                else
                     UItool:message2(" 抽屉里面什么都没有了。  ",30) 
                    
            end
        end)
end

local liguiframenum = 1
function Mainscene:liguiframe()
    print("liguiframe")
    --立柜相册
        local liguiframe_locationx,liguiframe_locationy = UItool:getitem_location(self.furniture:getChildByName("liguiframe"), self.bg:getPositionX())
        self:Girl_bg_move(math.floor( liguiframe_locationx-self.grossini:getContentSize().width/6 ),liguiframe_locationy ,function ()
            print("liguiframe_locationy")
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)
            if liguiframenum==1 then
                if UItool:getBool("familyphoto") then
                    UItool:message2(" “看来这张照片原本应该是放在这的，有把小钥匙从相框的夹层里掉出来了。”  ",30)
                    self.furniture:getChildByName("frame_ligui"):setTexture("changesprite/frame1.png")
                    local key_item = Data.getItemData(23)
                    ModifyData.tableinsert(key_item.key)
                    
                    local itemnum = UItool:getInteger("familyphotonum")

                    for i=1,#ModifyData.getTable() do
                        if ModifyData.getTable()[i] == itemnum then
                            table.remove(ModifyData.getTable(),i) 
                            break
                        end
                    end
                    
                    self.merge:removeSelf()
                    self.merge = Merge:createScene()
                    self:addChild(self.merge,5)
                    liguiframenum = liguiframenum+1
                    UItool:setBool("familyphoto",false)
                    else
                        UItool:message2(" “相框是空的，或许里面原本应该有张照片？”   ",30)
                end
                
            else
                UItool:message2(" “这上面到底是谁呢？”  ",30)
        end

        end)
end


local phonenum = 1
function Mainscene:phone()
    print("phone")
        
        local phone_locationx,phone_locationy = UItool:getitem_location(self.furniture:getChildByName("phone"), self.bg:getPositionX())

        self:Girl_bg_move( math.floor(phone_locationx-self.grossini:getContentSize().width/7),phone_locationy ,function ()
            
            self.grossini:setScaleX(-self.girlx)
            self.grossini:setScaleY(self.girly)

            -- if UItool:ifcontain(16) or UItool:ifcontain(9) then
                if phonenum==1  then

                   if UItool:getBool("redflower") then
                        UItool:message2(" “很好，我们可以进行交换了。” ",30)
                        local key_item = Data.getItemData(17)
                        ModifyData.tableinsert(key_item.key)

                        local itemnum = UItool:getInteger("redflowernum")
                        Data.getItemData(itemnum).use = true
                        for i=1,#ModifyData.getTable() do
                            if ModifyData.getTable()[i] == itemnum then
                                table.remove(ModifyData.getTable(),i) 
                                break
                            end
                        end

                        local phonepapernum = UItool:getInteger("phonepapernum")
                        if phonepapernum then
                            for i=1,#ModifyData.getTable() do
                                if ModifyData.getTable()[i] == phonepapernum then
                                    table.remove(ModifyData.getTable(),i) 
                                    break
                                end
                            end
                        end
                        
                        self.merge:removeSelf()
                        self.merge = Merge:createScene()
                        self:addChild(self.merge,5)
                        phonenum = phonenum + 1
                        UItool:setBool("redflower",false)

                        elseif UItool:getBool("phonepaper") then
                            
                            UItool:message2(" “你喜欢花吗？我最喜欢了，尤其是红色的。” ",30)
                            
                            self.merge:removeSelf()
                            self.merge = Merge:createScene()
                            self:addChild(self.merge,5)
                            else
                                if UItool:ifcontain(16) then
                                    UItool:message2(" “你拿到我想要的东西了嘛 ？” ",30)
                                    else
                                        UItool:message2(" 一部电话。",30)
                                end
                                
                                
                    end

                    else
                        UItool:message2(" 嘟。。嘟。。嘟。。  ",30)


                end
            
            

        end)
end

function Mainscene:modify()

    local tb = PublicData.ROOMTABLE
    tb[chapterNumber][roomNumber+1].lock=0
    local str = json.encode(tb)
    ModifyData.writeToDoc(str,"room")
end

local doornum = 1
function Mainscene:door()
    print("door")
    --门
        local door_locationx,door_locationy = UItool:getitem_location(self.furniture:getChildByName("door"), self.bg:getPositionX())

        self:Girl_bg_move( door_locationx,door_locationy ,function ()
             if UItool:getBool("doorkey") then
                UItool:message2(" door open  ",30)
                local itemnum = UItool:getInteger("doorkeynum")
                for i=1,#ModifyData.getTable() do
                    if ModifyData.getTable()[i] == itemnum then
                        table.remove(ModifyData.getTable(),i) 
                        break
                    end
                end

                self.merge:removeSelf()
                self.merge = Merge:createScene()
                self:addChild(self.merge,5)
                doornum = doornum + 1
                 UItool:setBool("doorkey",false)

                 self.modify()
                else
                    UItool:message2(" “打不开……我需要找到钥匙。”  ",30)

                end
        end)

end

local Big_framenum = 1
function Mainscene:Big_frame()
    print("Big_frame")
        
        local Big_frame_locationx,Big_frame_locationy = UItool:getitem_location(self.furniture:getChildByName("Big_frame"), self.bg:getPositionX())

        self:Girl_bg_move( Big_frame_locationx,Big_frame_locationy ,function ()
            if Big_framenum==1 then
                if UItool:getBool("stamp") then

                    UItool:message2("“是我的护身符。” ",30)
                    local key_item = Data.getItemData(4)
                    ModifyData.tableinsert(key_item.key)
                    
                    local itemnum = UItool:getInteger("stampnum")
                    for i=1,#ModifyData.getTable() do
                        if ModifyData.getTable()[i] == itemnum then
                            table.remove(ModifyData.getTable(),i) 
                            break
                        end
                    end
                    self.furniture:getChildByName("Big_frame_s"):setTexture("changesprite/Big_frame2.png")
                    self.merge:removeSelf()
                    self.merge = Merge:createScene()
                    self:addChild(self.merge,5)
                    Big_framenum = Big_framenum + 1
                    UItool:setBool("stamp",false)
                    else
                        UItool:message2(" “这画下面有个圆形的凹槽，好像要用什么东西插进去才能打开。” ",30)

                end
            end
            
            

        end)
end

local hua_framenum = 1
function Mainscene:hua_frame()
    print("hua_frame")
        
        local hua_frame_locationx,hua_frame_locationy = UItool:getitem_location(self.furniture:getChildByName("hua_frame"), self.bg:getPositionX())

        self:Girl_bg_move( hua_frame_locationx,hua_frame_locationy ,function ()
            if UItool:getBool("yansemima") then
                UItool:message2(" “这幅画上的花是粉颜色，有6朵。” ",30 )
                else
                    UItool:message2(" 画上有好多花。 ",30 )
            end
        
        end)
end

local frame_5num = 1
function Mainscene:frame_5()
    print("frame_5")
        
        local frame_5_locationx,frame_5_locationy = UItool:getitem_location(self.furniture:getChildByName("frame_5"), self.bg:getPositionX())

        self:Girl_bg_move( frame_5_locationx,frame_5_locationy ,function ()
            if frame_5num==1 then

                UItool:message3(" “咦，画的后面似乎有什么东西。 ” ","“是一张全家福，但没有我…… ”",30)
                local key_item = Data.getItemData(22)
                ModifyData.tableinsert(key_item.key)
                self.merge:removeSelf()
                self.merge = Merge:createScene()
                self:addChild(self.merge,5)
                frame_5num=frame_5num+1

            else
                UItool:message2(" 一张小照片。 ",30)
        end
        
        end)
end

local fang_framenum = 1
function Mainscene:fang_frame()
    print("fang_frame")
        
        local fang_frame_locationx,fang_frame_locationy = UItool:getitem_location(self.furniture:getChildByName("fang_frame"), self.bg:getPositionX())

        self:Girl_bg_move( fang_frame_locationx,fang_frame_locationy ,function ()
            if UItool:getBool("yansemima") then
                UItool:message2(" “这幅画上的花是蓝颜色，有5朵。” ",30 )
                else
                    UItool:message2(" 画上有好多花。 ",30 )
            end
        end)
end

local yuan_framenum = 1
function Mainscene:yuan_frame()
    print("yuan_frame")
        
        local yuan_frame_locationx,yuan_frame_locationy = UItool:getitem_location(self.furniture:getChildByName("yuan_frame"), self.bg:getPositionX())

        self:Girl_bg_move( yuan_frame_locationx,yuan_frame_locationy ,function ()

        if UItool:getBool("yansemima") then
                UItool:message2(" “这幅画上的花是白颜色，有9朵。”",30 )
                else
                    UItool:message2(" 画上有好多花。 ",30 )
            end
        end)
end

local frame_1num = 1
function Mainscene:frame_1()
    print("frame_1")
        
        local frame_locationx,frame_locationy = UItool:getitem_location(self.furniture:getChildByName("frame_1"), self.bg:getPositionX())

        self:Girl_bg_move( frame_locationx,frame_locationy ,function ()
            if UItool:getBool("yansemima") then
                UItool:message2(" “这幅画上的花是黄颜色，有4朵。” ",30 )
                else
                    UItool:message2(" 画上有好多花。 ",30 )
            end
        end)
end

local bigframenum = 1
function Mainscene:bigframe()
    print("bigframe")
        
        local bigframe_locationx,bigframe_locationy = UItool:getitem_location(self.furniture:getChildByName("bigframe"), self.bg:getPositionX())

        self:Girl_bg_move( bigframe_locationx,bigframe_locationy ,function ()
            if UItool:getBool("yansemima") then
                UItool:message2(" “这幅画里的我拿了一朵紫色的花——那是我最喜欢的颜色。” ",30 )
                else
                    UItool:message2(" 画上有好多花。 ",30 )
            end
        end)
end

local wardrobe_topnum = 1
function Mainscene:wardrobe_top()
    --衣柜顶
    print("wardrobe_top")
        
        local yuan_frame_locationx,yuan_frame_locationy = UItool:getitem_location(self.furniture:getChildByName("wardrobe_top"), self.bg:getPositionX())

        self:Girl_bg_move( yuan_frame_locationx,yuan_frame_locationy ,function ()
        if wardrobe_topnum==1 then
            if UItool:getBool("stool") then
                UItool:message2(" “我从衣柜顶上拿到了一个密码盒子。”",30)
                local key_item = Data.getItemData(10)
                ModifyData.tableinsert(key_item.key)
                
                local itemnum = UItool:getInteger("stoolnum")
                for i=1,#ModifyData.getTable() do
                    if ModifyData.getTable()[i] == itemnum then
                        table.remove(ModifyData.getTable(),i) 
                        break
                    end
                end
                self.furniture:getChildByName("wardrobe_top"):setTouchEnabled(false)
                self.furniture:getChildByName("wardrobe_top"):setVisible(false)
                self.merge:removeSelf()
                self.merge = Merge:createScene()
                self:addChild(self.merge,5)
                wardrobe_topnum = wardrobe_topnum+1
                UItool:setBool("stool",false)
                else
                    UItool:message2(" “太高了我够不到！” ",30)
            end

            else
                UItool:message2(" ”太高了我够不到！” ",30)
        end
        

        end)
end



function Mainscene:AllButtons(  )
    self.AllButtons = 
    {  
        self.furniture:getChildByName("bed_up"),
        self.furniture:getChildByName("bed_down"),
        self.furniture:getChildByName("toilet_glass"),
        self.furniture:getChildByName("bedside_table_btn"),
        self.furniture:getChildByName("stool"),
        self.furniture:getChildByName("wardrobe"),
        self.furniture:getChildByName("cushion"),
        self.furniture:getChildByName("B_vase"),
        self.furniture:getChildByName("bookshelf_two"),
        self.furniture:getChildByName("book"),
        self.furniture:getChildByName("wardrobe_drawer_2"),
        self.furniture:getChildByName("phone"),
        self.furniture:getChildByName("door"),
        self.furniture:getChildByName("Big_frame"),
        self.furniture:getChildByName("hua_frame"),
        self.furniture:getChildByName("yuan_frame"),
        self.furniture:getChildByName("fang_frame"),
        self.furniture:getChildByName("wardrobe_top"),
        self.furniture:getChildByName("frame_1"),
        self.furniture:getChildByName("bear_btn"),
        self.furniture:getChildByName("bigframe"),
        self.furniture:getChildByName("frame_5"),
        self.furniture:getChildByName("liguiframe"),

        self.furniture:getChildByName("teaflower"),
        self.furniture:getChildByName("quilt"),
        self.furniture:getChildByName("cup"),
        self.furniture:getChildByName("linglan"),
        self.furniture:getChildByName("lamp")


    }
    local function renwu_haoyou_shezhiButtonClick(event,eventType)
        if eventType == TOUCH_EVENT_ENDED then
            AudioEngine.playEffect("gliss.mp3")
            if event:getName()=="bed_up" then
                print("bed_up")
                self:bed_up()
                elseif event:getName()=="bed_down" then
                    print("bed_down")
                    self:bed_down()
                    elseif event:getName()=="toilet_glass" then
                        print("toilet_glass")
                        self:toilet_glass()
                        elseif event:getName()=="bedside_table_btn" then
                            print("bedside_table_btn")
                            self:bedside_table()
                            elseif event:getName()=="stool" then
                                print("stool")
                                self:stool()
                                elseif event:getName()=="wardrobe" then
                                    print("wardrobe")
                                    self:wardrobe()
                                    elseif event:getName()=="cushion" then
                                        print("cushion")
                                        self:cushion()
                                        elseif event:getName()=="B_vase" then
                                            print("B_vase")
                                            self:B_vase()
                                            elseif event:getName()=="bookshelf_two" then
                                                print("··bookshelf_two·")
                                                self:bookshelf_two()
                                                elseif event:getName()=="book" then
                                                    print("book")
                                                    self:book()
                                                    elseif event:getName()=="wardrobe_drawer_2" then
                                                        print("·wardrobe_drawer_2··")
                                                        self:wardrobe_drawer_2()
                                                        elseif event:getName()=="phone" then
                                                            print("··phone·")
                                                            self:phone()
                                                            elseif event:getName()=="door" then
                                                                print("··door·")
                                                                self:door()
                                                                elseif event:getName()=="Big_frame" then
                                                                    print("··Big_frame·")
                                                                    self:Big_frame()
                                                                    elseif event:getName()=="hua_frame" then
                                                                        print("·hua_frame··")
                                                                        self:hua_frame()
                                                                        elseif event:getName()=="yuan_frame" then
                                                                            print("yuan_frame")
                                                                            self:yuan_frame()
                                                                            elseif event:getName()=="fang_frame" then
                                                                                print("fang_frame")
                                                                                self:fang_frame()
                                                                                elseif event:getName()=="wardrobe_top" then
                                                                                    print("wardrobe_top")
                                                                                    self:wardrobe_top()
                                                                                    elseif event:getName()=="frame_1" then
                                                                                        print("frame_1")
                                                                                        self:frame_1()
                                                                                        elseif event:getName()=="bear_btn" then
                                                                                            print("bear")
                                                                                            self:bear()
                                                                                            elseif event:getName()=="bigframe" then
                                                                                                print("bigframe")
                                                                                                self:bigframe()
                                                                                                elseif event:getName()=="liguiframe" then
                                                                                                    print("liguiframe")
                                                                                                    self:liguiframe()
                                                                                                    elseif event:getName()=="frame_5" then
                                                                                                        print("frame_5")
                                                                                                        self:frame_5()
                                                                                                        elseif event:getName()=="teaflower" then
                                                                                                            print("teaflower")
                                                                                                            self:teaflower()
                                                                                                            elseif event:getName()=="quilt" then
                                                                                                                print("quilt")
                                                                                                                self:quilt()
                                                                                                                elseif event:getName()=="lamp" then
                                                                                                                    print("lamp")
                                                                                                                    self:lamp()
                                                                                                                    elseif event:getName()=="cup" then
                                                                                                                        print("cup")
                                                                                                                        self:cup()
                                                                                                                        elseif event:getName()=="linglan" then
                                                                                                                            print("linglan")
                                                                                                                            self:linglan()
                                                                                                            
                                                                                                                 
            end
        end
    end
    for key, var in pairs(self.AllButtons) do
        if self.grossini:getNumberOfRunningActions()>0 or self.bg:getNumberOfRunningActions()>0 then
            else
                var:addClickEventListener(renwu_haoyou_shezhiButtonClick)
                -- var:setSwallowTouches(false)

        end
    end
end

    --角色移动
function Mainscene:grossiniwalk()
    --骨骼动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/loli/Export/loli/loli.ExportJson") 
    self.grossini = ccs.Armature:create("loli")
    self.grossini:setScaleX(-self.girlx)
    self.grossini:setScaleY(self.girly)
    
    self.grossini:getAnimation():playWithIndex(1)
    -- self.grossini:getAnimation():setSpeedScale(1.1)
    self.grossini:getAnimation():play("stand")
     UItool:setCurrentState("stand")
     print("人物的位置",self.savedata.girlpositionx)
    self.grossini:setPosition(cc.p(self.savedata.girlpositionx,140))
    self:addChild(self.grossini,6)
end

function Mainscene:touchpoint()
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/dianji/Export/dianji/dianji.ExportJson") 
    self.dianji = ccs.Armature:create("dianji")
    self.dianji:getAnimation():playWithIndex(0,-1,-1)
    self.dianji:setPosition(cc.p(-200,-200))
    self.bg:addChild(self.dianji)
end

function Mainscene:ontouch( ... )
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

function Mainscene:Girl_bg_move(X, Y,event)

    --点击位置
        local apoint = X
        local gril_pointx = self.grossini:getPositionX()
        local delta =  X - gril_pointx

        -- 继续点击的时候是否连续
        if self.grossini:getScaleX()>0  and X < gril_pointx then
            -- print("self.grossini:getScaleX() > 0 , 脸是左朝向 点击左边")
            if self.grossini:getNumberOfRunningActions()>0  then
                self.grossini:stopAction(self.sequence)
                self.bg:stopAction(self.bgsequence)
            else
                self.grossini:getAnimation():play("walk")
                
            end

            elseif self.grossini:getScaleX() > 0  and X > gril_pointx then
                -- print("self.grossini:getScaleX() > 0 ，脸是左朝向  点击右边")
                if self.grossini:getNumberOfRunningActions()>0  then
                    self.grossini:stopAction(self.sequence)
                    self.bg:stopAction(self.bgsequence)
                else
                    self.grossini:getAnimation():play("walk")
                    
                end

                elseif self.grossini:getScaleX() < 0  and X > gril_pointx then
                    -- print("self.grossini:getScaleX() < 0 ，脸是右朝向  点击右边")
                    if self.grossini:getNumberOfRunningActions()>0  then
                        self.grossini:stopAction(self.sequence)
                        self.bg:stopAction(self.bgsequence)
                    else
                        self.grossini:getAnimation():play("walk")
                    end

                    elseif self.grossini:getScaleX() < 0  and X < gril_pointx then
                        
                        if self.grossini:getNumberOfRunningActions()>0  then
                            self.grossini:stopAction(self.sequence)
                            self.bg:stopAction(self.bgsequence)
                        else
                            
                            self.grossini:getAnimation():play("walk")
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
            
            self.grossini:getAnimation():play("stand")
            event = event or nil 
            if event ~= nil  then
                event()
                
                else
                    
                    
            end

            local girlpositionx = self.grossini:getPositionX()
            local bgpositionx = self.bg:getPositionX()
            print("背景坐标",bgpositionx,self.bg:getPositionX())
            local tb = PublicData.SAVEDATA
            tb.girlpositionx=girlpositionx
            tb.bgpositionx=bgpositionx
            local str = json.encode(tb)
            ModifyData.writeToDoc(str,"savedata")

        end

        if apoint<self.visibleSize.width/2 then
            --点击在左边的时候
            -- print("l点击在左边的时候")
            if self.grossini:getPositionX()<self.visibleSize.width/2 then
                --人物在左边的时候
                -- print("l人物在左边的时候")
                if self.bg:getPositionX()==0 then
                    -- print("l地图在原点")
                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                    self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
                    
                end
                
                elseif self.grossini:getPositionX()>self.visibleSize.width/2 then
                    --人物在右边的时候
                    -- print("l人物在右边的时候")

                    self.bgmove=cc.MoveBy:create( math.abs(self.time4), cc.p(-x,self.bg:getPositionY()))
                    local delaybg = cc.DelayTime:create(math.abs(self.time1))
                    self.bgsequence = cc.Sequence:create(delaybg,self.bgmove)
                    self.bg:runAction(self.bgsequence)

                    local delaygirl = cc.DelayTime:create(math.abs(self.time4))
                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time1), cc.p(self.visibleSize.width/2 ,self.grossini:getPositionY()))
                    self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,delaygirl,cc.CallFunc:create(threestep))

                    elseif self.grossini:getPositionX()==self.visibleSize.width/2 then
                        --人物在中间的时候
                        -- print("l人物在中间的时候")
                        if self.bg:getPositionX()<0  then
                            
                            if self.bg:getPositionX()<delta  then
                                -- print("l地图小于")
                                print("点击在左边 ，背景向右走")
                                self.bgmove=cc.MoveBy:create( math.abs(self.time), cc.p(-delta,self.bg:getPositionY()))
                                self.bgsequence = cc.Sequence:create(self.bgmove)
                                self.bg:runAction(self.bgsequence)
                                else
                                    -- print("l地图大于")
                                    print("点击在左边 ，背景走到最右")
                                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time6), cc.p( apoint - self.bg:getPositionX(),self.grossini:getPositionY()))
                                    self.bgmove=cc.MoveTo:create( math.abs(self.time2), cc.p(0,self.bg:getPositionY()))
                                    self.bgsequence = cc.Sequence:create(self.bgmove)
                                    self.bg:runAction(self.bgsequence)
                            end
                            elseif self.bg:getPositionX()==0 then
                                self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                        end
            end

            elseif apoint>self.visibleSize.width/2 then
                --点击在右边的时候
                -- print("r点击在右边的时候")
                if self.grossini:getPositionX()<self.visibleSize.width/2 then
                    --人物在左边的时候
                    -- print("r人物在左边的时候")
                    if self.bg:getPositionX()==0 then
                        -- print("r地图在原点")
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
                        -- print("r人物在右边的时候")
                        self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))

                         elseif self.grossini:getPositionX()==self.visibleSize.width/2 then
                            -- print("r人物在中间的时候")
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
                                    -- print("r画面在最左的时候")
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
                        print("人物在中间，点击在右边，背景向左走")
                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                        
                        else
                            print("人物在中间，点击在右边，背景走到最左")
                            self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay3,self.girlmoveto,cc.CallFunc:create(threestep))
                            
                    end
                    else

                        if self.bg:getPositionX()<delta then
                            print("********")
                            self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                            
                            else
                                print("&&&&&&&&")
                                self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay2,self.girlmoveto,cc.CallFunc:create(threestep))
                        end
                end
                else
            end

            else

                -- 人物不在中间
                
                
                -- print("停顿时间",self.tingdun)
                
        end
        self.grossini:runAction(self.sequence)
end





return Mainscene

















