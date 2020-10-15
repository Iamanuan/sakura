package.path = package.path .. ";src/?.lua;"
require("cocos.init")
require("config")
require("framework.init")
local manager = require("app.managers.GameManager")
GameManager = manager:getInstance()
local writablepath = cc.FileUtils:getInstance():getWritablePath()
local rankfname = "rank.txt"
local levelname = "level.txt"

if cc.FileUtils:getInstance():isFileExist(writablepath ..  rankfname) then
    GameManager.rankinfo = dofile(writablepath ..  rankfname)
end

if cc.FileUtils:getInstance():isFileExist(writablepath .. levelname) then
    GameManager.levelinfo = dofile(writablepath .. levelname)
end

reakSocketHandle, debugXpCall = require("src/LuaDebugjit")("localhost", 7005)
-- cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakSocketHandle, 0.5, false)
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

collectgarbage("setpause",100)
collectgarbage("setstepmul",5000)

cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")

cc.FileUtils:getInstance():addSearchPath("E:/Mobile_SourceCode/branches/BubbleDragon/src")
cc.FileUtils:getInstance():addSearchPath("E:/Mobile_SourceCode/branches/BubbleDragon/res")



local director = cc.Director:getInstance()
director:getOpenGLView():setDesignResolutionSize(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT, 4) --3定高,4定宽
director:setDisplayStats(DEBUG>0)

cc.Director:getInstance():setAnimationInterval(1.0 / 60.0)

local MainScene = require("app.scenes.MainScene").create()
if not director:getRunningScene() then
    director:runWithScene(MainScene)
else
    director:replaceWithScene(MainScene)
end

-- require("app.MyApp"):new():run()