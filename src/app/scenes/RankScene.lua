local RankScene = class("RankScene",function ()
    local scene = cc.Scene:create()
    return scene
end)

function RankScene.create()
    local scene = RankScene.new()
    scene:addChild(scene:createLayer(),0)
    return scene
end

function RankScene.ctor()
end

local function onBackClick()
    local scene = require("app.scenes.MainScene").create()
    cc.Director:getInstance():replaceScene(scene)
end

local function createRankNode(i,name,grade)
    local node = cc.Node:create()
    node:setContentSize(500,50)
    local rank = display.newTTFLabel({text =  i..".", font = "res/fonts/fzxkjt.TTF", size = 36})
    rank:setColor(cc.c3b(151,34, 43))
    rank:setPosition(50,0)
    rank:align(display.CENTER)
    rank:enableShadow(cc.c4b(151,34, 43, 255), cc.size(0.3, 0), 0)
    node:addChild(rank)
    local name = display.newTTFLabel({text = name, font = "res/fonts/fzxkjt.TTF", size = 36})
    name:setAnchorPoint(0,0)
    name:setColor(cc.c3b(38, 38, 38))
    name:setPosition(cc.p(250,0))
    name:align(display.CENTER)
    node:addChild(name)
    local grade = display.newTTFLabel({text = tostring(grade), font = "res/fonts/fzxkjt.TTF", size = 36})
    grade:setAnchorPoint(0,0)
    grade:setColor(cc.c3b(121, 74, 20))
    grade:setPosition(cc.p(420,0))
    grade:align(display.CENTER)
    node:addChild(grade)
    return node
end

function RankScene:createLayer()
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
    layer:addChild(bg,0)

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

    local rankbkg = cc.Sprite:create("rank_bg.png")
    rankbkg:setPosition(cc.p(size.width/2,size.height/2))
    layer:addChild(rankbkg,0)

    local scrollview  = ccui.ScrollView:create()
    scrollview:setTouchEnabled(true)
    scrollview:setBounceEnabled(true)
    scrollview:setDirection(ccui.ScrollViewDir.vertical)
    scrollview:size(500,600)

    -- 测试代码
    -- scrollview:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    -- scrollview:setBackGroundColor(cc.c3b(0, 255, 0))
    -- scrollview:setBackGroundColorOpacity(128)

    scrollview:setInnerContainerSize(cc.size(300,50*#GameManager.rankinfo+1))

    for i,info in ipairs(GameManager.rankinfo) do
        local ranknode = createRankNode(i,info.name,info.grade)
        ranknode:setAnchorPoint(0,0)
        scrollview:addChild(ranknode,0,i)
        ranknode:setPosition(0,scrollview:getInnerContainerSize().height - 50 *i+10)
    end

    scrollview:setAnchorPoint(0,1)
    scrollview:jumpToBottom()
    scrollview:setPosition(cc.p(size.width/2-240,size.height/2+260))
    layer:addChild(scrollview)

    local confirmitem = ccui.Button:create():loadTextures("confirmon.png", "confirmdown.png", ""):pos(size.width/2,size.height/2 - 470):setScale(SCALE):addTo(layer,0)
    confirmitem:addTouchEventListener( function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            onBackClick()
        end
    end )

    return layer
end



return RankScene
