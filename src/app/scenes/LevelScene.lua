local GameLevel = class("GameLevel",function ()
    local scene = cc.Scene:create()
    return scene
end)

local level_btnPos = {
    {x=display.cx,y=display.cy+530},
    {x=display.cx-235,y=display.cy+130},
    {x=display.cx+225,y=display.cy},
    {x=display.cx-235,y=display.cy-200},
    {x=display.cx-293,y=display.cy-575},
    {x=display.cx+163,y=display.cy-575},
}

local start_nodePos = {
    {x=display.cx+225,y=display.cy+470},
    {x=display.cx-450,y=display.cy-10},
    {x=display.cx+225,y=display.cy+200},
    {x=display.cx-455,y=display.cy-200},
    {x=display.cx-400,y=display.cy-750},
    {x=display.cx+225,y=display.cy-750},
}

local manager = require("app.managers.GameManager")
GameManager = manager:getInstance()

function GameLevel.create()
    local scene = GameLevel.new()
    scene:addChild(scene:createLayer(),0)
    return scene
end

function GameLevel:ctor()
    self.level_btn = {} 
    self.start_node = {}
end

local function onBackClick()
    local scene = require("app.scenes.MainScene").create()
    cc.Director:getInstance():replaceScene(scene)
end

function GameLevel:createLayer()
    local imgName = "bg_0@2x.png"
    if device.platform == "ios" then
        local ok, rtn = luaoc.callStaticMethod("OCFunctions", "isIphoneX", {info = 20})
        if ok and rtn.isIphoneX == "YES" then
            imgName = "bg_0@3x.png"
        end
    end

    local size = cc.Director:getInstance():getWinSize()
    local layer = display.newLayer()
    local bkg = cc.Sprite:create(imgName)
    bkg:setPosition(cc.p(size.width/2,size.height/2))
    layer:addChild(bkg,0)

    -- 关卡
    for i=1,6 do
       self.level_btn[i] = ccui.Button:create():loadTextures("levelup_"..i..".png","leveldown_"..i..".png","leveldis_"..i..".png"):pos(level_btnPos[i].x,level_btnPos[i].y):setEnabled(false):addTo(layer)
       self.level_btn[i]:addTouchEventListener(function(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                GameManager:setGameStats(i)
                local scene = require("app.scenes.GameScenePass").create()
                cc.Director:getInstance():replaceScene(scene)
            end
        end)

        self.start_node[i] = display.newNode():pos(start_nodePos[i].x,start_nodePos[i].y):addTo(layer)
    end

    if #GameManager.levelinfo ~= 0 then
        for i=1,#GameManager.levelinfo do
            self.level_btn[i]:setEnabled(true)
            if GameManager.levelinfo[i].pass == 1 then
                if GameManager.levelinfo[i].time > 0 and GameManager.levelinfo[i].time <= 60 then
                    cc.Sprite:create("start1.png"):pos(55,0):addTo(self.start_node[i])
                    cc.Sprite:create("start1.png"):pos(110,0):addTo(self.start_node[i])
                    cc.Sprite:create("start1.png"):pos(165,0):addTo(self.start_node[i])
                elseif GameManager.levelinfo[i].time > 60 and GameManager.levelinfo[i].time <= 120 then
                    cc.Sprite:create("start1.png"):pos(55,0):addTo(self.start_node[i])
                    cc.Sprite:create("start1.png"):pos(110,0):addTo(self.start_node[i])
                    cc.Sprite:create("start0.png"):pos(165,0):addTo(self.start_node[i])
                elseif GameManager.levelinfo[i].time > 120 and GameManager.levelinfo[i].time <= 160 then
                    cc.Sprite:create("start1.png"):pos(55,0):addTo(self.start_node[i])
                    cc.Sprite:create("start0.png"):pos(110,0):addTo(self.start_node[i])
                    cc.Sprite:create("start0.png"):pos(165,0):addTo(self.start_node[i])
                elseif GameManager.levelinfo[i].time > 160 or GameManager.levelinfo[i].time == 0 then
                    cc.Sprite:create("start0.png"):pos(55,0):addTo(self.start_node[i])
                    cc.Sprite:create("start0.png"):pos(110,0):addTo(self.start_node[i])
                    cc.Sprite:create("start0.png"):pos(165,0):addTo(self.start_node[i])
                end
            end
        end

        local pass = #GameManager.levelinfo < 6 and (#GameManager.levelinfo+1) or #GameManager.levelinfo

        if GameManager.levelinfo[#GameManager.levelinfo].pass == 1 then
            self.level_btn[pass]:setEnabled(true)
            self.level_btn[pass]:loadTextures("leveldown_"..pass..".png","","")
        else
            self.level_btn[#GameManager.levelinfo]:loadTextures("leveldown_"..#GameManager.levelinfo..".png","","")
        end
    else
        self.level_btn[1]:setEnabled(true)
        self.level_btn[1]:loadTextures("leveldown_1.png","","")
    end
    
    --返回
    local backbtn = ccui.Button:create():loadTextures("backup.png", "backdown.png", ""):pos(70,size.height-90):setScale(SCALE):addTo(layer,0)
    backbtn:addTouchEventListener( function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            onBackClick()
        end
    end )

    return layer
end

return GameLevel
