
GameScene13=class("GameScene13", function()
    return cc.Scene:create()
end)

GameScene13.panel = nil
local roomNumber
local chapterNumber

function GameScene13:ctor()

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    
    self.bg = cc.Sprite:create("bg_mainscene.png")
    self.bg:setPosition(cc.p(0,0))
    self.bg:setAnchorPoint(cc.p(0,0))
    self.bg:addTo(self)

    roomNumber = ModifyData.getRoomNum()
    chapterNumber = ModifyData.getChapterNum()
    
    local function settingcallback( )

        local tb = PublicData.ROOMTABLE
        if roomNumber<#Data.SCENE[chapterNumber] then
            --todo
            tb[chapterNumber][roomNumber+1].lock=0
        end
        
        local str = json.encode(tb)
        ModifyData.writeToDoc(str,"room")
        UItool:message2("欢迎来到第三个房间",30)
    end

    self.setting = cc.MenuItemImage:create("comm/setting.png","comm/setting.png")
    self.setting:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2-100))
    self.setting:setAnchorPoint(cc.p(0.5,0.5))
    self.setting:setScale(2)
    -- 对该按钮注册按键响应函数：
    self.setting:registerScriptTapHandler(settingcallback)

    self.menu=cc.Menu:create(self.setting)
    self.menu:setPosition(0,0) 
    self:addChild(self.menu,2)

end

function GameScene13:init()
   

    
   
end

return GameScene13

















