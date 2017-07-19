
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
            local str = json.encode(Data.FURNITURE13)
            ModifyData.writeToDoc(str,"furniture")
            
            PublicData.FURNITURE = UItool:deepcopy(Data.FURNITURE13)
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
    self.panel = cc.CSLoader:createNode(Config.RES_GAMESCENE13)
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
    self:addChild(self.grossini,6)

    self.bg:setPositionX(self.savedata.bgpositionx)
    self.grossini:setPosition(cc.p(self.savedata.girlpositionx,143))

    local function update(delta)  
        -- self:update(delta)  
        
        if UItool:getBool("pasitem") then
            --重新渲染合成界面
            UItool:setBool("pasitem",false)

            self:megerupdate()
            
        end
    end  
    self:scheduleUpdateWithPriorityLua(update,0.3)


end

function GameScene13:xiadun()
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

function GameScene13:wanyao()
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

function GameScene13:megerupdate()
    self.merge:removeSelf()
    self.merge = Merge:createScene()
    self:addChild(self.merge,5)
end


function GameScene13:init()
    self:ontouch()
    
    self:AllButtons()
end

-- 洗手池柜子
function  GameScene13:wash_cabinet( )
    local x,y = UItool:getitem_location(self.furniture:getChildByName("wash_cabinet"), self.bg:getPositionX())
    GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[11].num==1 then
            self.furnituretb[11].ifchangesprite = true
            self.furniture:getChildByName("handswash_1"):setTexture("changesprite/GameScene13/handswash_5.png")
            self.furniture:getChildByName("qingjieji"):setVisible(true)
            self.furnituretb[11].num=self.furnituretb[11].num+1
            self.furnituretb[11].appear = true
            elseif self.furnituretb[11].num==2 then
                self.furniture:getChildByName("qingjieji"):setVisible(false)
                self.furnituretb[11].appear = false
                local key_item = Data.getItemData(63)
                table.insert(PublicData.MERGEITEM, key_item.key)
                self.furnituretb[11].num=self.furnituretb[11].num+1
                UItool:message2("一瓶清洁剂",30)
                
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        end,self.grossini,self.bg)
end

--水龙头
local touchnum=1
function  GameScene13:tap( )
    local x,y = UItool:getitem_location(self.furniture:getChildByName("tap"), self.bg:getPositionX())
    GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[19].num==1 then
            UItool:message2("里面好像堵住了，不过还有些红色的液体渗了出来。不，这好像是，血……我的天啊……",30)
            self.furnituretb[19].num=self.furnituretb[19].num+1
            elseif self.furnituretb[19].num==2 then
                print("点击水龙头次数",touchnum )
                if touchnum%2==1 then
                    print("开启水龙头")
                    

                    if self.furnituretb[15].weiniang  then
                        print("滴水")
                        if UItool:getBool("pliers") then
                            UItool:message2(" 呀——！水龙头掉了，里面有一条项链，总之赶紧离开这里吧，我不想被溅一身的水……",30)
                            local key_item = Data.getItemData(80)
                            table.insert(PublicData.MERGEITEM, key_item.key)
                            UItool:setBool("pliers",false)
                            local itemnum = UItool:getInteger("pliersnum")
                            for i=1,#PublicData.MERGEITEM do
                                if PublicData.MERGEITEM[i] == itemnum then
                                    table.remove(PublicData.MERGEITEM,i) 
                                    break
                                end
                            end
                            self.furnituretb[19].num=self.furnituretb[19].num+1
                            else
                                UItool:message2(" 血迹不见了，但堵在里面的东西似乎还在。 ",30)     
                        end
                        else
                            print("滴血")
                    end

                    elseif touchnum%2==0 then
                        print("关闭水龙头")
                        if UItool:getBool("zhenguan") then
                            UItool:message2(" 用针管抽了一管血……希望能派得上用场……",30)
                            local key_item = Data.getItemData(75)
                            table.insert(PublicData.MERGEITEM, key_item.key)
                            UItool:setBool("zhenguan",false)
                            local itemnum = UItool:getInteger("zhenguannum")
                            for i=1,#PublicData.MERGEITEM do
                                if PublicData.MERGEITEM[i] == itemnum then
                                    table.remove(PublicData.MERGEITEM,i) 
                                    break
                                end
                            end

                            else
                                UItool:message2(" 它被堵住了，还在向外渗血…… ",30)     
                        end
                end
                touchnum=touchnum+1
                else
                     UItool:message2(" 它还在喷水，我不想再被弄湿了…… ",30)     
                
                
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        end,self.grossini,self.bg)
end

--洋装
function  GameScene13:dress( )
    local x,y = UItool:getitem_location(self.furniture:getChildByName("dress"), self.bg:getPositionX())
    GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[1].num==1 then
                UItool:message2(" 这件衣服和我身上穿着的洋装一模一样！不过湿淋淋的，被水浸透了。",30)
                self.furnituretb[1].num=self.furnituretb[1].num+1
            elseif self.furnituretb[1].num==2 then
                local key_item = Data.getItemData(51)
                table.insert(PublicData.MERGEITEM, key_item.key)
                self.furnituretb[1].num=self.furnituretb[1].num+1
                UItool:message2("衣服的兜里有一把钥匙，不知道是哪里的。",30)
                else
                    UItool:message2("和我的洋装一模一样的一件湿裙子。",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        end,self.grossini,self.bg)
end

--条款
function  GameScene13:clause_btn( )
    local x,y = UItool:getitem_location(self.furniture:getChildByName("clause_btn"), self.bg:getPositionX())
    GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
            if self.furnituretb[2].num==1 then
                UItool:message2("装裱着医院条例的相框。",30)
                self.furnituretb[2].num=1 + self.furnituretb[2].num
                elseif self.furnituretb[2].num==2 then
                    UItool:message2("相框后面竟然有个箱子？",30)
                    self.furniture:getChildByName("clause"):setVisible(false)
                    self.furnituretb[2].num=1 + self.furnituretb[2].num
                    elseif self.furnituretb[2].num==3 then
                        self.furnituretb[2].num=1 + self.furnituretb[2].num
                        UItool:message2("（显示大图）是个保险箱。箱子上有文字的密码和一个凹槽，看来需要密码和某个符合凹槽的物品一起才能打开。",30)
                        elseif self.furnituretb[2].num==4 then
                            if UItool:getBool("passpad") then
                                UItool:message2(" 还需要符合凹槽的物品才能打开。",30)
                                self.furnituretb[2].passpad=true
                                UItool:setBool("passpad",false)
                                local itemnum = UItool:getInteger("passpadnum")
                                for i=1,#PublicData.MERGEITEM do
                                    if PublicData.MERGEITEM[i] == itemnum then
                                        table.remove(PublicData.MERGEITEM,i) 
                                        break
                                    end
                                end
                                
                                elseif UItool:getBool("xianglian") then
                                    UItool:setBool("xianglian",false)
                                    local itemnum = UItool:getInteger("xiangliannum")
                                    for i=1,#PublicData.MERGEITEM do
                                        if PublicData.MERGEITEM[i] == itemnum then
                                            table.remove(PublicData.MERGEITEM,i) 
                                            break
                                        end
                                    end
                                    if self.furnituretb[2].passpad==true then
                                        local key_item = Data.getItemData(71)
                                        table.insert(PublicData.MERGEITEM, key_item.key)
                                        UItool:message2(" 箱子开了……里面是一片碎纸，和我手上的这几片很相似。 ",30)    
                                        self.furnituretb[2].num = self.furnituretb[2].num + 1
                                    end
                                    else
                                        UItool:message2("这个结实的保险箱需要密码和某个符合凹槽的物品一起才能打开。",30)
                            end
                            
                                
            end
            local str = json.encode(self.furnituretb)
            ModifyData.writeToDoc(str,"furniture")
            self:megerupdate()
        end,self.grossini,self.bg)
end

--书桌上的点滴瓶
function GameScene13:infusion_bottle( )
    print("点滴瓶")
    local x1,y1 = UItool:getitem_location(self.furniture:getChildByName("infusion_bottle"), self.bg:getPositionX())
    GameScenemove( math.floor( x1-self.grossini:getContentSize().width/6),y1 ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[5].num==1 then
            local key_item = Data.getItemData(52)
            table.insert(PublicData.MERGEITEM, key_item.key)
            self.furnituretb[5].num=self.furnituretb[5].num+1
            self.furnituretb[5].bool = false
            UItool:message2("拿到了一个瓶子，好像是输液用的。",30)
            self.furniture:getChildByName("infusion_bottle"):setVisible(false)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        end,self.grossini,self.bg)
end

--书桌下的工具箱
function GameScene13:tool_box()
    print("工具箱")
    print("位置",self.furniture:getChildByName("tool_box"):getPositionX())
    local x2,y2 = UItool:getitem_location(self.furniture:getChildByName("tool_box"), self.bg:getPositionX())
    GameScenemove( math.floor( x2-self.grossini:getContentSize().width/6),y2 ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[4].num==1 then
            local key_item = Data.getItemData(53)
            table.insert(PublicData.MERGEITEM, key_item.key)

            local key_items = Data.getItemData(54)
            table.insert(PublicData.MERGEITEM, key_items.key)

            self.furnituretb[4].num=self.furnituretb[4].num+1
            UItool:message2("发现了一把钥匙和一个圆圆的把手，应该会用得上。",30)
            self.furnituretb[4].ifchangesprite = true
            self.furniture:getChildByName("tool_box_c"):setTexture("changesprite/GameScene13/tool_box_o.png")
            else
                UItool:message2("没有东西了。",30)

        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        end,self.grossini,self.bg)
end

--书桌又抽屉
function GameScene13:drawer_right( )
    local x,y= UItool:getitem_location(self.furniture:getChildByName("drawer_right"), self.bg:getPositionX())
        GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function ()

        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[3].num==1 then
            if UItool:getBool("table_key") then
                UItool:message2(" 抽屉开了，但是里面只有一根导管而已。",30)
                local key_item = Data.getItemData(55)
                table.insert(PublicData.MERGEITEM, key_item.key)
                UItool:setBool("table_key",false)
                local itemnum = UItool:getInteger("table_keynum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                self.furniture:getChildByName("table_c"):setTexture("changesprite/GameScene13/table_o.png")
                self.furnituretb[3].num = self.furnituretb[3].num+1
                self.furnituretb[3].ifchangesprite = true
                else
                    UItool:message2(" 这个抽屉被上了锁。 ",30)     
            end
            else
                UItool:message2(" 抽屉已经空了。 ",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)
end
--工具车
function GameScene13:tool_car( )
     local x1,y1 = UItool:getitem_location(self.furniture:getChildByName("tool_car"), self.bg:getPositionX())
    GameScenemove( math.floor( x1-self.grossini:getContentSize().width/6),y1 ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[6].num==1 then
            local key_item = Data.getItemData(56)
            table.insert(PublicData.MERGEITEM, key_item.key)
            self.furnituretb[6].num=self.furnituretb[6].num+1
            UItool:message2("这是什么？看起来像是安在什么地方的按钮。",30)
            
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        end,self.grossini,self.bg)
end

--左边玻璃柜
function  GameScene13:glass_btn_L( )
    local x,y = UItool:getitem_location(self.furniture:getChildByName("glass_btn_L"), self.bg:getPositionX())
    GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[14].num==1 then
            if UItool:getBool("handle") then
                self.furniture:getChildByName("Node_2"):getChildByName("glass"):setTexture("changesprite/GameScene13/glass_2.png")
                UItool:setBool("handle",false)
                UItool:message2(" 柜子的左半边可以打开了，但是右半边还是需要钥匙才能打开. ",30)     
                local itemnum = UItool:getInteger("handlenum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                
                self.furnituretb[14].num = self.furnituretb[14].num+1
                
                else
                    UItool:message2(" 一个装着心脏的标本瓶……看起来好诡异啊…… ",30)     
            end
            elseif self.furnituretb[14].num==2 then
                
                self.furnituretb[14].num=self.furnituretb[14].num+1
                self.furniture:getChildByName("Node_2"):getChildByName("glass"):setTexture("changesprite/GameScene13/glass_3.png")
                elseif self.furnituretb[14].num==3 then
                    self.furnituretb[14].num = self.furnituretb[14].num+1
                    local key_item = Data.getItemData(67)
                    self.furniture:getChildByName("Node_2"):getChildByName("glass"):setTexture("changesprite/GameScene13/glass_4.png")
                    table.insert(PublicData.MERGEITEM, key_item.key)
                    UItool:message2("一个装着心脏的标本瓶……看起来好诡异啊……",30)
                    else
                        UItool:message2("剩下的东西都没什么用了的样子。",30)
            
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        end,self.grossini,self.bg)
end

--右边玻璃柜
function  GameScene13:glass_btn_R( )
    local x,y = UItool:getitem_location(self.furniture:getChildByName("glass_btn_R"), self.bg:getPositionX())
    GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[15].num==1 then
            if UItool:getBool("glass_key") then
                self.furniture:getChildByName("Node_2"):getChildByName("glass"):setTexture("changesprite/GameScene13/glass_5.png")
                UItool:setBool("glass_key",false)
                UItool:message2(" 打开了右半边的锁。. ",30)     
                local itemnum = UItool:getInteger("glass_keynum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                
                self.furnituretb[15].num = self.furnituretb[15].num+1
                
                else
                    UItool:message2(" 右半边被锁住了。 ",30)     
            end
            elseif self.furnituretb[15].num==2 then
                self.furnituretb[15].num = self.furnituretb[15].num+1

                local key_item = Data.getItemData(70)
                self.furniture:getChildByName("Node_2"):getChildByName("glass"):setTexture("changesprite/GameScene13/glass_6.png")
                table.insert(PublicData.MERGEITEM, key_item.key)
                self.furnituretb[15].weiniang = true
                self.furniture:getChildByName("machine_1"):setTexture("changesprite/GameScene13/machine_2.png")
                UItool:message2("又是一个标本瓶！里面装着一缕金色的头发。",30)
                else
                    -- UItool:message2("剩下的东西都没什么用了的样子。",30)
            
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        end,self.grossini,self.bg)
end

--档案柜
function  GameScene13:file_cabinet( )
    local x,y = UItool:getitem_location(self.furniture:getChildByName("files_btn"), self.bg:getPositionX())
    GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[7].num==1 then
            if UItool:getBool("files_key") then
                UItool:message2(" 打开了柜子。",30)
                
                UItool:setBool("files_key",false)

                local itemnum = UItool:getInteger("files_keynum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                self.furniture:getChildByName("Node_2"):getChildByName("files_cabinet"):setTexture("changesprite/GameScene13/files_cabinet_3.png")
                self.furnituretb[7].num = self.furnituretb[7].num+1
                
                else
                    UItool:message2(" 果然，这里也上了锁…… ",30)     
            end

            elseif self.furnituretb[7].num==2 then
                local key_item = Data.getItemData(58)
                table.insert(PublicData.MERGEITEM, key_item.key)

                local key_items = Data.getItemData(59)
                table.insert(PublicData.MERGEITEM, key_items.key)
                UItool:message2(" 唔，好像是一张胸部的CT相片，还有一块不知道有什么用的碎纸。 ",30)  
                self.furniture:getChildByName("Node_2"):getChildByName("files_cabinet"):setTexture("changesprite/GameScene13/files_cabinet_2.png")   
                self.furnituretb[7].num = self.furnituretb[7].num+1
                else
                    UItool:message2(" 没剩下什么东西了。 ",30)     

        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
        end,self.grossini,self.bg)
end
--显像光管
function GameScene13:light_screen( )
    local x,y= UItool:getitem_location(self.furniture:getChildByName("light_screen"), self.bg:getPositionX())
        GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function ()

        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[8].num==1 then
            if UItool:getBool("CTphoto") then
                UItool:message2("(显示大图(密码)) 原来如此！这下就能够看清上面写了些什么了。",30)
                
                UItool:setBool("CTphoto",false)
                local itemnum = UItool:getInteger("CTphotonum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                self.furniture:getChildByName("light_screen"):loadTextures("changesprite/GameScene13/baiban_p.png","changesprite/GameScene13/baiban_p.png")
                self.furnituretb[8].num = self.furnituretb[8].num+1
                self.furnituretb[8].ifchangesprite = true
                else
                    UItool:message2(" 我不太清楚这个是什么，不过我好像在医院里见过。 ",30)     
            end
            else
                -- UItool:message2(" 抽屉已经空了。 ",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)
end

--监控台
function GameScene13:screen( )
    local x,y= UItool:getitem_location(self.furniture:getChildByName("screen"), self.bg:getPositionX())
        GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function ()
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[12].num==1 then
            
            if UItool:getBool("button") then
                UItool:message2("出现画面了",30)
                self.furnituretb[12].use = true
                self.furnituretb[12].num = self.furnituretb[12].num+1
                self.furniture:getChildByName("machine_1"):setTexture("changesprite/GameScene13/machine_4.png")
                UItool:setBool("button",false)
                local itemnum = UItool:getInteger("buttonnum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                else
                    UItool:message2("台子上有很多按钮，不过似乎少了最重要的那个，所以无法开启机器。",30)
            end

            elseif self.furnituretb[12].num==2 then
               if UItool:getBool("hair_simple") then
                    UItool:message2("嘻嘻……真的很漂亮，谢谢你呢。这些东西你拿去吧，祝你早日……",30)
                    
                    self.furnituretb[12].num = self.furnituretb[12].num+1
                    self.furnituretb[12].cabinetopen=true
                    self.furniture:getChildByName("cabinet"):setVisible(true)
                    self.furniture:getChildByName("cabinet"):setEnabled(true)
                    self.furniture:getChildByName("machine_1"):setTexture("changesprite/GameScene13/machine_7.png")
                    UItool:setBool("hair_simple",false)
                    local itemnum = UItool:getInteger("hair_simplenum")
                    for i=1,#PublicData.MERGEITEM do
                        if PublicData.MERGEITEM[i] == itemnum then
                            table.remove(PublicData.MERGEITEM,i) 
                            break
                        end
                    end
                    else
                        UItool:message2("你决定好把我想要的东西给我了吗？",30)
                end
            
               
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)

end
--监控台柜子
function GameScene13:cabinet( )
    local x,y= UItool:getitem_location(self.furniture:getChildByName("cabinet"), self.bg:getPositionX())
        GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function ()
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[18].num==1 then
                UItool:message2("一把钳子和一瓶胶水，这些有什么用……",30)
                local key_item = Data.getItemData(73)
                table.insert(PublicData.MERGEITEM, key_item.key)

                local key_items = Data.getItemData(77)
                table.insert(PublicData.MERGEITEM, key_items.key)
                self.furniture:getChildByName("machine_1"):setTexture("changesprite/GameScene13/machine_6.png")
                
                
                else
                    -- UItool:message2("台子上有很多按钮，不过似乎少了最重要的那个，所以无法开启机器。",30)
               
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)
end

--黑板病例A
function GameScene13:record_A( )
    local x,y= UItool:getitem_location(self.furniture:getChildByName("record_A"), self.bg:getPositionX())
        GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function ()
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[12].use then
            local key_item = Data.getItemData(66)
            table.insert(PublicData.MERGEITEM, key_item.key)
            self.furnituretb[12].use=false
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)
end

--急救箱
function GameScene13:first_aid( )
    local x,y= UItool:getitem_location(self.furniture:getChildByName("first_aid"), self.bg:getPositionX())
        GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function ()
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[9].num==1 then
            
            UItool:message2("（显示大图）这个急救箱需要输入正确的密码才能够打开。",30)
            self.furnituretb[9].num = self.furnituretb[9].num+1
            elseif self.furnituretb[9].num ==2 then
                UItool:password("96524",60,61,"急救箱里有一把手术剪刀和一根针管。") -- 密码四
                self.furniture:getChildByName("first_aid_c"):setTexture("changesprite/GameScene13/first_aid_o.png")
                self.furnituretb[9].num = self.furnituretb[9].num+1
                self.furnituretb[9].ifchangesprite = true
                else
                    UItool:message2(" 我不太清楚这个是什么，不过我好像在医院里见过。 ",30)     
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)
end

--人物模型

function GameScene13:human_model( )
    local x,y= UItool:getitem_location(self.furniture:getChildByName("human_model"), self.bg:getPositionX())
        GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function ()
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[16].num==1 then
            
            UItool:message2("虽然看起来就是医院里普通的那种吓人的肌肉人像，但是不知道为什么，我总感觉它不是那么可怕，而且它似乎缺了些什么……",30)
            self.furnituretb[16].num = self.furnituretb[16].num+1
            elseif self.furnituretb[16].num ==2 then
                if UItool:getBool("cardiac") then
                    UItool:setBool("cardiac",false)
                    self.furnituretb[16].num=self.furnituretb[16].num+1
                    self.furniture:getChildByName("model1"):setTexture("changesprite/GameScene13/model_o_h_h.png")
                    UItool:message2("将标本瓶里的心安到了人像的身上……",30)
                    

                    local itemnum = UItool:getInteger("cardiacnum")
                    for i=1,#PublicData.MERGEITEM do
                        if PublicData.MERGEITEM[i] == itemnum then
                            table.remove(PublicData.MERGEITEM,i) 
                            break
                        end
                    end
                    else
                        UItool:message2("……我想把它身上缺失的部分找回来。",30)
                end
                elseif self.furnituretb[16].num ==3 then
                    self.furnituretb[16].num=self.furnituretb[16].num+1
                    local key_item = Data.getItemData(68)
                    table.insert(PublicData.MERGEITEM, key_item.key)
                    local key_item = Data.getItemData(69)
                    table.insert(PublicData.MERGEITEM, key_item.key)
                    self.furniture:getChildByName("model1"):setTexture("changesprite/GameScene13/model_o_h.png")
                    UItool:message2("钥匙和另一张碎纸……看起来只再需要一张就可以把它拼完整了。",30)

                else
                    UItool:message2("  这个人像现在看起来完整多了。 ",30)     
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)
end
--帘布
function GameScene13:Curtain_btn( )
    local x,y= UItool:getitem_location(self.furniture:getChildByName("Curtain_btn"), self.bg:getPositionX())
        GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function ()

        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[10].num==1 then
            self.furnituretb[10].num=self.furnituretb[10].num+1
            UItool:message2("这块布可以拉开。",30)
            self.furniture:getChildByName("curtain_1"):setTexture("changesprite/GameScene13/curtain_3.png")
            self.furnituretb[10].passpad=true
            self.furniture:getChildByName("passpad"):setEnabled(true)
            self.furniture:getChildByName("passpad"):setVisible(true)
            self.furniture:getChildByName("gate"):setEnabled(true)
            self.furniture:getChildByName("gate"):setVisible(true)
            
            elseif self.furnituretb[10].num==2 then
                if UItool:getBool("shoushudao") then
                    self.furnituretb[10].num=self.furnituretb[10].num+1
                    self.furniture:getChildByName("curtain_1"):setTexture("changesprite/GameScene13/curtain_2.png")
                    UItool:message2("用剪刀剪下来了一块布，应该会有用？",30)
                    local key_item = Data.getItemData(62)
                    table.insert(PublicData.MERGEITEM, key_item.key)

                    local itemnum = UItool:getInteger("shoushudaonum")
                    for i=1,#PublicData.MERGEITEM do
                        if PublicData.MERGEITEM[i] == itemnum then
                            table.remove(PublicData.MERGEITEM,i) 
                            break
                        end
                    end
                    else
                        UItool:message2("用普通的布做成的帘子，布料看起来吸水性很好。",30)
                end
                else
                    UItool:message2("用普通的布做成的帘子。",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)
end

--密码板
function  GameScene13:passpad( )
    local x,y= UItool:getitem_location(self.furniture:getChildByName("passpad"), self.bg:getPositionX())
        GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function ()

        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[13].num==1 then
            if UItool:getBool("qingjiebu") then
                self.furnituretb[13].num=self.furnituretb[13].num+1
                self.furniture:getChildByName("door_1"):setTexture("changesprite/GameScene13/door_2.png")
                UItool:message2("洗掉了脏的地方！这里印了一行字……会是个密码吗？",30)
                local itemnum = UItool:getInteger("qingjiebunum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                else
                    UItool:message2("这里脏了一块。",30)
            end
            elseif self.furnituretb[13].num==2 then
                self.furnituretb[13].num=self.furnituretb[13].num+1
                local key_item = Data.getItemData(65)
                table.insert(PublicData.MERGEITEM, key_item.key)
                self.furniture:getChildByName("door_1"):setTexture("changesprite/GameScene13/door_3.png")
                UItool:message2("将印有密码的板子取了下来。",30)
                else
                    UItool:message2("“手术中”。还是不要随便进入里面了吧……",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)
end

function  GameScene13:gate( )
    local x,y= UItool:getitem_location(self.furniture:getChildByName("Curtain_btn"), self.bg:getPositionX())
        GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function ()
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)

        UItool:message2("“手术中”。还是不要随便进入里面了吧……",30)
        end,self.grossini,self.bg)
end

function GameScene13:rack( )
    local x,y= UItool:getitem_location(self.furniture:getChildByName("rack"), self.bg:getPositionX())
        GameScenemove( math.floor( x-self.grossini:getContentSize().width/6),y ,function ()
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[17].num==1 then
            if UItool:getBool("xuediping") then
                UItool:setBool("xuediping",false)
                self.furnituretb[17].num=self.furnituretb[17].num+1
                self.furniture:getChildByName("rack_o"):setTexture("changesprite/GameScene13/rack_t.png")
                self.furnituretb[17].ifchangesprite=true
                UItool:message2("将输血瓶连到了人像的身上……",30)
                local itemnum = UItool:getInteger("xuedipingnum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                else
                    UItool:message2("床上的人似乎还在输液的样子……不要打扰他了。",30)
            end
            else
                UItool:message2("输液用的架子。",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()

        end,self.grossini,self.bg)
end

function GameScene13:modify()

    local chapter_tb = PublicData.CHAPTERTABLE
    chapter_tb[2].lock = 0

    local str = json.encode(chapter_tb)
    ModifyData.writeToDoc(str,"chapter")

    -- local tb = PublicData.ROOMTABLE
    -- tb[chapterNumber+1][roomNumber].lock=0
    -- local str = json.encode(tb)
    -- ModifyData.writeToDoc(str,"room")
    UItool:setBool("topbar",false)

    ModifyData.removeDoc("GBposition")
    ModifyData.removeDoc("furniture")
    ModifyData.removeDoc("mergeitem")
    PublicData.MERGEITEM={}
    PublicData.FURNITURE={}
    PublicData.SAVEDATA={}
    -- table.insert(PublicData.MERGEITEM, 11)


    ModifyData.setRoomNum(1)
    UItool:setInteger("roomNumber", 1)

    ModifyData.setChapterNum(2)
    UItool:setInteger("chapterNumber", 2)
    

    local scene = GameScene12.new()
    local turn = cc.TransitionFade:create(1, scene)
    cc.Director:getInstance():replaceScene(turn)

end
--手术床
function GameScene13:operating_table()
    local xiangkuang_locationx,xiangkuang_locationy = UItool:getitem_location(self.furniture:getChildByName("operating_table"), self.bg:getPositionX())
    GameScenemove( math.floor( xiangkuang_locationx-self.grossini:getContentSize().width/6),xiangkuang_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
        if self.furnituretb[20].num==1 then
            if UItool:getBool("bingli") then
                self.furnituretb[20].num=self.furnituretb[20].num+1
                self.furniture:getChildByName("sheet_c"):setTexture("changesprite/GameScene13/sheet_o.png")
                UItool:message2("恭喜通关",30)
                local itemnum = UItool:getInteger("xuedipingnum")
                for i=1,#PublicData.MERGEITEM do
                    if PublicData.MERGEITEM[i] == itemnum then
                        table.remove(PublicData.MERGEITEM,i) 
                        break
                    end
                end
                else
                    UItool:message2("……虽然不知道那里躺着谁，但我不应该去打扰他。",30)
                end
            else
                -- UItool:message2("输液用的架子。",30)
        end
        local str = json.encode(self.furnituretb)
        ModifyData.writeToDoc(str,"furniture")
        self:megerupdate()
    end,self.grossini,self.bg)
end 

function GameScene13:Button_71()
    local xiangkuang_locationx,xiangkuang_locationy = UItool:getitem_location(self.furniture:getChildByName("Button_71"), self.bg:getPositionX())
    GameScenemove( math.floor( xiangkuang_locationx-self.grossini:getContentSize().width/6),xiangkuang_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
            UItool:message2("一些化学仪器，没有什么能用的了。",30)
        end,self.grossini,self.bg)
end 

function GameScene13:Button_69()
    local xiangkuang_locationx,xiangkuang_locationy = UItool:getitem_location(self.furniture:getChildByName("Button_69"), self.bg:getPositionX())
    GameScenemove( math.floor( xiangkuang_locationx-self.grossini:getContentSize().width/6),xiangkuang_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
            UItool:message2("不是很清楚这些管道和仪表盘是用来做什么的……",30)
        end,self.grossini,self.bg)
end 

function GameScene13:Button_69_0()
    local xiangkuang_locationx,xiangkuang_locationy = UItool:getitem_location(self.furniture:getChildByName("Button_69_0"), self.bg:getPositionX())
    GameScenemove( math.floor( xiangkuang_locationx-self.grossini:getContentSize().width/6),xiangkuang_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
            UItool:message2("不是很清楚这些管道和仪表盘是用来做什么的……",30)
        end,self.grossini,self.bg)
end 

function GameScene13:Button_67()
    local xiangkuang_locationx,xiangkuang_locationy = UItool:getitem_location(self.furniture:getChildByName("Button_67"), self.bg:getPositionX())
    GameScenemove( math.floor( xiangkuang_locationx-self.grossini:getContentSize().width/6),xiangkuang_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
            UItool:message2("上面有好多按钮，不过还是不要随便按的好。",30)
        end,self.grossini,self.bg)
end 

function GameScene13:shoushudeng()
    local xiangkuang_locationx,xiangkuang_locationy = UItool:getitem_location(self.furniture:getChildByName("shoushudeng"), self.bg:getPositionX())
    GameScenemove( math.floor( xiangkuang_locationx-self.grossini:getContentSize().width/6),xiangkuang_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
            UItool:message2("灯没有开。",30)
        end,self.grossini,self.bg)
end 

function GameScene13:Button_66()
    local xiangkuang_locationx,xiangkuang_locationy = UItool:getitem_location(self.furniture:getChildByName("Button_66"), self.bg:getPositionX())
    GameScenemove( math.floor( xiangkuang_locationx-self.grossini:getContentSize().width/6),xiangkuang_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
            UItool:message2("里面都是些用不到的文件。",30)
        end,self.grossini,self.bg)
end 
function GameScene13:drawer_long()
    local xiangkuang_locationx,xiangkuang_locationy = UItool:getitem_location(self.furniture:getChildByName("drawer_long"), self.bg:getPositionX())
    GameScenemove( math.floor( xiangkuang_locationx-self.grossini:getContentSize().width/6),xiangkuang_locationy ,function (  )
        self.grossini:setScaleX(-self.girlx)
        self.grossini:setScaleY(self.girly)
            UItool:message2("抽屉里是空的。",30)
        end,self.grossini,self.bg)
end



function GameScene13:AllButtons(  )
    self.AllButtons = 
    {
        self.furniture:getChildByName("dress"),
        self.furniture:getChildByName("clause_btn"),
        self.furniture:getChildByName("glass_cabinet"),
        self.furniture:getChildByName("files_btn"),
        self.furniture:getChildByName("infusion_bottle"),
        self.furniture:getChildByName("tool_box"),
        self.furniture:getChildByName("wash_cabinet"),
        self.furniture:getChildByName("record_A"),
        self.furniture:getChildByName("drawer_long"),
        self.furniture:getChildByName("drawer_right"),
        self.furniture:getChildByName("tap"),
        self.furniture:getChildByName("Curtain"),
        self.furniture:getChildByName("tool_car"),
        self.furniture:getChildByName("first_aid"),
        self.furniture:getChildByName("screen"),
        self.furniture:getChildByName("cabinet"),
        self.furniture:getChildByName("light_screen"),
        self.furniture:getChildByName("rack"),
        self.furniture:getChildByName("human_model"),
        self.furniture:getChildByName("operating_table"),
        self.furniture:getChildByName("Curtain_btn"),
        self.furniture:getChildByName("gate"),
        self.furniture:getChildByName("passpad"),
        self.furniture:getChildByName("record_A"),
        self.furniture:getChildByName("glass_btn_L"),
        self.furniture:getChildByName("Button_66"),
        self.furniture:getChildByName("shoushudeng"),
        self.furniture:getChildByName("Button_69"),
        self.furniture:getChildByName("Button_67"),
        self.furniture:getChildByName("Button_69_0"),
        self.furniture:getChildByName("Button_71"),
        self.furniture:getChildByName("glass_btn_R")


    }

    --条款
    if self.furnituretb[2].num>=3 then
        self.furniture:getChildByName("clause"):setVisible(false)
    end
    --右抽屉
    if self.furnituretb[3].ifchangesprite then
        self.furniture:getChildByName("table_c"):setTexture("changesprite/GameScene13/table_o.png")
    end
    --工具箱
    if self.furnituretb[4].ifchangesprite then
        self.furniture:getChildByName("tool_box_c"):setTexture("changesprite/GameScene13/tool_box_o.png")
    end
    --点滴瓶
    if self.furnituretb[5].bool == false then
        self.furniture:getChildByName("infusion_bottle"):setVisible(false)
    end

    --档案柜
    if self.furnituretb[7].num==2 then
        self.furniture:getChildByName("Node_2"):getChildByName("files_cabinet"):setTexture("changesprite/GameScene13/files_cabinet_3.png")
        elseif self.furnituretb[7].num>=3 then
            self.furniture:getChildByName("Node_2"):getChildByName("files_cabinet"):setTexture("changesprite/GameScene13/files_cabinet_2.png")   
    end

    --显象光管
    if self.furnituretb[8].ifchangesprite then
        self.furniture:getChildByName("light_screen"):loadTextures("changesprite/GameScene13/baiban_p.png","changesprite/GameScene13/baiban_p.png")
    end

    --急救箱
    if self.furnituretb[9].ifchangesprite then
        self.furniture:getChildByName("first_aid_c"):setTexture("changesprite/GameScene13/first_aid_o.png")
    end 

    --帘子
    if self.furnituretb[10].num==2 then
        self.furniture:getChildByName("curtain_1"):setTexture("changesprite/GameScene13/curtain_3.png")
        elseif self.furnituretb[10].num>=3 then
            self.furniture:getChildByName("curtain_1"):setTexture("changesprite/GameScene13/curtain_2.png")
    end

    if self.furnituretb[11].appear then
        self.furniture:getChildByName("qingjieji"):setVisible(true)
        else
            self.furniture:getChildByName("qingjieji"):setVisible(false)
    end

    if self.furnituretb[11].ifchangesprite then
        self.furniture:getChildByName("handswash_1"):setTexture("changesprite/GameScene13/handswash_5.png")
    end

    if self.furnituretb[10].passpad then
        self.furniture:getChildByName("passpad"):setEnabled(true)
        self.furniture:getChildByName("passpad"):setVisible(true)
        self.furniture:getChildByName("gate"):setEnabled(true)
        self.furniture:getChildByName("gate"):setVisible(true)
        else
            self.furniture:getChildByName("passpad"):setEnabled(false)
            self.furniture:getChildByName("passpad"):setVisible(false)
            self.furniture:getChildByName("gate"):setEnabled(false)
            self.furniture:getChildByName("gate"):setVisible(false)
    end

    if self.furnituretb[12].cabinetopen==true then
        
        self.furniture:getChildByName("cabinet"):setVisible(true)
        self.furniture:getChildByName("cabinet"):setEnabled(true)
        else
            self.furniture:getChildByName("cabinet"):setVisible(false)
            self.furniture:getChildByName("cabinet"):setEnabled(false)
    end

    if self.furnituretb[13].num==2 then
        self.furniture:getChildByName("door_1"):setTexture("changesprite/GameScene13/door_2.png")
        elseif self.furnituretb[13].num>=3 then
            self.furniture:getChildByName("door_1"):setTexture("changesprite/GameScene13/door_3.png")            
    end

    --左玻璃柜
    if self.furnituretb[14].num==2 then
        self.furniture:getChildByName("Node_2"):getChildByName("glass"):setTexture("changesprite/GameScene13/glass_2.png")
        elseif self.furnituretb[14].num==3 then
            self.furniture:getChildByName("Node_2"):getChildByName("glass"):setTexture("changesprite/GameScene13/glass_3.png")
            elseif self.furnituretb[14].num>=4 then
                self.furniture:getChildByName("Node_2"):getChildByName("glass"):setTexture("changesprite/GameScene13/glass_4.png")
    end

    --右玻璃柜
    if self.furnituretb[15].num==2 then
        self.furniture:getChildByName("Node_2"):getChildByName("glass"):setTexture("changesprite/GameScene13/glass_5.png")
        elseif self.furnituretb[15].num>=3 then
            self.furniture:getChildByName("Node_2"):getChildByName("glass"):setTexture("changesprite/GameScene13/glass_6.png")
    end
    --人模型
    if self.furnituretb[16].num==2 then
        self.furniture:getChildByName("model1"):setTexture("changesprite/GameScene13/model_o_h_h.png")
        elseif self.furnituretb[16].num>=3 then
            self.furniture:getChildByName("model1"):setTexture("changesprite/GameScene13/model_o_h.png")
    end

    --点滴架
    if self.furnituretb[17].ifchangesprite then
        self.furniture:getChildByName("rack_o"):setTexture("changesprite/GameScene13/rack_t.png")
    end

    

    local function allButtonClick(event,eventType)
        if eventType == TOUCH_EVENT_ENDED then
            if UItool:getBool("effect") then
                AudioEngine.playEffect("gliss.mp3")
            end

            if event:getName()=="dress" then
                self:dress()
                elseif event:getName()=="clause_btn" then
                    self:clause_btn()
                    elseif event:getName()=="glass_btn_L" then
                        self:glass_btn_L()
                        elseif event:getName()=="files_btn" then
                            self:file_cabinet()
                            elseif event:getName()=="infusion_bottle" then
                                self:infusion_bottle()
                                elseif event:getName()=="tool_box" then
                                    self:tool_box()
                                    elseif event:getName()=="wash_cabinet" then
                                        self:wash_cabinet()
                                        elseif event:getName()=="record_A" then
                                            self:record_A()
                                            elseif event:getName()=="drawer_long" then
                                                self:drawer_long()
                                                elseif event:getName()=="tap" then
                                                    self:tap()
                                                    elseif event:getName()=="Curtain" then
                                                        self:Curtain()
                                                        elseif event:getName()=="tool_car" then
                                                            self:tool_car()
                                                            elseif event:getName()=="first_aid" then
                                                                self:first_aid()
                                                                elseif event:getName()=="screen" then
                                                                    self:screen()
                                                                    elseif event:getName()=="cabinet" then
                                                                        self:cabinet()
                                                                        elseif event:getName()=="light_screen" then
                                                                            self:light_screen()
                                                                            elseif event:getName()=="rack" then
                                                                                self:rack()
                                                                                elseif event:getName()=="human_model" then
                                                                                    self:human_model()
                                                                                    elseif event:getName()=="operating_table" then
                                                                                        self:operating_table()
                                                                                        elseif event:getName()=="drawer_right" then
                                                                                            self:drawer_right()
                                                                                            elseif event:getName()=="Curtain_btn" then
                                                                                                self:Curtain_btn()
                                                                                                elseif event:getName()=="passpad" then
                                                                                                    self:passpad()
                                                                                                    elseif event:getName()=="gate" then
                                                                                                        self:gate()
                                                                                                        elseif event:getName()=="record_A" then
                                                                                                            self:record_A()
                                                                                                            elseif event:getName()=="glass_btn_R" then
                                                                                                                self:glass_btn_R()
                                                                                                                elseif event:getName()=="Button_71" then
                                                                                                                    self:Button_71()
                                                                                                                    elseif event:getName()=="Button_69_0" then
                                                                                                                        self:Button_69_0()
                                                                                                                        elseif event:getName()=="Button_67" then
                                                                                                                            self:Button_67()
                                                                                                                            elseif event:getName()=="Button_69" then
                                                                                                                                self:Button_69()
                                                                                                                                elseif event:getName()=="shoushudeng" then
                                                                                                                                    self:shoushudeng()
                                                                                                                                    elseif event:getName()=="Button_66" then
                                                                                                                                        self:Button_66()
                                                                                                                

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

















