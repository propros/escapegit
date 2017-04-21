
Girlactions = class("Girlactions",function( ... )
    local str = select(1,...) 
	return ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(str) 
    end)

function Girlactions:ctor(name )
    self.grossini = name 
    self.grossini = ccs.Armature:create(name)
end

function Girlactions:create(name )
    
    self.grossini:getAnimation():playWithIndex(1)
    local girlation = Girlactions .new ()

    return girlation
end

function Girlactions:walk()
 	self.grossini:getAnimation():play("walk")
end

function Girlactions:stand()
    self.grossini:getAnimation():play("stand")
end

function Girlactions:setscaleX( strx )
    self.grossini:setScaleX(str)
end

function Girlactions:setscaleY( stry )
    self.grossini:setScaleY(str)
end




return Girlactions
