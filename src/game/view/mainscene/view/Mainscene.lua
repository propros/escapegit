

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

    self:ontouch()
    self:AllMenu()

    print("math.floor(_allNodeNum/_countNum)  ", math.floor(1/3))
    print("_allNodeNum%_countNum     ",1%3)
    print(" 0 % 3 ",0%3)
    print(" 2 % 3 ",2%3)
    print(" 3 % 3 ",3%3)
    print(" 4 % 3 ",4%3)
    print(" 5 % 3 ",5%3)

end

function Mainscene:AllMenu()

	local frontnode = cc.Node:create()
    frontnode:addTo(self.bg,2)

    local function playMusic()
        --
        local onescene = Onescene:createScene()
        self:addChild(onescene)

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
        
        local item_location = UItool:getitem_location(self.wardrobe:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:Girl_bg_move( item_location ,event)
        

    end

    local function dressing_tablecallback( )
        -- 左化妆台 dressing_table
        print("左化妆台 dressing_table")
        local item_location = UItool:getitem_location(self.mirror:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:Girl_bg_move( item_location ,event)

    end

    local function stoolcallback()
        -- 矮凳 stool
        local item_location = UItool:getitem_location(self.stool:getPositionX(), self.bg:getPositionX())
         --girl walk
        self:grossiniwalk()
        -- bg && girl move
        self:Girl_bg_move( item_location ,event)
        local key_item = Data.getItemData(5)
        print("key_item  : ",key_item.pic)
        -- 椅子旋转45度
         
        local function reorderSprite()
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
            self.stool:setRotation(45)
            local function key_itemfun(event,eventType)
                if eventType == TOUCH_EVENT_ENDED then
                
                self.btn_key:setPosition(cc.p(self.stool:getPositionX()*2,500))
                ModifyData.tableinsert(key_item.key)
                print("ModifyData.tableinsert...")
                print("ModifyData.getTableNum()",ModifyData.getTableNum())
                -- self:getItemTablenum(  )
                -- self:getItemTable(  )
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

    local function candlestickcallback()
        -- 烛台 candlestick
        print("烛台 candlestick")
        local item_location = UItool:getitem_location(self.candlestick:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:Girl_bg_move( item_location ,event)
        print("zhutai location ", location)

    end

    local function table_furniturecallback( )
        -- 家具桌 table_furniture
        print("家具桌 table_furniture")
        local item_location = UItool:getitem_location(self.mirror:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:Girl_bg_move( item_location ,event)
        print("jingzi location ", location)

    end

    local function rackcallback()
        --衣架 rack
        print("--衣架 rack")

        local item_location = UItool:getitem_location(self.rack:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:Girl_bg_move( item_location ,event)
        print("rack location",location)

    end

    local function toiletcallback()
        --抽屉 toilet
        print("抽屉 toilet")
        local item_location = UItool:getitem_location(self.toilet:getPositionX(), self.bg:getPositionX())

        --girl walk
        self:grossiniwalk()
        -- bg && girl move
        self:Girl_bg_move( item_location ,event)
        print("chouti location ", location)

        local padlock_item = Data.getItemData(6)
        print("padlock_item  : ",padlock_item.pic)

        -- 椅子旋转45度 
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

    local function lampcallback()
        --吊灯 lamp
        print("吊灯 lamp")
        local item_location = UItool:getitem_location(self.lamp:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:Girl_bg_move( item_location ,event)
        print("diaodeng location ", location)

    end

    local function clockcallback()
        -- 吊钟 clock
        print("吊钟 clock")
        local item_location = UItool:getitem_location(self.clock:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:Girl_bg_move( item_location ,event)
        print("吊钟 location ", location)

    end

    local function mirrorcallback()
        -- 镜子 mirror
        print("镜子 mirror")
        local item_location = UItool:getitem_location(self.mirror:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:Girl_bg_move( item_location ,event)
        print("jingzi location ", location)

    end

    local function bellcallback()
        -- 座地钟 bell
        print("座地钟 bell")
        local item_location = UItool:getitem_location(self.bell:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:Girl_bg_move( item_location ,event)
        print("zuodizhong location ", location)



    end

    local function dressingtablecallback()
        -- 右梳妆台 dressingtable
        print("右梳妆台 dressingtable")
        local item_location = UItool:getitem_location(self.dressingtable:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:Girl_bg_move( item_location ,event)
        print("dressingtable location ", location)

    end

    local function chaircallback()
        -- 椅子 chair
        print("椅子 chair")
        local item_location = UItool:getitem_location(self.chair:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
        self:Girl_bg_move( item_location ,event)
        print("chair location ", location)

    end

    local function modelcallback()
        -- 模特model
        print("模特 model")
        local item_location = UItool:getitem_location(self.model:getPositionX(), self.bg:getPositionX())
        print("item_location ",item_location)
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
    self.dressing_table:registerScriptTapHandler(playMusic)

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
    self.lamp:registerScriptTapHandler(lampcallback)

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
    print("girl walks")
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
        local x1 = gril_pointx - apoint
    --速度
        local speed = 110
    --时间
        self.time = delta / speed
        self.time1 = (math.abs(delta)-x)/speed
        self.time2 = x1 / speed
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
            
            print("111111111111111,",self.grossini:getPositionX( ) )
            print("touchpoint.x",apoint)
        end
        -- 取消屏蔽层 停止动作
        local function threestep()
            print("three")
            self.layer:removeFromParent()
            self.grossini:stopActionByTag(22)
        end

        -- 人物在屏幕左二分之一 点击在左边
        if apoint <= self.visibleSize.width/2 and self.grossini:getPositionX()<=self.visibleSize.width/2  then
            if self.bg:getPositionX()==0 then
                print("345 hang ")
                self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
            end

            if self.bg:getPositionX()<=0 then
                
                --
                if self.bg:getPositionX()<= -self.visibleSize.width/2 then
                    --todo
                    print("355 hang")
                    self.bgmove=cc.MoveBy:create( math.abs(self.time), cc.p(-delta,self.bg:getPositionY()))
                    elseif self.bg:getPositionX()> -self.visibleSize.width/2 then
                        self.bgmove=cc.MoveTo:create( math.abs(self.time), cc.p(0,self.bg:getPositionY()))
                end
                
            end

            elseif 
                -- 点击在右边人物在左边
                apoint>self.visibleSize.width/2 and self.grossini:getPositionX()<self.visibleSize.width/2  then
                print("365 hang ")
                self.girlmoveto = cc.MoveTo:create(math.abs(self.time1), cc.p(self.visibleSize.width/2 ,self.grossini:getPositionY()))
            
                     --  人物在中间的时候
                elseif self.grossini:getPositionX() >= self.visibleSize.width/2 then
                    print("369 hang")

                    if self.bg:getPositionX()>=1.5*self.visibleSize.width-self.bg:getContentSize().width  then
                        print("376 hang ")
                        self.bgmove=cc.MoveBy:create( math.abs(self.time), cc.p(-delta,self.bg:getPositionY()))
                        
                    end
                    if self.bg:getPositionX()<= 1.5*self.visibleSize.width-self.bg:getContentSize().width
                        and
                        self.bg:getPositionX()>=self.visibleSize.width-self.bg:getContentSize().width
                        then
                        print("382 hang ")
                        self.bgmove=cc.MoveTo:create( math.abs(self.time), cc.p(self.visibleSize.width-self.bg:getContentSize().width,self.bg:getPositionY()))
                    end
                         -- 当画面在最左的时候人物的行走
                         -- 画面在最左点击在右边，人物在中间或右边
                     if self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width and
                        apoint>=self.visibleSize.width/2
                        then
                        print("389 hang ")
                        self.girlmoveto = cc.MoveTo:create(math.abs(self.time), cc.p(apoint,self.grossini:getPositionY()))
                        -- 画面在最左点击在左边，人物在中间或右边
                        elseif self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width and
                        apoint<self.visibleSize.width/2 then
                        self.girlmoveto = cc.MoveTo:create(math.abs(self.time2), cc.p(self.visibleSize.width/2,self.grossini:getPositionY()))
                            --todo
                    end
                
                end

        local delay= cc.DelayTime:create(math.abs(self.time))
        local bgdelay = cc.DelayTime:create(math.abs(self.time))
        local bgsequence = cc.Sequence:create(self.bgmove)
        if self.bg:getPositionX() == 0  and self.grossini:getPositionX() ~= self.visibleSize.width/2 then
            print(" == 0  and ~= ")
             self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
            elseif self.bg:getPositionX() == 0 and self.grossini:getPositionX() == self.visibleSize.width/2 then
                print("== 0  ==")
                if apoint <= self.visibleSize.width/2  then
                    print("无delay ")
                    self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
                    else
                        print(" 有 delay")
                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                end
                
                elseif self.grossini:getPositionX() >= self.visibleSize.width/2 and self.bg:getPositionX() == self.visibleSize.width-self.bg:getContentSize().width then
                    print("girl >= /2 ")
                    if apoint <= self.visibleSize.width/2 and self.grossini:getPositionX() == self.visibleSize.width/2 and self.bg:getPositionX() ~= 0 then
                        --todo
                        print("zuo ")
                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
                        else
                            print("else ")
                            self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),self.girlmoveto,cc.CallFunc:create(threestep))
                    end
                    
                    --todo
                    elseif self.bg:getPositionX() ~= 0  then
                        print("delay ~= 0")
                        self.sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,self.girlmoveto,cc.CallFunc:create(threestep))
        end
        self.grossini:runAction(self.sequence)
        self.bg:runAction(self.bgmove)
end

function Mainscene:onEnter()
    
end

function Mainscene:onExit()
	print("onExit")
end



 
function Mainscene:destroyScene()

end

return Mainscene



























