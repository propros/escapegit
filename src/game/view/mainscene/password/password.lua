
password = class("password", function()
    return cc.Layer:create()
end)

function password:ctor( )

    self:passwords()
end

function password:passwords()
    self.furnituretb = PublicData.FURNITURE --存储文件

    self.panel = cc.CSLoader:createNode(Config.RES_PASSWORD)
    self.center = self.panel:getChildByName("Node_center")
    self.bg = self.center:getChildByName("pass_di")
    
    self.key_item = nil 
    local shildinglayer = Shieldingscreenpas:new()
    self:addChild(shildinglayer)
    self:addChild(self.panel)
    self.pass1 = 0
    self.pass2 = 0
    self.pass3 = 0
    self.pass4 = 0
    self.pass5 = 0

    self.number1 = self.bg:getChildByName("AtlasLabel_1")
    self.number2 = self.bg:getChildByName("AtlasLabel_2")
    self.number3 = self.bg:getChildByName("AtlasLabel_3")
    self.number4 = self.bg:getChildByName("AtlasLabel_4")
    self.number5 = self.bg:getChildByName("AtlasLabel_5")

    self:passbtn( )


end

function password:passwordbtn1(  )
    self.pass1 = self.pass1 + 1
    if self.pass1==10 then
        self.pass1=0
    end
    self.number1:setString(self.pass1)
    
end


function password:passwordbtn2(  )
    self.pass2 = self.pass2 +1
    if self.pass2==10 then
        self.pass2=0
    end
    self.number2:setString(self.pass2)
end


function password:passwordbtn3(  )
    self.pass3 = self.pass3 +1
    if self.pass3==10 then
        self.pass3=0
    end
    self.number3:setString(self.pass3)
end

function password:passwordbtn4(  )
     self.pass4 = self.pass4+1
     if self.pass4==10 then
        self.pass4=0
    end
    self.number4:setString(self.pass4)
end


function password:passwordbtn5(  )
     self.pass5 = self.pass5+1
     if self.pass5==10 then
        self.pass5=0
    end
    self.number5:setString(self.pass5)
end

function password:passbtn( )
    self.password1 = self.bg:getChildByName("password1")
    self.password2 = self.bg:getChildByName("password2")
    self.password3 = self.bg:getChildByName("password3")
    self.password4 = self.bg:getChildByName("password4")
    self.password5 = self.bg:getChildByName("password5")

    local allPassbtn = 
    {
        self.password1,
        self.password2,
        self.password3,
        self.password4,
        self.password5
    
    }

    local function allPassbtnclick(event,eventType)

        if eventType == TOUCH_EVENT_ENDED then
            
            if UItool:getBool("effect") then
                AudioEngine.playEffect("gliss.mp3")
            end
            if event:getName()=="password1" then
                self:passwordbtn1()
                elseif event:getName()=="password2" then
                    self:passwordbtn2()
                    elseif event:getName()=="password3" then
                        self:passwordbtn3()
                        elseif event:getName()=="password4" then
                            self:passwordbtn4()
                            elseif event:getName()=="password5" then
                                self:passwordbtn5()     
                        
            end
            
        end

    end

    for key, var in pairs(allPassbtn) do
        var:addClickEventListener(allPassbtnclick)
    end
end




function password:open( ... )
	self:openHandler(...)
	local scene = UItool:getRunningSceneObj()
    scene:addChild(self,11)
	--print("open(...)")
end

function password:openHandler(str,itemnum)  -- itemnum 密码打开以后里面的物品
    assert(type(str) == "string" or type(str) == "number", "提示框内容只能是字符串或者是数字类型！")
    --print(str)
    self:setpassword(str,itemnum)

end

function password:setpassword(str,itemnum)
	--print("输入的数字",str)
	local str = str or "警告"
	local itemnum = itemnum or nil 
   
    
    
    local OKbutton = self.bg:getChildByName("OK")
    OKbutton:addClickEventListener(function(psender,event)
        local sendpass = self.pass1..self.pass2..self.pass3..self.pass4..self.pass5
        if str == sendpass then
        	if itemnum == nil  then

        		else
                    
        			if Data.getItemData(itemnum).ifcontain == true  then
        				self.key_item = Data.getItemData(itemnum)
			        	-- ModifyData.tableinsert(self.key_item.key)
                        table.insert(PublicData.MERGEITEM, self.key_item.key)
			        	UItool:message2("里面是个颜料罐……怎么净是一些奇奇怪怪的东西。",30)

                        self.furnituretb[7].passpass = true
                        local str = json.encode(self.furnituretb)
                        ModifyData.writeToDoc(str,"furniture")

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






































