function GameScenemove(X, Y,event,grossini,bg)

	local girlx = 0.28
    local girly = 0.28

	local director = cc.Director:getInstance()
    local visibleSize = cc.Director:getInstance():getVisibleSize() 
    local winsize = cc.Director:getInstance():getWinSizeInPixels()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    --点击位置
        local apoint = X
        local gril_pointx = grossini:getPositionX()
        local delta =  X - gril_pointx

        -- 继续点击的时候是否连续
        if grossini:getScaleX()>0  and X < gril_pointx then
            ---- print("grossini:getScaleX() > 0 , 脸是左朝向 点击左边")
            if grossini:getNumberOfRunningActions()>0  then
                grossini:stopAction(sequence)
                bg:stopAction(bgsequence)
            else
                grossini:getAnimation():play("walk")
                
            end

            elseif grossini:getScaleX() > 0  and X > gril_pointx then
                ---- print("grossini:getScaleX() > 0 ，脸是左朝向  点击右边")
                if grossini:getNumberOfRunningActions()>0  then
                    grossini:stopAction(sequence)
                    bg:stopAction(bgsequence)
                else
                    grossini:getAnimation():play("walk")
                    
                end

                elseif grossini:getScaleX() < 0  and X > gril_pointx then
                    ---- print("grossini:getScaleX() < 0 ，脸是右朝向  点击右边")
                    if grossini:getNumberOfRunningActions()>0  then
                        grossini:stopAction(sequence)
                        bg:stopAction(bgsequence)
                    else
                        grossini:getAnimation():play("walk")
                    end

                    elseif grossini:getScaleX() < 0  and X < gril_pointx then
                        
                        if grossini:getNumberOfRunningActions()>0  then
                            grossini:stopAction(sequence)
                            bg:stopAction(bgsequence)
                        else
                            
                            grossini:getAnimation():play("walk")
                    end
            end
    --人物位置
        local gril_pointx =math.floor( grossini:getPositionX())
        local delta =  apoint - gril_pointx
        --距离
        local x = apoint-visibleSize.width/2
        local x2 = bg:getContentSize().width + bg:getPositionX() - visibleSize.width
    --速度
        local speed = 390
    --时间
        local time = delta / speed  --普通距离
        local time1 = math.abs((math.abs(delta)-math.abs(x)))/speed -- 人物到中间的时候
        local time2 = math.abs( bg:getPositionX() ) / speed  --地图最左边的时候
        local time3 = x2 /speed --地图到最右边的时候
        local time4 = x / speed 
        local time5 = (x-x2)/speed
        local time6 = ( -delta + bg:getPositionX() )/speed
        
        --一步
        local function onestep()
            
            --面部朝向
            if delta>=0 then
                grossini:setScaleX(-girlx)
                grossini:setScaleY(girly)
                else
                    grossini:setScaleX(girlx)
                    grossini:setScaleY(girly)
            end
           if UItool:getCurrentState()=="stand" then
            
                UItool:setCurrentState("stand")
                -- delaystand = cc.DelayTime:create(0)
            end
        end

        local function threestep()
            
            grossini:getAnimation():play("stand")
            event = event or nil 
            if event ~= nil  then
                event()
                
                else
            end

            --更新数据表里面的位置数据
            local girlpositionx = grossini:getPositionX()
            local bgpositionx = bg:getPositionX()
            
            local tb = PublicData.SAVEDATA
            tb.girlpositionx=girlpositionx
            tb.bgpositionx=bgpositionx
            local str = json.encode(tb)
            -- local strs = json.encode(Data.SAVEDATA)
            -- print("data.savedata",strs)
            -- print("最后走的这里")
            local docpath = cc.FileUtils:getInstance():getWritablePath().."GBposition.txt"
        ---- print("文件是否存在",cc.FileUtils:getInstance():isFileExist(docpath),docpath)
            if cc.FileUtils:getInstance():isFileExist(docpath)==true then
                -- print("写入gbposiontion")
                ModifyData.writeToDoc(str,"GBposition")
                else
                    -- print("把PublicData.SAVEDATA 置空")
                    PublicData.SAVEDATA = {}
            end
            

        end

        if apoint<visibleSize.width/2 then
            --点击在左边的时候
            ---- print("l点击在左边的时候")
            if grossini:getPositionX()<visibleSize.width/2 then
                --人物在左边的时候
                ---- print("l人物在左边的时候")
                if bg:getPositionX()==0 then
                    ---- print("l地图在原点")
                    girlmoveto = cc.MoveTo:create(math.abs(time), cc.p(apoint,grossini:getPositionY()))
                    sequence = cc.Sequence:create(cc.CallFunc:create(onestep),girlmoveto,cc.CallFunc:create(threestep))
                    
                end
                
                elseif grossini:getPositionX()>visibleSize.width/2 then
                    --人物在右边的时候
                    ---- print("l人物在右边的时候")

                    bgmove=cc.MoveBy:create( math.abs(time4), cc.p(-x,bg:getPositionY()))
                    local delaybg = cc.DelayTime:create(math.abs(time1))
                    bgsequence = cc.Sequence:create(delaybg,bgmove)
                    bg:runAction(bgsequence)

                    local delaygirl = cc.DelayTime:create(math.abs(time4))
                    girlmoveto = cc.MoveTo:create(math.abs(time1), cc.p(visibleSize.width/2 ,grossini:getPositionY()))
                    sequence = cc.Sequence:create(cc.CallFunc:create(onestep),girlmoveto,delaygirl,cc.CallFunc:create(threestep))

                    elseif grossini:getPositionX()==visibleSize.width/2 then
                        --人物在中间的时候
                        ---- print("l人物在中间的时候")
                        if bg:getPositionX()<0  then
                            
                            if bg:getPositionX()<delta  then
                                ---- print("l地图小于")
                                --print("点击在左边 ，背景向右走")
                                bgmove=cc.MoveBy:create( math.abs(time), cc.p(-delta,bg:getPositionY()))
                                bgsequence = cc.Sequence:create(bgmove)
                                bg:runAction(bgsequence)
                                else
                                    ---- print("l地图大于")
                                    --print("点击在左边 ，背景走到最右")
                                    girlmoveto = cc.MoveTo:create(math.abs(time6), cc.p( apoint - bg:getPositionX(),grossini:getPositionY()))
                                    bgmove=cc.MoveTo:create( math.abs(time2), cc.p(0,bg:getPositionY()))
                                    bgsequence = cc.Sequence:create(bgmove)
                                    bg:runAction(bgsequence)
                            end
                            elseif bg:getPositionX()==0 then
                                girlmoveto = cc.MoveTo:create(math.abs(time), cc.p(apoint,grossini:getPositionY()))
                        end
            end

            elseif apoint>visibleSize.width/2 then
                --点击在右边的时候
                ---- print("r点击在右边的时候")
                if grossini:getPositionX()<visibleSize.width/2 then
                    --人物在左边的时候
                    ---- print("r人物在左边的时候")
                    if bg:getPositionX()==0 then
                        ---- print("r地图在原点")
                        girlmoveto = cc.MoveTo:create(math.abs(time1), cc.p(visibleSize.width/2 ,grossini:getPositionY()))
                        bgmove=cc.MoveBy:create( math.abs(time4), cc.p(-x,bg:getPositionY()))

                        local delaybg = cc.DelayTime:create(math.abs(time1))
                        bgsequence = cc.Sequence:create(delaybg,bgmove)
                        bg:runAction(bgsequence)
                        
                        local delaygirl = cc.DelayTime:create(time4)
                        sequence = cc.Sequence:create(cc.CallFunc:create(onestep),girlmoveto,delaygirl,cc.CallFunc:create(threestep))

                    end
                
                    elseif grossini:getPositionX()>visibleSize.width/2 then
                        --人物在右边的时候
                        ---- print("r人物在右边的时候")
                        girlmoveto = cc.MoveTo:create(math.abs(time), cc.p(apoint,grossini:getPositionY()))
                        sequence = cc.Sequence:create(cc.CallFunc:create(onestep),girlmoveto,cc.CallFunc:create(threestep))

                         elseif grossini:getPositionX()==visibleSize.width/2 then
                            ---- print("r人物在中间的时候")
                            if bg:getPositionX() <= 0 and bg:getPositionX() > visibleSize.width-bg:getContentSize().width then

                                if bg:getContentSize().width + bg:getPositionX() - visibleSize.width > apoint-visibleSize.width/2 then

                                    bgmove=cc.MoveBy:create( math.abs(time), cc.p(-delta,bg:getPositionY()))
                                    bgsequence = cc.Sequence:create(bgmove)
                                    bg:runAction(bgsequence)

                                    else
                                        ------
                                        girlmoveto = cc.MoveTo:create(math.abs(time5), cc.p(apoint-(bg:getContentSize().width-visibleSize.width+bg:getPositionX()),grossini:getPositionY()))

                                        bgmove=cc.MoveTo:create( math.abs(time3), cc.p(visibleSize.width-bg:getContentSize().width,bg:getPositionY()))
                                        bgsequence = cc.Sequence:create(bgmove)
                                        bg:runAction(bgsequence)
                                end
                                elseif bg:getPositionX() == visibleSize.width-bg:getContentSize().width then
                                    ---- print("r画面在最左的时候")
                                    girlmoveto = cc.MoveTo:create(math.abs(time), cc.p(apoint,grossini:getPositionY()))
                                    
                            end
            end
            
        end

        local delay = cc.DelayTime:create(math.abs(time))
        local delay1 = cc.DelayTime:create(math.abs(time1))
        local delay2 = cc.DelayTime:create(math.abs(time2))-- zuo
        local delay3 = cc.DelayTime:create(math.abs(time3))--you
        --人物在中间
        if grossini:getPositionX() == visibleSize.width/2 then
            --背景在原点，且点击在右边
            if bg:getPositionX() == 0 and apoint > visibleSize.width/2  then
                sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,girlmoveto,cc.CallFunc:create(threestep))
                -- 背景在原点 点击在左边
                elseif bg:getPositionX() == 0 and apoint < visibleSize.width/2 then
                    sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delaystand,girlmoveto,cc.CallFunc:create(threestep))
                    -- 背景在最左边
                    elseif bg:getPositionX() == visibleSize.width-bg:getContentSize().width and 
                    apoint >visibleSize.width/2  then
                        sequence = cc.Sequence:create(cc.CallFunc:create(onestep),girlmoveto,cc.CallFunc:create(threestep))
                        elseif bg:getPositionX() == visibleSize.width-bg:getContentSize().width and
                    apoint < visibleSize.width/2 then
                            sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,girlmoveto,cc.CallFunc:create(threestep))
                            
            end
            --背景不在边上的时候
            if bg:getPositionX()~=0 and bg:getPositionX() ~= visibleSize.width-bg:getContentSize().width then

                if apoint>visibleSize.width/2 then

                    if bg:getContentSize().width + bg:getPositionX() - visibleSize.width >apoint-visibleSize.width/2 then
                        ------
                        --print("人物在中间，点击在右边，背景向左走")
                        sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,girlmoveto,cc.CallFunc:create(threestep))
                        
                        else
                            --print("人物在中间，点击在右边，背景走到最左")
                            sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay3,girlmoveto,cc.CallFunc:create(threestep))
                            
                    end
                    else

                        if bg:getPositionX()<delta then
                            --print("********")
                            sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay,girlmoveto,cc.CallFunc:create(threestep))
                            
                            else
                                --print("&&&&&&&&")
                                sequence = cc.Sequence:create(cc.CallFunc:create(onestep),delay2,girlmoveto,cc.CallFunc:create(threestep))
                        end
                end
                else
            end

            else
                
        end
        grossini:runAction(sequence)
end