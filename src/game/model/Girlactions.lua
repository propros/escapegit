
Girlactions = class("Girlactions",function( )
    -- local str = select(1,...) 
 --    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/donghua/loli/Export/loli/loli.ExportJson")
	-- return ccs.Armature:create("loli")

	if UItool:getBool("oneroomagain", false)==false then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/donghua/loli/Export/loli/loli.ExportJson") 
        return ccs.Armature:create("loli")
        else
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/donghua/lolierzhoumu/Export/lolierzhoumu/lolierzhoumu.ExportJson")     
            return ccs.Armature:create("lolierzhoumu")
    end
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
