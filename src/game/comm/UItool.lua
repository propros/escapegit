
UItool = class("UItool")

-- 当前状态.
UItool.m_currentState = nil
UItool.message = nil 

--弹出框
function UItool:message(...)
    local message = Message.new()   
    message:open(...)
end

function UItool:message3(str1,str2,size)

    local message3 = Message3.new()   
    message3:open(str1,str2,size)
    print("uitool message3")
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
function UItool:message2removeFromParent()
    local message = Message2.new()
    message:removeFromParents()
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
    -- print("sound is :",cc.UserDefault:getInstance():getBoolForKey(key))
-- print("··///·",cc.FileUtils:getInstance():getWritablePath())
end

-- 根据key获取字符串，default为获取失败时返回的默认值
function UItool:getBool( key , default)
    local value = cc.UserDefault:getInstance():getBoolForKey(key)
   return value
end

-- 整数类型
function UItool:setInteger( key , value )
    cc.UserDefault:getInstance():setIntegerForKey(key, value)
--     print("sound is :",cc.UserDefault:getInstance():getBoolForKey(key))
-- print("··///·",cc.FileUtils:getInstance():getWritablePath())
end

-- 根据key获取字符串，default为获取失败时返回的默认值
function UItool:getInteger( key , default)
    local value = cc.UserDefault:getInstance():getIntegerForKey(key)
   return value
end

function UItool:ifcontain( num )
    for key,var in pairs(ModifyData.getTable()) do
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


--@param _slv 底层图片
--@param _allNodeNum 总共要添加子类的个数 如果传_childList 了这个可以不传
--@param _countNum 每行个数  不传时默认是1
--@param _spX 子类x轴的间隔
--@param _spY y轴的间隔
--@param _childList 要添加子类的的列表一定是排好序的


--UIunit:setScrollView(self.srollview,1,3,400,480,list)
function UItool:setScrollView(_slv,_allNodeNum,_countNum,_spX,_spY,_childList,_startX,_startY)
    local coun = 0

    if _childList ~= nil then
     _allNodeNum = #_childList
    end

    _startX = _startX or 0
    _startY = _startY or 0

        local cc = math.floor(_allNodeNum/_countNum)
        if _allNodeNum%_countNum >0 then
            cc = cc+1
        end
        coun = cc*_spY
    
    local _size = _slv 
    if _childList ~= nil then
            for var=1, #_childList do
                local node_1 = _childList[var]
                local y = _size.height-(math.floor((var-1)/_countNum)+1)*_spY
                node_1:setPosition(((var-1)%_countNum)*_spX+_startX,y+_startY)
                _slv:addChild(node_1)
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
    if  direType == SCROLLVIEW_DIR_VERTICAL then
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
        if direType == SCROLLVIEW_DIR_VERTICAL then
            _py = 1-(0-_slv:getInnerContainer():getPositionY())/(_size.height - _slv:getContentSize().height)
        elseif direType  == SCROLLVIEW_DIR_HORIZONTAL  then
            _py  = _slv:getInnerContainer():getPositionX()/(_slv:getContentSize().width-_size.width)
        end
        _sld:setPercent(_py*100)
    end
    local  function getInnerPosition()
        if direType == SCROLLVIEW_DIR_VERTICAL then
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




















