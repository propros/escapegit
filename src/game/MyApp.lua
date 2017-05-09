
require("game.comm.RequireLua")

local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()



	local director = cc.Director:getInstance()
    local platform = cc.Application:getInstance():getTargetPlatform()
    if platform == cc.PLATFORM_OS_LINUX or platform == cc.PLATFORM_OS_MAC or platform == cc.PLATFORM_OS_WINDOWS then
        director:setDisplayStats(true)
    else
          director:setDisplayStats(false)
    end
    
    director:setAnimationInterval(1.0 / 30)

    --适配

    local frameSize = cc.Director:getInstance():getOpenGLView():getFrameSize()
    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(1920,1080, cc.ResolutionPolicy.FIXED_HEIGHT)

    
    print("******")

    -- if UItool:getBool("music", true) then
    --     print("音乐背景 true ")
    --     UItool:setBool("music", true)
    --     AudioEngine.playMusic("music/jintou.mp3")
    --     else
    --         UItool:setBool("music", false)
    --         print("音乐背景 false ")
    -- end
    AudioEngine.preloadMusic("jintou.mp3")
    AudioEngine.preloadEffect("gliss.mp3")
   
end

return MyApp
