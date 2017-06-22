
require("game/view/mainscene/onescene/PlayerLayer")
Mainscene=class("Mainscene", function()
    return cc.Scene:create()
end)

Mainscene.panel = nil
function Mainscene:ctor()
   
	self.director = cc.Director:getInstance()
	self.visibleSize = cc.Director:getInstance():getVisibleSize()
    -- self.visibleSize = cc.Director:getInstance():getWinSize()  
    self.winsize = cc.Director:getInstance():getWinSizeInPixels()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    -- self.node = cc.Node:create()
    -- self.node:addTo(self)
    -- 家具底层
    self.panel = cc.CSLoader:createNode(Config.RES_MAINSCENE)
    self.panel:setPosition(cc.p(0,0))
    self:addChild(self.panel)
    --主节点
    self.node =  self.panel:getChildByName("Node_left_bottom")
    self.node:setPosition(0, self.visibleSize.height)
    --背景
    self.bg = self.node:getChildByName("bg")
    print("背景的大小 %d  ,  %d ",self.bg:getContentSize().width,self.bg:getContentSize().height)
    -- self.bg:setPosition(cc.p(0,0))

    local draw = cc.DrawNode:create()  
    -- local points = {cc.p(0,0), cc.p(0 + size, 0), cc.p(0 + size, 0 + size), cc.p(0, 0 + size)}  
    draw:drawDot(cc.p(self.bg:getPositionX(),self.visibleSize.height - self.bg:getContentSize().height*0.85),50,cc.c4b(0,0,0,1))  
    -- draw:setTag("draw")  
    self:addChild(draw,100)  

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

    self:init()
--合成条
    self.merge = Merge:createScene()
    self:addChild(self.merge,5)
    

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
    self:scheduleUpdateWithPriorityLua(update,0.1)
    
end

function Mainscene:init()
    self:touchpoint()
    self:grossiniwalk()-- 人物动作

    self.scheduler = nil -- 定时器
    self.goscheduler = nil --过关定时器
    self.m_isAnimationing = nil 

    self:ontouch()
    self:AllButtons()

    self.runtime = nil 

    self:fishmove() --鱼的移动 
    
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

    local speed = 3 
  
    posdoublefish = posdoublefish - speed  -8
    posfeifish = posfeifish - speed 
    posfishgroup = posfishgroup - speed -7
    posfishgroup2 = posfishgroup2 - speed *1.2

    poslongfish = poslongfish - speed -1
    poslshark = poslshark + speed 
    posrfish = posrfish + speed +4
    posrfish1 = posrfish1 + speed +4

    posrfishgroup1 = posrfishgroup1 + speed 
    posrpianyu = posrpianyu + speed 
    possanjiao = possanjiao - speed -6
    possfish = possfish - speed -5

    possshark = possshark + speed 
    postiaoyu = postiaoyu - speed -4
    posfishx = posfishx - speed -3
    posfishy = posfishy - speed -1
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
    print("bed_up")
    local bed_up_locationx ,bed_up_locationy = UItool:getitem_location(self.furniture:getChildByName("bed_up"), self.bg:getPositionX())
    self:Girl_bg_move( bed_up_locationx,bed_up_locationy ,function (  )
        self.grossini:getAnimation():play("stoop_1")--直腰
        if bed_upnum==1 then
            UItool:message2(" 带绳子的小盒子，绳子太紧我解不开  ",30)
            local key_item = Data.getItemData(3)
            ModifyData.tableinsert(key_item.key)
            self.merge:removeSelf()
            self.merge = Merge:createScene()
            self:addChild(self.merge,5)
            bed_upnum=bed_upnum+1
            else
                UItool:message2(" 已经空了  ",30)
        end
    end)
end

local bed_downnum = 1
function Mainscene:bed_down()
    --床底
    local bed_down_locationx, bed_down_locationy= UItool:getitem_location(self.furniture:getChildByName("bed_down"), self.bg:getPositionX())

    self:Girl_bg_move( bed_down_locationx ,bed_down_locationy,function (  )
        if bed_downnum==1 then
            self.grossini:getAnimation():play("squat_1") -- 下蹲
            UItool:setCurrentState("xiadun")
            UItool:message2(" 这里有把小锤子，可能会有用。  ",30)
            local key_item = Data.getItemData(14)
            ModifyData.tableinsert(key_item.key)
            self.merge:removeSelf()
            self.merge = Merge:createScene()
            self:addChild(self.merge,5)
            bed_downnum=bed_downnum+1
            else
                self.grossini:getAnimation():play("squat_1") -- 下蹲
                UItool:setCurrentState("xiadun")
                UItool:message2(" 已经空了  ",30)
        end

    end)
end 

local bedside_tablenum= 1
function Mainscene:bedside_table()
    --床头柜
    print("bedside_table")
        local bedside_table_locationx, bedside_table_locationy= UItool:getitem_location(self.furniture:getChildByName("bedside_table"), self.bg:getPositionX())

        self:Girl_bg_move( bedside_table_locationx,bedside_table_locationy ,function (  )
            if bedside_tablenum==1 then
                if UItool:getBool("bedkey") then
                    UItool:message2(" 又发现一半 ",30)
                    local key_item = Data.getItemData(12)
                    ModifyData.tableinsert(key_item.key)

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
                    bedside_tablenum= 1+ bedside_tablenum
                    UItool:setBool("bedkey",false)

                else
                    UItool:message2(" 它锁住了 ",30)

                end

                else
                    UItool:message2("空了",30)
            end
            

        end)
end

function Mainscene:L_curtain()
    --左窗帘
    print("L_curtain")
        local L_curtain_locationx,L_curtain_locationy = UItool:getitem_location(self.furniture:getChildByName("L_curtain"), self.bg:getPositionX())

        self:Girl_bg_move( L_curtain_locationx,L_curtain_locationy ,function (  )
            -- self.grossini:getAnimation():play("squat_2")  -- 下蹲站起
            -- UItool:message2(" 得到数字（3572）",40)
        end)
end

local clicknum = 0
function Mainscene:R_curtain()
    --右窗帘  多次点击
    print("R_curtain")
            local R_curtain_locationx, R_curtain_locationy= UItool:getitem_location(self.furniture:getChildByName("R_curtain"), self.bg:getPositionX())
            self:Girl_bg_move( R_curtain_locationx,R_curtain_locationy,function (  )
                
            end)
            
           
        
        print("number == %d",clicknum)
end

local bearnum = 1
function Mainscene:bear()
    --  熊 多次点击
    print("bear")
            local R_curtain_locationx, R_curtain_locationy= UItool:getitem_location(self.furniture:getChildByName("bear"), self.bg:getPositionX())
            self:Girl_bg_move( R_curtain_locationx,R_curtain_locationy,function (  )
                if bearnum==1 then
                    
                    UItool:message2(" 我喜欢的小熊，但和它在一起的洋娃娃不见了。 ",30)
                    bearnum = 1+bearnum 
                    elseif bearnum==2 then
                        bearnum = 1+bearnum 
                        UItool:message2(" 小熊的身体里好像有什么东西。 ",30)
                        elseif bearnum==3 then

                            if UItool:getBool("scissors") then
                                UItool:message2(" 对不起小熊",30)
                                local key_item = Data.getItemData(19)
                                ModifyData.tableinsert(key_item.key)
                                
                                local itemnum = UItool:getInteger("scissorsnum")
                                for i=1,#ModifyData.getTable() do
                                    if ModifyData.getTable()[i] == itemnum then
                                        table.remove(ModifyData.getTable(),i) 
                                        break
                                    end
                                end

                                self.merge:removeSelf()
                                self.merge = Merge:createScene()
                                self:addChild(self.merge,5)
                                bearnum = 1+bearnum 
                                UItool:setBool("scissors",false) 

                            end

                end
                
                
            end)
            
           
        
        print("number == %d",clicknum)
end

local toilet_glassnum = 1
function Mainscene:toilet_glass()
    --梳妆台-镜子
    print("toilet_glass")
    local toilet_glass_locationx,toilet_glass_locationy = UItool:getitem_location(self.furniture:getChildByName("toilet_glass"), self.bg:getPositionX())

        self:Girl_bg_move( toilet_glass_locationx,toilet_glass_locationy ,function (  )
            if toilet_glassnum == 1 then
                if UItool:getBool("hammer") then
                    UItool:message2(" 锋利的碎片 好像还有字，你需要纸和笔记录下来 ",30)
                    local key_item = Data.getItemData(1)
                    ModifyData.tableinsert(key_item.key)
                    
                    local itemnum = UItool:getInteger("hammernum")
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
                    UItool:setBool("hammer",false)

                end

                elseif toilet_glassnum == 2 then

                    if UItool:getBool("paperpen") then
                        UItool:message2(" 密码纸（6732）  ",30)
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

                    end
                    else
                        UItool:message2(" 你在干嘛？  ",30)
            end
            
            
        end)
end
local toilet_drawernum = 1
function Mainscene:toilet_drawer()
    --梳妆台-抽屉
    print("toilet_drawer")
    local toilet_drawer_locationx,toilet_drawer_locationy = UItool:getitem_location(self.furniture:getChildByName("toilet_drawer"), self.bg:getPositionX())

        self:Girl_bg_move( toilet_drawer_locationx,toilet_drawer_locationy ,function (  )
            
        end)
end

local stoolnum = 1
function Mainscene:stool()
    --凳子
    print("stool")
    local stool_locationx,stool_locationy = UItool:getitem_location(self.furniture:getChildByName("stool"), self.bg:getPositionX())

        self:Girl_bg_move( stool_locationx,stool_locationy ,function (  )
            if stoolnum==1 then
                UItool:message2(" 嘿……这凳子还挺轻的。  ",30)
                local key_item = Data.getItemData(8)
                ModifyData.tableinsert(key_item.key)
                self.merge:removeSelf()
                self.merge = Merge:createScene()
                self:addChild(self.merge,5)
                stoolnum = stoolnum +1
                else
                    UItool:message2(" 嘿……凳子搬走了。  ",30)
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
                    UItool:message2(" 发现颜色密码箱 ",30)
                    local key_item = Data.getItemData(21)
                    ModifyData.tableinsert(key_item.key)

                    local itemnum = UItool:getInteger("keynum")
                    for i=1,#ModifyData.getTable() do
                        if ModifyData.getTable()[i] == itemnum then
                            table.remove(ModifyData.getTable(),i) 
                            break
                        end
                    end

                    self.merge:removeSelf()
                    self.merge = Merge:createScene()
                    self:addChild(self.merge,5)
                    wardrobenum = wardrobenum + 1
                    UItool:setBool("key",false) 

                end
                else
                    UItool:message2(" 已经空了 ",30)
            end
            
        
    end)
end

local cushionnum = 1
function Mainscene:cushion()
    --靠垫
    print("cushion")
           
    local cushion_locationx,cushion_locationy = UItool:getitem_location(self.furniture:getChildByName("cushion"), self.bg:getPositionX())

    self:Girl_bg_move( cushion_locationx,cushion_locationy ,function (  )
        if cushionnum == 1 then
             UItool:message2(" 衣柜钥匙 ",30)
            self.grossini:getAnimation():play("stoop_2") --直腰
            local key_item = Data.getItemData(18)
            ModifyData.tableinsert(key_item.key)
            self.merge:removeSelf()
            self.merge = Merge:createScene()
            self:addChild(self.merge,5)
            cushionnum = cushionnum+1
            else
                UItool:message2(" 已经来过了 ",30)
        end
        
        
    end)
end


local B_vasenum = 1
function Mainscene:B_vase()
    --大花瓶
    print("B_vase")
    local B_vase_locationx,B_vase_locationy = UItool:getitem_location(self.furniture:getChildByName("B_vase"), self.bg:getPositionX())

    self:Girl_bg_move( B_vase_locationx,B_vase_locationy ,function (  )
        if B_vasenum==1 then
            if UItool:getBool("redbrush") then
                UItool:message2(" 红色花朵 ",30)
                local key_item = Data.getItemData(16)
                ModifyData.tableinsert(key_item.key)

                local itemnum = UItool:getInteger("redbrushnum")
                for i=1,#ModifyData.getTable() do
                    if ModifyData.getTable()[i] == itemnum then
                        table.remove(ModifyData.getTable(),i) 
                        break
                    end
                end

                self.merge:removeSelf()
                self.merge = Merge:createScene()
                self:addChild(self.merge,5)
                B_vasenum = B_vasenum + 1
                UItool:setBool("redbrush",false)
                else
                    UItool:message2(" 花朵被摘走了 ",30)
            end
            else
                UItool:message2(" 花朵被摘走了 ",30)

        end
        

    end)
end


function Mainscene:S_vase()
    --小花瓶
    print("S_vase")
        
        local S_vase_locationx,S_vase_locationy = UItool:getitem_location(self.furniture:getChildByName("S_vase"), self.bg:getPositionX())

        self:Girl_bg_move( S_vase_locationx,S_vase_locationy ,function ()
        
        end)
end

local sofabacknum = 1
function Mainscene:sofaback()
    --沙发背
    print("sofaback")
    local sofaback_locationx,sofaback_locationy = UItool:getitem_location(self.furniture:getChildByName("sofaback"), self.bg:getPositionX())

    self:Girl_bg_move( sofaback_locationx,sofaback_locationy ,function ()
        UItool:message2(" 沙发不能移动 ",30 )
    end)
end



local bookshelf_onenum = 1
function Mainscene:bookshelf_one()
    --书架一
    print("bookshelf_one")
       
        local bookshelf_one_locationx,bookshelf_one_locationy = UItool:getitem_location(self.furniture:getChildByName("bookshelf_one"), self.bg:getPositionX())

        self:Girl_bg_move( bookshelf_one_locationx,bookshelf_one_locationy ,function ()
            UItool:message2(" 这都是书  ",30 )
        end)
end

local bookshelf_twonum = 1
function Mainscene:bookshelf_two()
    --书架二  多次点击
    print("bookshelf_two")
    
        local bookshelf_two_locationx,bookshelf_two_locationy = UItool:getitem_location(self.furniture:getChildByName("bookshelf_two"), self.bg:getPositionX())

        self:Girl_bg_move( bookshelf_two_locationx,bookshelf_two_locationy ,function ()

            if bookshelf_twonum == 1 then
               UItool:message2("书可真多啊" , 30)
               bookshelf_twonum = bookshelf_twonum + 1
               elseif  bookshelf_twonum == 2 then
                bookshelf_twonum = bookshelf_twonum + 1
                UItool:message2("我最喜欢的书也在上面。" , 30)
                   elseif bookshelf_twonum == 3 then
                       bookshelf_twonum = bookshelf_twonum + 1
                       UItool:message2("咦，有东西掉出来了 ,像是一串电话号码" , 30)
                       local key_item = Data.getItemData(9)
                        ModifyData.tableinsert(key_item.key) 
                        self.merge:removeSelf()
                        self.merge = Merge:createScene()
                        self:addChild(self.merge,5)
                        else
                            UItool:message2(" 空了 " , 30)
            end
            
            
    end)
        
    
    
end

local L_drawernum = 1
function Mainscene:L_drawer()
    print("L_drawer")
    --书桌左抽屉
           
        local L_drawer_locationx,L_drawer_locationy = UItool:getitem_location(self.furniture:getChildByName("L_drawer"), self.bg:getPositionX())

        self:Girl_bg_move( L_drawer_locationx,L_drawer_locationy ,function ()
            

        end)
end

local R_drawernum = 1
function Mainscene:R_drawer()
    print("R_drawer")
    --书桌右抽屉
    local R_drawer_locationx,R_drawer_locationy = UItool:getitem_location(self.furniture:getChildByName("R_drawer"), self.bg:getPositionX())

    self:Girl_bg_move( R_drawer_locationx,R_drawer_locationy ,function ()
        
        
    end)

end

local booknum = 1
function Mainscene:book()
    print("book")
    local book_locationx,book_locationy = UItool:getitem_location(self.furniture:getChildByName("book"), self.bg:getPositionX())

    self:Girl_bg_move( book_locationx,book_locationy ,function ()
        
        if booknum==1 then
            UItool:message2("  我可以用它来抄一些东西  ",30) 
            booknum = booknum+1
            local key_item = Data.getItemData(15)
            ModifyData.tableinsert(key_item.key) 
            self.merge:removeSelf()
            self.merge = Merge:createScene()
            self:addChild(self.merge,5)
            else
                UItool:message2("  不需要太多  ",30) 
        end
    end)
end

local Pintunum = 1
function Mainscene:Pintu()
    print("Pintu")
    local Pintu_locationx,Pintu_locationy = UItool:getitem_location(self.furniture:getChildByName("Pintu"), self.bg:getPositionX())

    self:Girl_bg_move( Pintu_locationx,Pintu_locationy ,function ()
       --  if UItool:ifcontain( 8 ) then

       -- local PlayerLayer = PlayerLayer:createScene()
       --  print("进入拼图界面", PlayerLayer)
       --  self:addChild(PlayerLayer,125)
       --  else
       --      UItool:message2("缺少东西浸润它 ",30)
       --  end
    end)
end

local wardrobe_drawer_1num = 0
function Mainscene:wardrobe_drawer_1()
    --立柜抽屉一层  多次点击 
    print("wardrobe_drawer_1")
            local wardrobe_drawer_1_locationx,wardrobe_drawer_1_locationy = UItool:getitem_location(self.furniture:getChildByName("wardrobe_drawer_1"), self.bg:getPositionX())

            self:Girl_bg_move( wardrobe_drawer_1_locationx,wardrobe_drawer_1_locationy ,function ()
        --     wardrobe_drawer_1num = wardrobe_drawer_1num+1
        --     UItool:message2("有效点击次数"..wardrobe_drawer_1num , 30)
        -- if wardrobe_drawer_1num==8  then
        --     UItool:message2(" 数字（0311）  ",30)
        --     elseif wardrobe_drawer_1num>8  then
        --          UItool:message2("密码已发出",30)
        --     end
                
            end)
        
        
end

local wardrobe_drawer_2num = 1
function Mainscene:wardrobe_drawer_2()
    print("wardrobe_drawer_2")
    --立柜抽屉二层
        local wardrobe_drawer_2_locationx,wardrobe_drawer_2_locationy = UItool:getitem_location(self.furniture:getChildByName("wardrobe_drawer_2"), self.bg:getPositionX())

        self:Girl_bg_move( wardrobe_drawer_2_locationx,wardrobe_drawer_2_locationy ,function ()
        
        if wardrobe_drawer_2num==1 then
            UItool:message2("  刷子  ",30) 
            wardrobe_drawer_2num = wardrobe_drawer_2num+1
            local key_item = Data.getItemData(6)
            ModifyData.tableinsert(key_item.key) 
            self.merge:removeSelf()
            self.merge = Merge:createScene()
            self:addChild(self.merge,5)
            else
                UItool:message2("  没有更多  ",30) 
        end
        end)
end

local wardrobe_drawer_3num = 1
function Mainscene:wardrobe_drawer_3()
    print("wardrobe_drawer_3")
           
        local wardrobe_drawer_3_locationx,wardrobe_drawer_3_locationy = UItool:getitem_location(self.furniture:getChildByName("wardrobe_drawer_3"), self.bg:getPositionX())

        self:Girl_bg_move( wardrobe_drawer_3_locationx,wardrobe_drawer_3_locationy ,function ()
        UItool:message2(" 好像被锁住了 ",30 )
        end)

end

local phonenum = 1
function Mainscene:phone()
    print("phone")
        
        local phone_locationx,phone_locationy = UItool:getitem_location(self.furniture:getChildByName("phone"), self.bg:getPositionX())

        self:Girl_bg_move( phone_locationx,phone_locationy ,function ()
            if phonenum==1 then
               if UItool:getBool("redflower") then
                    UItool:message2(" 床头柜钥匙 ",30)
                    local key_item = Data.getItemData(17)
                    ModifyData.tableinsert(key_item.key)

                    local itemnum = UItool:getInteger("redflowernum")
                    for i=1,#ModifyData.getTable() do
                        if ModifyData.getTable()[i] == itemnum then
                            table.remove(ModifyData.getTable(),i) 
                            break
                        end
                    end

                    self.merge:removeSelf()
                    self.merge = Merge:createScene()
                    self:addChild(self.merge,5)
                    phonenum = phonenum + 1
                    UItool:setBool("redflower",false)

                end
                else
                    UItool:message2(" 你没有花了 ",30)
            end
            

        end)
end

local wardrobe_albumnum = 1
function Mainscene:wardrobe_album()
    print("wardrobe_album") -- 立柜相册
        -- UItool:message2("线索一",30)
        local wardrobe_album_locationx,wardrobe_album_locationy = UItool:getitem_location(self.furniture:getChildByName("wardrobe_album"), self.bg:getPositionX())

        self:Girl_bg_move( wardrobe_album_locationx,wardrobe_album_locationy ,function ()
        UItool:message2(" 和电话挨着的是相册 ",30 )
        end)

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
                else
                    UItool:message2("  没有钥匙  ",30)

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
                UItool:message2("得到了护身符 。。。 护身符",30)
                local key_item = Data.getItemData(4)
                ModifyData.tableinsert(key_item.key)
                
                local itemnum = UItool:getInteger("stampnum")
                for i=1,#ModifyData.getTable() do
                    if ModifyData.getTable()[i] == itemnum then
                        table.remove(ModifyData.getTable(),i) 
                        break
                    end
                end

                self.merge:removeSelf()
                self.merge = Merge:createScene()
                self:addChild(self.merge,5)
                Big_framenum = Big_framenum + 1
                UItool:setBool("stamp",false)

                end
                else
                    UItool:message2(" 我一直在看着你 ",30)
            end
            
            

        end)
end

local hua_framenum = 1
function Mainscene:hua_frame()
    print("hua_frame")
        
        local hua_frame_locationx,hua_frame_locationy = UItool:getitem_location(self.furniture:getChildByName("hua_frame"), self.bg:getPositionX())

        self:Girl_bg_move( hua_frame_locationx,hua_frame_locationy ,function ()
        UItool:message2(" 黄花3朵 ",30 )
        end)
end

local fang_framenum = 1
function Mainscene:fang_frame()
    print("fang_frame")
        
        local fang_frame_locationx,fang_frame_locationy = UItool:getitem_location(self.furniture:getChildByName("fang_frame"), self.bg:getPositionX())

        self:Girl_bg_move( fang_frame_locationx,fang_frame_locationy ,function ()
        UItool:message2(" 粉花7朵 ",30 )
        end)
end

local yuan_framenum = 1
function Mainscene:yuan_frame()
    print("yuan_frame")
        
        local yuan_frame_locationx,yuan_frame_locationy = UItool:getitem_location(self.furniture:getChildByName("yuan_frame"), self.bg:getPositionX())

        self:Girl_bg_move( yuan_frame_locationx,yuan_frame_locationy ,function ()
        UItool:message2(" 绿花4朵 ",30 )
        end)
end

local frame_1num = 1
function Mainscene:frame_1()
    print("frame_1")
        
        local frame_locationx,frame_locationy = UItool:getitem_location(self.furniture:getChildByName("frame_1"), self.bg:getPositionX())

        self:Girl_bg_move( frame_locationx,frame_locationy ,function ()
        UItool:message2("蓝花5朵",30)
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
                UItool:message2(" 带密码的小盒子  ",30)
                local key_item = Data.getItemData(10)
                ModifyData.tableinsert(key_item.key)
                
                local itemnum = UItool:getInteger("stoolnum")
                for i=1,#ModifyData.getTable() do
                    if ModifyData.getTable()[i] == itemnum then
                        table.remove(ModifyData.getTable(),i) 
                        break
                    end
                end
                self.merge:removeSelf()
                self.merge = Merge:createScene()
                self:addChild(self.merge,5)
                wardrobe_topnum = wardrobe_topnum+1
                UItool:setBool("stool",false)
            end
            
            else
                UItool:message2(" 太高了   ",30)
        end
        

        end)
end



function Mainscene:AllButtons(  )
    self.AllButtons = 
    {
            self.furniture:getChildByName("L_curtain"),
            self.furniture:getChildByName("R_curtain"),
            self.furniture:getChildByName("bed_up"),
            self.furniture:getChildByName("bed_down"),
            self.furniture:getChildByName("toilet_glass"),
            self.furniture:getChildByName("bedside_table"),
            self.furniture:getChildByName("toilet_drawer"),
            self.furniture:getChildByName("stool"),
            self.furniture:getChildByName("wardrobe"),
            self.furniture:getChildByName("cushion"),
            self.furniture:getChildByName("B_vase"),
            self.furniture:getChildByName("S_vase"),
            self.furniture:getChildByName("sofaback"),
            self.furniture:getChildByName("L_drawer"),
            self.furniture:getChildByName("R_drawer"),
            self.furniture:getChildByName("bookshelf_one"),
            self.furniture:getChildByName("bookshelf_two"),
            self.furniture:getChildByName("book"),
            self.furniture:getChildByName("Pintu"),
            self.furniture:getChildByName("wardrobe_drawer_1"),
            self.furniture:getChildByName("wardrobe_drawer_2"),
            self.furniture:getChildByName("wardrobe_drawer_3"),
            self.furniture:getChildByName("phone"),
            self.furniture:getChildByName("wardrobe_album"),
            self.furniture:getChildByName("door"),
            self.furniture:getChildByName("Big_frame"),
            self.furniture:getChildByName("hua_frame"),
            self.furniture:getChildByName("yuan_frame"),
            self.furniture:getChildByName("fang_frame"),
            self.furniture:getChildByName("wardrobe_top"),
            self.furniture:getChildByName("frame_1"),
            self.furniture:getChildByName("bear")

    }
    local function renwu_haoyou_shezhiButtonClick(event,eventType)
        if eventType == TOUCH_EVENT_ENDED then
            if event:getName()=="L_curtain" then
                print("L_curtain")
                self:L_curtain()
                elseif event:getName()=="R_curtain" then
                    print("R_curtain")
                    self:R_curtain()
                    elseif event:getName()=="bed_up" then
                        print("bed_up")
                        self:bed_up()
                        elseif event:getName()=="bed_down" then
                            print("bed_down")
                            self:bed_down()
                            elseif event:getName()=="toilet_glass" then
                                print("toilet_glass")
                                self:toilet_glass()
                                elseif event:getName()=="bedside_table" then
                                    print("bedside_table")
                                    self:bedside_table()
                                    elseif event:getName()=="toilet_drawer" then
                                        print("toilet_drawer")
                                        self:toilet_drawer()
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
                                                        elseif event:getName()=="S_vase" then
                                                            print("S_vase")
                                                            self:S_vase()
                                                            elseif event:getName()=="sofaback" then
                                                                print("sofaback")
                                                                self:sofaback()
                                                                elseif event:getName()=="L_drawer" then
                                                                    print("L_drawer")
                                                                    self:L_drawer()
                                                                    elseif event:getName()=="R_drawer" then
                                                                        print("··R_drawer·")
                                                                        self:R_drawer()
                                                                        elseif event:getName()=="bookshelf_one" then
                                                                            print("bookshelf_one")
                                                                            self:bookshelf_one()
                                                                            elseif event:getName()=="bookshelf_two" then
                                                                                print("··bookshelf_two·")
                                                                                self:bookshelf_two()
                                                                                elseif event:getName()=="book" then
                                                                                    print("book")
                                                                                    self:book()
                                                                                    elseif event:getName()=="Pintu" then
                                                                                        print("Pintu")
                                                                                        self:Pintu()
                                                                                        elseif event:getName()=="wardrobe_drawer_1" then
                                                                                            print("wardrobe_drawer_1")
                                                                                            self:wardrobe_drawer_1()
                                                                                            elseif event:getName()=="wardrobe_drawer_2" then
                                                                                                print("·wardrobe_drawer_2··")
                                                                                                self:wardrobe_drawer_2()
                                                                                                elseif event:getName()=="wardrobe_drawer_3" then
                                                                                                    print("··wardrobe_drawer_3·")
                                                                                                    self:wardrobe_drawer_3()
                                                                                                    elseif event:getName()=="phone" then
                                                                                                        print("··phone·")
                                                                                                        self:phone()
                                                                                                        elseif event:getName()=="wardrobe_album" then
                                                                                                            print("··wardrobe_album·")
                                                                                                            self:wardrobe_album()
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
                                                                                                                                        elseif event:getName()=="bear" then
                                                                                                                                            print("bear")
                                                                                                                                            self:bear()
                                                                                                                    
                                                                                                                 
            end
        end
    end
    for key, var in pairs(self.AllButtons) do
        if self.grossini:getNumberOfRunningActions()>0 or self.bg:getNumberOfRunningActions()>0 then
            else
                var:addClickEventListener(renwu_haoyou_shezhiButtonClick)
                var:setSwallowTouches(false)

        end
    end
end

    --角色移动
function Mainscene:grossiniwalk()
    --骨骼动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/donghua/loli1/Export/loli/loli.ExportJson") 
    self.grossini = ccs.Armature:create("loli")
    self.grossini:setScaleX(-0.25)
    self.grossini:setScaleY(0.25)
    
    self.grossini:getAnimation():playWithIndex(1)
    self.grossini:getAnimation():play("stand")
     UItool:setCurrentState("stand")
    self.grossini:setPosition(cc.p(170,170))
    self:addChild(self.grossini)
end

function Mainscene:touchpoint()
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/donghua/dianji/Export/dianji/dianji.ExportJson") 
    self.dianji = ccs.Armature:create("dianji")
    self.dianji:getAnimation():playWithIndex(0,-1,-1)
    -- self.dianji:getAnimation():play("dianji",1,-1)
    self.dianji:setPosition(cc.p(-200,-200))
    
    self:addChild(self.dianji)
end

function Mainscene:ontouch( ... )
	--触摸
	--实现事件触发回调
	local function onTouchBegan(touch, event)
		--人物行走调用
        local rect = cc.rect(0, self.visibleSize.height - self.bg:getContentSize().height*0.85,self.bg:getContentSize().width, self.bg:getContentSize().height)  
  
        if cc.rectContainsPoint(rect, touch:getLocation()) then  
           local gril_pointx = self.grossini:getPositionX()
           local touchlocation = touch:getLocation()
           self.dianji:getAnimation():playWithIndex(0,-1,-1)
           self.dianji:setPosition(cc.p(touchlocation.x,touchlocation.y))
           self:Girl_bg_move(touchlocation.x,touchlocation.y)
           else
        end  
         
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
        if delta>0   then
            self.grossini:setScaleX(-0.25)
            self.grossini:setScaleY(0.25)
            else
                self.grossini:setScaleX(0.25)
                self.grossini:setScaleY(0.25)
        end
         --是否下蹲着 
        if UItool:getCurrentState()=="xiadun" then
            self.delaystand = cc.DelayTime:create(0)
            self.tingdun = 2
            -- print("917 蹲着呢")
            -- self.grossini:getAnimation():play("squat_2")--站起来
            UItool:setCurrentState("stand")
            else
                self.delaystand = cc.DelayTime:create(0)
                self.tingdun = 0
                -- print(" 923 没蹲着")
        end

        -- 继续点击的时候是否连续
        if self.grossini:getScaleX()>0  and X < gril_pointx then
            -- print("self.grossini:getScaleX() > 0 , 脸是左朝向 点击左边")
            if self.grossini:getNumberOfRunningActions()>0  then
                self.grossini:stopAction(self.sequence)
                self.bg:stopAction(self.bgmove)
            else

                if UItool:getCurrentState()=="stand" then
                    self.grossini:getAnimation():play("walk")
                    UItool:setCurrentState("stand")
                end
                
            end

             elseif self.grossini:getScaleX() > 0  and X > gril_pointx then
                -- print("self.grossini:getScaleX() > 0 ，脸是左朝向  点击右边")
                if self.grossini:getNumberOfRunningActions()>0  then
                    self.grossini:stopAction(self.sequence)
                    self.bg:stopAction(self.bgmove)
                else
                    if UItool:getCurrentState()=="stand" then
                        
                        self.grossini:getAnimation():play("walk")
                        UItool:setCurrentState("stand")
                    end
                    
                end

                elseif self.grossini:getScaleX() < 0  and X > gril_pointx then
                    -- print("self.grossini:getScaleX() < 0 ，脸是右朝向  点击右边")
                    if self.grossini:getNumberOfRunningActions()>0  then
                        self.grossini:stopAction(self.sequence)
                        self.bg:stopAction(self.bgmove)
                    else
                        if UItool:getCurrentState()=="stand" then
                            self.grossini:getAnimation():play("walk")
                            UItool:setCurrentState("stand")
                        end
                    
                    end

                    elseif self.grossini:getScaleX() < 0  and X < gril_pointx then
                        -- print("self.grossini:getScaleX() < 0 ，脸是右朝向  点击左边")
                        if self.grossini:getNumberOfRunningActions()>0  then
                            self.grossini:stopAction(self.sequence)
                            self.bg:stopAction(self.bgmove)
                        else
                            if UItool:getCurrentState()=="stand" then
                                self.grossini:getAnimation():play("walk")
                                UItool:setCurrentState("stand")
                            end
                    
                    end
            end
    --人物位置
        local gril_pointx = self.grossini:getPositionX()
        local delta =  apoint - gril_pointx
        --距离
        local x = apoint-self.visibleSize.width/2
        local x2 = self.bg:getPositionX()+ self.visibleSize.width
    --速度
        local speed = 390
    --时间
        self.time = delta / speed  --普通距离
        self.time1 = math.abs((math.abs(delta)-math.abs(x)))/speed -- 人物到中间的时候
        self.time2 = math.abs( self.bg:getPositionX() ) / speed  --地图最左边的时候
        self.time3 = x2 /speed --地图到最右边的时候
        --面部朝向
        if delta>0   then
            self.grossini:setScaleX(-0.25)
            self.grossini:setScaleY(0.25)
            else
                self.grossini:setScaleX(0.25)
                self.grossini:setScaleY(0.25)
        end
        --一步
        local function onestep()
           
        end

        local function threestep()
            self.grossini:getAnimation():play("stand")
            event = event or nil 
            if event ~= nil  then
                
                event()
                else
                    
                    
            end
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
                end
                
                elseif self.grossini:getPositionX()>self.visibleSize.width/2 then
                    --人物在右边的时候
                    -- print("l人物在右边的时候")
                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time1), cc.p(self.visibleSize.width/2 ,self.grossini:getPositionY()))
                    elseif self.grossini:getPositionX()==self.visibleSize.width/2 then
                        --人物在中间的时候
                        -- print("l人物在中间的时候")
                        if self.bg:getPositionX()<0  then
                            
                            if self.bg:getPositionX()<delta  then
                                -- print("l地图小于")
                                self.bgmove=cc.MoveBy:create( math.abs(self.time), cc.p(-delta,self.bg:getPositionY()))
                                self.bg:runAction(self.bgmove)
                                else
                                    -- print("l地图大于")
                                    self.bgmove=cc.MoveTo:create( math.abs(self.time2), cc.p(0,self.bg:getPositionY()))
                                    self.bg:runAction(self.bgmove)
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
                    end
                
                elseif self.grossini:getPositionX()>self.visibleSize.width/2 then
                    --人物在右边的时候
                    -- print("r人物在右边的时候")
                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                     elseif self.grossini:getPositionX()==self.visibleSize.width/2 then
                        -- print("r人物在中间的时候")
                        if self.bg:getPositionX() <= 0 and self.bg:getPositionX() > self.visibleSize.width-self.bg:getContentSize().width then
                            if self.bg:getPositionX()+ self.visibleSize.width>apoint-self.visibleSize.width/2 then
                                self.bgmove=cc.MoveBy:create( math.abs(self.time), cc.p(-delta,self.bg:getPositionY()))
                                self.bg:runAction(self.bgmove)
                                else
                                    self.bgmove=cc.MoveTo:create( math.abs(self.time3), cc.p(self.visibleSize.width-self.bg:getContentSize().width,self.bg:getPositionY()))
                                    self.bg:runAction(self.bgmove)
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
                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.delaystand,self.girlmoveto,cc.CallFunc:create(threestep))
                        elseif self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width and
                    apoint < self.visibleSize.width/2 then
                            self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                            
            end
            --背景不在边上的时候
            if self.bg:getPositionX()~=0 and self.bg:getPositionX() ~= self.visibleSize.width-self.bg:getContentSize().width then
                if apoint>self.visibleSize.width/2 then
                    if self.bg:getPositionX()+ self.visibleSize.width>apoint-self.visibleSize.width/2 then
                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                        
                        else
                            self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay3,self.girlmoveto,cc.CallFunc:create(threestep))
                            
                    end
                    else
                        if self.bg:getPositionX()<delta then
                            self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                            
                            else
                                self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay2,self.girlmoveto,cc.CallFunc:create(threestep))
                        end
                end
                else
            end

            else

                -- 人物不在中间
                
                
                -- print("停顿时间",self.tingdun)
                self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.delaystand,self.girlmoveto,cc.CallFunc:create(threestep))
        end
        self.grossini:runAction(self.sequence)
end


return Mainscene



























