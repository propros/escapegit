

function sendGetServer(acc, pwd,parent)
    local xhr = cc.XMLHttpRequest:new() -- 新建一个XMLHttpRequest对象  
 
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON -- json数据类型  

    xhr:open("POST", "http://192.168.181.110:7001/accLogin") -- POST方式  
    local msg = 
    {
        acc = acc,
        pwd = pwd
    }

    local function MsgCallBack(param)
        -- 显示状态码,成功显示200  

        print("acc SHIDUOS 是多少 ",acc )
        print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
        print("Http Status Code:"..xhr.statusText)  
        print("打印收到登录消息", xhr.response)

        local msg = json.decode(xhr.response) -- 解析json数据  
        
        local code = msg.code

        if code == 0 then
            UItool:message2("不要动，",30 )
            -- local scene = Mainscene.new()
            -- local turn = cc.TransitionFade:create(1, scene)
            -- cc.Director:getInstance():replaceScene(turn)
            -- UItool:message4(" ...... "," “这里是，我的房间吗……？” ","“但为什么，窗外像是海底的世界呢？”","“我想我应该出去看看……”",30,scene)
        else
            print("code != 0")
        end
    end

    xhr:registerScriptHandler(MsgCallBack)  -- 注册脚本方法回调  

    xhr:send(json.encode(msg))  -- 发送请求  
    print("发送请求消息1")
end






