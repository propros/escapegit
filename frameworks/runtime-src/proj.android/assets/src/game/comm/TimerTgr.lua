
--****************************************************************** 
-- 文件名:    TimerTgr.lu 
-- 版 权:    (C) 从这里开始 
-- 创建人:    陈泽丹 
-- 日 期:    2014-10-26 14:12 
-- 版 本:    1.0 
-- 描 述:     
--************************** 修改记录 ****************************** 
-- 修改人: 
-- 日 期: 
-- 描 述: 
--****************************************************************** 



-- 定时器 
function TimerBuf() 
    local public, protected = {},{} 
    public = public or {} 
    protected = protected or {} 
    local private = {} 

    -------------------------------------------------------------------- 
    -- public: 
    -- 运行 
    function public:create( _times, _debugInfo ) 
        private.times = _times 
        protected.debugInfo = _debugInfo 
    end 

    -- 释放 
    function public:release() 
        if public:isRun() then 
            public:stop() 
        end 
    end 

    -- 开启 
    function public:start() 
        if public:isRun() then 
            public:stop() 
        end 
        local function onTime() 
            self:onTime() 
        end 
        private.tgr = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onTime, private.times, false) 
        return true 
    end 

    -- 结束 
    function public:stop() 
        if public:isRun() then 
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry( private.tgr ) 
            private.tgr = nil 
        end 
    end 

    -- 是否进行中 
    function public:isRun() 
        if nil == private.tgr then 
            return false 
        end 
        return true 
    end 

    -- 回调 
    function public:onTime( ... ) 
        cclog( "TimerBuf:onTime is nil" ) 
    end 

    -------------------------------------------------------------------- 
    return public 
end 

-- 定时器 
function TimerExBuf() 
    local public, protected = {},{} 
    public = public or {} 
    protected = protected or {} 
    local private = 
        { 
            intervalTimer   = TimerBuf(), 
            timesTimer      = TimerBuf(), 
        } 

    -------------------------------------------------------------------- 
    -- public: 
    -- 运行 
    function public:create( _interval, _times, _debugInfo ) 
        protected.debugInfo = _debugInfo 
        private.intervalTimer:create( _interval, _debugInfo ) 
        private.timesTimer:create( _times, _debugInfo ) 
        function private.intervalTimer:onTime() 
            private.timesTimer:start() 
            private.intervalTimer:stop() 
        end 
        function private.timesTimer:onTime() 
            public:onTime() 
        end 
    end 

    -- 释放 
    function public:release() 
        if public:isRun() then 
            public:stop() 
        end 
    end 

    -- 开启 
    function public:start() 
        if public:isRun() then 
            public:stop() 
        end 
        private.intervalTimer:start() 
        return true 
    end 

    -- 结束 
    function public:stop() 
        if private.intervalTimer:isRun() then 
            private.intervalTimer:stop() 
        end 
        if private.timesTimer:isRun() then 
            private.timesTimer:stop() 
        end 
    end 

    -- 是否进行中 
    function public:isRun() 
        if private.intervalTimer:isRun() then 
            return true 
        end 
        if private.timesTimer:isRun() then 
            return true 
        end 
        return false 
    end 


    -- 回调 
    function public:onTime( ... ) 
        cclog( "TimerExBuf:onTime is nil" ) 
    end 

    -------------------------------------------------------------------- 
    return public 
end 