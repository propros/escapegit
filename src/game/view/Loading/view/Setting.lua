

Setting = class("Setting",function()
    return cc.Scene:create()
end)

function Setting:createScene()
    local Setting = Setting:new()
    
    Setting:initScene()
    return Setting
end
Setting.background=nil

function Setting:initScene()
    self.director = cc.Director:getInstance()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self:Settingbtn()

    if UItool:getBool("music", true) then
        print("音乐背景 true ")
        UItool:setBool("music", true)
        else
            UItool:setBool("music", false)
            print("音乐背景 false ")
    end

    if UItool:getBool("effect",true) then
        print("音效背景 true ")
        UItool:setBool("effect",true)
        else
            UItool:setBool("effect",false)
            print("音效背景 false ")
    end

end


function Setting:back(  )
    print("back")
    self:removeFromParent()
end

function Setting:Settingbtn( )
    local director = cc.Director:getInstance()
    self.background = cc.CSLoader:createNode(Config.RES_SETTING)
    --屏蔽层
    local shildinglayer = ShieldingLayerpin:new()
    self:addChild(shildinglayer) 
    self:addChild(self.background)

    local center = self.background:getChildByName("Node_center")
    center:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))
    local bg = center:getChildByName("bg")
    local back = bg:getChildByName("back")
    local musicslables  = bg:getChildByName("musics")
    

    local function backbtnclick(event,eventType)

        if eventType == TOUCH_EVENT_ENDED then
            if UItool:getBool("effect") then
                AudioEngine.playEffect("gliss.mp3")
            end
            self:back()
        end

    end
    back:addClickEventListener(backbtnclick)

    -- 背景音乐

    local soundOnItem = cc.MenuItemImage:create("setting/open.png","setting/open.png")         --创建菜单开的图片菜单项
     local soundOffItem = cc.MenuItemImage:create("setting/close.png","setting/close.png")
     local soundItem = cc.MenuItemToggle:create(soundOnItem,soundOffItem)  --创建开关菜单项MenuIemToggle
     soundItem:setPosition(cc.p(musicslables:getPositionX()+90,musicslables:getPositionY()))
     local function soundItemCallbck(args)
        -- cclog("soundItem")
        print("音效")
        if soundItem:getSelectedIndex()==1 then
            print("soundItem:getSelectedIndex()==1")
            UItool:setBool("effect",false)
            else
                print("soundItem:getSelectedIndex()~=1")
                UItool:setBool("effect",true)
                
                AudioEngine.playEffect("gliss.mp3")
            
        end
     end
     soundItem:registerScriptTapHandler(soundItemCallbck)
  
     local musicOnItem = cc.MenuItemImage:create("setting/open.png","setting/open.png")
     local musicOffItem = cc.MenuItemImage:create("setting/close.png","setting/close.png")
     local musicItem = cc.MenuItemToggle:create(musicOnItem,musicOffItem)
     musicItem:setPosition(cc.p(musicslables:getPositionX()-250,musicslables:getPositionY()))
     local function musicItemCallback(args)
        print("音乐")
        if musicItem:getSelectedIndex()==1 then
            print("musicItem:getSelectedIndex()==1")
            AudioEngine.stopMusic()
            UItool:setBool("music", false)
            else
                print("musicItem:getSelectedIndex()~=1")
                AudioEngine.playMusic("jintou.mp3",true)
                UItool:setBool("music", true)
                if UItool:getBool("effect") then
                    AudioEngine.playEffect("gliss.mp3")
                end
        end
        
     end

      if UItool:getBool("music", true) then
        print("音乐背景 true ")
        musicItem:setSelectedIndex(0)
        else
            musicItem:setSelectedIndex(1)
            
            print("音乐背景 false ")
    end

    if UItool:getBool("effect",true) then
        print("音效背景 true ")
        soundItem:setSelectedIndex(0)
        else
            soundItem:setSelectedIndex(1)
            print("音效背景 false ")
    end



     musicItem:registerScriptTapHandler(musicItemCallback)
  
     --创建Menu对象，并加入layer中
     local mn = cc.Menu:create(soundItem , musicItem )
     mn:setPosition(cc.p(0,0))
     bg:addChild(mn)

     

    --[[
    AudioEngine.setMusicVolume(0.5)                                  
     --设置背景音乐音量

    AudioEngine.setEffectsVolume(0.5)                      
         --设置音效音量

    AudioEngine.getMusicVolume()                                         
         --获得背景音乐音量

    AudioEngine.getEffectsVolume()                                 
         --获得音效音量
    --]]

    
    
end

function Setting:onExit()
    
end


return Setting
