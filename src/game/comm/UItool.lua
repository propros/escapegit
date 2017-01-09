UItool = class("UItool")

--弹出框
function UItool:message(...)
    local message = Message.new()   
    message:open(...)
end

function UItool:getRunningSceneObj()
	--获取当前的场景
    local director = cc.Director:getInstance()
    return director:getRunningScene()
end

function UItool:getitem_location(item,bg)
	return item+bg
end