
Onescene = class("Onescene",function()
    return cc.Scene:create()
end)

function Onescene:createScene()
    local one = Onescene:new()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    one:initScene()
    return one
end

function Onescene:initScene()

	-- local shildinglayer = Shieldingscreen:new()
 --    self:addChild(shildinglayer)
--返回
    local button = ccui.Button:create("bu_back1.png","bu_back2.png")
    button:setAnchorPoint(cc.p(1,1))
    -- button:setSwallowTouches(true)
    button:setPosition(cc.p(button:getContentSize().width , self.visibleSize.height))        
    self:addChild(button)

    -- local function BackbuttonClick(event, eventType)
    --     if eventType == ccui.TouchEventType.ended then
    --         self:removeFromParent();
    --     end
    -- end
	button:addClickEventListener(function ( psender,event )
		self:removeFromParent();
	end)
	    -- button:addTouchEventListener(BackbuttonClick)
-- 拼图
	self.fragment_sprite_bg = cc.Sprite:create("test.png")
	self.fragment_sprite_bg:setAnchorPoint(cc.p(0,0))
	self.content_size = self.fragment_sprite_bg:getContentSize()
    self.fragment_sprite_bg:setPosition(display.cx , display.cy )
    self.fragment_sprite_bg:setOpacity(128) 
    self.fragment_sprite_bg:addTo(self) 
    
	local pos_x, pos_y = self.fragment_sprite_bg:getPosition()
	local line_1 = cc.DrawNode:create():drawSegment(
	        cc.p(pos_x, pos_y + self.content_size.height/3), cc.p(pos_x + self.content_size.width, pos_y + self.content_size.height/3), 11, cc.c4f(0,0,0,1))
	local line_2 = cc.DrawNode:create():drawSegment(
	        cc.p(pos_x, pos_y + 2*self.content_size.height/3), cc.p(pos_x + self.content_size.width, pos_y + 2*self.content_size.height/3), 11, cc.c4f(0,0,0,1))
	local line_3 = cc.DrawNode:create():drawSegment(
	        cc.p(pos_x + self.content_size.width/3, pos_y), cc.p(pos_x + self.content_size.width/3, pos_y + self.content_size.height), 11, cc.c4f(0,0,0,1))
	local line_4 = cc.DrawNode:create():drawSegment(
	        cc.p(pos_x + 2*self.content_size.width/3, pos_y), cc.p(pos_x + 2*self.content_size.width/3, pos_y + self.content_size.height), 11, cc.c4f(0,0,0,1))
	self:addChild(line_1,1)
	self:addChild(line_2,1)
	self:addChild(line_3,1)
	self:addChild(line_4,1)

    self.fragment_table={}

	-- local pos_x, pos_y = self.fragment_sprite_bg:getPosition()
 --    local cache = cc.Director:getInstance():getTextureCache():addImage("test.png")
 --    local content_size = cache:getContentSize()
 --    for i = 1, 3 do
 --        for j = 1, 3 do
 --            self.sprite = cc.Sprite:create()
 --            self.sprite:setAnchorPoint(0, 0)
 --            self.sprite:setTexture(cache)
 --            self.sprite:setTextureRect(cc.rect((i-1)*content_size.width/3, (j-1)*content_size.height/3, content_size.width/3, content_size.height/3))
 --            self:addChild(self.sprite)
 --            self.fragment_table[#self.fragment_table + 1] = self.sprite
 --            self.sprite:setPosition(pos_x + (j-1)*self.content_size.width/3, pos_y + (i-1)*self.content_size.height/3)
 --        end
 --    end

    local fragment_sprite = display.newSprite("test.png")
    fragment_sprite:setAnchorPoint(0, 0)

    local rect = cc.rect(0, 0, self.content_size.width/3, self.content_size.height/3)
    --创建一个裁剪区域用于裁剪图块
    -- local clipnode = cc.ClippingRegionNode:create()
    local clipnode = cc.ClippingNode:create()
    clipnode:setClippingRegion(rect)--设置裁剪区域的大小
    clipnode:setContentSize(self.content_size.width/3, self.content_size.height/3)
    clipnode:addChild(fragment_sprite)--添加图片
    fragment_sprite:setPosition(0 - (j-1)*self.content_size.width/3, 0 - (i-1)*self.content_size.height/3)--设置图片显示的部分
    self:addChild(clipnode)
    self.fragment_table[#self.fragment_table + 1] = clipnode
    clipnode:setPosition(pos_x + (j-1)*self.content_size.width/3, pos_y + (i-1)*self.content_size.height/3)

    local function onTouchBegan(touch, event)
        -- print("67890")
        return true
        
    end

    local function onTouchMoved(touch, event)   
        local spritewidth = self.sprite:getContentSize().width
        local spriteheight = self.sprite:getContentSize().height
        local location = touch:getLocation()

        local touchRect = cc.rect(self.sprite:getPositionX(),self.sprite:getPositionY(),spritewidth,spriteheight)


        if cc.rectContainsPoint(touchRect,location) then
            print("**********")
            -- self.sprite:setPosition(cc.p(100,100))
        end
    end

    local function onTouchEnded(touch, events)
        local touchs= touch:getLocation()
        -- print("1234")
    end

    local listener = cc.EventListenerTouchOneByOne:create() -- 创建一个事件监听器
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispatcher = self:getEventDispatcher() -- 得到事件派发器
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self) -- 将监听器注册到派发器中

    -- local spritewidth = self.sprite:getContentSize().width
    -- local spriteheight = self.sprite:getContentSize().height
    -- local location = event:getLocation()

    -- local touchRect = cc.rect(self.sprite:getPositionX()-spritewidth/2,self.sprite:getPositionY()-spriteheight/2,spritewidth,spriteheight)


    -- if touchRect:containsPoint(location) then
    --     self.sprite:setPosition(cc.p(100,100))
    -- end

end






return Onescene




















