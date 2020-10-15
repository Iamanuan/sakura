local OverScene = class("OverScene",function ()
    local scene = cc.Scene:create()
    return scene
end)

function OverScene.create()
    local scene = OverScene.new()
    scene:addChild(scene:createLayer(),0)
    return scene
end

function OverScene.ctor()
end

local function onBackClick()
    local scene = require("MainScene").create()
    cc.Director:getInstance():replaceScene(scene)
end


function OverScene:createLayer()
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
    local bg = cc.Sprite:create(imgName)
    bg:setPosition(cc.p(size.width/2,size.height/2))
    bg:setPosition(cc.p(size.width/2,size.height/2))
    layer:addChild(bg)
    local layout = ccui.Layout:create():size(size.width, size.height)
    layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    layout:setBackGroundColor(cc.c3b(0,0,0))
    layout:setBackGroundColorOpacity(160)
    layout:setTouchEnabled(true)
    layout:addTouchEventListener(function(sender, eventType)
        if layer.layoutTouchCallback then
            layer:layoutTouchCallback(eventType)
        end
    end)

    layer:addChild(layout)

    local overbkg = cc.Sprite:create("over_bg.png")
    overbkg:setPosition(cc.p(size.width/2,size.height/2))
    layer:addChild(overbkg,0)
    if GameManager:getGameStats() ~= 7 then
        overbkg:setTexture("over_bg1.png")
    end

    local failtip = display.newTTFLabel({text = FAILREASON[GameManager.failreason], font = "res/fonts/fzxkjt.TTF", size = 36})
    failtip:setColor(cc.c3b(151, 34, 43))
    failtip:setPosition(cc.p(size.width/2,size.height/2 + 130 ))
    failtip:setOpacity(0)
    failtip:align(display.CENTER)
    failtip:runAction(cc.Spawn:create(cc.Blink:create(1,3),cc.FadeIn:create(0.5)))
    layer:addChild(failtip,0)

    local gradelabel =display.newTTFLabel({text = tostring(GameManager.grade), font = "res/fonts/fzxkjt.TTF", size = 36})
    gradelabel:setColor(cc.c3b(121, 74, 20))
    gradelabel:setAnchorPoint(0,0.5)
    gradelabel:setPosition(cc.p(size.width/2-100,size.height/2-100))
    layer:addChild(gradelabel,0)

    local commit = ccui.Button:create():loadTextures("commiton.png", "commitdown.png", ""):pos(size.width/2,size.height/2 -230):setScale(SCALE):addTo(layer,0)
    local namebox = ccui.EditBox:create(cc.size(255,50),"none.png")
    namebox:setReturnType(cc.KEYBOARD_RETURNTYPE_DEFAULT)
    namebox:setPosition(cc.p(size.width/2,size.height/2+5))
    namebox:setPlaceHolder("请留名")
    namebox:setPlaceholderFontColor(cc.c3b(38, 38, 38))
    namebox:setFontColor(cc.c3b(38, 38, 38))
    layer:addChild(namebox,0)

    local passtime = GameManager.currpasstime
    if GameManager:getGameStats() ~= 7 then
        namebox:hide()
        failtip:setPosition(cc.p(size.width/2,size.height/2 + 30 ))
        gradelabel:setString(passtime.."秒")
        commit:loadTextures("confirmon.png","confirmdown.png","")
        if passtime > 0 and passtime <= 60 and GameManager.currpasslevel == true then
            cc.Sprite:create("start1.png"):pos(size.width/2-60,size.height/2+130):addTo(layer)
            cc.Sprite:create("start1.png"):pos(size.width/2,size.height/2+130):addTo(layer)
            cc.Sprite:create("start1.png"):pos(size.width/2+60,size.height/2+130):addTo(layer)
        elseif passtime > 60 and passtime <= 120 and GameManager.currpasslevel == true then
            cc.Sprite:create("start1.png"):pos(size.width/2-60,size.height/2+130):addTo(layer)
            cc.Sprite:create("start1.png"):pos(size.width/2,size.height/2+130):addTo(layer)
            cc.Sprite:create("start0.png"):pos(size.width/2+60,size.height/2+130):addTo(layer)
        elseif passtime > 120 and passtime <= 160 and GameManager.currpasslevel == true then
            cc.Sprite:create("start1.png"):pos(size.width/2-60,size.height/2+130):addTo(layer)
            cc.Sprite:create("start0.png"):pos(size.width/2,size.height/2+130):addTo(layer)
            cc.Sprite:create("start0.png"):pos(size.width/2+60,size.height/2+130):addTo(layer)
        elseif passtime > 160 or passtime == 0 or GameManager.currpasslevel == false  then
            cc.Sprite:create("start0.png"):pos(size.width/2-60,size.height/2+130):addTo(layer)
            cc.Sprite:create("start0.png"):pos(size.width/2,size.height/2+130):addTo(layer)
            cc.Sprite:create("start0.png"):pos(size.width/2+60,size.height/2+130):addTo(layer)
        end
    end



    local function onCommitClick()
        local writablepath = cc.FileUtils:getInstance():getWritablePath()
        if GameManager:getGameStats() == 7 then
            local name = namebox:getText()
            if #GameManager.rankinfo == 100 then
                table.remove(GameManager.rankinfo)
            end
            if name == "" or not name then
                name = "bubble" .. #GameManager.rankinfo+1
            end
    
            table.insert(GameManager.rankinfo,{name = name,grade = GameManager.grade})
            table.sort(GameManager.rankinfo,function ( a,b )
                return a.grade > b.grade
            end)
    
            local rankfname = "rank.txt"
            local file = io.open(writablepath .. rankfname,"wb")
            local str = {}
            for i,v in ipairs(GameManager.rankinfo) do
                table.insert(str,string.format("{name = \"%s\",grade = %s},\n",v.name,v.grade))
            end
            file:write("local info = {\n" .. table.concat(str,"").."}\nreturn info")
            file:close()
        else
            -- 提交关卡
            local levelfname = "level.txt"
            local levelfile = io.open(writablepath .. levelfname,"wb")
            local levelstr = {}
            for i,v in ipairs(GameManager.levelinfo) do
                table.insert(levelstr,string.format("{pass = %s,time = %s},\n",v.pass,v.time))
            end
            levelfile:write("local level = {\n" .. table.concat(levelstr,"") .."}\nreturn level")
            levelfile:close()
        end

        --结束后，重置一些数据
        GameManager:deleteStageInfo()
        GameManager.shoottimes = 0
        GameManager.grade = 0
        GameManager.failreason = 0
        GameManager:setGameTime(180)
        GameManager.currpasstime = 0
        GameManager.currpasslevel = false
        if GameManager:getGameStats() == 7 then
            local scene = require("app.scenes.RankScene").create()
            cc.Director:getInstance():replaceScene(scene)
        else
            local scene = require("app.scenes.LevelScene").create()
            cc.Director:getInstance():replaceScene(scene)
        end
    end

    commit:addTouchEventListener( function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            onCommitClick()
        end
    end )

    return layer
end

return OverScene
