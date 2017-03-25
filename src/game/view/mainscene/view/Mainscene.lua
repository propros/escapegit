
require("game/view/mainscene/onescene/PlayerLayer")
Mainscene=class("Mainscene", function()
    return cc.Scene:create()
end)

Mainscene.panel = nil
function Mainscene:ctor()

	self.director = cc.Director:getInstance()
	self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    self.node = cc.Node:create()
    self.node:addTo(self)
    -- 家具底层
    self.panel = cc.CSLoader:createNode(Config.RES_MAINSCENE)
    self.panel:setPosition(cc.p(0,0))
    self:addChild(self.panel)
    --主节点
    self.node =  self.panel:getChildByName("Node_left_bottom")
    --背景
    self.bg = self.node:getChildByName("bg")
    self.bg:setPosition(cc.p(0,0))
    --家具
    self.furniture = self.bg:getChildByName("furniture")

    ---[[
	self.grossini = cc.Sprite:create("walk/w1.png")
    self.grossini:setAnchorPoint(cc.p(0.5,0))
    self.grossini:setScaleX(-1)
    self.grossini:setPosition(cc.p(self.grossini:getContentSize().width,self.grossini:getContentSize().height*0.1))
    self.grossini:addTo(self)
    
    --]]
    -- 
    self.scheduler = nil -- 定时器
    self.goscheduler = nil --过关定时器
    self.m_isAnimationing = nil 

    self:ontouch()
    self:AllButtons()

    self.runtime = nil 

    local button = ccui.Button:create("bu_back1.png","bu_back1.png")
    button:setAnchorPoint(cc.p(1,1))
    button:setPosition(cc.p(self.visibleSize.width - button:getContentSize().width + 30 , self.visibleSize.height/1.03))        
    self:addChild(button,10)
    button:setSwallowTouches(true)

    button:addClickEventListener(function ( psender,event )
        if  UItool:getBool("merge") then
            if #ModifyData.getTable() == 0    then
            UItool:message2("你的物品栏是空的",30)
            else
                UItool:setBool("merge", false)
                local merge = Merge:createScene()
                self:addChild(merge,5)
            end
        end
        
    end)


    local function update(delta)  
        self:update(delta)  
    end  
    self:scheduleUpdateWithPriorityLua(update,0.1)


end

local bed_upnum = 1
function Mainscene:bed_up()
    --床上
    print("bed_up")
    if bed_upnum>1 then
        UItool:message2("墙上怎么挂着别人的照片",30)
        else
            local function bed_ups( select )
                if select == "yes" then
                    local bed_up_location = UItool:getitem_location(self.furniture:getChildByName("bed_up"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( bed_up_location ,event)
                    bed_upnum = bed_upnum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("前面好像有线索，\n要去查看一下嘛？",30,bed_ups)
    end
end

local bed_downnum = 1
function Mainscene:bed_down()
    --床底
    if bed_downnum>1 then
        UItool:message2("花瓶好漂亮啊",30)
        else
            local function bed_downs( select )
                if select == "yes" then
                    local bed_down_location = UItool:getitem_location(self.furniture:getChildByName("bed_down"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( bed_down_location ,event)
                    bed_downnum = bed_downnum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("前面好像有线索，\n要去查看一下嘛？",30,bed_downs)
    end
end 

local bedside_tablenum = 1
function Mainscene:bedside_table()
    --床头柜
    print("bedside_table")
    if bedside_tablenum==2 then

        UItool:password("1502",1) -- 密码四

        else
            local function bedside_tables( select )
                if select == "yes" then
                    local bedside_table_location = UItool:getitem_location(self.furniture:getChildByName("bedside_table"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( bedside_table_location ,event)
                    bedside_tablenum = bedside_tablenum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("前面好像有物品，\n要去查看一下嘛？",30,bedside_tables)
    end
end

local L_curtainnum = 1
function Mainscene:L_curtain()
    --左窗帘
    print("L_curtain")

    if L_curtainnum>1 then
        local L_curtain_location1 = UItool:getitem_location(self.furniture:getChildByName("L_curtain"):getPositionX(), self.bg:getPositionX())
        self:grossiniwalk()
        self:Girl_bg_move( L_curtain_location1 ,function (  )
            UItool:message2("（3572）",30)
        end)

        else
            local function L_curtains(select)
                if select == "yes" then
                    print(" L_curtains  yes ")
                    local L_curtain_location1 = UItool:getitem_location(self.furniture:getChildByName("L_curtain"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( L_curtain_location1 ,event)
                    L_curtainnum = L_curtainnum + 1
                    elseif select == "no" then    
                    print("  no ")  
                end
            end
            UItool:message("前面好像有物品，\n要去查看一下嘛？",30,L_curtains)
    end
end

local clicknum = 0
local R_curtainnum = 1
function Mainscene:R_curtain()
    --右窗帘
    print("R_curtain")
    if R_curtainnum>1 then        
        -- self:R_curtain_tentimes()
        clicknum = clicknum+1
        if clicknum==5  then

           UItool:message2(" 你的到了一把钥匙放在了包里  ",30)
           local key_item = Data.getItemData(5)
           ModifyData.tableinsert(key_item.key)
        end
        print("number == %d",clicknum)
        else
            local function R_curtains(select)
                if select == "yes" then
                    print("是的")
                    local R_curtain_location1 = UItool:getitem_location(self.furniture:getChildByName("R_curtain"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( R_curtain_location1 ,event)
                    R_curtainnum = R_curtainnum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("好像有什么东西, \n要过去查看一下嘛 ？",30,R_curtains)
                
    end
end

local toilet_glassnum = 1
function Mainscene:toilet_glass()
    --梳妆台-镜子
    print("toilet_glass")
    if toilet_glassnum>1 then
        UItool:message2(" 我倒映出了凳子 ",30 )
        else
            local function toilet_glasss(select)
                if select == "yes" then
                    print("是的")
                    local toilet_glass_location1 = UItool:getitem_location(self.furniture:getChildByName("toilet_glass"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( toilet_glass_location1 ,event)
                    toilet_glassnum = toilet_glassnum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("好像有什么东西, \n要过去查看一下嘛 ？",30,toilet_glasss)
    end
end

local toilet_drawernum = 1
function Mainscene:toilet_drawer()
    --梳妆台-抽屉
    print("toilet_drawer")
    if toilet_drawernum>1 then
        UItool:password("0311",11)
        else
            local function toilet_drawers( select )
                if select == "yes" then
                    local toilet_drawer_location = UItool:getitem_location(self.furniture:getChildByName("toilet_drawer"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( toilet_drawer_location ,event)
                    toilet_drawernum = toilet_drawernum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("前面好像有物品，\n要去查看一下嘛？",30,toilet_drawers)
    end
end
local stoolnum = 1
function Mainscene:stool()
    --凳子
    print("stool")
    if stoolnum>1 then
        UItool:message2(" 两个物品加起来可能会有效 ",30 )
        else
            local function stools(select)
                if select == "yes" then
                    print("是的")
                    local stool_location1 = UItool:getitem_location(self.furniture:getChildByName("stool"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( stool_location1 ,event)
                    stoolnum = stoolnum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("好像有什么东西, \n要过去查看一下嘛 ？",30,stools)
    end

end

local wardrobenum = 1
function Mainscene:wardrobe()
    --衣柜
    print("wardrobe")
    if wardrobenum>1 then
        if UItool:ifcontain( 5 ) then
            UItool:message2(" 得到一个箱子 ,钥匙消失 ",30 )
            local key_item = Data.getItemData(3)
            ModifyData.tableinsert(key_item.key)
            for i=1,#ModifyData.getTable() do
                if ModifyData.getTable()[i] == 5 then
                     table.remove(ModifyData.getTable(),i) 
                     break
                end
            end
        end
        else
            local function wardrobess(select)
                if select == "yes" then
                    print("是的")
                    local wardrobe_location1 = UItool:getitem_location(self.furniture:getChildByName("wardrobe"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( wardrobe_location1 ,event)
                    wardrobenum = wardrobenum + 1
                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("好像有什么东西, \n要过去查看一下嘛 ？",30,wardrobess)
    end
end

local cushionnum = 1
function Mainscene:cushion()
    --靠垫
    print("cushion")
    if cushionnum>1 then
           UItool:message2(" 得到一个护身符 ",30 )
           local key_item = Data.getItemData(4)
            ModifyData.tableinsert(key_item.key)
        else
            local function cushions(select)
                if select == "yes" then
                    print("是的")
                    local cushion_location1 = UItool:getitem_location(self.furniture:getChildByName("cushion"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( cushion_location1 ,event)
                    cushionnum = cushionnum + 1
                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("好像有什么东西, \n要过去查看一下嘛 ？",30,cushions)
    end
end


local B_vasenum = 1
function Mainscene:B_vase()
    --大花瓶
    print("B_vase")
    if B_vasenum>1 then
           UItool:message2(" 鲜花插在花瓶中 ",30 )
        else
            local function B_vases(select)
                if select == "yes" then
                    print("是的")
                    local B_vase_location1 = UItool:getitem_location(self.furniture:getChildByName("B_vase"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( B_vase_location1 ,event)
                    B_vasenum = B_vasenum + 1
                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("好像有什么东西, \n要过去查看一下嘛 ？",30,B_vases)
    end
end

local S_vasenum = 1
function Mainscene:S_vase()
    --小花瓶
    print("S_vase")
    if S_vasenum>1 then
        UItool:message2(" 你好像在找东西，1502 ",30 )
        else
            local function S_vases(select)
                if select == "yes" then
                    print("是的")
                    local stool_location1 = UItool:getitem_location(self.furniture:getChildByName("S_vase"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( stool_location1 ,event)
                    S_vasenum = S_vasenum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("好像有什么东西, \n要过去查看一下嘛 ？",30,S_vases)
    end
end

local sofabacknum = 1
function Mainscene:sofaback()
    --沙发背
    print("sofaback")
    if sofabacknum>1 then
        
           UItool:message2(" 沙发不能移动 ",30 )
        
        else
            local function sofabacks(select)
                if select == "yes" then
                    print("是的")
                    local sofaback_location1 = UItool:getitem_location(self.furniture:getChildByName("sofaback"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( sofaback_location1 ,event)
                    sofabacknum = sofabacknum + 1
                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("好像有什么东西, \n要过去查看一下嘛 ？",30,sofabacks)
    end
end



local bookshelf_onenum = 1
function Mainscene:bookshelf_one()
    --书架一
    print("bookshelf_one")
    if bookshelf_onenum>1 then
        UItool:message2(" 这都是书  ",30 )
        else
            local function bookshelf_ones(select)
                if select == "yes" then
                    print("是的")
                    local bookshelf_one_location1 = UItool:getitem_location(self.furniture:getChildByName("bookshelf_one"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( bookshelf_one_location1 ,event)
                    bookshelf_onenum = bookshelf_onenum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("好像有什么东西, \n要过去查看一下嘛 ？",30,bookshelf_ones)
    end
end

local bookshelf_twonum = 1
function Mainscene:bookshelf_two()
    --书架二
    print("bookshelf_two")
    if bookshelf_twonum>1 then
        if bookshelf_twonum == 4  then
            local key_item = Data.getItemData(9)
            ModifyData.tableinsert(key_item.key) 
            UItool:message2("得到了一张纸",30)
            
        end
        bookshelf_twonum = bookshelf_twonum + 1
        else
            local function bookshelf_twonums( select )
                if select == "yes" then
                    local bookshelf_two_location = UItool:getitem_location(self.furniture:getChildByName("bookshelf_two"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( bookshelf_two_location ,event)
                    bookshelf_twonum = bookshelf_twonum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("前面好像有线索，\n要去查看一下嘛？",30,bookshelf_twonums)
    end

end

local L_drawernum = 1
function Mainscene:L_drawer()
    print("L_drawer")
    if L_drawernum>1 then
           UItool:password("3572")
        else
            local function L_drawers(select)
                if select == "yes" then
                    print("是的")
                    local L_drawer_location1 = UItool:getitem_location(self.furniture:getChildByName("L_drawer"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( L_drawer_location1 ,event)
                    L_drawernum = L_drawernum + 1
                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("好像有什么东西, \n要过去查看一下嘛 ？",30,L_drawers)
    end
end

local R_drawernum = 1
function Mainscene:R_drawer()
    print("R_drawer")
    if R_drawernum>1 then
        UItool:password("1011",6) -- 密码3
        else
            local function R_drawers( select )
                if select == "yes" then
                    local R_drawer_location = UItool:getitem_location(self.furniture:getChildByName("R_drawer"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( R_drawer_location ,event)
                    R_drawernum = R_drawernum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("前面好像有物品，\n要去查看一下嘛？",30,R_drawers)
    end

end

local booknum = 1
function Mainscene:book()
    print("book")
    if booknum>1 then
        
        UItool:message2("  书是人类进步的阶梯  ",30)
        else
            local function books( select )
                if select == "yes" then
                    local book_location = UItool:getitem_location(self.furniture:getChildByName("book"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( book_location ,event)
                    booknum = booknum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("前面好像有线索，\n要去查看一下嘛？",30,books)
    end
end

local Pintunum = 1
function Mainscene:Pintu()
    print("Pintu")
    if Pintunum>1 then
        if UItool:ifcontain( 8 ) then
           local PlayerLayer = PlayerLayer:createScene()
            print("进入拼图界面", PlayerLayer)
            self:addChild(PlayerLayer,125)
            else
                UItool:message2("缺少东西浸润它 ",30)
        end
        else
            local function Pintus( select )
                if select == "yes" then
                    local Pintu_location = UItool:getitem_location(self.furniture:getChildByName("Pintu"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( Pintu_location ,event)
                    Pintunum = Pintunum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("前面好像有线索，\n要去查看一下嘛？",30,Pintus)
    end

end

local wardrobe_drawer_1num = 1
function Mainscene:wardrobe_drawer_1()
    --立柜抽屉一层
    print("wardrobe_drawer_1")
    if wardrobe_drawer_1num>1 then
        if wardrobe_drawer_1num==10  then
           UItool:message2(" 数字（0311）  ",30)
        end
        wardrobe_drawer_1num = wardrobe_drawer_1num+1
        print("number == %d",wardrobe_drawer_1num)
        else
            local function wardrobe_drawer_1s(select)
                if select == "yes" then
                    print("是的")
                    local R_curtain_location1 = UItool:getitem_location(self.furniture:getChildByName("wardrobe_drawer_1"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( R_curtain_location1 ,event)
                    wardrobe_drawer_1num = wardrobe_drawer_1num + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("好像有什么东西, \n要过去查看一下嘛 ？",30,wardrobe_drawer_1s)
                
    end
end

local wardrobe_drawer_2num = 1
function Mainscene:wardrobe_drawer_2()
    print("wardrobe_drawer_2")
    if wardrobe_drawer_2num == 2 then
        UItool:password("1837",7)
        else
            local function wardrobe_drawer_2s( select )
                if select == "yes" then
                    local wardrobe_drawer_2_location = UItool:getitem_location(self.furniture:getChildByName("wardrobe_drawer_2"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( wardrobe_drawer_2_location ,event)
                    wardrobe_drawer_2num = wardrobe_drawer_2num + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("前面好像有线索，\n要去查看一下嘛？",30,wardrobe_drawer_2s)
    end
end

local wardrobe_drawer_3num = 1
function Mainscene:wardrobe_drawer_3()
    print("wardrobe_drawer_3")
    if wardrobe_drawer_3num>1 then
        -- if UItool:ifcontain( 1 ) then
           UItool:message2(" 好像被锁住了 ",30 )
        -- end

        else
            local function wardrobe_drawer_3s(select)
                if select == "yes" then
                    print(" L_curtains  yes ")
                    local L_curtain_location1 = UItool:getitem_location(self.furniture:getChildByName("wardrobe_drawer_3"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( L_curtain_location1 ,event)
                    wardrobe_drawer_3num = wardrobe_drawer_3num + 1
                    elseif select == "no" then    
                    print("  no ")  
                end
            end
            UItool:message("前面好像有物品，\n要去查看一下嘛？",30,wardrobe_drawer_3s)
    end

end

local phonenum = 1
function Mainscene:phone()
    print("phone")
    if wardrobe_drawer_3num>1 then
        UItool:message2(" 电话沟通你我他 ",30 )
        else
            local function wardrobe_drawer_3s(select)
                if select == "yes" then
                    print(" L_curtains  yes ")
                    local L_curtain_location1 = UItool:getitem_location(self.furniture:getChildByName("wardrobe_drawer_3"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( L_curtain_location1 ,event)
                    wardrobe_drawer_3num = wardrobe_drawer_3num + 1
                    elseif select == "no" then    
                    print("  no ")  
                end
            end
            UItool:message("前面好像有物品，\n要去查看一下嘛？",30,wardrobe_drawer_3s)
    end
end

local wardrobe_albumnum = 1
function Mainscene:wardrobe_album()
    print("wardrobe_album")
    if wardrobe_albumnum>1 then
        -- UItool:message2("线索一",30)
        else
            local function wardrobe_albums( select )
                if select == "yes" then
                    local wardrobe_album_location = UItool:getitem_location(self.furniture:getChildByName("wardrobe_album"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( wardrobe_album_location ,event)
                    wardrobe_albumnum = wardrobe_albumnum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("前面好像有线索，\n要去查看一下嘛？",30,wardrobe_albums)
    end

end

local doornum = 1
function Mainscene:door()
    print("door")
    --门 
    if doornum == 2 then
        if UItool:ifcontain( 6 ) then
           UItool:message2(" 门打开，你可以出去了 。 ",30 )

        end
        
        else
            local function doors( select )
                if select == "yes" then
                    local door_location = UItool:getitem_location(self.furniture:getChildByName("door"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( door_location ,event)
                    doornum = doornum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("你要出去嘛 ？，好像需要先得到钥匙。既然你想过去，就去看看吧。",30,doors)
    end

    

end

local Big_framenum = 1
function Mainscene:Big_frame()
    print("Big_frame")
    if Big_framenum>1 then
        UItool:message2("房间的一切尽在我眼中",30)
        else
            local function Big_frames( select )
                if select == "yes" then
                    local bed_up_location = UItool:getitem_location(self.furniture:getChildByName("Big_frame"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( bed_up_location ,event)
                    Big_framenum = Big_framenum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("前面好像有线索，\n要去查看一下嘛？",30,Big_frames)
    end
end

local hua_framenum = 1
function Mainscene:hua_frame()
    print("hua_frame")
    if hua_framenum>1 then
        UItool:message2(" 知识就是力量 ",30 )
        else
            local function hua_frames(select)
                if select == "yes" then
                    print("是的")
                    local toilet_glass_location1 = UItool:getitem_location(self.furniture:getChildByName("hua_frame"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( toilet_glass_location1 ,event)
                    hua_framenum = hua_framenum + 1

                    elseif select == "no" then
                        print("不去")
                end
            end
            UItool:message("好像有什么东西, \n要过去查看一下嘛 ？",30,hua_frames)
    end
end

local yuan_framenum = 1
function Mainscene:yuan_frame()
    print("yuan_frame")

    if yuan_framenum>1 then
        
        UItool:message2(" 我最高你碰不到 ",30)

        else
            local function yuan_framenums(select)
                if select == "yes" then
                    print(" L_curtains  yes ")
                    local L_curtain_location1 = UItool:getitem_location(self.furniture:getChildByName("yuan_frame"):getPositionX(), self.bg:getPositionX())
                    self:grossiniwalk()
                    self:Girl_bg_move( L_curtain_location1 ,event)
                    yuan_framenum = yuan_framenum + 1
                    elseif select == "no" then    
                    print("  no ")  
                end
            end
            UItool:message("前面好像有物品，\n要去查看一下嘛？",30,yuan_framenums)
    end
end

local frame_1num = 1
function Mainscene:frame_1()
    print("frame_1")
end

local frame_2num = 1
function Mainscene:frame_2()
    print("frame_2")
end

local frame_3num = 1
function Mainscene:frame_3()
    print("frame_3")
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
            self.furniture:getChildByName("frame_1"),
            self.furniture:getChildByName("frame_2"),
            self.furniture:getChildByName("frame_3")

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
                                                                                                                        elseif event:getName()=="frame_1" then
                                                                                                                            print("··frame_1·")
                                                                                                                            self:frame_1()
                                                                                                                            elseif event:getName()=="frame_2" then
                                                                                                                                print("··frame_2·")
                                                                                                                                self:frame_2()
                                                                                                                                elseif event:getName()=="frame_3" then
                                                                                                                                    print("·frame_3··")
                                                                                                                                    self:frame_3()
                                                                                                                                    elseif event:getName()=="yuan_frame" then
                                                                                                                                        print("yuan_frame")
                                                                                                                                        self:yuan_frame()
                                                                                                                 
            end
        end
    end
    for key, var in pairs(self.AllButtons) do
        if self.grossini:getNumberOfRunningActions()>0 or self.bg:getNumberOfRunningActions()>0 then
            print("状态在运行中。")
            else
                print("状态没有运行。")
                var:addClickEventListener(renwu_haoyou_shezhiButtonClick)
                var:setSwallowTouches(true)
        end
    end
end

function Mainscene:update( delta )
    
    if self.grossini:getNumberOfRunningActions()>0 or self.bg:getNumberOfRunningActions()>0 then
        for key, var in pairs(self.AllButtons) do
            var:setTouchEnabled(false)
            var:setSwallowTouches(true)
        end
        else
            for key, var in pairs(self.AllButtons) do
                var:setTouchEnabled(true)
                var:setSwallowTouches(true)
        end
    end

end

    --角色移动
function Mainscene:grossiniwalk()
    local animation = cc.Animation:create()  
    local name  
    for i = 1, 4 do  
    
    name = "walk/w"..i..".png"  
    -- 用图片名称加一个精灵帧到动画中  
     animation:addSpriteFrameWithFile(name)  
    end   
  -- 在2.8秒内持续14帧  
     animation:setDelayPerUnit(1.5 / 4.0)  
  -- 设置"当动画结束时,是否要存储这些原始帧"，true为存储  
      animation:setRestoreOriginalFrame(false)  
  
  -- 创建序列帧动画  
    local action = cc.Animate:create( animation) 
     local repeatForevers = cc.RepeatForever:create(action)
     repeatForevers:setTag(22)
    self.grossini:runAction( repeatForevers)

    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/walk/walkstand.ExportJson") 
    -- self.grossini = ccs.Armature:create("walkstand")
    -- self.grossini:getAnimation():playWithIndex(3, -1, 1)
    -- self.grossini:getAnimation():setSpeedScale(0.2)
    -- self.grossini:setPosition(cc.p(100,125))
    -- self.bg:addChild(self.grossini,125)
end

function Mainscene:ontouch( ... )
	-- body
	--实现事件触发回调
	local function onTouchBegan(touch, event)
		--人物行走调用
        self.m_isAnimationing = true
        if self.grossini:getNumberOfRunningActions()>0 or self.bg:getNumberOfRunningActions()>0 then
            self.grossini:stopAllActions()
            self.bg:stopAllActions()
            else
        end
        self:grossiniwalk()
        return true
		
	end

	local function onTouchMoved(touch, event)	
	end

	local function onTouchEnded(touch, events)
        local touchs= touch:getLocation()
        self:Girl_bg_move(touchs.x)
	end
	local listener = cc.EventListenerTouchOneByOne:create() -- 创建一个事件监听器
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

	local eventDispatcher = self:getEventDispatcher() -- 得到事件派发器
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self) -- 将监听器注册到派发器中

end

function Mainscene:Girl_bg_move(touch, event)
    --点击位置
        local apoint = touch
    --人物位置
        local gril_pointx = self.grossini:getPositionX()
        local delta =  apoint - gril_pointx
        --距离
        local x = apoint-self.visibleSize.width/2
        local x2 = self.bg:getPositionX()+ self.visibleSize.width
    --速度
        local speed = 160
    --时间
        self.time = delta / speed  --普通距离
        self.time1 = math.abs((math.abs(delta)-math.abs(x)))/speed -- 人物到中间的时候
        self.time2 = math.abs( self.bg:getPositionX() ) / speed  --地图最左边的时候
        self.time3 = x2 /speed --地图到最右边的时候
        --面部朝向
        if delta>0   then
            self.grossini:setScaleX(-1)
            else
                self.grossini:setScaleX(1)
        end
        --一步，屏蔽层
        local function onestep()
            -- self.layer=cc.Layer:create()
            -- local shildinglayer = Shieldingscreen:new()
            -- self.layer:addChild(shildinglayer)
            -- self.layer:addTo(self,6)
        end
        -- 取消屏蔽层 停止动作
        self.callback = function () end 
        local function threestep()
            -- self.layer:removeFromParent()
            self.grossini:stopActionByTag(22)
            event = event or nil 
            if event ~= nil  then
                print("event  ~= nil ")
                event()
                else
                    print("event == nil ")
                    
            end
        end

        if apoint<self.visibleSize.width/2 then
            --点击在左边的时候
            print("l点击在左边的时候")
            if self.grossini:getPositionX()<self.visibleSize.width/2 then
                --人物在左边的时候
                print("l人物在左边的时候")
                if self.bg:getPositionX()==0 then
                    print("l地图在原点")
                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                    self.runtime = math.abs(self.time)
                end
                
                elseif self.grossini:getPositionX()>self.visibleSize.width/2 then
                    --人物在右边的时候
                    print("l人物在右边的时候")
                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time1), cc.p(self.visibleSize.width/2 ,self.grossini:getPositionY()))
                    self.runtime = math.abs(self.time1)
                    elseif self.grossini:getPositionX()==self.visibleSize.width/2 then
                        --人物在中间的时候
                        print("l人物在中间的时候")
                        if self.bg:getPositionX()<0  then
                            
                            if self.bg:getPositionX()<delta  then
                                print("l地图小于")
                                self.bgmove=cc.MoveBy:create( math.abs(self.time), cc.p(-delta,self.bg:getPositionY()))
                                self.bg:runAction(self.bgmove)
                                self.runtime = math.abs(self.time)
                                else
                                    print("l地图大于")
                                    self.bgmove=cc.MoveTo:create( math.abs(self.time2), cc.p(0,self.bg:getPositionY()))
                                    self.runtime = math.abs(self.time2)
                                    self.bg:runAction(self.bgmove)
                            end
                            elseif self.bg:getPositionX()==0 then
                                self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                                self.runtime = math.abs(self.time)
                        end
            end

            elseif apoint>self.visibleSize.width/2 then
                --点击在右边的时候
                print("r点击在右边的时候")
                if self.grossini:getPositionX()<self.visibleSize.width/2 then
                    --人物在左边的时候
                    print("r人物在左边的时候")
                    if self.bg:getPositionX()==0 then
                        print("r地图在原点")
                        self.girlmoveto = cc.MoveTo:create(math.abs(self.time1), cc.p(self.visibleSize.width/2 ,self.grossini:getPositionY()))
                        self.runtime = math.abs(self.time1)
                    end
                
                elseif self.grossini:getPositionX()>self.visibleSize.width/2 then
                    --人物在右边的时候
                    print("r人物在右边的时候")
                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                    self.runtime = math.abs(self.time)
                     elseif self.grossini:getPositionX()==self.visibleSize.width/2 then
                        print("r人物在中间的时候")
                        if self.bg:getPositionX() <= 0 and self.bg:getPositionX() > self.visibleSize.width-self.bg:getContentSize().width then
                            if self.bg:getPositionX()+ self.visibleSize.width>apoint-self.visibleSize.width/2 then
                                self.bgmove=cc.MoveBy:create( math.abs(self.time), cc.p(-delta,self.bg:getPositionY()))
                                self.runtime = math.abs(self.time)
                                self.bg:runAction(self.bgmove)
                                else
                                    self.bgmove=cc.MoveTo:create( math.abs(self.time3), cc.p(self.visibleSize.width-self.bg:getContentSize().width,self.bg:getPositionY()))
                                    self.bg:runAction(self.bgmove)
                                    self.runtime = math.abs(self.time3)
                            end
                            elseif self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width then
                                print("r画面在最左的时候")
                                self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                                self.runtime = math.abs(self.time)
                        end
            end
            
        end

        local delay = cc.DelayTime:create(math.abs(self.time))
        local delay1 = cc.DelayTime:create(math.abs(self.time1))
        local delay2 = cc.DelayTime:create(math.abs(self.time2))-- zuo
        local delay3 = cc.DelayTime:create(math.abs(self.time3))--you
        

        if self.grossini:getPositionX() == self.visibleSize.width/2 then

            if self.bg:getPositionX() == 0 and apoint > self.visibleSize.width/2  then
                self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                
                elseif self.bg:getPositionX() == 0 and apoint < self.visibleSize.width/2 then

                    self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
                    
                    elseif self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width and 
                    apoint >self.visibleSize.width/2  then

                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
                        
                        elseif self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width and
                    apoint < self.visibleSize.width/2 then

                            self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                            
            end
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
                print("682")
                self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
        end
        self.grossini:runAction(self.sequence)
end


return Mainscene



























