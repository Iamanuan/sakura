local MainScene = class("MainScene",function ()
    local scene = cc.Scene:create()
    return scene
end)

function MainScene.create()
    local scene = MainScene.new()
    scene:addChild(scene:createLayer(),0)
    return scene
end

function MainScene:ctor()
    self._isAllowSound = cc.UserDefault:getInstance():getBoolForKey("is_allow_sound",false)
    function onEvent(event)
        if event == "enter" then
            self:onEnter()
        elseif event ==  "exit" then
            self:onExit()
        elseif event == "exitTransitionStart" then
            self:onExitTransitionStart()
        elseif event == "enterTransitionFinish" then
            self:onEnterTransitionFinish()
        elseif event == "cleanup" then
            self:onCleanup()
        end
    end
    self:registerScriptHandler(onEvent)
end

function MainScene:createLayer()
    local size = cc.Director:getInstance():getWinSize()
    local layer = display.newLayer()
    layer:setNodeEventEnabled(true)


    local imgName = "mainbkg@2x.png"
    if device.platform == "ios" then
    local ok, rtn = luaoc.callStaticMethod("OCFunctions", "isIphoneX", {info = 20})
    if ok and rtn.isIphoneX == "YES" then
        imgName = "mainbkg@3x.png"
    end
    end
    local bkg = cc.Sprite:create(imgName)
    bkg:setPosition(cc.p(size.width/2,size.height/2))
    layer:addChild(bkg,0)

    -- local gametitle1 = cc.Sprite:create("title.png")
    -- gametitle1:setScale(SCALE)
    -- gametitle1:setPosition(cc.p(size.width/2,size.height/2 + 550))
    -- layer:addChild(gametitle1,0)

    -- 计时模式按钮
    local startmenu = ccui.Button:create():loadTextures("timebtnup.png", "timebtndown.png", ""):pos(size.width/2-230,size.height/2+300):addTo(layer,0)
    startmenu:addTouchEventListener( function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            GameManager:setGameStats(7)
            local scene = require("app.scenes.GameScene").create()
            cc.Director:getInstance():replaceScene(scene)
        end
    end )

    -- 关卡模式按钮
    local foreverbtn = ccui.Button:create():loadTextures("foreverbtnup.png","foreverbtndown.png",""):pos(size.width/2+250,size.height/2+300):addTo(layer,0)
    foreverbtn:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local scene = require("app.scenes.LevelScene").create()
            cc.Director:getInstance():replaceScene(scene)
        end
    end)

    -- 设置按钮
    local onitem = ccui.Button:create():loadTextures("onup.png", "ondown.png", ""):pos(70,size.height-90):addTo(layer,0)
    local offitem = ccui.Button:create():loadTextures("offup.png", "offdown.png", ""):pos(70,size.height-90):addTo(layer,0)

    local refreshMusicBtns = function()
        offitem:setVisible(not self._isAllowSound)
        onitem:setVisible(self._isAllowSound)
    end

    onitem:addTouchEventListener( function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:isAllowSound()
            refreshMusicBtns()
        end
    end )
    
    offitem:addTouchEventListener( function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:isAllowSound()
            refreshMusicBtns()
        end
    end )
    refreshMusicBtns()

    if self._isAllowSound then
        audio.loadFile("sound/Doraemon.ogg",function()
            audio.playBGM("sound/Doraemon.ogg",true)
        end)
    end

    -- 排行按钮
    local rankmenu = ccui.Button:create():loadTextures("rankup.png", "rankdown.png", ""):pos(size.width-70,size.height-100):addTo(layer,0)
    rankmenu:addTouchEventListener( function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local scene = require("app.scenes.RankScene").create()
            cc.Director:getInstance():replaceScene(scene)
        end
    end )
    return layer
end

function MainScene:isAllowSound()
    self._isAllowSound = not self._isAllowSound
    if self._isAllowSound then
        audio.loadFile("sound/Doraemon.ogg",function()
            audio.playBGM("sound/Doraemon.ogg",true)
        end)
        audio.resumeAll()
    else
        audio.pauseAll()
    end
    
    cc.UserDefault:getInstance():setBoolForKey("is_allow_sound",self._isAllowSound)
end

function  MainScene:onEnter()
end

function MainScene:onExit()
end

function MainScene:onCleanup()

end

function MainScene:onEnterTransitionFinish()
end

function MainScene:onExitTransitionStart()
end

return MainScene
