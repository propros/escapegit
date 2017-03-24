-- require "Cocos2d"  
-- require "Cocos2dConstants"  
  
SushiSprite = class("SushiSprite", function(...)  
    local str = select(1,...)  
    return cc.Sprite:createWithSpriteFrameName(str)  
end)  
  
sushiNormal = {  
    "qiepian_01.png",  
    "qiepian_02.jpg",
    "qiepian_03.jpg",
    "qiepian_04.jpg",
    "qiepian_05.jpg",
    "qiepian_06.jpg",  
    "qiepian_07.jpg",
    "qiepian_08.jpg",
    "qiepian_09.jpg",
    "qiepian_10.jpg",
    "qiepian_11.jpg",
    "qiepian_12.jpg",
    "qiepian_14.jpg",
    "qiepian_13.jpg",
    "qiepian_15.jpg",
    "qiepian_16.jpg" 
}
  
function SushiSprite.create(row, col,i)  
    local index = i
    local sprite = SushiSprite.new(sushiNormal[index], row, col, index);  
    return sprite  
end  
  
function SushiSprite:ctor(str, row, col, index)  
    self.m_row = row  
    self.m_col = col  
    self.m_imgIndex = index  
    self.m_isNeedRemove = false  
    self.m_ignoreCheck = false  
    self.m_displayMode = DISPLAY_MODE_NORMAL  
end  
  
function SushiSprite.getContentWidth()  
    local itemWidth = 0;  
    if 0 == itemWidth then  
        local sprite = cc.Sprite:createWithSpriteFrameName(sushiNormal[1])  
        itemWidth = sprite:getContentSize().width  
    end  
    return itemWidth;  
end  
  
function SushiSprite:getCol()  
    return self.m_col  
end  
  
function SushiSprite:setCol(value)  
    self.m_col = value  
end  
  
function SushiSprite:getRow()  
    return self.m_row  
end  
  
function SushiSprite:setRow(value)  
    self.m_row = value  
end  
  
function SushiSprite:getImgIndex()  
    return self.m_imgIndex  
end  
  
function SushiSprite:getIgnoreCheck()  
    return self.m_ignoreCheck  
end  
  
function SushiSprite:setIgnoreCheck(value)  
    self.m_ignoreCheck = value  
end  
  
function SushiSprite:getIsNeedRemove()  
    return self.m_isNeedRemove  
end  
  
function SushiSprite:setIsNeedRemove(value)  
    self.m_isNeedRemove = value  
end  
  
function SushiSprite:setDisplayMode(value)  
    self.m_displayMode = value  
    local frame  
    self:setSpriteFrame(frame)  
end  
  
function SushiSprite:getDisplayMode()  
    return self.m_displayMode  
end  
  
return SushiSprite 






























