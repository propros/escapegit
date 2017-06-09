
Girlactions = class("Girlactions",function( )
    -- local str = select(1,...) 
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/loli/Export/loli/loli.ExportJson")
	return ccs.Armature:create("loli")
    end)


function Girlactions:walk()
    self:getAnimation():playWithIndex(1)
 	self:getAnimation():play("walk")
end

function Girlactions:stand()
    self:getAnimation():playWithIndex(1)
    self:getAnimation():play("stand")
end

-- function Girlactions:setscaleX( strx )
--     self.grossini:setScaleX(str)
-- end

-- function Girlactions:setscaleY( stry )
--     self.grossini:setScaleY(str)
-- end




return Girlactions
