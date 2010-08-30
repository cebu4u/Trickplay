dofile ("Assets.lua")
dofile ("Globals.lua")
dofile ("menu/menu.lua")
dofile ("Game.lua")
dofile ("Board.lua")
dofile ("Creep.lua")
dofile ("Tower.lua")
dofile ("Bullet.lua")
dofile ("TowerInfo.lua")
dofile ("Popup.lua")



screen:show()

function app.on_loaded()
	dofile ("Themes.lua")
	
	Popup:new{text = "Welcome to Robots vs Zombies!", draw = true, fadeSpeed = 500}:render()
	-- Everything is loaded
	
	AssetLoader.on_preload_ready = function()
		
		--mediaplayer:play_sound("backgroundMusic.mp3")
		
		--local track_url = "themes/robot/sounds/ThemeSong.mp3"
		if SOUND then
		
			local track_url = "ThemeLoop.mp3"
			mediaplayer:load(track_url)
			mediaplayer.on_loaded = function (mediaplayer)
				mediaplayer:play()
			end
			mediaplayer.on_end_of_stream = function (mediaplayer)
				mediaplayer:seek(0) 
				mediaplayer:play()
			end
			
		end

		----
		
		TitleBackground = AssetLoader:getImage("TitleBackground",{name="TitleBackground"} )
		--MainMenuImage = AssetLoader:getImage("MainMenu", {name = "MainMenu", x = 500, y = 100})
		screen:add(TitleBackground)
		
		dofile ("Circle.lua")
		
		function createMainMenu()
		
			local o = AssetLoader:getImage( "MainMenuOverlay",{ name="overlay" } )
			local e = AssetLoader:getImage( "MainMenuPressEnter",{ name="pressEnter" } )
			
			local mainMenuList = {
				{
				AssetLoader:getImage("MainMenuSingle",{ name="single", extra={overlay = e} }),
				AssetLoader:getImage("MainMenuDouble",{ name="double", extra={overlay = o} }),
				}
			}
			
			--mainMenuList[1][2].extra.overlay = o
			
			if settings.saved then
				
				mainMenuList[1][3] = mainMenuList[1][2]
				mainMenuList[1][2] = mainMenuList[1][1]
				mainMenuList[1][1] = AssetLoader:getImage("MainMenuResume",{ name="resume", extra={overlay = o} })
				
			end
			
			
			local mainMenuFocus = AssetLoader:getImage( "MainMenuFocus",{ name="Main Menu Focus" } ) --Rectangle{color="FF00CC", w=300, h=250}
			
			local g = Group{}
			screen:add(g)
		
			MainMenu = Menu:new{container = g, list = mainMenuList, hl = mainMenuFocus}
			--MainMenu:create_key_functions()
			MainMenu:button_directions()
			MainMenu:create_buttons(10)
			MainMenu:apply_color_change("FFFFFF", "000000")
			--MainMenu.container.name = os.time()
			--MainMenu.buttons:grab_key_focus()
				
			MainMenu:update_cursor_position()
			MainMenu.hl.opacity = 255
			MainMenu.hl.color = "FFFFFF"
			
			MainMenu.container.anchor_point = {MainMenu.container.w/2, MainMenu.container.h/2}
			MainMenu.container.position = { screen.w/2, screen.h/2 + 150}
			
			MainMenu.buttons.extra.r = function()
				
				local select = MainMenu.list[1][MainMenu.x].name
					
				if select == "double" then
					
					createLevelMenu(1)
					
					LevelMenu.theme = Themes.robot
					LevelMenu.theme.wave = dofile("themes/"..LevelMenu.theme.themeName.."/coop.lua")
					round = 2
					
					game = Game:new{ theme = LevelMenu.theme , gold = LevelMenu.theme.wave.money/2}
					game:startGame()
					
					local hl2 = AssetLoader:getImage( "select2",{} )
					BoardMenu:add_hl( hl2 )
					BoardMenu:update_cursor_position(hl2)
					BoardMenu:controller_directions(hl2)
					
					local player = game.board:addPlayer{name = "Player 2", gold = LevelMenu.theme.wave.money/2, lives = 30, color = {102,255,109}}
					
					hl2.extra.r = function() BoardMenu.buttons.extra.r{ x=hl2.extra.x, y=hl2.extra.y, player=player } end
					ipod_keys(hl2)
					
					-- Player 2 info bar -------------
					game.p2info = Group{y = 995, z=2.5}
					game.infobar2 = AssetLoader:getImage("PlayerLeft",{})
					game.name2 = Text {font = "Sans 30px", text = player.name, x =300, y=10, color = "000000"}
					game.gold2 = Text {font = "Sans 30px", text = player.gold, x =70, y=10, color = "000000"}
					game.p2info:add(game.infobar2, game.name2, game.gold2)
					
					game.board.player2.info = Popup:new{group = game.p2info, fadeSpeed = 800, on_fade_in = function() end, on_fade_out = function() end}
					
					-- Player 1 info bar -------------
					local infobar = AssetLoader:getImage("PlayerRight",{})
					local playerInfo = Group{opacity = 0, z=2.5}
					playerInfo:add(infobar, game.board.player.playertext, game.board.player.goldtext)
					playerInfo.anchor_point = {infobar.w, infobar.h}
					playerInfo.position = {screen.w, screen.h - 25}
					screen:add(playerInfo)
					
					game.board.player.info = Popup:new{group = playerInfo, fadeSpeed = 800, on_fade_in = function() end, on_fade_out = function() end}
					----------------------------------
					
					screen:add(livestext, leveltext)
					screen:add(bulletImage, healthbar, shootAnimation, healthbarblack, bloodGroup, obstaclesGroup)
					
				elseif select == "resume" then
				
					resumed = true
					
					round = settings.round
					currentLevel = round
					
					savedRound = round
					local themesave = settings.theme
					Themes.robot.wave = dofile("themes/"..themesave.themeName.."/round"..round..".lua")
					game = Game:new{ theme = Themes.robot , gold = settings.gold}
					game:startGame()
					    
					screen:add(livestext, leveltext)
					screen:add(bulletImage, healthbar, shootAnimation, healthbarblack, bloodGroup, obstaclesGroup)
					
					-- Player 1 info bar-------------
					local infobar = AssetLoader:getImage("PlayerRight",{})
					local playerInfo = Group{opacity = 0, z=2.5}
					playerInfo:add(infobar, game.board.player.playertext, game.board.player.goldtext)
					playerInfo.anchor_point = {infobar.w, infobar.h}
					playerInfo.position = {screen.w, screen.h - 25}
					screen:add(playerInfo)
					
					game.board.player.info = Popup:new{group = playerInfo, fadeSpeed = 800, on_fade_in = function() end, on_fade_out = function() end}
					----------------------------------
					    
					Popup:new{text = "Resuming Level "..round}				
					
				else
					
					ThemeMenu.buttons.extra.r()
					
					--ACTIVE_CONTAINER = ThemeMenu
					--keyboard_key_down = ThemeMenu.buttons.on_key_down
					--ThemeMenu.container.opacity = 255
					
				end
				
			end
			
			if not ThemeMenu then
			
				-- Theme menu
				dofile ("ThemeMenu.lua")
				dofile ("Levels.lua")
				dofile ("Pause.lua")
				
			end
			
			ThemeMenu.container.opacity = 255
			
			MainMenu.buttons.extra.up = function()
				
				if MainMenu.list[1][MainMenu.x].name == "single" then
					
					ThemeMenu.buttons.extra.up()
					ThemeMenu:update_cursor_position()
					
				end
				
			end
			
			MainMenu.buttons.extra.down = function()
				
				if MainMenu.list[1][MainMenu.x].name == "single" then
					
					ThemeMenu.buttons.extra.down()
					ThemeMenu:update_cursor_position()
					
				end
				
			end
			
			local focusTheme = function()
			
				if MainMenu.list[1][MainMenu.x].name == "single" then
					ThemeMenu.hl.opacity = 255
				else
					ThemeMenu.hl.opacity = 0
				end
			
			end
			
			local temp = MainMenu.buttons.extra.right
			MainMenu.buttons.extra.right = function()
				temp()
				focusTheme()
			end
			
			local temp = MainMenu.buttons.extra.left
			MainMenu.buttons.extra.left = function()
				temp()
				focusTheme()
			end
			
			ACTIVE_CONTAINER = MainMenu
			keyboard_key_down = MainMenu.buttons.on_key_down
		    
			AssetLoader.on_preload_ready = nil
			
			MainMenu:overlay()
			MainMenu.updateOverlays()
			MainMenu.buttons.extra.left()
			
			MainMenu:addSound("themes/robot/sounds/BeepHigh.mp3", "themes/robot/sounds/BeepLow.mp3")
		
		end
		
		createMainMenu()
		
		--screen:add( AssetLoader:getImage("BuyFocus",{name="robot", x=200, y=200, z=20}) )
		--screen:add(AssetLoader:getImage("InfoBar",{x = 500, y = 500}))
		
	end
	
	function app.on_closing()
		print (savedRound, savedLevel, savedGold, savedLives)
		if (gamestarted) then
			settings.saved = true
			settings.round = savedRound
			settings.level = savedLevel
			settings.theme = savedTheme
			settings.gold = savedGold
			settings.lives = savedLives
			settings.towerPos = savedTowerPos
			settings.towerUpgrades = savedTowerUpgrades
			--settings.towerOwner = savedTowerOwner
			settings.towerType = savedTowerType
			--settings.player = game.board.player
		else
			settings.saved = false		
		end
	end

end

function controllers:on_controller_connected(controller)
	print( "NEW ONE CONNECTED" , controller.name )
	
	function controller.on_disconnected( controller )
	end
	
	function controller.on_key_down( controller , k )
	    if controller.name == "Keyboard" then
	        pcall( keyboard_key_down, ACTIVE_CONTAINER.buttons, k )
	    else
	        print( "FROM" , controller.name , "KEY DOWN" , k )
	        print("-"..controller.name.."-")
	        
	        pcall(ipod_key_down, k)
	    end
	end

end

--[[function grab_focus(controller, k)

	print(controller, k)
	if k == keys.Up then print("UP!!!") end

end]]

function ipod_key_down( k )
    
	print("Ipod key:", k)
	
	ipod_k[k]()

end

function ipod_keys(object)

	if not ipod_k then ipod_k = {} end
	
	ipod_k[keys.Up] = object.extra.up
	ipod_k[keys.Down] = object.extra.down
	ipod_k[keys.Left] = object.extra.left
	ipod_k[keys.Right] = object.extra.right
	ipod_k[keys.space] = object.extra.space
	ipod_k[keys.Return] = object.extra.r

end

function app.on_closing()

	if currentLevel and lastThemePlayed then
	
		settings[lastThemePlayed] = {currentLevel = currentLevel}
	
	end
	
end