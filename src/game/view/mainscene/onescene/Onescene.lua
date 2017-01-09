
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

	local shildinglayer = Shieldingscreen:new()
    self:addChild(shildinglayer)
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

	local pos_x, pos_y = self.fragment_sprite_bg:getPosition()
    local cache = cc.Director:getInstance():getTextureCache():addImage("test.png")
    local content_size = cache:getContentSize()
    for i = 1, 3 do
        for j = 1, 3 do
            self.sprite = cc.Sprite:create()
            self.sprite:setAnchorPoint(0, 0)
            self.sprite:setTexture(cache)
            self.sprite:setTextureRect(cc.rect((i-1)*content_size.width/3, (j-1)*content_size.height/3, content_size.width/3, content_size.height/3))
            self:addChild(self.sprite)
            self.fragment_table[#self.fragment_table + 1] = self.sprite
            self.sprite:setPosition(pos_x + (j-1)*self.content_size.width/3, pos_y + (i-1)*self.content_size.height/3)
        end
    end


    -- self.sprite:setTouchEnabled(true)
    --         self.sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
    --             --local boundingBox = sprite:getCascadeBoundingBox()
    --             local position = cc.p(self.sprite:getPosition())
    --             local boundingBox = cc.rect(position.x, position.y, self.content_size.width/3, self.content_size.height/3) --getCascadeBoundingBox()方法获得的rect大小为整张图片的大小，此处重新计算图块的rect。

    --             if "began" == event.name and not cc.rectContainsPoint(boundingBox, cc.p(event.x, event.y)) then
    --                 self.sprite:setTouchSwallowEnabled(false)
    --                 return false
    --             end

    --             if "began" == event.name then
    --                 self.sprite:setTouchSwallowEnabled(true)--吞噬触摸，防止响应下层的图块。
    --                 --将当前的图块置顶
    --                 for index = 1, self.fragment_num do
    --                     self.fragment_table[index]:setLocalZOrder(PiecePuzzleGameView.FRAGMENT_ZORDER)
    --                 end
    --                 self.sprite:setLocalZOrder(PiecePuzzleGameView.FRAGMENT_ZORDER + 1)

    --                 return true
    --             elseif "moved" == event.name then
    --                 local pos_x, pos_y = self.sprite:getPosition()
    --                 pos_x = pos_x + event.x - event.prevX
    --                 pos_y = pos_y + event.y - event.prevY
    --                 if pos_x < display.left or pos_x > display.right - self.content_size.width/3 then
    --                     pos_x = pos_x - event.x + event.prevX
    --                 end
    --                 if pos_y < display.bottom or pos_y > display.top - self.content_size.height/3 then
    --                     pos_y = pos_y - event.y + event.prevY
    --                 end
    --                 self.sprite:setPosition(pos_x, pos_y)
    --             elseif "ended" == event.name then

    --             end
    --         end)
	

end






return Onescene




















