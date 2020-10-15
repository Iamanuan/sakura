local SettingScene = class("SettingScene",function ()
    local scene = cc.Scene:create()
    return scene
end)

function SettingScene.create()
    local scene = SettingScene.new()
    scene:addChild(scene:createLayer(),0)
    return scene
end

function SettingScene:ctor()
    self._isAllowSound = cc.UserDefault:getInstance():getBoolForKey("is_allow_sound",true)
end

local function onBackClick()
    local scene = require("app.scenes.MainScene").create()
    cc.Director:getInstance():replaceScene(scene)
end

function SettingScene:isAllowSound()
    if self._isAllowSound then
        print(1)
        audio.resumeAll()
    else
        print(0)
        audio.pauseAll()
    end
end

function SettingScene:createLayer()
    local size = cc.Director:getInstance():getWinSize()
    local layer = display.newLayer()
    local imgName = "mainbkg@2x.png"
    if device.platform == "ios" then
        local ok, rtn = luaoc.callStaticMethod("OCFunctions", "isIphoneX", {info = 20})
        if ok and rtn.isIphoneX == "YES" then
            imgName = "mainbkg@3x.png"
        end
    end
    local bg = cc.Sprite:create(imgName)
    local bkg = cc.Sprite:create("settingbkg.png"):setScale(SCALE)
    bg:setPosition(cc.p(size.width/2,size.height/2))
    bkg:setPosition(cc.p(size.width/2,size.height/2))
    layer:addChild(bg,0)
    layer:addChild(bkg,0)

    local onitem = ccui.Button:create():loadTextures("on.png", "on.png", ""):pos(size.width/2+250,size.height/2-60):setScale(SCALE):addTo(layer,0)
    local offitem = ccui.Button:create():loadTextures("off.png", "off.png", ""):pos(size.width/2+250,size.height/2-60):setScale(SCALE):addTo(layer,0)

    local refreshMusicBtns = function()
        offitem:setVisible(not self._isAllowSound)
        onitem:setVisible(self._isAllowSound)
    end

    onitem:addTouchEventListener( function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self._isAllowSound = not self._isAllowSound
            refreshMusicBtns()
        end
    end )
    
    offitem:addTouchEventListener( function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            self._isAllowSound = not self._isAllowSound
            refreshMusicBtns()
        end
    end )

    refreshMusicBtns()

    local commit = ccui.Button:create():loadTextures("commiton.png", "commitdown.png", ""):pos(size.width/2+20,size.height/2-200):setScale(SCALE):addTo(layer,0)
    commit:addTouchEventListener( function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            onBackClick()
            self:isAllowSound()
        end
    end )

    return layer
end

return SettingScene
