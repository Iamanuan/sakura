-- DEBUG
DEBUG = 0                   -- 0-NONE DEBUG 1-LESS DEBUG 2-MORE 3-ALL
--[[目前已知问题:
1、不适配IPAD分辨率,界面上下显示不全
2、游戏界面要根据适配重弄下
]]

-- 颜色
LIGHTBLUE = cc.c3b(0,128,255)
DEEPBLUE = cc.c3b(0,0,128)
SKYBLUE = cc.c3b(102,204,255)
GRAPEPURPLE = cc.c3b(128,0,255)
LIGHTGREY = cc.c3b(179,179,179)
GRASSGREEN = cc.c3b(64,128,0)
RICEYELLOW = cc.c3b(247,238,214)
LIGHTPURPLE = cc.c3b(204,102,255)
ORANGERED = cc.c3b(254,184,0)
PINK = cc.c3b(255,111,207)

-- 图片
PG = "pg.png"
PH = "ph.png"
PJ = "pj.png"
PL = "pl.png"
PR = "pr.png"
PZ = "pz.png"

-- 泡泡相关
BUBBCLR = {LIGHTBLUE,DEEPBLUE,LIGHTGREY,GRASSGREEN,LIGHTPURPLE,ORANGERED}
BUBBIMG = {PG,PH,PJ,PL,PR,PZ}
BUBBSIZE = 80
BUBBSPEED = 4000            -- 泡泡飞行速度
WORLDBODY = 666             -- 世界BODY TAG
BUBBSHOOT = 999             -- 要发射的泡泡精灵/BODY TAG
BUBBRANDOM = 888            -- 随机出的泡泡精灵/BODY TAG
BUBBFLY   = 777             -- 飞行中的泡泡精灵/BODY TAG
BUBBPOSY = 350              -- 发射和随机泡泡距离舞台底部的距离
TAGGAMELAYER = 555
TAGGRADE = 554
TAGTIMER = 553

START1 = 99991
START2 = 99992
START3 = 99993

-- 游戏设置
BUBBMOVENEED = 4                -- 所有泡泡向下移动一次需要的次数
BUBBWIPENEED  = 3               -- 泡泡消除
MAXGAMETIME = 180              -- 游戏倒计时3MIN
GRADEREWARD = 10                -- 消除1个泡泡得10分
MAXROW = 12                     -- 最多行数
MAXODD = 12                     -- 奇数行泡泡数/最大列数
MAXEVEN = 11                    -- 偶数行泡泡数
MAXLEVEL = 2                    -- 最大关卡数
WORLDCATEMASK = 0X0F            -- 世界类别掩码        0001
WORLDCONTMASK = 0X05            -- 世界接触检测掩码
-- WORLDCOLLMASK = 0X0             -- 世界碰撞检测掩码
NORBBCATEMASK = 0X06            -- 普通泡泡类别掩码    0110
NORBBCONTMASK = 0X01            -- 普通泡泡接触检测掩码 0001
NORBBCOLLMASK = 0X0             -- 普通泡泡碰撞检测掩码
SPEBBCATEMASK = 0X03            -- 特殊泡泡类别掩码     0011
SPEBBCONTMASK = 0X04            -- 特殊泡泡接触检测掩码 0100
SPEBBCOLLMASK = 0X08            -- 特殊泡泡碰撞检测掩码 1000

-- DESIGN RESOLUTION
MUSICON = TRUE
CONFIG_SCREEN_WIDTH  = 1080
CONFIG_SCREEN_HEIGHT =1920
-- CONFIG_SCREEN_AUTOSCALE = "EXACT_FIT"
SCALE = 1
-- GAMESTATS

-- GAME FAIL REASON
FAILREASON = {"对于樱花来说时间也是有尽头！！","没位置了!","不能往下移动了!!","樱花樱花，过关啦！！"}

-- 关卡配置表最多8行12列,初始化 8 行 6 列的内容,配置泡泡的类型,0表示没有泡泡,
-- 如果某个位置没填也会被当成0,别配成会掉下来的,没做数据检查 = =
LEVEL =
{
    -- 偶数行比奇数行少个
    [1] =
    {
        {0,2,3,4,5,6,6,2,3,4,5,0},
        {0,0,5,4,5,6,1,2,3,4,0},
        {0,0,0,4,1,2,6,5,3,0,0,0},
    },
    [2] =
    {
        {0,0,0,0,5,6,1,2,0,0,0,0},
        {0,0,0,4,5,6,1,2,4,0,0,0},
        {0,0,3,4,5,6,1,2,3,4,0,0},
    },
    [3] =
    {
        {0,5,2,1,5,6,1,3,4,1,0},
        {0,1,4,4,5,6,1,2,5,3,0},
        {0,6,3,4,5,6,1,2,3,6,0},
        {0,2,3,4,5,6,1,2,3,4,0},
    },
    [4]=
    {
        {0,5,2,3,5,6,1,2,1,4,0},
        {3,6,1,4,5,6,1,2,4,6,5},
        {1,5,3,4,5,6,1,2,3,2,3},
        {0,2,3,4,5,6,1,2,3,4,0},
    },
    [5]={
        {1,3,5,2,2,3,6,4,6,3,5},
        {0,2,4,4,4,5,1,2,6,1,0},
        {0,0,3,6,6,1,6,4,3,0,0},
        {0,0,0,4,3,2,1,2,0,0,0},
        {0,0,0,0,5,4,2,0,0,0,0},
        {0,0,0,0,2,6,1,0,0,0,0},
    },
    [6]={
        {0,0,0,0,5,6,1,0,0,0,0},
        {0,0,0,4,5,6,1,2,0,0,0},
        {0,0,3,4,5,6,1,2,3,0,0},
        {0,2,3,4,5,6,1,2,3,4,0},
        {0,2,3,4,5,6,1,2,3,4,0},
        {0,0,3,4,5,6,2,3,4,0,0},
    },
    [7]={
        {0,0,1,4,3,4,5,6,2,0,0},
        {0,0,4,4,4,5,1,2,6,1,0},
        {0,1,3,4,5,6,1,2,3,4,0},
    }
}

