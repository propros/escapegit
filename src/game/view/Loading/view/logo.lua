

local logo = class("logo", cc.load("mvc").ViewBase)



function logo:onCreate()
    
    self.director = cc.Director:getInstance()
	self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
 
    self.bg = cc.Sprite:create("cn/Load/image/UI/gamelogo.png")
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self.bg:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))
    self.bg:addTo(self,1)

    local timer = TimerExBuf()
    timer:create(2,1,1)
    function timer:onTime()
        local scene = Loading.new()
        local turn = cc.TransitionFade:create(1,scene)
        cc.Director:getInstance():replaceScene(turn)
        timer:stop()
    end
    timer:start()
    -- UItool:setBool("ifcontinue", false)
    -- table.insert(PublicData.MERGEITEM,19)
    -- table.insert(PublicData.MERGEITEM,11)

    
end

function logo:onExit()
	if UItool:getBool("music", true) then
        
        UItool:setBool("music", true)
        AudioEngine.playMusic("sound/jintou.mp3",true)
        else
            UItool:setBool("music", false)
            
    end
    
    
    -- AudioEngine.setMusicVolume(UItool:getIntegerdefault( "volumepercent" , 100 )/100)    
    -- ModifyData.removeDoc("savedata")     
          

end

return logo











