
require("game/view/mainscene/onescene/PlayerLayer")
Mainscene=class("Mainscene", function()
    return cc.Scene:create()
end)
function Mainscene:ctor()

	self.director = cc.Director:getInstance()
	self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    self.node = cc.Node:create()
    self.node:addTo(self)

    self.bg = cc.Sprite:create("bg/bg.png")
    self.bg:setPosition(cc.p(0,0))
    self.bg:setAnchorPoint(cc.p(0,0))
    self.bg:addTo(self)

    local fbg = cc.Sprite:create("bg/fbg.png")
    fbg:setPosition(cc.p(0,0))
    fbg:setAnchorPoint(cc.p(0,0))
    fbg:addTo(self.bg,1)

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

    self:ontouch()
    self:AllMenu()

    local function update()
        if Data.getItemData(8).appear then
        print("true")
         UItool:message("通关 通关",30)
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.goscheduler)
        else
            print("false")
        end
    end


    self.goscheduler=cc.Director:getInstance():getScheduler():scheduleScriptFunc(update,1,false)
    -- self.scheduler=cc.Director:getInstance():getScheduler():scheduleScriptFunc(reorderSprite,self.time,false)
end

function Mainscene:updates()
    
end

function Mainscene:AllMenu()

	local frontnode = cc.Node:create()
    frontnode:addTo(self.bg,2)

    local function playMusic()
        --
        -- local onescene = Onescene:createScene()
        -- self:addChild(onescene)
        local scene = PlayerLayer.new()
        local turn = cc.TransitionPageTurn:create(0.5, scene, false)
        cc.Director:getInstance():replaceScene(turn)

    end

    local function menuscallback()
    	--菜单
    	print("menuscallback")
        local onetextdata = Data.gettextData(2)
        local alert = ccui.Text:create()
	    alert:setString(onetextdata.text)
	    alert:setFontName(Zapfino)
	    alert:setFontSize(30)
	    alert:setColor(cc.c3b(251, 138, 38))
	    alert:setPosition(cc.p(500,500))
	    self:addChild(alert,5)
        
    end

    local function wardrobecallback( )
    	--衣柜
        UItool:message("凯瑟琳：\n时间的卡索拉就放开打mm,,\n,Menu/menu.pngMenu/menu.png",30)
        self:grossiniwalk()
        
        local item_location = UItool:getitem_location(self.wardrobe:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:Girl_bg_move( item_location ,event)
        

    end

    local function dressing_tablecallback( )
        -- 左化妆台 dressing_table
        print("左化妆台 dressing_table")
        local item_location = UItool:getitem_location(self.dressing_table:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:grossiniwalk()
        print("typetypetypetypetypetypetypetypetypetype")
        
        
        self.m_send = cc.Sprite:create("bg_zuichang.png")
        self.m_send:setPosition(cc.p(500,600))
        self:addChild(self.m_send,9)
        
        print("type: %s", type(self.m_send))

        self.m_sendField = ccui.TextField:create()
        self.m_sendField:setTouchEnabled(true)
        self.m_sendField:setFontSize(30)
        local size = self.m_send:getContentSize()
        self.m_sendField:setTouchSize(size)
        self.m_sendField:setPlaceHolder("input words here")
        self.m_sendField:setPosition(cc.p(size.width*0.5, size.height*0.5))
        self.m_send:addChild( self.m_sendField)

        print("type: %s", type(self.m_send))
        print("self.m_sendField type: %s", type(self.m_sendField))

        
        local widgetSize = cc.Director:getInstance():getWinSize()
        self._displayValueLabel = ccui.Text:create()
        self._displayValueLabel:setString("NodeContainer Add CCNode")
        -- self._displayValueLabel:setFontName(font_TextName)
        self._displayValueLabel:setFontSize(32)
        self._displayValueLabel:setAnchorPoint(cc.p(0.5, -1))
        self._displayValueLabel:setPosition(cc.p(widgetSize.width / 2.0, widgetSize.height / 1.2 + self._displayValueLabel:getContentSize().height * 1.5))
        self:addChild(self._displayValueLabel)


-- TEXTFIELD_EVENT_ATTACH_WITH_IME,
--     TEXTFIELD_EVENT_DETACH_WITH_IME,
--     TEXTFIELD_EVENT_INSERT_TEXT,
--     TEXTFIELD_EVENT_DELETE_BACKWARD,

-- TextFiledEventType.attach_with_ime
-- TextFiledEventType.detach_with_ime
-- TextFiledEventType.insert_text
-- TextFiledEventType.delete_backward

        local function textFieldEvent(sender, eventType)
            self._displayValueLabel:setString(self.m_sendField:getString())
            if sender == ccui.TEXTFIELD_EVENT_ATTACH_WITH_IME then
                local textField = sender
                local screenSize = cc.Director:getInstance():getWinSize()
                --点击输入框的时候，
                print("attach with IME")
            elseif sender == ccui.TEXTFIELD_EVENT_DETACH_WITH_IME then
                local textField = sender
                local screenSize = cc.Director:getInstance():getWinSize()
                --输入完，离开输入框
                -- self.firend_di:runAction(cc.MoveTo:create(0.125, cc.p(self.firend_di_X,self.firend_di_Y)))
                print("detach with IME")
                self._displayValueLabel:setString(self.m_sendField:getString())
                print("****************")
            elseif sender == ccui.TEXTFIELD_EVENT_INSERT_TEXT then
                --输入字符
                print("insert words")
            elseif sender == ccui.TEXTFIELD_EVENT_DELETE_BACKWARD then
                --删除字符
                print("delete word")
                else
                    print("没有没有没有")
            end

            if self.m_sendField:getString()=="12345" then
                print("otototototototototo")
                self._displayValueLabel:setString("succeed")
            end
            
        end
        self.m_sendField:addEventListener(textFieldEvent) 
        self:Girl_bg_move( item_location ,event)



    end

    local function stoolcallback()
        print(" 矮凳 stool 矮凳 stool 矮凳 stool 矮凳 stool 矮凳 stool")
        -- 矮凳 stool
        local item_location = UItool:getitem_location(self.stool:getPositionX(), self.bg:getPositionX())
         --girl walk
        self:grossiniwalk()
        -- bg && girl move
        self:Girl_bg_move( item_location ,event)
        local key_item = Data.getItemData(5)
        print("key_item  : ",key_item.pic)
         
        local function reorderSprite()
            print("&&&&&&&&&&")
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
            self.stool:setRotation(45)
            local function key_itemfun(event,eventType)
                if eventType == TOUCH_EVENT_ENDED then
                
                self.btn_key:setPosition(cc.p(self.stool:getPositionX()*2,500))
                ModifyData.tableinsert(key_item.key)
                print("ModifyData.tableinsert...")
                print("ModifyData.getTableNum()",ModifyData.getTableNum())
                
                end  
            end

            self.btn_key = ccui.Button:create(key_item.pic)
            self.btn_key:setAnchorPoint(cc.p(0,0))
            self.btn_key:setPosition(cc.p(self.stool:getPositionX(),500))
            self.btn_key:addTo(self,1)
            self.btn_key:addClickEventListener(key_itemfun)
        end
        

        self.scheduler=cc.Director:getInstance():getScheduler():scheduleScriptFunc(reorderSprite,self.time,false)
        
    end
local num = 1
    local function candlestickcallback()

        if num >= 2 then
            local item_location = UItool:getitem_location(self.candlestick:getPositionX(), self.bg:getPositionX())
            print("item_location ",item_location)
            self:grossiniwalk()
            self:Girl_bg_move( item_location ,event)
            print("zhutai location ", location)
            UItool:message(" 你get到了烛台技能 ",30)
            else
                local item_location = UItool:getitem_location(self.candlestick:getPositionX(), self.bg:getPositionX())
                print("item_location ",item_location)
                self:grossiniwalk()
                self:Girl_bg_move( item_location ,event)
                UItool:message(" 你再点击一下试试",30)
                num = num + 1
        end
        -- 烛台 candlestick
        

    end

    local function table_furniturecallback( )
        -- 家具桌 table_furniture
        print("家具桌 table_furniture")
        local item_location = UItool:getitem_location(self.mirror:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:grossiniwalk()
        self:Girl_bg_move( item_location ,event)
        print("jingzi location ", location)

    end

    local number = 1
    local function rackcallback()
        --衣架 rack

        self.scheduleras = nil
        local item_location = UItool:getitem_location(self.rack:getPositionX(), self.bg:getPositionX())
        self:grossiniwalk()
        self:Girl_bg_move( item_location ,event)
        local schedulers = cc.Director:getInstance():getScheduler()
        local function tentimes()
            print("tentimes")
            if number >=10 then
                --todo
                UItool:message(" 你打开了新技能 ",30)
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
                else
                    print("***********")
            end
        end
        

        if number>1 then
            --todo
            else
                self.scheduler = schedulers:scheduleScriptFunc(tentimes,3,false)
        end
        number = number+1
        print("number == %d",number)

    end

    local function toiletcallback()
        -- 抽屉
        if self.grossini:getPositionX()<self.visibleSize.width/2  then
            local item_location = UItool:getitem_location(self.toilet:getPositionX(), self.bg:getPositionX())
            --girl walk
            self:grossiniwalk()
            -- bg && girl move
            self:Girl_bg_move( item_location ,event)

            else
                print("抽屉 toilet")
                local item_location = UItool:getitem_location(self.toilet:getPositionX(), self.bg:getPositionX())
                --girl walk
                self:grossiniwalk()
                -- bg && girl move
                self:Girl_bg_move( item_location ,event)

                local padlock_item = Data.getItemData(6)
                print("padlock_item  : ",padlock_item.pic)

                -- 抽屉 toilet旋转45度 
                local function reorderSprite()
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
                    self.toilet:setRotation(45)
                    local function padlock_itemcall(event,eventType)
                        if eventType == TOUCH_EVENT_ENDED then
                        
                        self.btn_lock:setPosition(cc.p(self.toilet:getPositionX()*0.5,500))
                        ModifyData.tableinsert(padlock_item.key)
                        print("ModifyData.tableinsert...")
                        print("ModifyData.getTableNum()",ModifyData.getTableNum())
                        end  
                    end

                    self.btn_lock = ccui.Button:create(padlock_item.pic)
                    self.btn_lock:setAnchorPoint(cc.p(0,0))
                    self.btn_lock:setPosition(cc.p(self.toilet:getPositionX(),500))
                    self.btn_lock:addTo(self ,1)
                    self.btn_lock:addClickEventListener(padlock_itemcall)
                end

                self.scheduler=cc.Director:getInstance():getScheduler():scheduleScriptFunc(reorderSprite,self.time,false)
        end

    end

    local function lampcallback()
        --吊灯 lamp
        print("吊灯 lamp")
        local item_location = UItool:getitem_location(self.lamp:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:grossiniwalk()
        self:Girl_bg_move( item_location ,event)
        print("diaodeng location ", location)

    end

    local function clockcallback()
        -- 吊钟 clock
        print("吊钟 clock")
        local item_location = UItool:getitem_location(self.clock:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:grossiniwalk()
        self:Girl_bg_move( item_location ,event)
        print("吊钟 location ", location)

    end

    local function mirrorcallback()
        -- 镜子 mirror
        print("镜子 mirror")
        local item_location = UItool:getitem_location(self.mirror:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:grossiniwalk()
        self:Girl_bg_move( item_location ,event)
        print("jingzi location ", location)

    end

    local function bellcallback()
        -- 座地钟 bell
        print("座地钟 bell")
        local item_location = UItool:getitem_location(self.bell:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:grossiniwalk()
        self:Girl_bg_move( item_location ,event)
        print("zuodizhong location ", location)



    end

    local function dressingtablecallback()
        -- 右梳妆台 dressingtable
        print("右梳妆台 dressingtable")
        local item_location = UItool:getitem_location(self.dressingtable:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:grossiniwalk()
        self:Girl_bg_move( item_location ,event)
        print("dressingtable location ", location)

    end

    local function chaircallback()
        -- 椅子 chair
        print("椅子 chair")
        local item_location = UItool:getitem_location(self.chair:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:grossiniwalk()
        self:Girl_bg_move( item_location ,event)
        print("chair location ", location)

    end

    local function modelcallback()
        -- 模特model
        print("模特 model")
        local item_location = UItool:getitem_location(self.model:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:grossiniwalk()
        self:Girl_bg_move( item_location ,event)
        print("model location ", location)

    end

    local function mergecallback(  )
        print("合成 merge")
        local merge = Merge:createScene()
        self:addChild(merge,5)
    end

    local merge = cc.MenuItemImage:create("he_btn.png","he_btn,png")
    merge:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2)  )
    merge:setAnchorPoint(cc.p(0.5,0.5))
    -- 对该按钮注册按键响应函数：
    merge:registerScriptTapHandler(mergecallback)
	--下拉菜单
 	
    local menus=cc.MenuItemImage:create("Menu/menu.png","Menu/menu.png")
    menus:setPosition(self.origin.x + menus:getContentSize().width*0.55, self.origin.y + self.visibleSize.height*0.9 )
    menus:setAnchorPoint(cc.p(0.5,0.5))
    -- 对该按钮注册按键响应函数：
    menus:registerScriptTapHandler(menuscallback)
    
    local menulabel = cc.Label:createWithSystemFont("Menu" ,"Zapfino", 38)
    menulabel:setColor(cc.c3b(251, 138, 38))
    menulabel:setPosition(cc.p(menus:getContentSize().width/2.8,menus:getContentSize().height/1.7))
    menulabel:addTo(menus,5)

    -- 衣柜
    self.wardrobe=cc.MenuItemImage:create("furniture/left/wardrobe.png","furniture/left/wardrobe.png")
    self.wardrobe:setPosition(self.origin.x + self.wardrobe:getContentSize().width*0.55, self.origin.y + self.visibleSize.height *0.01)
    self.wardrobe:setAnchorPoint(cc.p(0.5,0))
    -- 对该按钮注册按键响应函数：
    self.wardrobe:registerScriptTapHandler(wardrobecallback)
   
    --左化妆台
    self.dressing_table = cc.MenuItemImage:create("furniture/left/dressing_table.png","furniture/left/dressing_table.png")
    self.dressing_table:setAnchorPoint(cc.p(0.5,0))
    self.dressing_table:setPosition(cc.p(self.wardrobe:getPositionX()+self.dressing_table:getContentSize().width*1.65,self.origin.y + self.visibleSize.height *0.01))
    self.dressing_table:registerScriptTapHandler(dressing_tablecallback)

    --矮凳 stool矮凳 stool
    self.stool = cc.MenuItemImage:create("furniture/left/stool.png","furniture/left/stool.png")
    self.stool:setAnchorPoint(cc.p(0.5,0))
    self.stool:setPosition(cc.p(self.dressing_table:getPositionX()+self.stool:getContentSize().width*1.35,self.origin.y + self.visibleSize.height *0.01))
    self.stool:registerScriptTapHandler(stoolcallback)

    --烛台
    self.candlestick = cc.MenuItemImage:create("furniture/left/candlestick.png","furniture/left/candlestick.png")
    self.candlestick:setAnchorPoint(cc.p(0.5,0))
    self.candlestick:setPosition(cc.p(self.stool:getPositionX()+self.candlestick:getContentSize().width*0.95,self.origin.y + self.visibleSize.height *0.01))
    self.candlestick:registerScriptTapHandler(candlestickcallback)

    --家具桌
    self.table_furniture = cc.MenuItemImage:create("furniture/left/table_furniture.png","furniture/left/table_furniture.png")
    self.table_furniture:setAnchorPoint(cc.p(0.5,0))
    self.table_furniture:setPosition(cc.p(self.candlestick:getPositionX()+self.table_furniture:getContentSize().width*0.95,self.origin.y + self.visibleSize.height *0.01))
    self.table_furniture:registerScriptTapHandler(table_furniturecallback)

    --衣架
    self.rack = cc.MenuItemImage:create("furniture/left/rack.png","furniture/left/rack.png")
    self.rack:setAnchorPoint(cc.p(0.5,0))
    self.rack:setPosition(cc.p(self.table_furniture:getPositionX()+self.rack:getContentSize().width*1.79,self.origin.y + self.visibleSize.height *0.01))
    self.rack:registerScriptTapHandler(rackcallback)

    --抽屉
    self.toilet = cc.MenuItemImage:create("furniture/left/toilet.png","furniture/left/toilet.png")
    self.toilet:setAnchorPoint(cc.p(0.5,0))
    self.toilet:setPosition(cc.p(self.rack:getPositionX()+self.toilet:getContentSize().width*0.99,self.origin.y + self.visibleSize.height *0.01))
    self.toilet:registerScriptTapHandler(toiletcallback)

    --吊灯
    self.lamp = cc.MenuItemImage:create("furniture/left/lamp.png","furniture/left/lamp.png")
    self.lamp:setAnchorPoint(cc.p(0.5,1))
    self.lamp:setPosition(cc.p(self.wardrobe:getPositionX()+self.lamp:getContentSize().width*1.25,self.origin.y + self.visibleSize.height))
    self.lamp:registerScriptTapHandler(playMusic)

    -- 吊钟
    self.clock = cc.MenuItemImage:create("furniture/left/clock.png","furniture/left/clock.png")
    self.clock:setAnchorPoint(cc.p(0.5,1))
    self.clock:setPosition(cc.p(self.visibleSize.width/2,self.origin.y + self.visibleSize.height))
    self.clock:registerScriptTapHandler(clockcallback)

    --镜子
    self.mirror = cc.MenuItemImage:create("furniture/left/mirror.png","furniture/left/mirror.png")
    self.mirror:setAnchorPoint(cc.p(0.5,0.4))
    self.mirror:setPosition(cc.p(self.toilet:getPositionX()-10,self.origin.y + self.visibleSize.height/2))
    self.mirror:registerScriptTapHandler(mirrorcallback)

    --座地钟
    self.bell = cc.MenuItemImage:create("furniture/right/bell.png","furniture/right/bell.png")
    self.bell:setAnchorPoint(cc.p(0.5,0))
    self.bell:setPosition(cc.p(self.visibleSize.width+1.25*self.bell:getContentSize().width,self.origin.y + self.visibleSize.height *0.01))
    self.bell:registerScriptTapHandler(bellcallback)

    --右梳妆台
    self.dressingtable = cc.MenuItemImage:create("furniture/right/dressingtable.png","furniture/right/dressingtable.png")
    self.dressingtable:setAnchorPoint(cc.p(0.5,0))
    self.dressingtable:setPosition(cc.p(self.visibleSize.width*1.35+self.dressingtable:getContentSize().width,self.origin.y + self.visibleSize.height *0.01))
    self.dressingtable:registerScriptTapHandler(dressingtablecallback)

    --椅子
    self.chair = cc.MenuItemImage:create("furniture/right/chair.png","furniture/right/chair.png")
    self.chair:setAnchorPoint(cc.p(0.5,0))
    self.chair:setPosition(cc.p(self.dressingtable:getPositionX()+self.chair:getContentSize().width*1.5,self.origin.y + self.visibleSize.height *0.01))
    self.chair:registerScriptTapHandler(chaircallback)

    --模特
    self.model = cc.MenuItemImage:create("furniture/right/model.png","furniture/right/model.png")
    self.model:setAnchorPoint(cc.p(0.5,0))
    self.model:setPosition(cc.p(self.chair:getPositionX()+self.model:getContentSize().width*1.5,self.origin.y + self.visibleSize.height *0.01))
    self.model:registerScriptTapHandler(modelcallback)

    local menu=cc.Menu:create(menus,self.wardrobe,self.dressing_table,self.stool,self.candlestick,self.table_furniture,self.rack,self.toilet,self.lamp,self.clock,self.mirror,self.bell,self.dressingtable,self.chair,self.model,merge)
    menu:setPosition(0,0)
    frontnode:addChild(menu)

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
end

function Mainscene:ontouch( ... )
	-- body
	--实现事件触发回调
	local function onTouchBegan(touch, event)
		--人物行走调用
		self:grossiniwalk()
        return true
		
	end

	local function onTouchMoved(touch, event)	
	end

	local function onTouchEnded(touch, events)
        local touchs= touch:getLocation()
        self:Girl_bg_move(touchs.x, events)
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
        local speed = 140
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
            print("one")

            self.layer=cc.Layer:create()
            local shildinglayer = Shieldingscreen:new()
            self.layer:addChild(shildinglayer)
            self.layer:addTo(self,6)
        end
        -- 取消屏蔽层 停止动作
        local function threestep()
            print("three")
            self.layer:removeFromParent()
            self.grossini:stopActionByTag(22)
        end



        -- 人物在屏幕左二分之一 点击在左边
        -- if apoint <= self.visibleSize.width/2 and self.grossini:getPositionX()<=self.visibleSize.width/2  then
        --     if self.bg:getPositionX()==0 then
        --         print("345 hang ")
        --         self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
        --     end

        --     if self.bg:getPositionX()<=0 then
                
        --         --
        --         if self.bg:getPositionX()<= -self.visibleSize.width/2 then
        --             --todo
        --             print("355 hang")
        --             self.bgmove=cc.MoveBy:create( math.abs(self.time), cc.p(-delta,self.bg:getPositionY()))
        --             elseif self.bg:getPositionX()> -self.visibleSize.width/2 then
        --                 self.bgmove=cc.MoveTo:create( math.abs(self.time), cc.p(0,self.bg:getPositionY()))
        --         end
                
        --     end

        --     elseif 
        --         -- 点击在右边人物在左边
        --         apoint>self.visibleSize.width/2 and self.grossini:getPositionX()<self.visibleSize.width/2  then
        --         print("365 hang ")
        --         self.girlmoveto = cc.MoveTo:create(math.abs(self.time1), cc.p(self.visibleSize.width/2 ,self.grossini:getPositionY()))
            
        --              --  人物在中间的时候
        --         elseif self.grossini:getPositionX() >= self.visibleSize.width/2 then
        --             print("369 hang")

        --             if self.bg:getPositionX()>=1.2*self.visibleSize.width-self.bg:getContentSize().width  then
        --                 print("376 hang ")
        --                 self.bgmove=cc.MoveBy:create( math.abs(self.time), cc.p(-delta,self.bg:getPositionY()))
                        
        --             end
        --             if self.bg:getPositionX()<= 1.2*self.visibleSize.width-self.bg:getContentSize().width
        --                 and
        --                 self.bg:getPositionX()>=self.visibleSize.width-self.bg:getContentSize().width
        --                 then
        --                 print("382 hang ")
        --                 self.bgmove=cc.MoveTo:create( math.abs(self.time), cc.p(self.visibleSize.width-self.bg:getContentSize().width,self.bg:getPositionY()))
        --             end
        --                  -- 当画面在最左的时候人物的行走
        --                  -- 画面在最左点击在右边，人物在中间或右边
        --              if self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width and
        --                 apoint>=self.visibleSize.width/2
        --                 then
        --                 print("389 hang ")
        --                 self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
        --                 -- 画面在最左点击在左边，人物在中间或右边
        --                 elseif self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width and
        --                 apoint<self.visibleSize.width/2 then
        --                 self.girlmoveto = cc.MoveTo:create(math.abs(self.time2), cc.p(self.visibleSize.width/2,self.grossini:getPositionY()))
        --                     --todo
        --             end
                
        --         end

        -- local delay= cc.DelayTime:create(math.abs(self.time))
        -- local bgdelay = cc.DelayTime:create(math.abs(self.time))
        -- local bgsequence = cc.Sequence:create(self.bgmove)
        -- if self.bg:getPositionX() == 0  and self.grossini:getPositionX() ~= self.visibleSize.width/2 then
        --     print(" == 0  and ~= ")
        --      self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
        --     elseif self.bg:getPositionX() == 0 and self.grossini:getPositionX() == self.visibleSize.width/2 then
        --         print("== 0  ==")
        --         if apoint <= self.visibleSize.width/2  then
        --             print("无delay ")
        --             self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
        --             else
        --                 print(" 有 delay")
        --                 self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
        --         end
                
        --         elseif self.grossini:getPositionX() >= self.visibleSize.width/2 and self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width then
        --             print("girl >= /2 ")
        --             if apoint <= self.visibleSize.width/2 and self.grossini:getPositionX() == self.visibleSize.width/2 and self.bg:getPositionX() ~= 0 then
        --                 --todo
        --                 print("zuo ")
        --                 self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
        --                 else
        --                     print("else ")
        --                     self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
        --             end
                    
        --             elseif self.bg:getPositionX() ~= 0  then
        --                 print("delay ~= 0")
        --                 self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
        -- end
--
        if apoint<self.visibleSize.width/2 then
            --点击在左边的时候
            print("l点击在左边的时候")
            if self.grossini:getPositionX()<self.visibleSize.width/2 then
                --人物在左边的时候
                print("l人物在左边的时候")
                if self.bg:getPositionX()==0 then
                    print("l地图在原点")
                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))

                end
                
                elseif self.grossini:getPositionX()>self.visibleSize.width/2 then
                    --人物在右边的时候
                    print("l人物在右边的时候")
                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time1), cc.p(self.visibleSize.width/2 ,self.grossini:getPositionY()))
                    elseif self.grossini:getPositionX()==self.visibleSize.width/2 then
                        --人物在中间的时候
                        print("l人物在中间的时候")
                        if self.bg:getPositionX()<0  then
                            
                            if self.bg:getPositionX()<delta  then
                                print("l地图小于")
                                self.bgmove=cc.MoveBy:create( math.abs(self.time), cc.p(-delta,self.bg:getPositionY()))
                                self.bg:runAction(self.bgmove)
                                else
                                    print("l地图大于")
                                    self.bgmove=cc.MoveTo:create( math.abs(self.time2), cc.p(0,self.bg:getPositionY()))
                                    self.bg:runAction(self.bgmove)
                            end
                            elseif self.bg:getPositionX()==0 then
                                self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
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
                    end
                
                elseif self.grossini:getPositionX()>self.visibleSize.width/2 then
                    --人物在右边的时候
                    print("r人物在右边的时候")
                    self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))

                     elseif self.grossini:getPositionX()==self.visibleSize.width/2 then
                        print("r人物在中间的时候")
                        if self.bg:getPositionX() <= 0 and self.bg:getPositionX() > self.visibleSize.width-self.bg:getContentSize().width then
                            if self.bg:getPositionX()+ self.visibleSize.width>apoint-self.visibleSize.width/2 then
                                self.bgmove=cc.MoveBy:create( math.abs(self.time), cc.p(-delta,self.bg:getPositionY()))
                                self.bg:runAction(self.bgmove)
                                else
                                    self.bgmove=cc.MoveTo:create( math.abs(self.time3), cc.p(self.visibleSize.width-self.bg:getContentSize().width,self.bg:getPositionY()))
                                    self.bg:runAction(self.bgmove)
                            end
                            elseif self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width then
                                print("r画面在最左的时候")
                                self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                            
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
                print("643")
                elseif self.bg:getPositionX() == 0 and apoint < self.visibleSize.width/2 then

                    self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
                    print("647")
                    elseif self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width and 
                    apoint >self.visibleSize.width/2  then

                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
                        print("652")
                        elseif self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width and
                    apoint < self.visibleSize.width/2 then

                            self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                            print("657")
            end
            
            if self.bg:getPositionX()~=0 and self.bg:getPositionX() ~= self.visibleSize.width-self.bg:getContentSize().width then
                
                if apoint>self.visibleSize.width/2 then
                    if self.bg:getPositionX()+ self.visibleSize.width>apoint-self.visibleSize.width/2 then
                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                        print("666")
                        else
                            self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay3,self.girlmoveto,cc.CallFunc:create(threestep))
                            print("669")
                    end
                    else
                        if self.bg:getPositionX()<delta then
                            self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                            print("674")
                            else
                                self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay2,self.girlmoveto,cc.CallFunc:create(threestep))
                                print("677")
                        end
                end

                else
                    -- self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
                    print("683")
            end

            else
                print("682")
                self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
        end
        self.grossini:runAction(self.sequence)
        -- self.bg:runAction(self.bgmove)
end

function Mainscene:onEnter()
    
end

function Mainscene:onExit()
	print("onExit")
end



 
function Mainscene:destroyScene()

end

return Mainscene



























