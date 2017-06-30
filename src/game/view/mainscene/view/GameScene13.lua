
GameScene13=class("GameScene13", function()
    return cc.Scene:create()
end)

GameScene13.panel = nil
local roomNumber
local chapterNumber


function GameScene13:ctor()

    local function onNodeEvent(event)
        
        if event == "enter" then
            self:onEnter()
            elseif event == "enterTransitionFinish" then
                self:onEnterTransitionFinish()
        end
    end
    self:registerScriptHandler(onNodeEvent)

    self.director = cc.Director:getInstance()
    self.visibleSize = cc.Director:getInstance():getVisibleSize() 
    self.winsize = cc.Director:getInstance():getWinSizeInPixels()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    if #PublicData.SAVEDATA==0 then
        local docpath = cc.FileUtils:getInstance():getWritablePath().."GBposition.txt"
        ---- print("文件是否存在",cc.FileUtils:getInstance():isFileExist(docpath),docpath)
        if cc.FileUtils:getInstance():isFileExist(docpath)==false then
            local str = json.encode(Data.SAVEDATA)
            ModifyData.writeToDoc(str,"GBposition")
            PublicData.SAVEDATA = UItool:deepcopy(Data.SAVEDATA)
            
        else
            
            local str = ModifyData.readFromDoc("GBposition")
            PublicData.SAVEDATA = json.decode(str)
        end
    end


    self.savedata = PublicData.SAVEDATA
    

      -- 家具状态
    if #PublicData.FURNITURE==0 then
        local docpath = cc.FileUtils:getInstance():getWritablePath().."furniture.txt"
        ---- print("文件是否存在",cc.FileUtils:getInstance():isFileExist(docpath),docpath)
        if cc.FileUtils:getInstance():isFileExist(docpath)==false then
            local str = json.encode(Data.FURNITURE12)
            ModifyData.writeToDoc(str,"furniture")
            
            PublicData.FURNITURE = UItool:deepcopy(Data.FURNITURE12)
        else
            local str = ModifyData.readFromDoc("furniture")
            PublicData.FURNITURE = json.decode(str)
        end
    end

    self.furnituretb = PublicData.FURNITURE
    roomNumber = ModifyData.getRoomNum()
    chapterNumber = ModifyData.getChapterNum()

    --人物缩放
    self.girlx = 0.28
    self.girly = 0.28

    --下蹲屏蔽时间
    self.screenxiadun = 1.3
    --弯腰屏蔽时间
    self.screenwanyao = 1.2

    self.director = cc.Director:getInstance()
    self.visibleSize = cc.Director:getInstance():getVisibleSize() 
    self.winsize = cc.Director:getInstance():getWinSizeInPixels()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    -- 家具底层
    self.panel = cc.CSLoader:createNode(Config.RES_GAMESCENE12)
    self.panel:setPosition(cc.p(0,0))
    self:addChild(self.panel,4)

    --合成条
    self.merge = Merge:createScene()
    self:addChild(self.merge,5)

    --主节点
    self.node =  self.panel:getChildByName("Node_left_top")
    self.node:setPosition(0, self.visibleSize.height)
    --背景
    self.bg = self.node:getChildByName("bg")
    --家具层
    self.furniture = self.bg:getChildByName("furniture")



    --返回按钮
    local mainback = self.node:getChildByName("back")
    mainback:addClickEventListener(function ()
        if UItool:getBool("effect") then
            AudioEngine.playEffect("gliss.mp3")
        end
        --返回loading
        local scene = Loading.new()
        local turn = cc.TransitionFade:create(1,scene)
        cc.Director:getInstance():replaceScene(turn)
        end)

    local shezhi = self.node:getChildByName("shezhi")
    shezhi:addClickEventListener(function ()
        if UItool:getBool("effect") then
            AudioEngine.playEffect("gliss.mp3")
        end
        --返回loading
        local setting = Setting:createScene()
        self:addChild(setting,13)
        end)
    
    self.grossini = GIRL:new()
    self.grossini:setScaleX(-self.girlx)
    self.grossini:setScaleY(self.girly)
    self.grossini:stand()
    self:addChild(self.grossini,12)

    self.bg:setPositionX(self.savedata.bgpositionx)
    self.grossini:setPosition(cc.p(self.savedata.girlpositionx,140))

    local function update(delta)  
        self:update(delta)  
        
        if UItool:getBool("pasitem") then
            --重新渲染合成界面
            UItool:setBool("pasitem",false)

            self:megerupdate()
            
        end
    end  
    self:scheduleUpdateWithPriorityLua(update,0.3)

    self:fishmove() --鱼的移动 
    self:fire_weiniang_mao()
end

function GameScene13:megerupdate()
    self.merge:removeSelf()
    self.merge = Merge:createScene()
    self:addChild(self.merge,5)
end


function GameScene13:init()
    self:ontouch()
    
    self:AllButtons()
    -- self:fishmove() --鱼的移动 
end

function GameScene13:fire_weiniang_mao( )
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/donghua/huolu/huolu.ExportJson") 
    self.huolu = ccs.Armature:create("huolu")
    self.huolu:setAnchorPoint(cc.p(0.5,0.4))
    self.huolu:getAnimation():playWithIndex(0,1,1)
    self.huolu:setPosition(cc.p(self.furniture:getChildByName("stove"):getPositionX()+10,self.furniture:getChildByName("stove"):getPositionY()+10))
    self.bg:addChild(self.huolu,16)
    
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/donghua/weiniang/weiniang.ExportJson") 
    self.weiniang = ccs.Armature:create("weiniang")
    
    self.weiniang:setAnchorPoint(cc.p(0.5,0.4))
    self.weiniang:getAnimation():playWithIndex(0,1,1)
    self.weiniang:getAnimation():play("Animation1")
    
    self.weiniang:setPosition(cc.p(self.furniture:getChildByName("weiniang"):getPositionX(),self.furniture:getChildByName("weiniang"):getPositionY()-10))
    self.bg:addChild(self.weiniang,16)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/donghua/mao/mao.ExportJson") 
    self.mao = ccs.Armature:create("mao")
    self.mao:setAnchorPoint(cc.p(0.5,0))
    self.mao:getAnimation():playWithIndex(0,1,1)
    self.mao:getAnimation():play("Animation2")
    self.mao:setPosition(cc.p(self.furniture:getChildByName("cat"):getPositionX(),self.furniture:getChildByName("cat"):getPositionY()-5))
    self.bg:addChild(self.mao,16)


    local function settingcallback( )
        
        self:modify()
    end

    self.setting = cc.MenuItemImage:create("continue.png","continue2.png")
    self.setting:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))
    self.setting:setAnchorPoint(cc.p(0.5,0.5))
    -- self.setting:setScale(2)
    -- 对该按钮注册按键响应函数：
    self.setting:registerScriptTapHandler(settingcallback)
    
    self.menu=cc.Menu:create(self.setting)
    self.menu:setPosition(0,0) 
    self:addChild(self.menu,7)


end
function GameScene13:update( delta )

    local fish1 = self.fish1:getPositionX()
    local fish2 =self.fish2:getPositionX()
    local fish3 =  self.fish3:getPositionX()
    local fish4 = self.fish4 :getPositionX()

    local fish5 = self.fish5:getPositionX()
    local fish6 = self.fish6:getPositionX()
    local fish7 = self.fish7:getPositionX()
    local fish8x = self.fish8:getPositionX()
    local fish8y = self.fish8:getPositionY()

    local fish9 = self.fish9:getPositionX()

    local speed = 1 
  
    fish1 = fish1 + speed  
    fish2 = fish2 - speed - 1
    fish3 = fish3 - speed -2
    fish4 = fish4 + speed *1.2

    fish5 = fish5 + speed +1.1
    fish6 = fish6 - speed -2.5
    fish7 = fish7 - speed 
    fish8x = fish8x - speed -1.8
    fish8y = fish8y - speed -1.1

    fish9 = fish9 - speed 
    
    local width = self.winsize.width 
    local height = self.winsize.height
  
    if fish1 > width *2 + self.fish1:getContentSize().width*0.6 then
        fish1 = -self.fish1:getContentSize().width*0.6
    end

    if fish2 < -self.fish2:getContentSize().width * 0.6 then  
        fish2 = 2*width + self.fish2:getContentSize().width * 0.6
    end  

    if fish3 < -self.fish3:getContentSize().width * 0.6 then  
        fish3 = width * 2 + self.fish3:getContentSize().width*0.6
        
    end  
  
    if fish6 < -self.fish6:getContentSize().width*0.6  then  
        fish6 = width *2 +self.fish6:getContentSize().width*0.6
    end  


    if fish7 < -self.fish7:getContentSize().width*0.6 then
        fish7 = width *2 +self.fish7:getContentSize().width*0.6
    end

    if fish4 > width *2 + self.fish4:getContentSize().width*0.6 then
        fish4 = -self.fish4:getContentSize().width*0.6
    end

    if fish5 > width *2 + self.fish5:getContentSize().width*0.6 then
        fish5 = - self.fish5:getContentSize().width*0.6
    end


    if fish9 < -self.fish9:getContentSize().width*0.6 then
        fish9 = width *2 +self.fish9:getContentSize().width*0.6
    end

    if fish8x < -self.fish8:getContentSize().width*0.7 then
        fish8x = width *2 +self.fish8:getContentSize().width*0.6
    end

    if fish8y < -self.fish8:getContentSize().height then
        fish8y = height +self.fish8:getContentSize().height*0.6
    end

    self.fish1:setPositionX(fish1)
    self.fish2:setPositionX(fish2)
    self.fish3:setPositionX(fish3)
    self.fish4:setPositionX(fish4)
    self.fish5:setPositionX(fish5)
    self.fish6:setPositionX(fish6)
    self.fish7:setPositionX(fish7)
    self.fish9:setPositionX(fish9)
    self.fish8:setPosition(cc.p(fish8x,fish8y))

end

function GameScene13:fishmove()  
    self.fish1 = self.bg:getChildByName("fish1")
    self.fish2 = self.bg:getChildByName("fish2")
    self.fish3 = self.bg:getChildByName("fish3")
    self.fish4 = self.bg:getChildByName("fish4")
    self.fish5 = self.bg:getChildByName("fish5")
    self.fish6 = self.bg:getChildByName("fish6")
    self.fish7 = self.bg:getChildByName("fish7")
    self.fish8 = self.bg:getChildByName("fish8")
    self.fish9 = self.bg:getChildByName("fish9")
    
    
    local function updateFunc(dt)  
        self:update(dt)  
    end  
end 

function GameScene13:modify()

    local chapter_tb = PublicData.CHAPTERTABLE
    chapter_tb[2].lock = 0

    local str = json.encode(chapter_tb)
    ModifyData.writeToDoc(str,"chapter")

    -- local tb = PublicData.ROOMTABLE
    -- tb[chapterNumber+1][roomNumber].lock=0
    -- local str = json.encode(tb)
    -- ModifyData.writeToDoc(str,"room")
    UItool:setBool("topbar",false)

    ModifyData.removeDoc("GBposition")
    ModifyData.removeDoc("furniture")
    ModifyData.removeDoc("mergeitem")
    PublicData.MERGEITEM={}
    PublicData.FURNITURE={}
    PublicData.SAVEDATA={}
    -- table.insert(PublicData.MERGEITEM, 11)


    ModifyData.setRoomNum(1)
    UItool:setInteger("roomNumber", 1)

    ModifyData.setChapterNum(2)
    UItool:setInteger("chapterNumber", 2)
    

    local scene = GameScene12.new()
    local turn = cc.TransitionFade:create(1, scene)
    cc.Director:getInstance():replaceScene(turn)

end






function GameScene13:AllButtons(  )
    self.AllButtons = 
    {   

    }

    local function allButtonClick(event,eventType)
        if eventType == TOUCH_EVENT_ENDED then
            if UItool:getBool("effect") then
                AudioEngine.playEffect("gliss.mp3")
            end
        end
    end


    for key, var in pairs(self.AllButtons) do
        var:addClickEventListener(allButtonClick)
    end

end

function GameScene13:ontouch( ... )
    --触摸
    --实现事件触发回调
    local function onTouchBegan(touch, event)
        --人物行走调用
        local rect = cc.rect(0, 145,self.bg:getContentSize().width, self.bg:getContentSize().height)  
  
        if cc.rectContainsPoint(rect, touch:getLocation()) then  
           local gril_pointx = self.grossini:getPositionX()
           local target = event:getCurrentTarget()
           local locationInNode = target:convertToNodeSpace(touch:getLocation())  
           local touchlocation = touch:getLocation()
           --点击效果

           GameScenemove(touchlocation.x,touchlocation.y,nil,self.grossini,self.bg)

           else
        end  
        self.merge:removeSelf()
        self.merge = Merge:createScene()
        self:addChild(self.merge,5)
         
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


function GameScene13:onEnterTransitionFinish ()
    
  
    
    -- self.right:removeFromParent()
    --点击效果层
    local dianjilayer = TouchLayer:new()
    self.bg:addChild(dianjilayer,128)

    
   
end

function GameScene13:onEnter()
    self:init()
    
    -- self.right = cc.Sprite:create("cn/Load/image/UI/pause.png")
    -- self.right:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))
    -- self:addChild(self.right,29)
    -- local rotate = cc.RotateBy:create(2, -30)
    -- self.right:runAction( cc.RepeatForever:create(rotate))
     
end

return GameScene13

















