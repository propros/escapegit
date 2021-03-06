

Shoucang = class("Shoucang",function()
    return cc.Scene:create()
end)

function Shoucang:createScene()
    local Shoucang = Shoucang:new()
    
    Shoucang:initScene()
    return Shoucang
end
Shoucang.background=nil

function Shoucang:initScene()
    self.director = cc.Director:getInstance()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    -- 收藏存储
    if #PublicData.SHOUCANG==0 then
        local docpath = cc.FileUtils:getInstance():getWritablePath().."shoucang.txt"
        if cc.FileUtils:getInstance():isFileExist(docpath)==false then
            local str = json.encode(PublicData.SHOUCANG)
            ModifyData.writeToDoc(str,"shoucang")
            -- PublicData.SHOUCANG = Data.CHAPTER
            print("写文件")
        else
            print("读文件")
            local str = ModifyData.readFromDoc("shoucang")
            PublicData.SHOUCANG = json.decode(str)
        end
    end

    self.background = cc.CSLoader:createNode(Config.RES_SHOUCANG)
    -- --屏蔽层
    local shildinglayer = ShieldingLayerpin:new()
    self:addChild(shildinglayer) 
    self:addChild(self.background)

    local center = self.background:getChildByName("Node_center")
    center:setPosition(cc.p(self.visibleSize.width/2,self.visibleSize.height/2))

    self.back = center:getChildByName("back")
    self.back :addClickEventListener(function ()
        if UItool:getBool("effect") then
            AudioEngine.playEffect("gliss.mp3")
        end
        self:removeFromParent()
        end)

    self.srollview = center:getChildByName("ScrollView_1")

    -- for k,v in pairs(PublicData.SHOUCANG) do
        
    --     local icon = Data.getItemData(v)
    --     self.sprite = cc.Sprite:create(icon.pic)
    --     local y = 1080-(math.floor((k-1)/2)+1)*340
    --     -- local y = 10 
    --     self.sprite:setAnchorPoint(cc.p(0,0))
    --     self.sprite:setPosition(((k-1)%2)*430+600  ,y)
    --     self:addChild(self.sprite,2) 
    -- end


    
   self.srollview:removeAllChildren()
   local list = {}
    for i=1,#PublicData.SHOUCANG+1 do
        self.item=cc.CSLoader:createNode("cn/Load/collectitem.csb")
        self.di = self.item:getChildByName("Sprite_1")
        self.que = self.item:getChildByName("question")
        if i == #PublicData.SHOUCANG+1 then
            
            else
                -- PublicData.SHOUCANG[i]
                self.que:setTexture("role"..i..".jpg")
        end
        
        table.insert(list,self.item)

    end

    -- for i=1,20 do
    --     self.item=cc.CSLoader:createNode("cn/Load/collectitem.csb")
    --     self.di = self.item:getChildByName("Sprite_1")
    --     table.insert(list,self.item)
    -- end


    UItool:setScrollView(self.srollview,nil,1,2,500,self.di:getContentSize().height*1.5,list)


end



function Shoucang:onExit()
    
end



return Shoucang
