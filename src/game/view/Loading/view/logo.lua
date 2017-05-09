

local logo = class("logo", cc.load("mvc").ViewBase)



function logo:onCreate()
    
    self.director = cc.Director:getInstance()
	self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
 
    self.bg = cc.Sprite:create("zhonggao.jpg")
    self.bg:setAnchorPoint(cc.p(0.5,0.5))
    self.bg:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))
    self.bg:addTo(self,1)

    local timer = TimerExBuf()
    timer:create(1,1,1)
    function timer:onTime()
        local scene = Loading.new()
        local turn = cc.TransitionFade:create(1,scene)
        cc.Director:getInstance():replaceScene(turn)
        timer:stop()
    end
    timer:start()

    
end

function logo:onExit()
	if UItool:getBool("music", true) then
        print("音乐背景 true ")
        UItool:setBool("music", true)
        AudioEngine.playMusic("jintou.mp3",true)
        else
            UItool:setBool("music", false)
            print("音乐背景 false ")
    end
    
    AudioEngine.setMusicVolume(UItool:getInteger( "volumepercent" , 100 )/100)                              

end

return logo











