--这是一个新手引导的类  
ClipLayer = class("ClipLayer",function()  
    return cc.Layer:create()  
end)  
  
ClipLayer.__index = ClipLayer --用于访问  
  
-------------------------------------------------------------  
ClipLayer.menu_node   = nil --这是响应的node  
ClipLayer.menu_node_s   = nil --这是响应的node  
ClipLayer.visibleSize = nil --屏幕大小size  
ClipLayer.origin      = nil --原点  
ClipLayer.nodef       = nil --模板  
  
function ClipLayer:create()  
    local layer = ClipLayer.new()  
    layer:ctor()  
    layer:addChild(layer:createClip(),1)  
      
    return layer  
end  
  
function ClipLayer:ctor()  
    self.visibleSize = cc.Director:getInstance():getVisibleSize()  
    self.origin = cc.Director:getInstance():getVisibleOrigin()  
end  
  
function ClipLayer:createClip()  
    local clip = cc.ClippingNode:create()--创建裁剪节点    
    clip:setInverted(true)--设置底板可见    
    clip:setAlphaThreshold(0.0)--设置透明度Alpha值为0    
  
    local layerColor = cc.LayerColor:create(cc.c4b(0,0,0,150))   
      
    clip:addChild(layerColor,8)--在裁剪节点添加一个灰色的透明层    
  
    --创建模板，也就是你要在裁剪节点上挖出来的那个”洞“是什么形状的，这里我用close的图标来作为模板    
    self.nodef = cc.Node:create()--创建模版      
    local close = cc.Sprite:create("close.jpg")--这里使用的是close的那个图标     
    self.nodef:addChild(close)--在模版上添加精灵      
    self.nodef:setPosition(cc.p(self.visibleSize.width /4,self.visibleSize.height /2)) --设置的坐标正好是在close button的坐标位置上    
    clip:setStencil(self.nodef)--设置模版     
      
    return clip  
end  
  
  
--从外界传入一个menu，和一个number  
--注意，外面的mneu不要用api里面的一行排列或者是一列排列，  
--否则menu会破坏，导致下面的代码运行不了  
function ClipLayer:createMenu(menu_node,number)  
      
    if self.menu_node then  
        self.menu_node_s = self.menu_node:getChildByTag(number)  
    end  
      
        function clipfunc(tg,sender)  
            -- cclog("输出clipping----点击")  
            if self.menu_node_s then  
                  
                local dd = self.menu_node_s:isRunning()  --不论是隐藏还是显示，都在运行中  
                print("判断这个节点是否在运行     " .. tostring(dd))  
                self.menu_node_s:activate()  
              
            else  
  
            end  
        end  
      
    self.blackItem = cc.MenuItemImage:create()     
    self.blackItem:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2));    
    self.blackItem:setContentSize(self.visibleSize)--设置大小为整个屏幕的大小  
      
    self.closeItemm = cc.MenuItemImage:create("CloseNormal.png","CloseSelected.png")  
    self.closeItemm:registerScriptTapHandler(clipfunc)  
    self.closeItemm:setPosition(self.menu_node_s:getPosition())  
    self.nodef:setPosition(self.menu_node_s:getPosition())  

    self.blackMenu = cc.Menu:create()    
    self.blackMenu:setPosition(cc.p(0,0));    
    self.blackMenu:setAnchorPoint(0,0);    
    self.blackMenu:addChild(self.blackItem)  
    self.blackMenu:addChild(self.closeItemm)  
  
    self:addChild(self.blackMenu,2)  
end  
  
  
  
  
  
return ClipLayer  