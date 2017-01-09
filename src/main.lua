
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"


function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("-----------------------------------------")
    return msg
end

local function main()
	require("game.MyApp"):create():run()

end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
