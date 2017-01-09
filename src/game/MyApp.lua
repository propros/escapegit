
require("game.comm.RequireLua")

local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()



	local director = cc.Director:getInstance()
    local platform = cc.Application:getInstance():getTargetPlatform()
    if platform == cc.PLATFORM_OS_LINUX or platform == cc.PLATFORM_OS_MAC or platform == cc.PLATFORM_OS_WINDOWS then
        director:setDisplayStats(true)
    else
          director:setDisplayStats(false)
--        director:setDisplayStats(true)
    end

    math.randomseed(os.time())

    --适配

    local frameSize = cc.Director:getInstance():getOpenGLView():getFrameSize()
    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(1920,1080, cc.ResolutionPolicy.FIXED_HEIGHT)

    
    print("******")
   
end

return MyApp
