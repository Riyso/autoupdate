script_name("VC-Tools")
script_version("1.5")


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
local AI_PAGE = {}
local AI_HINTS = {}
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

local toast_ok, toast = pcall(import, 'lib\\mimtoasts.lua')
if not toast_ok then
    local dlstatus = require('moonloader').download_status
    downloadUrlToFile('https://raw.githubusercontent.com/GovnocodedByChapo/mimtoasts/main/mimtoasts.lua', getWorkingDirectory()..'\\lib\\mimtoasts.lua', function (id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
            thisScript():reload()
        end
    end)
end

imgui.OnInitialize(function()
    local io = imgui.GetIO()
    io.IniFilename = nil
    --imgui.Theme()

    local glyph_ranges = io.Fonts:GetGlyphRangesCyrillic()
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    io.Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('moonloader\\resource\\fonts\\Jost-Regular.ttf'), 16, config, iconRanges)
    textik = io.Fonts:AddFontFromFileTTF("moonloader\\resource\\fonts\\Jost-Regular.ttf", 16)
    header = io.Fonts:AddFontFromFileTTF('moonloader\\resource\\fonts\\Jost-Bold.ttf', 30, nil, glyph_ranges)
    subheader = io.Fonts:AddFontFromFileTTF('moonloader\\resource\\fonts\\Jost-Regular.ttf', 22, nil, glyph_ranges)
    pagebuttons = io.Fonts:AddFontFromFileTTF('moonloader\\resource\\fonts\\Jost-Bold.ttf', 22, nil, glyph_ranges)
    pagebuttons1 = io.Fonts:AddFontFromFileTTF('moonloader\\resource\\fonts\\Jost-Medium.ttf', 22, nil, glyph_ranges)
end)

local newFrame = imgui.OnFrame(
    function() return renderWindow[0] end,
    function(player)
        local resX, resY = getScreenResolution()
        local sizeX, sizeY = 700, 400
        imgui.Theme()
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
        if imgui.Begin('', renderWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar) then
            imgui.SetCursorPos(imgui.ImVec2(0,0))
            imgui.BeginChild('##aaa', imgui.ImVec2(178, 390), false)
            imgui.LeftChild(imgui.ImVec2(178,390))
            	imgui.NewLine()
            	imgui.NewLine()
            	imgui.NewLine()
                --imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
                imgui.PushFont(header)
                    imgui.CenterText("BIG DICK's")
                imgui.PopFont()
                imgui.PushFont(subheader)
                    imgui.SubHeader('club')
                imgui.PopFont()
                imgui.Text('')
                imgui.NewLine()
                for i, page in ipairs(Page) do
                    if imgui.PageButton(i == menu, faicons(PageIcons[i]), u8(page)) then
                        menu = i
                    end
                end
                --imgui.PopStyleColor()
                imgui.SetCursorPos(imgui.ImVec2(65,360))
                if addons.ToggleButton("##", stylemenu) then
                	ini.main.stylemenu = stylemenu[0]
                	inicfg.save(ini, directIni)
                	if ini.main.stylemenu == false then
				        toast.Show(u8'Настройки были обновлены', toast.TYPE.OK, el.duration[0], customColors or nil)
				        -- toast.TYPE.INFO, toast.TYPE.OK, toast.TYPE.ERROR, toast.TYPE.WARN, toast.TYPE.DEBUG
			        else
			        	toast.Show(u8'Настройки были обновлены', toast.TYPE.OKS, el.duration[0], customColors or nil)
				        -- toast.TYPE.INFO, toast.TYPE.OK, toast.TYPE.ERROR, toast.TYPE.WARN, toast.TYPE.DEBUG
			        end
                end
            imgui.EndChild()
            imgui.SetCursorPos(imgui.ImVec2(180, 0))
            if ini.main.stylemenu == false then
            	imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0.09, 0.10, 0.12, 1.00))
        	elseif ini.main.stylemenu == true then
        		imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0.60, 0.60, 0.60, 1.00))
        	end
            imgui.BeginChild('##adasd', imgui.ImVec2(560, -0.0), false)
                imgui.RightChild(imgui.ImVec2(560,392))
                imgui.SetCursorPos(imgui.ImVec2(35, 35))
                imgui.BeginChild('##mainchildwithinformation', imgui.ImVec2(560, -0.0), false)
                            if menu == 1 then 
                                imgui.Text("This item is under development .. [1]")
                            elseif menu == 2 then
                                imgui.Text("This item is under development .. [2]")
                            elseif menu == 3 then
                                imgui.PushFont(pagebuttons1)
                    			imgui.Text(u8"Обновление: 24.11.2023v")
                    			imgui.PopFont()
                    			imgui.Text(u8"- Обновлен стиль меню скрипта")
                    			imgui.Text(u8"- Добавлена возможно переключения темы в dark / light")
                    			imgui.Text(u8"- Добавлено больше навигации в список скрипта")
                    			imgui.Text(u8"- Добавлены push-уведомления к некоторым функциям")
                    			imgui.Text(u8"- Добавлена небольшая система регистрации")
                           	elseif menu == 4 then
                                imgui.Text("This item is under development .. [4]")
                            else
                            	--
                            end
                imgui.EndChild()
            imgui.EndChild()
            imgui.PopStyleColor()
        imgui.End()
        end
    end
)

function main()
    while not isSampAvailable() do wait(5000) end
    if ini.main.dostup then
	    if toast_ok then
		    if ini.main.stylemenu == false then
				toast.Show(u8'Успешная авторизация', toast.TYPE.OK, el.duration[0], customColors or nil)
			else
		        toast.Show(u8'Успешная авторизация', toast.TYPE.OKS, el.duration[0], customColors or nil)
			end
		end
	else
		captchaLength = 10
		generatedCaptcha = generateCaptcha(captchaLength)
		pause = true
	    if toast_ok then
	    	if ini.main.stylemenu == false then
		        toast.Show(u8'Вы не зарегистрированы', toast.TYPE.ERROR, el.duration[0], customColors or nil)
		        -- toast.TYPE.INFO, toast.TYPE.OK, toast.TYPE.ERROR, toast.TYPE.WARN, toast.TYPE.DEBUG
	        else
	        	toast.Show(u8'Вы не зарегистрированы', toast.TYPE.ERRORS, el.duration[0], customColors or nil)
		        -- toast.TYPE.INFO, toast.TYPE.OK, toast.TYPE.ERROR, toast.TYPE.WARN, toast.TYPE.DEBUG
	        end
	    end
	    sampAddChatMessage("{ffffff}* {0088ff}[Big Disk's Tool]{ffffff} Приветствуем Вас, для регистрации введите данную капчу: " .. generatedCaptcha .. " {0088ff}[/dosp] {ffffff}*", -1)
	    --setClipboardText(generatedCaptcha)
	end

    sampRegisterChatCommand('cnpanel2', function()
	    renderWindow[0] = not renderWindow[0]
    end)
    sampRegisterChatCommand('dosp', dosss)

    
    autoupdate("https://raw.githubusercontent.com/Riyso/autoupdate/main/version.json", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/Riyso/autoupdate/")
	stylemenu[0] = ini.main.stylemenu
    wait(-1)
end

function dosss(arg)
	if pause == true then
	    if #arg == 0 then 
        	sampAddChatMessage("{ffffff}* {0088ff}[Big Disk's Tool]{ffffff} Пример ввода команды: {ff0000}/dosp code {ffffff}*")
	    else
	        if string.lower(arg) == string.lower(generatedCaptcha) then
	            sampAddChatMessage("{ffffff}* {0088ff}[Big Disk's Tool]{ffffff} Доступ был разрешен. Вы были успешно зарегистрированы {0088ff}[/cnpanel2] {ffffff}*", -1)
	            pause = false
	            ini.main.dostup = true
	            inicfg.save(ini, directIni)
	        else
	            sampAddChatMessage("{ffffff}* {0088ff}[Big Disk's Tool]{ffffff} Доступ был запрещен. Неверный ввод капчи, попробуйте снова *", -1)
	        end
	    end
	else
		--
	end
end

function generateCaptcha(length)
    local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local captcha = ""

    for i = 1, length do
        local randomIndex = math.random(1, #characters)
        captcha = captcha .. string.sub(characters, randomIndex, randomIndex)
    end

    return captcha
end

function onWindowMessage(msg, wparam, lparam)
	if wparam == 0x1B and not isPauseMenuActive() and renderWindow[0] then
			consumeWindowMessage(true, false)
            renderWindow[0] = false
    else
	end
end      

function imgui.CenterText(text)
    imgui.SetCursorPosX(imgui.GetWindowSize().x / 2 - imgui.CalcTextSize(text).x / 2)
    imgui.Text(u8(text))
end

function imgui.SubHeader(text)
    imgui.SetCursorPosX(imgui.GetWindowSize().x / 2 - imgui.CalcTextSize(text).x / 2)
    imgui.Text(u8(text))
end

function ImSaturate(f)
	return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
end

function imgui.Theme()
    imgui.SwitchContext()
    imgui.GetStyle().FramePadding = imgui.ImVec2(3.5, 3.5)
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().ChildRounding = 1.5
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().WindowRounding = 5
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(7.0, 4.0)
    imgui.GetStyle().ScrollbarSize = 13.0
    imgui.GetStyle().ScrollbarRounding = 0
    imgui.GetStyle().GrabMinSize = 8.0
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 3)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
    if ini.main.stylemenu == false then
	    --==[ COLORS ]==--
	    imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(1.00, 1.00, 1.00, 0.00)
	    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
	    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
	    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
	    imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
	    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
	    imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
	    imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
	    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
	    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
	elseif ini.main.stylemenu == true then
		imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(1.00, 1.00, 1.00, 0.00)
	    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
	    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
	    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
	    imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
	    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
	    imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
	    imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
	    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
	    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
	    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
	end
end

function imgui.LeftChild(size)
    local c = imgui.GetCursorPos()
    local p = imgui.GetCursorScreenPos()
    local dl = imgui.GetWindowDrawList()
    imgui.SetCursorPos(imgui.ImVec2(c.x + size.x - 20 - 10, c.y + 10))
end

function imgui.RightChild(size)
    local c = imgui.GetCursorPos()
        local p = imgui.GetCursorScreenPos()
    local dl = imgui.GetWindowDrawList()
    imgui.SetCursorPos(imgui.ImVec2(c.x + size.x - 20 - 10, c.y + 10))
end

function bringVec4To(from, to, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
        local count = timer / (duration / 100)
        return imgui.ImVec4(
            from.x + (count * (to.x - from.x) / 100),
            from.y + (count * (to.y - from.y) / 100),
            from.z + (count * (to.z - from.z) / 100),
            from.w + (count * (to.w - from.w) / 100)
        ), true
    end
    return (timer > duration) and to or from, false
end

function bringVec2To(from, to, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
        local count = timer / (duration / 100)
        return imgui.ImVec2(
            from.x + (count * (to.x - from.x) / 100),
            from.y + (count * (to.y - from.y) / 100)
        ), true
    end
    return (timer > duration) and to or from, false
end

function imgui.Hint(str_id, hint_text, color, no_center)
	color = color or imgui.GetStyle().Colors[imgui.Col.PopupBg]
	local p_orig = imgui.GetCursorPos()
	local hovered = imgui.IsItemHovered()
	imgui.SameLine(nil, 0)

	local duration = 0.2
	local show = true

	if not AI_HINTS[str_id] then
		AI_HINTS[str_id] = {
			status = false,
			timer = 0
		}
	end
	local pool = AI_HINTS[str_id]

	if hovered then
		for k, v in pairs(AI_HINTS) do
			if k ~= str_id and os.clock() - v.timer <= duration  then
				show = false
			end
		end
	end

	if show and pool.status ~= hovered then
		pool.status = hovered
		pool.timer = os.clock()
	end

	local rend_window = function(alpha)
		local size = imgui.GetItemRectSize()
		local scrPos = imgui.GetCursorScreenPos()
		local DL = imgui.GetWindowDrawList()
		local center = imgui.ImVec2( scrPos.x - (size.x / 2), scrPos.y + (size.y / 2) - (alpha * 4) + 10 )
		local a = imgui.ImVec2( center.x - 7, center.y - size.y - 3 )
		local b = imgui.ImVec2( center.x + 7, center.y - size.y - 3)
		local c = imgui.ImVec2( center.x, center.y - size.y + 3 )
		local col = ToU32(imgui.ImVec4(color.x, color.y, color.z, alpha))

		DL:AddTriangleFilled(a, b, c, col)
		imgui.SetNextWindowPos(imgui.ImVec2(center.x, center.y - size.y - 3), imgui.Cond.Always, imgui.ImVec2(0.5, 1.0))
		imgui.PushStyleColor(imgui.Col.PopupBg, color)
		imgui.PushStyleColor(imgui.Col.Border, color)
		imgui.PushStyleColor(imgui.Col.Text, getContrastColor(color))
		imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
		imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 6)
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha)

		local max_width = function(text)
			local result = 0
			for line in text:gmatch('[^\r\n]+') do
				local len = imgui.CalcTextSize(line).x
				if len > result then
					result = len
				end
			end
			return result
		end

		local hint_width = max_width(hint_text) + (imgui.GetStyle().WindowPadding.x * 2)
		imgui.SetNextWindowSize(imgui.ImVec2(hint_width, -1), imgui.Cond.Always)
		imgui.Begin('##' .. str_id, _, imgui.WindowFlags.Tooltip + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar)
			for line in hint_text:gmatch('[^\r\n]+') do
				if no_center then
					imgui.Text(line)
				else
					imgui.SetCursorPosX((hint_width - imgui.CalcTextSize(line).x) / 2)
					imgui.Text(line)
				end
			end
		imgui.End()

		imgui.PopStyleVar(3)
		imgui.PopStyleColor(3)
	end

	if show then
		local between = os.clock() - pool.timer
		if between <= duration then
			local alpha = hovered and limit(between / duration, 0.0, 1.0) or limit(1.00 - between / duration, 0.0, 1.0)
			rend_window(alpha)
		elseif hovered then
			rend_window(1.00)
		end
	end

	imgui.SetCursorPos(p_orig)
end

function limit(v, min, max)
	min = min or 0.0
	max = max or 1.0
	return v < min and min or (v > max and max or v)
end

function getContrastColor(bg_col, col_1, col_2)
	col_1 = col_1 or imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
	col_2 = col_2 or imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    local luminance = 1 - (0.299 * bg_col.x + 0.587 * bg_col.y + 0.114 * bg_col.z)
    return luminance < 0.5 and col_1 or col_2
end


function imgui.PageButton(bool, icon, name, but_wide)
	but_wide = but_wide or 190
	local duration = 0.25
	local DL = imgui.GetWindowDrawList()
	local p1 = imgui.GetCursorScreenPos()
	local p2 = imgui.GetCursorPos()
	local col = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
		
	if not AI_PAGE[name] then
		AI_PAGE[name] = { clock = nil }
	end
	local pool = AI_PAGE[name]

	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    local result = imgui.InvisibleButton(name, imgui.ImVec2(but_wide, 35))
    if result and not bool then 
    	pool.clock = os.clock() 
    end
    local pressed = imgui.IsItemActive()
    imgui.PopStyleColor(3)
	if bool then
		if pool.clock and (os.clock() - pool.clock) < duration then
			local wide = (os.clock() - pool.clock) * (but_wide / duration)
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2((p1.x + 190) - wide, p1.y + 35), 0x10FFFFFF, 15, 10)
	       	DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 5, p1.y + 35), ToU32(col))
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + wide, p1.y + 35), ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 15, 10)
		else
			DL:AddRectFilled(imgui.ImVec2(p1.x, (pressed and p1.y + 3 or p1.y)), imgui.ImVec2(p1.x + 5, (pressed and p1.y + 32 or p1.y + 35)), ToU32(col))
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 15, 10)
		end
	else
		if imgui.IsItemHovered() then
			DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), 0x10FFFFFF, 15, 10)
		end
	end
	imgui.SameLine(10); imgui.SetCursorPosY(p2.y + 8)
	if bool then
		imgui.Text((' '):rep(3) .. icon)
		imgui.SameLine(60)
        imgui.PushFont(pagebuttons)
        imgui.SetCursorPosY(p2.y + 4)
		imgui.Text(name)
        imgui.PopFont()
	else
		if ini.main.stylemenu == false then
			imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), (' '):rep(3) .. icon)
		else
			imgui.TextColored(imgui.ImVec4(0.00, 0.00, 0.00, 1.00), (' '):rep(3) .. icon)
		end
		imgui.SameLine(60)
        imgui.PushFont(pagebuttons1)
        imgui.SetCursorPosY(p2.y + 4)
        if ini.main.stylemenu == false then
			imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), name)
		else
			imgui.TextColored(imgui.ImVec4(0.00, 0.00, 0.00, 1.00), name)
		end
        imgui.PopFont()
	end
	imgui.SetCursorPosY(p2.y + 40)
	return result
end

--
--     _   _   _ _____ ___  _   _ ____  ____    _  _____ _____   ______   __   ___  ____  _     _  __
--    / \ | | | |_   _/ _ \| | | |  _ \|  _ \  / \|_   _| ____| | __ ) \ / /  / _ \|  _ \| |   | |/ /
--   / _ \| | | | | || | | | | | | |_) | | | |/ _ \ | | |  _|   |  _ \\ V /  | | | | |_) | |   | ' / 
--  / ___ \ |_| | | || |_| | |_| |  __/| |_| / ___ \| | | |___  | |_) || |   | |_| |  _ <| |___| . \ 
-- /_/   \_\___/  |_| \___/ \___/|_|   |____/_/   \_\_| |_____| |____/ |_|    \__\_\_| \_\_____|_|\_\                                                                                                                                                                                                                    
--
-- Author: http://qrlk.me/samp
--
function autoupdate(json_url, prefix, url)
    local dlstatus = require('moonloader').download_status
    local json = getWorkingDirectory() .. '\\' .. thisScript().name .. '-version.json'
    if doesFileExist(json) then os.remove(json) end

    local update = true

    downloadUrlToFile(json_url, json,
        function(_, status)
            if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                if doesFileExist(json) then
                    local f = io.open(json, 'r')
                    if f then
                        local info = decodeJson(f:read('*a'))
                        f:close()
                        os.remove(json)

                        updatelink = info.updateurl
                        updateversion = info.latest

                        print('Текущая версия: ' .. thisScript().version)
                        print('Новая версия: ' .. updateversion)

                        if updateversion ~= thisScript().version then
                            lua_thread.create(function(prefix)
                                local color = -1
                                sampAddChatMessage(prefix .. 'Обнаружено обновление. Пытаюсь обновиться c ' .. thisScript().version .. ' на ' .. updateversion, color)
                                wait(250)
                                downloadUrlToFile(updatelink, thisScript().path,
                                    function(_, status1)
                                        if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                                            print('Загрузка обновления завершена.')
                                            sampAddChatMessage(prefix .. 'Обновление завершено!', color)
                                            goupdatestatus = true
                                            lua_thread.create(function() wait(500) thisScript():reload() end)
                                        elseif status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                                            if goupdatestatus == nil then
                                                sampAddChatMessage(prefix .. 'Обновление прошло неудачно. Запускаю устаревшую версию..', color)
                                                update = false
                                            end
                                        end
                                    end
                                )
                            end, prefix)
                        else
                            update = false
                            print('v' .. thisScript().version .. ': Обновление не требуется.')
                        end
                    end
                else
                    print('v' .. thisScript().version .. ': Не удалось прочитать файл обновления.')
                    update = false
                end
            end
        end
    )

    while update do wait(100) end
end
