local Girlactions = class("Girlactions",function()
		return display.newSprite("#player1-1-1.png")
	end)

function Girlactions:ctor()
    local StateMachine = require("game.comm.StateMachine")
    self.fsm =  StateMachine.new() --创建状态机

    self.fsm:setupState({
        events = 
        {
            {name = "walkAction", from = {"none","attackA","attackB","hurt"},   to = "walk" },
            
        },
        callbacks = 
        {
            onbeforewalkAction = function(event) self:stopAllActions(); end,
            onwalkAction = function(event) self:walk() end,
            onleavewalkAction = function(event)  end,

            onbeforehurtAction = function(event) self:stopAllActions(); end,
            onhurtAction = function(event) 
                    self:hurt();
                    self:performWithDelay(function() self.fsm:doEvent("walkAction") end, 0.5); 
                end,
            onleavehurtAction =  function(event)  end,

            onbeforedeadAction = function(event) self:stopAllActions(); end,
            ondeadAction = function(event)self:dead() end,
            onleavedeadAction = function(event) end,

            onbeforeattackAAction = function(event) self:stopAllActions(); end,
            onattackAAction = function(event) 
                self:attackA()
                self:performWithDelay(function() self.fsm:doEvent("walkAction") end, 0.5); end,
            onleaveattackAAction = function(event) end,

            onbeforeattackBAction = function(event)  self:stopAllActions(); end,
            onattackBAction = function(event) self:attackB()
            self:performWithDelay(function() self.fsm:doEvent("walkAction") end, 0.5); end,
            onleaveattackBAction = function(event) end,
        },
    })
end

function Girlactions:walk()
 	local frames = display.newFrames("player1-1-%i.png", 1, 4)--行走
	local animation = display.newAnimation(frames, 0.5 / 4) 
	self:playAnimationForever(animation)
end


return Girlactions
