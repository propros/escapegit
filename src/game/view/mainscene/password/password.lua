
password = class("password", function()
    return cc.Layer:create()
end)

function password:ctor( )
	self.panel = cc.CSLoader:createNode(Config.RES_PASSWORD)
    self.bg = self.panel:getChildByName("Node_center"):getChildByName("password_bg")
    self.TextFieldstring = nil
    self.key_item = nil 
    local shildinglayer = Shieldingscreenpas:new()
    self:addChild(shildinglayer)
    self:addChild(self.panel)
    
    
end

function password:open( ... )
	self:openHandler(...)
	local scene = UItool:getRunningSceneObj()
    scene:addChild(self,11)
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
    -- print("点击输入框")
        if self.bg:getChildByName("TextField_1"):getString()==str then
        	self.TextFieldstring = str
        end
        if self.TextFieldstring == self.bg:getChildByName("TextField_1"):getString() then
        	
        end
    end
    self.bg:getChildByName("TextField_1"):addEventListener(textFieldEvent) 

    local OKbutton = self.bg:getChildByName("OK")
    OKbutton:addClickEventListener(function(psender,event)
        if self.TextFieldstring == self.bg:getChildByName("TextField_1"):getString() then
        	if itemnum == nil  then

        		else
                    
        			if Data.getItemData(itemnum).ifcontain == true  then
        				self.key_item = Data.getItemData(itemnum)
			        	ModifyData.tableinsert(self.key_item.key)
			        	UItool:message2("“里面是个颜料罐……怎么净是一些奇奇怪怪的东西。”",30)
			        	Data.getItemData(itemnum).ifcontain = false 

                        -- local itempassnum = UItool:getInteger("yansemima")
                        -- for i=1,#ModifyData.getTable() do
                        --     if ModifyData.getTable()[i] == itempassnum then
                        --         table.remove(ModifyData.getTable(),i) 
                        --         break
                        --     end
                        -- end

			        	self:removeFromParent()
                        UItool:setBool("pasitem", true)
		        	else
		        		UItool:message2(" 里面已经没东西了。  ",30)
			        	self:removeFromParent()
        			end
        	end
        	else
        	    self:removeFromParent()
        		UItool:message2("密码不正确。",30)
        end
    end)
end






































