
local Girl=class("Girl",function ()
  local girls = cc.Sprite:create("walk/w2.png")
  return girls
end)

function Girl:onEnterRun(  )
  local grossini = cc.Sprite:create("walk/w2.png")
    local animation = cc.Animation:create()  
  local name  
  for i = 1, 4 do  
    
    name = "walk/w"..i..".png"  
    -- 用图片名称加一个精灵帧到动画中  
    animation:addSpriteFrameWithFile(name)  
  end  
  -- should last 2.8 seconds. And there are 14 frames.  
  -- 在2.8秒内持续14帧  
  animation:setDelayPerUnit(5 / 14.0)  
  -- 设置"当动画结束时,是否要存储这些原始帧"，true为存储  
  animation:setRestoreOriginalFrame(true)  
  
  -- 创建序列帧动画  
  local action = cc.Animate:create(animation)  
  grossini:runAction(cc.RepeatForever:create(action))

end

function Girl:onEnterRun(  )
  
end

return Girl

