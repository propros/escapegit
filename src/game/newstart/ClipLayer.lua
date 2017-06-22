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
    self.layer = ClipLayer.new()  
    self.layer:ctor()  
    self.layer:addChild(self.layer:createClip(),1)  
      
    return self.layer  
end  
  
function ClipLayer:ctor()  
    self.visibleSize = cc.Director:getInstance():getVisibleSize()  
    self.origin = cc.Director:getInstance():getVisibleOrigin() 

    
    -- PublicData.SAVEDATA 
end  
  
function ClipLayer:createClip()  
    local clip = cc.ClippingNode:create()--创建裁剪节点    
    clip:setInverted(true)--设置底板可见    
    clip:setAlphaThreshold(255.0)--设置透明度Alpha值为0    
  
    self.layerColor = cc.LayerColor:create(cc.c4b(0,0,0,130))   
    
      
    clip:addChild(self.layerColor,8)--在裁剪节点添加一个灰色的透明层    
  
    --创建模板，也就是你要在裁剪节点上挖出来的那个”洞“是什么形状的，这里我用close的图标来作为模板    
    self.nodef = cc.Node:create()--创建模版      
    self.close = cc.Sprite:create("role1.jpg")--这里使用的是close的那个图标     
    self.close:setPosition(cc.p(780,230))
    self.nodef:addChild(self.close)--在模版上添加精灵      
    self.nodef:setPosition(cc.p(0,0)) --设置的坐标正好是在close button的坐标位置上    
    clip:setStencil(self.nodef)--设置模版   

    self.jiantou = cc.Sprite:create("jiantou.png")
    self.jiantou:setScale(2)
    self.jiantou:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self.jiantou,5)

    local moveup = cc.OrbitCamera:create(1, 1, 0, 0, 360, 0, 0);
    local movedown = cc.RotateBy:create(0.5, 0)
    self.jiantou:runAction(cc.RepeatForever:create(moveup)) 
    self.jiantou:setPosition(cc.p(self.close:getPositionX(),self.close:getPositionY()+self.close:getContentSize().height/2))

    self:inittouch() 
      
    return clip  
end  

local touchnum = 1
function ClipLayer:inittouch()
    local listener = cc.EventListenerTouchOneByOne:create() -- 创建一个事件监听器
    
    local function onTouchBegan(touch, event)
        local rect = cc.rect( self.close:getPositionX() - self.close:getContentSize().width * 0.5,self.close:getPositionY() - self.close:getContentSize().height * 0.5,self.close:getContentSize().width, self.close:getContentSize().height)  

        if cc.rectContainsPoint(rect,touch:getLocation()) then
            listener:setSwallowTouches(false)
            
            if touchnum==1 then
               self.close:setPosition(cc.p(1250,720))
               
               
               elseif touchnum==2 then
                   self.close:setPosition(cc.p(130,150))
                   
                   
                   elseif touchnum==3 then
                       touchnum = touchnum+1
                       self.close:setPosition(cc.p(1100,720))
                       
                       elseif touchnum==4 then
                           
                           UItool:message2("你可以将碎片拖到盒子上",30)
                           self.close:setPosition(cc.p(180,480))
                           
                           elseif touchnum==5 then
                               
                               self.close:setPosition(cc.p(160,150))
                               
                               elseif touchnum==6 then
                                   
                                   self.close:setPosition(cc.p(1450,650))
                                   
                                   UItool:message2("点击空白向前走",30)
                                   elseif touchnum==7 then
                                       
                                       self.close:setPosition(cc.p(1160,680))
                                       
                                       elseif touchnum==8 then
                                           self.close:setPosition(cc.p(130,150))
                                           
                                           
                                           elseif touchnum==9 then
                                               self.close:setPosition(cc.p(1160,680))
                                               
                                               PublicData.STUDY.study_over=true
                                               self.layer:removeFromParent()

                                               local tb = PublicData.STUDY
                                                
                                                local str = json.encode(tb)
                                                local docpath = cc.FileUtils:getInstance():getWritablePath().."study_over.txt"
                                                if cc.FileUtils:getInstance():isFileExist(docpath)==true then
                                                    -- print("写入gbposiontion")
                                                    ModifyData.writeToDoc(str,"study_over")
                                                    else
                                                        -- print("把PublicData.SAVEDATA 置空")
                                                        PublicData.STUDY = {}
                                                end

            end
            touchnum=touchnum+1
            self.jiantou:setPosition(cc.p(self.close:getPositionX(),self.close:getPositionY()+self.close:getContentSize().height/2))
            
            else
                
                listener:setSwallowTouches(true)
        end

         
        return true
        
    end

    local function onTouchMoved(touch, event)   
    end

    local function onTouchEnded(touch, events)
    end
    
    
    -- listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispatcher = self:getEventDispatcher() -- 得到事件派发器
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.layerColor) -- 将监听器注册到派发器中
end
  
  
--从外界传入一个menu，和一个number  
--注意，外面的mneu不要用api里面的一行排列或者是一列排列，  
--否则menu会破坏，导致下面的代码运行不了  
function ClipLayer:createMenu(menu_node,number)  
      
    if menu_node then
        self.menu_node_s = menu_node
        
    end  
        function clipfunc(tg,sender)  
            -- cclog("输出clipping----点击")
        
            if self.menu_node_s then  
                  
                local dd = self.menu_node_s:isRunning()  --不论是隐藏还是显示，都在运行中  
                print("判断这个节点是否在运行     " .. tostring(dd))  
                -- self.menu_node_s:settingcallback()
                self.blackItem:setEnabled(false)
                self.closeItemm:setEnabled(false)
                else
  
            end  
        end  
      
    self.blackItem = cc.MenuItemImage:create()     
    self.blackItem:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2));    
    self.blackItem:setContentSize(self.visibleSize)--设置大小为整个屏幕的大小  
      
    self.closeItemm = cc.MenuItemImage:create("role1.jpg","role1.jpg")  
    self.closeItemm:registerScriptTapHandler(clipfunc)  
    self.closeItemm:setPosition(self.menu_node_s:getPositionX(),self.menu_node_s:getPositionY())  
    self.nodef:setPosition(self.menu_node_s:getPositionX()+600,self.menu_node_s:getPositionY())  

    self.blackMenu = cc.Menu:create()    
    self.blackMenu:setPosition(cc.p(0,0));    
    self.blackMenu:setAnchorPoint(0,0);    
    self.blackMenu:addChild(self.blackItem) 
    self.blackMenu:addChild(self.closeItemm)  
  
    self:addChild(self.blackMenu,2)  
end  
  
  
  
  
  
return ClipLayer  