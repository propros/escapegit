
Sushi = require("game/view/mainscene/onescene/SushiSprite")  
  
PlayerLayer = class("PlayerLayer", function()  
    return cc.Scene:create()  
end)

function PlayerLayer:createScene()  
    local PlayerLayer = PlayerLayer:new()
    
    PlayerLayer:initScene()
    return PlayerLayer

end  

function PlayerLayer:initScene()
    self.spriteSheet = nil  
    self.m_isNeedFillVacancies = false  
    self.m_isAnimationing = true  
    self.m_isTouchEnable = true  
    self.m_srcSushi = nil  
    self.m_destSushi = nil   
    self.m_movingVertical = true
    self.m_hasCanSushi = true  
    self:init()
end
  
function PlayerLayer:init()   
    math.randomseed(os.time())  

    self.visibleSize = cc.Director:getInstance():getVisibleSize()

    local N = 16
    self.array = {}
    for i = 1 , N do
    self.array[i] = i 
    end
    for i = 1 , N do
    local j = math.random(N - i + 1) + i - 1;
    self.array[i],self.array[j] = self.array[j],self.array[i]
    end

    --返回主页面
    local function key_itemfun(event,eventType)
        if eventType == TOUCH_EVENT_ENDED then
        self:removeFromParent()
        
        end  
    end

    self.btn_back = ccui.Button:create("bu_back1.png","bu_back2.png")
    self.btn_back:setAnchorPoint(cc.p(1,1))
    self.btn_back:setPosition(cc.p(self.btn_back:getContentSize().width , self.visibleSize.height/3))
    self.btn_back:addTo(self,1)
    self.btn_back:addClickEventListener(key_itemfun)

    --创建游戏背景  
    local winSize = cc.Director:getInstance():getWinSize()  
    local background = cc.Sprite:create("background.png")  
    background:setAnchorPoint(0.5,1)  
    background:setPosition(winSize.width/2,winSize.height)  

    local shildinglayer = Shieldingscreen:new()
    self:addChild(shildinglayer,-1) 
    
    self:addChild(background)    
      
    --初始化寿司精灵表单  
    cc.SpriteFrameCache:getInstance():addSpriteFrames("qietu.plist","qietu.pvr.ccz")  
      
    --初始化矩阵的宽和高  
    self.m_width = 4
    self.m_height = 4
    
    --初始化寿司矩阵左下角的点  
    self.m_matrixLeftBottomX = (background:getContentSize().width - Sushi.getContentWidth() * self.m_width - (self.m_width - 1) * 6) / 2  
    self.m_matrixLeftBottomY = 0  
      
    --初始化数组  
    self.m_matrix = {}  

    --备用数组
    self.s_matrix = {}
  
    --初始化寿司矩阵  
    self:initMatrix();  
      
    --每帧刷新  
    local function update(delta)  
        self:update(delta)  
    end  
    self:scheduleUpdateWithPriorityLua(update,1)  
      
    --加事件监听器  
    local function onTouchBegan(touch, event)  
        return self:OnTouchBegan(touch, event)  
    end  
    local function onTouchMoved(touch, event)  
        self:onTouchMoved(touch, event)  
    end  
    local listener = cc.EventListenerTouchOneByOne:create()  
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )  
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )  
    local eventDispatcher = self:getEventDispatcher()  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)  

end  

function PlayerLayer:OnTouchBegan(touch, event)  
    local target = event:getCurrentTarget()  
  
    local locationInNode = target:convertToNodeSpace(touch:getLocation())  
    local s = target:getContentSize()  
    local rect = cc.rect(0, 0, s.width, s.height)  
  
    if cc.rectContainsPoint(rect, locationInNode) then  
        print(string.format("sprite began... x = %f, y = %f", locationInNode.x, locationInNode.y))  
        target:setOpacity(180)  
          
        self.m_srcSushi = nil  
        self.m_destSushi = nil  
        if self.m_isTouchEnable then  
            local location = touch:getLocation()
            self.m_srcSushi = self:sushiOfPoint(location)  
        end
        return self.m_isTouchEnable;  
    end  
    return false  
end  

function PlayerLayer:onTouchMoved(touch, event)  
    if not self.m_isTouchEnable or not self.m_srcSushi then  
        return  
    end
    local row = self.m_srcSushi:getRow()  
    local col = self.m_srcSushi:getCol()  
    local location = touch:getLocation()  
    local halfSushiWidth = self.m_srcSushi:getContentSize().width * 0.5  
    local halfSushiHeight = self.m_srcSushi:getContentSize().height * 0.5  
    --检查是否碰触上方寿司  
    local upRect = cc.rect(  
        self.m_srcSushi:getPositionX() - halfSushiWidth,  
        self.m_srcSushi:getPositionY() + halfSushiHeight,  
        self.m_srcSushi:getContentSize().width,  
        self.m_srcSushi:getContentSize().height
    )
    if cc.rectContainsPoint(upRect,location) then  
        row = row + 1  
        if row <= self.m_height then  
            self.m_destSushi = self.m_matrix[(row - 1) * self.m_width + col]  
        end  
        self.m_movingVertical = true  
        self:swapSushi()  
        return  
    end  
    --检查是否碰触左边寿司  
    upRect = cc.rect(  
        self.m_srcSushi:getPositionX() - 3 * halfSushiWidth,  
        self.m_srcSushi:getPositionY() - halfSushiHeight,  
        self.m_srcSushi:getContentSize().width,  
        self.m_srcSushi:getContentSize().height  
    )  
    if cc.rectContainsPoint(upRect,location) then  
        col = col - 1  
        if col >= 1 then  
            self.m_destSushi = self.m_matrix[(row - 1) * self.m_width + col]  
        end  
        self.m_movingVertical = false  
        self:swapSushi()  
        return  
    end  
    --检查是否碰触右边的寿司  
    upRect = cc.rect(  
        self.m_srcSushi:getPositionX() + halfSushiWidth,  
        self.m_srcSushi:getPositionY() - halfSushiHeight,  
        self.m_srcSushi:getContentSize().width,  
        self.m_srcSushi:getContentSize().height  
    )  
    if cc.rectContainsPoint(upRect,location) then  
        col = col + 1  
        if col <= self.m_width then  
            self.m_destSushi = self.m_matrix[(row - 1) * self.m_width + col]  
        end  
        self.m_movingVertical = false  
        self:swapSushi()  
        return  
    end  
    --检查是否碰触下方的寿司  
    upRect = cc.rect(  
        self.m_srcSushi:getPositionX() - halfSushiWidth,  
        self.m_srcSushi:getPositionY() - 3 * halfSushiHeight,  
        self.m_srcSushi:getContentSize().width,  
        self.m_srcSushi:getContentSize().height  
    )  
    if cc.rectContainsPoint(upRect,location) then  
        row = row - 1  
        if row >= 1 then  
            self.m_destSushi = self.m_matrix[(row - 1) * self.m_width + col]  
        end  
        self.m_movingVertical = true  
        self:swapSushi()  
        return  
    end  
end  
  
function PlayerLayer:sushiOfPoint(location)  
    local sushi  
    local rect = cc.rect(0,0,0,0)  
    local length = self.m_width * self.m_height  
    for i=1, length do  
        sushi = self.m_matrix[i]  
        if sushi then  
           rect.x = sushi:getPositionX() - sushi:getContentSize().width * 0.5  
           rect.y = sushi:getPositionY() - sushi:getContentSize().height * 0.5  
           rect.width = sushi:getContentSize().width  
           rect.height = sushi:getContentSize().height  
           if cc.rectContainsPoint(rect,location) then  
               return sushi  
           end  
        end  
    end  
    return nil  
end  
  
function PlayerLayer:swapSushi()  
    self.m_isAnimationing = true  
    self.m_isTouchEnable = false;  
    if not self.m_srcSushi or not self.m_destSushi then  
        self.m_movingVertical = true  
        return  
    end  
    local srcX,srcY = self.m_srcSushi:getPosition()  
    local destX,destY = self.m_destSushi:getPosition()  
    local time = 0.2  
      
    --交换m_srcSushi与m_destSushi在寿司矩阵中的行、列号  
    self.m_matrix[(self.m_srcSushi:getRow() - 1) * self.m_width + self.m_srcSushi:getCol()] = self.m_destSushi  
    self.m_matrix[(self.m_destSushi:getRow() - 1) * self.m_width + self.m_destSushi:getCol()] = self.m_srcSushi  
    local tmpRow = self.m_srcSushi:getRow()  
    local tmpCol = self.m_srcSushi:getCol()  
    self.m_srcSushi:setRow(self.m_destSushi:getRow())  
    self.m_srcSushi:setCol(self.m_destSushi:getCol())  
    self.m_destSushi:setRow(tmpRow)  
    self.m_destSushi:setCol(tmpCol)  

    self.m_srcSushi:stopAllActions()  
    self.m_destSushi:stopAllActions()  
    self.m_srcSushi:runAction(cc.MoveTo:create(time,{x=destX,y=destY}))  
    self.m_destSushi:runAction(cc.MoveTo:create(time,{x=srcX,y=srcY}))  
    -- return  
    self:pos()
end  

function PlayerLayer:pos( ... )

    local i=3
    self.fixed_fragment_num = 0
    for row=4,1,-1 do
        for col=1,4 do
            local x,y = self.s_matrix[(row-i - 1) * self.m_width + col]:getPosition()
            print("**********",x,y)
            -- print("##########",666+self.m_matrixLeftBottomX + (Sushi.getContentWidth() + 6) * (col - 1) + Sushi.getContentWidth() / 2,self.m_matrixLeftBottomY + (Sushi.getContentWidth() + 6) * (row - 1) + Sushi.getContentWidth() / 2)
            if x==666+self.m_matrixLeftBottomX + (Sushi.getContentWidth() + 6) * (col - 1) + Sushi.getContentWidth() / 2 and y==self.m_matrixLeftBottomY + (Sushi.getContentWidth() + 6) * (row - 1) + Sushi.getContentWidth() / 2 then
                
                self.fixed_fragment_num = self.fixed_fragment_num + 1
                print("self.fixed_fragment_num =",self.fixed_fragment_num )
                if self.fixed_fragment_num == 16 then
                    print("🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎")
                    self:removeFromParent()
                    UItool:message2("数字1837",30)
                    
                    
                end
            end
        end
        i=i-2
    end
end
  
function PlayerLayer:update(delta)  
    if self.m_isAnimationing then  
        self.m_isAnimationing = false    
        local length = self.m_height * self.m_width  
        for i=1, length do  
            local sushi = self.m_matrix[i]  
            if sushi and sushi:getNumberOfRunningActions()>0 then  
                self.m_isAnimationing = true  
                break  
            end  
        end  
    end
    self.m_isTouchEnable = not self.m_isAnimationing  
    
end 
  
function PlayerLayer:initMatrix()

    local i=1 
    
    for row=1,self.m_height do  
        for col=1,self.m_width do  
            local a=self.array[i]
            self:createAndDropSushi(row, col,a)  
            i=i+1
        end  
    end 

    for i=1,16 do
        for j=1,16 do
            if i == self.m_matrix[j]:getTag()  then
                self.s_matrix[i] = self.m_matrix[j]
            end
        end
    end
end  
  
function PlayerLayer:createAndDropSushi(row, col,i)  
    local size = cc.Director:getInstance():getWinSize()  
  
    local sushi =  Sushi.create(row,col,i)  
  
    --创建并执行下落动画  
    self.m_isAnimationing = true  
    local endx,endy = self:positionOfItem(row, col);  
    local startx = endx  
    local starty = endy + size.height / 2  
    local speed = starty / (1.5 * size.height);  
    sushi:setPosition(666+startx,starty)  
    local vec2_table = {x=endx+666, y=endy};  
    sushi:stopAllActions()  
    sushi:runAction(cc.MoveTo:create(speed,vec2_table))  
    self:addChild(sushi,125)  
  
    --给指定位置的数组赋值  
    sushi:setTag(i)
    self.m_matrix[(row - 1) * self.m_width + col] = sushi;
end  
  
function PlayerLayer:positionOfItem(row, col)  
    local x = self.m_matrixLeftBottomX + (Sushi.getContentWidth() + 6) * (col - 1) + Sushi.getContentWidth() / 2;  
    local y = self.m_matrixLeftBottomY + (Sushi.getContentWidth() + 6) * (row - 1) + Sushi.getContentWidth() / 2;  
    return x,y;  
end
  
return PlayerLayer





























