-- require("cocos/ui/DeprecatedUIEnum")

UItool = class("UItool")

-- 当前状态.
UItool.m_currentState = nil
UItool.message = nil 

--table深拷贝
function UItool:deepcopy(object)
    local lookup_table = {}  
    local function _copy(object)  
        if type(object) ~= "table" then  
            return object  
        elseif lookup_table[object] then  
  
            return lookup_table[object]  
        end  -- if          
        local new_table = {}  
        lookup_table[object] = new_table  
  
  
        for index, value in pairs(object) do  
            new_table[_copy(index)] = _copy(value)  
        end   
        return setmetatable(new_table, getmetatable(object))      
    end       
    return _copy(object)  
end 

--特殊物品特效
function UItool:specialitem(...)

    local special = SpecialItembg.new()   
    special:open(...)
    print("uitool special")
end

--弹出框
function UItool:message1(...)
    print("是否走到了这里")
    local messages = Message.new()   
    messages:open(...)
end

function UItool:message3(str1,str2,size)

    local message3 = Message3.new()   
    message3:open(str1,str2,size)
    print("uitool message3")
end


function UItool:message4(str1,str2,str3,str4,size,parente)

    local message4 = Message4.new()   
    message4:open(str1,str2,str3,str4,size,parente)
end

function UItool:message2(...)
    
    if UItool.message ~= nil then
        if UItool:getBool("topbar") then
            UItool:setBool("topbar",true)
            UItool.message:removeSelf()
            UItool.message = Message2.new()
            UItool.message:open(...)
            else
                UItool.message = Message2.new()
                UItool.message:open(...)
                UItool:setBool("topbar",true)
        end
        else
            UItool.message = Message2.new()
            UItool.message:open(...)
            UItool:setBool("topbar",true)
    end
    
end
function UItool:password(...)

    local password = password.new()
    password:open(...)
end

function UItool:getRunningSceneObj()
	--获取当前的场景
    local director = cc.Director:getInstance()
    return director:getRunningScene()
end

function UItool:getitem_location(item,bg)
	return item:getPositionX()+bg , item:getPositionY()
end

function UItool:setString( key , value )
    cc.UserDefault:getInstance():setStringForKey(key, value)
    cc.UserDefault:getInstance():flush()
    
end

-- 根据key获取字符串，default为获取失败时返回的默认值
function UItool:getString( key , default)
   local string=cc.UserDefault:getInstance():getStringForKey(key)

   if isNull(string) then
       return defauly
   end

    return string
end
-- bool类型
function UItool:setBool( key , value )
    cc.UserDefault:getInstance():setBoolForKey(key, value)
    cc.UserDefault:getInstance():flush()
    -- print("sound is :",cc.UserDefault:getInstance():getBoolForKey(key))
-- print("··///·",cc.FileUtils:getInstance():getWritablePath())
end

-- 根据key获取字符串，default为获取失败时返回的默认值
function UItool:getBool( key , default)
    local value = cc.UserDefault:getInstance():getBoolForKey(key,default)
   return value
end

-- 整数类型
function UItool:setInteger( key , value )
    cc.UserDefault:getInstance():setIntegerForKey(key, value)
    cc.UserDefault:getInstance():flush()
--     print("sound is :",cc.UserDefault:getInstance():getBoolForKey(key))
-- print("··///·",cc.FileUtils:getInstance():getWritablePath())
end

-- 根据key获取字符串，default为获取失败时返回的默认值
function UItool:getInteger( key )
    local value = cc.UserDefault:getInstance():getIntegerForKey(key)
   return value
end

function UItool:getIntegerdefault( key , default)
    local value = cc.UserDefault:getInstance():getIntegerForKey(key,default)
   return value
end



function UItool:removeUserXML( )
    local xmlpaths = cc.UserDefault:getXMLFilePath()
    print("xmlpaths:",xmlpaths)
    local strTab=UItool:StringSplit(xmlpaths,"Caches/UserDefault.xml")  
    local xmlpath=strTab[1].."Preferences/com.cangland.EscapeGame.plist"
    print("xmlpath2222222:",xmlpath)
    if xmlpath then
        print("存在")
        else
            print("不存在")
    end
    cc.FileUtils:getInstance():removeFile(xmlpath)
end

-- local strTab=StringSplit("1233333456","33")  
-- for index = 1,#strTab do  
--     print(strTab[index])  
-- end

--截取lua字符串
function UItool:StringSplit(str, splitStr,addNemptyStr,addSplitStrInTable)  
    if not addNemptyStr then addNemptyStr = false end  
    if not addSplitStrInTable then addSplitStrInTable = false end  
    local subStrTab = {};  
    while (true) do  
        local pos = string.find(str, splitStr);  
        if (not pos)  then  
            if str ~="" or addNemptyStr then  
                subStrTab[#subStrTab + 1] = str;  
            end  
            break;  
        end  
        local subStr = string.sub(str, 1, pos - 1);  
        if subStr~="" or addNemptyStr then  
            subStrTab[#subStrTab + 1] = subStr;  
        end  
        if addSplitStrInTable then  
            subStrTab[#subStrTab + 1] = splitStr;  
        end  
        str = string.sub(str, pos +string.len(splitStr) , #str);  
    end  
    return subStrTab;  
end 

function UItool:ifcontain( num )
    for key,var in pairs(PublicData.MERGEITEM) do
        if var == num then
            return true

            else
        end
    end
end

-- 设置当前状态.
function UItool:setCurrentState(state)
    self.m_currentState = state
    return true
end
-- 获取当前状态.
function UItool:getCurrentState()
    return self.m_currentState
end

function UItool:addBtnTouchEvent(_btn,_beganFun,_movedFun,_endedFun,canceledFun,_soundfile,_self)
    local function onBack(_fun,_touch,_type)
        
        if _fun ~= nil then
            if _self ~= nil then
                _fun(_self,_touch,_type)
            else
                _fun(_touch,_type)
            end
        end
    end
    local starTime = 0
    local function onTouchEvent(touch, _type)
        if _type == TOUCH_EVENT_BEGAN then --ccui.TouchEventType.began then
        
            if _soundfile ~= nil then
                --MusicFacade:playSoundForTag(_soundType)
                AudioEngine.playEffect(_soundfile)
            end
            print("*************")
            -- onBack(_beganFun,touch,_type)
            onBack(_endedFun,touch,_type)
        elseif _type == TOUCH_EVENT_MOVED then -- ccui.TouchEventType.moved then
            print("00000000000")
            onBack(_movedFun,touch,_type) 
        elseif _type == TOUCH_EVENT_ENDED then
            print("+++++++++++++")
            onBack(_endedFun,touch,_type)
        elseif _type == TOUCH_EVENT_CANCELED then
            onBack(canceledFun,touch,_type)
        end
    end
    _btn:addClickEventListener(onTouchEvent)
end

--设置滚动容器
--@param _slv 滚动容器
--@param _sld 滚动条
--@param _allNodeNum 总共要添加子类的个数 如果传_childList 了这个可以不传
--@param _countNum 每行个数  不传时默认是1
--@param _spX 子类x轴的间隔
--@param _spY y轴的间隔
--@param _childList 要添加子类的的列表一定是排好序的


--UIunit:setScrollView(self.srollview,1,3,400,480,list)
-- function UItool:setScrollView(_slv,_allNodeNum,_countNum,_spX,_spY,_childList,_startX,_startY)
--     local coun = 0

--     if _childList ~= nil then
--      _allNodeNum = #_childList
--     end

--     _startX = _startX or 0
--     _startY = _startY or 0

--         local cc = math.floor(_allNodeNum/_countNum)
--         if _allNodeNum%_countNum >0 then
--             cc = cc+1
--         end
--         coun = cc*_spY
    
--     local _size = _slv 
--     if _childList ~= nil then
--         for var=1, #_childList do
--             local node_1 = _childList[var]
--             local y = _size.height-(math.floor((var-1)/_countNum)+1)*_spY
--             node_1:setPosition(((var-1)%_countNum)*_spX+_startX,y+_startY)
--             _slv:addChild(node_1)
--         end
--     end

-- end

function UItool:setScrollView(_slv,_sld,_allNodeNum,_countNum,_spX,_spY,_childList,_startX,_startY)
   
    local coun = 0
    local direType = _slv:getDirection()
    print("类型",_slv:getDirection())
    if _childList ~= nil then
     _allNodeNum = #_childList
    end
    --  1 代表 SCROLLVIEW_DIR_VERTICAL
    print("cha  aaa", direType , SCROLLVIEW_DIR_VERTICAL)
    _startX = _startX or 0
    _startY = _startY or 0
    if  direType == 1 then
        if _countNum == nil or _countNum == 0 then
            _countNum = 1
        end
        local cc = math.floor(_allNodeNum/_countNum)
        if _allNodeNum%_countNum >0 then
            cc = cc+1
        end
        coun = cc*_spY
    elseif direType  == SCROLLVIEW_DIR_HORIZONTAL  then
        coun = _allNodeNum*_spX
    end
    if _spX == nil then _spX = 0 end
    local _size = UItool:onlySetScrollView(_slv,_sld,coun)
    if _childList ~= nil then
        if direType == 1 then
            for var=1, #_childList do
                local node_1 = _childList[var]
                local y = _size.height-(math.floor((var-1)/_countNum)+1)*_spY
                node_1:setPosition(((var-1)%_countNum)*_spX+_startX,y+_startY)
                _slv:addChild(node_1)
            end
        elseif direType == SCROLLVIEW_DIR_HORIZONTAL  then
            for var=1, #_childList do
                local node_1 = _childList[var]
                node_1:setPosition((var-1)*_spX+_startX,_startY)
                _slv:addChild(node_1)
            end
        end
    end

end

-- 只设置滚动容器，不进行子类添加
--@param _slv 滚动容器
--@param _sld 滚动条
--@param _slvHeighOrWidth 滚动容器的高或者宽
function UItool:onlySetScrollView(_slv,_sld,_slvHeighOrWidth)
    local schedulerID = nil
    local scheduler = cc.Director:getInstance():getScheduler()
    _slv:registerScriptHandler(function(eventType)
        if eventType == "exitTransitionStart" then
            _slv:addEventListener(function()end)
            if schedulerID  ~= nil then
                scheduler:unscheduleScriptEntry(schedulerID)
            end
        end
    end)
    local _size = _slv:getInnerContainerSize()
    local direType = _slv:getDirection()
    _slvHeighOrWidth = _slvHeighOrWidth or 0
    local contenSize = _slv:getContentSize()
    local innerLength = 0
    local conntentLength = 0
    if  direType == 1 then
        if  _slvHeighOrWidth - _size.height >0 then
            _size.height = _slvHeighOrWidth
        end
        innerLength = _size.height
        conntentLength = contenSize.height
    elseif direType  == SCROLLVIEW_DIR_HORIZONTAL  then

        if _slvHeighOrWidth > _size.width then
            _size.width = _slvHeighOrWidth
        end
        innerLength = _size.width
        conntentLength = contenSize.width
    end
    _slv:setInnerContainerSize(_size)
    if _sld == nil then return _size end
    _sld:stopAllActions()
    _sld:setOpacity(0)
    if innerLength - conntentLength <=2 then return _size end
    local function setInfo()
        local _py  = 0
        if direType == 1 then
            _py = 1-(0-_slv:getInnerContainer():getPositionY())/(_size.height - _slv:getContentSize().height)
        elseif direType  == SCROLLVIEW_DIR_HORIZONTAL  then
            _py  = _slv:getInnerContainer():getPositionX()/(_slv:getContentSize().width-_size.width)
        end
        _sld:setPercent(_py*100)
    end
    local  function getInnerPosition()
        if direType == 1 then
            return _slv:getInnerContainer():getPositionY()
        elseif direType  == SCROLLVIEW_DIR_HORIZONTAL  then
            return _slv:getInnerContainer():getPositionX()
        end
    end
    local oldNum = getInnerPosition()


    local function tick(param)
        if oldNum == getInnerPosition() then
            scheduler:unscheduleScriptEntry(schedulerID)
            schedulerID = nil
            if _sld == nil then return end
            _sld:runAction(cc.Sequence:create(cc.FadeOut:create(0.2)))
        else
            oldNum = getInnerPosition()
        end
    end
    local function onScroll(tager,select)
        setInfo()
        if schedulerID == nil and oldNum ~= getInnerPosition() then
            _sld:stopAllActions()
            _sld:runAction(cc.Sequence:create(cc.FadeIn:create(0.1)))
            schedulerID = scheduler:scheduleScriptFunc(tick,0.2, false)
        end
    end
    _slv:addEventListener(onScroll)
    setInfo()
    return _size
end




















