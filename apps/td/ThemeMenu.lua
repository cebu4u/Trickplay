--themeMenu.lua

local g = Group{}

local themeMenuList = {}
local names = {}

for k,v in pairs(Themes) do
	themeMenuList[ #themeMenuList + 1 ] = {}
	--themeMenuList[ #themeMenuList][1] = Rectangle{color = "CC00FF", w=300, h=80, name = k, x = 950}
        themeMenuList[ #themeMenuList][1] = AssetLoader:getImage("MainMenuSmallButton",{name = k} )
        
        
	names[#names+1] = k
end

themeMenuList[1][1].y = 400

screen:add(g)

local hl = AssetLoader:getImage("MainMenuSmallFocus",{name = "Theme focus"} )

ThemeMenu = Menu.create(g, themeMenuList, hl)
ThemeMenu.container.opacity = 0
ThemeMenu:create_key_functions()
ThemeMenu:button_directions()
ThemeMenu:create_buttons(10, "Sans 34px")
ThemeMenu:apply_color_change("FFFFFF", "000000")
ThemeMenu:update_cursor_position()

ThemeMenu.container.x = MainMenu.container.x - MainMenu.container.w/2 + 30
ThemeMenu.container.y = 200

ThemeMenu.buttons.extra.r = function()
        
        local t = Themes[ names[ThemeMenu.y] ]
        local n = t.themeName
        
        if not settings[n] then
                
                settings[n] = { currentLevel = 1 }
                
        end
        
        createLevelMenu(settings[n].currentLevel)

	MainMenu.container.opacity = 0
	ThemeMenu.container.opacity = 0

	LevelMenu.container.opacity = 255
	LevelMenu.hl.opacity = 100
	LevelMenu:update_cursor_position()
	LevelMenu.theme = t
	
	ACTIVE_CONTAINER = LevelMenu
	keyboard_key_down = LevelMenu.buttons.on_key_down

end

ThemeMenu.buttons.extra.space = function()

	ThemeMenu.container.opacity = 0
	ACTIVE_CONTAINER = MainMenu
	keyboard_key_down = MainMenu.buttons.on_key_down

end
