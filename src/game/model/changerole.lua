

function changerole (chapter,room,parent)	
	print("更换主角changerole()",chapter,room)

	local visiblesize = cc.Director:getInstance():getVisibleSize()
	local pic = Data.SCENE[chapter][room] 
	parent:setTexture(pic.changerolepic)
	-- local bg = cc.Sprite:create(pic.changerolepic)
 --    bg:setPosition(cc.p(visiblesize.width/4,visiblesize.height/4))
 --    bg:setScale(0.5)
    -- local scene = UItool:getRunningSceneObj()
    -- parent:addChild(bg,1)
    -- bg:addTo(self)
end