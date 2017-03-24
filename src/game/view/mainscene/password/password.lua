
password = class("password", function()
    return cc.Layer:create()
end)

function password:ctor( )
	self.panel = cc.CSLoader:createNode(Config.RES_PASSWORD)
    self.bg = self.panel:getChildByName("Node_center"):getChildByName("password_bg")
    self.TextFieldstring = nil
    self.key_item = nil 
    local shildinglayer = Shieldingscreen:new()
    self:addChild(shildinglayer)
    self:addChild(self.panel)

    local closebutton = self.bg:getChildByName("OK")
    closebutton:addClickEventListener(function(psender,event)
        if self.TextFieldstring == self.bg:getChildByName("TextField_1"):getString() then
        	self:removeFromParent()
        	else
        	    self:removeFromParent()
        		UItool:message2("密码不正确",30)
        end
    end)

end

function password:open( ... )
	self:openHandler(...)
	local scene = UItool:getRunningSceneObj()
    scene:addChild(self)
	print("open(...)")
end

function password:openHandler(str,itemnum)
    assert(type(str) == "string" or type(str) == "number", "提示框内容只能是字符串或者是数字类型！")
    print(str)
    self:setpassword(str,itemnum)

end

function password:setpassword(str,itemnum)
	print("输入的数字",str)
	local str = str or "警告"
	local itemnum = itemnum or nil 
    local function textFieldEvent(sender, eventType)
    print("点击输入框")
        if self.bg:getChildByName("TextField_1"):getString()==str then
        	self.TextFieldstring = str
        end
        if self.TextFieldstring == self.bg:getChildByName("TextField_1"):getString() then
        	if itemnum == nil  then
        		UItool:message2("里面是空的。",30)
        		self:removeFromParent()
        		else
        			if Data.getItemData(itemnum).appear == false  then
        				self.key_item = Data.getItemData(itemnum)
			        	ModifyData.tableinsert(self.key_item.key)
			        	UItool:message2("密码正确，你的到了 "..self.key_item.name,30)
			        	Data.getItemData(itemnum).appear = true 
			        	self:removeFromParent()
		        	else
		        		UItool:message2(" 里面没东西了  ",30)
			        	self:removeFromParent()

        			end
        	end
        end
    end
    self.bg:getChildByName("TextField_1"):addEventListener(textFieldEvent) 
end






































