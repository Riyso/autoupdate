script_name("VC-Tools")
script_version("1.0")


local imgui = require 'mimgui'
local faicons = require 'fAwesome6'
local ffi = require 'ffi'
local inicfg = require 'inicfg'
local toast_ok, toast = pcall(import, 'lib\\mimtoasts.lua')
local addons = require 'ADDONS'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local new = imgui.new
local renderWindow = new.bool(false)
local labels = {'AAAA','BBBB','CCCC','DDDD','EEEE','FFFF','GGGG','HHHH','IIII','JJJJ','KKKK','LLLL','MMMM','OOOO',}
local Page = {'Главная','Информация', 'Обновления', 'Настройки'}
local PageIcons = {'HOUSE_USER','CIRCLE_INFO', 'CLOUD_ARROW_DOWN', 'GEAR'}
local menu = 1
local AI_PAGE = {} --// Р В РІР‚СљР вЂ™Р’В¤Р В РІР‚СљР вЂ™Р’В«Р В РІР‚СљР РЋРІР‚вЂќ mimgui.ADDONS
local AI_HINTS = {} --// Р В РІР‚СљР вЂ™Р’В¤Р В РІР‚СљР вЂ™Р’В«Р В РІР‚СљР РЋРІР‚вЂќ mimgui.ADDONS
local ToU32 = imgui.ColorConvertFloat4ToU32
local ToVEC = imgui.ColorConvertU32ToFloat4
local el = {
    checkbox = new.bool(false),
    radio = new.int(0),
    combo = new.int(0),
    duration = new.int(5),
    input = imgui.new.char[256](),
    hintinput = new.char[256](),
}

local directIni = ("big disck's tool.ini")
local ini = inicfg.load(inicfg.load({
    main = {
        dostup = false,
        stylemenu = true
    },
}, directIni))
inicfg.save(ini, directIni)

local stylemenu = new.bool()

pause = false

local toast_ok, toast = pcall(import, 'lib\\mimtoasts.lua') -- Р“Р‡Р“В®Р“В¤Р“Р„Р“В«Р“С•Р“В·Р“В Р“С• Р“В¬Р“В®Р“В¤Р“С–Р“В«Р“С
