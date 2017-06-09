

function changerole (chapter,room,parent)	
	print("更换主角changerole()",chapter,room)

	local visiblesize = cc.Director:getInstance():getVisibleSize()
	local pic = Data.SCENE[chapter][room] 
	local bg = cc.Sprite:create(pic.changerolepic)
    bg:setPosition(cc.p(visiblesize.width/2,visiblesize.height/2))
    local scene = UItool:getRunningSceneObj()
    parent:addChild(bg,11)
    -- bg:addTo(self)
end