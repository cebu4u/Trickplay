dofile ("Square.lua")
dofile ("Player.lua")
dofile ("aStar.lua")

Board = {
	render = function (self, seconds)
		local s =self.timer.elapsed_seconds 
		seconds_elapsed = seconds_elapsed + seconds
		wave_counter = 0

--					for i=1, #self.theme.wave do
--						local wave = self.theme.creeps[self.theme.waveTable[(self.theme.wave[level][i].name)]]
--						self.creepWave[creepnum] = Creep:new(wave, -240, GTP(CREEP_START[1]) , self.theme.themeName .. wave.name)
--						screen:add(self.creepWave[creepnum].creepGroup)
--						creepGold[creepnum] = 0
--						creepnum = creepnum + 1
--					end
		
		CREEP_WAVE_LENGTH = self.theme.wave[level].size
		if (seconds_elapsed >= WAIT_TIME) then
			if (s > 1) then 
				self.timer:start() 
				if (creepnum <= CREEP_WAVE_LENGTH) then
					local i = wavePartCounter
--					for i=1, #self.theme.wave do
						local wave = self.theme.creeps[self.theme.waveTable[(self.theme.wave[level][i].name)]]
						self.creepWave[creepnum] = Creep:new(wave, -240, GTP(CREEP_START[1]) , self.theme.themeName .. wave.name)
						screen:add(self.creepWave[creepnum].creepGroup)
						creepGold[creepnum] = 0
						creepnum = creepnum + 1
						creeppartnum = creeppartnum +1
						if (creeppartnum == self.theme.wave[level][i].num+1) then
							creeppartnum = 1
							wavePartCounter = wavePartCounter + 1
						end
--					end
					print (creepnum)
				end
			end

			for k,v in pairs(self.creepWave) do
				if (v.hp ~= 0) then
					v:render(seconds)
				else
					wave_counter = wave_counter + 1
					v.greenBar.width = 0
					v.creepGroup.opacity = 0
					
					if (creepGold[k] ==0) then
						creepGold[k] = 1
						self.player.gold = self.player.gold + v.bounty
						goldtext.text = self.player.gold
					end
					table.remove(v,k)
				end
			end
			phasetext.text = "Wave Phase!"
		else
			countdowntimer.text = "Time till next wave: "..(WAIT_TIME-1) - math.floor(seconds_elapsed)
			phasetext.text = "Build Phase!"
		end
		if (wave_counter == CREEP_WAVE_LENGTH) then
			creepnum = 1
			seconds_elapsed = 0
			level = level + 1
			wavePartCounter = 1
			creeppartnum = 1
		end
		
		for i = 1, #self.squaresWithTowers do
			self.squaresWithTowers[i].tower:render(seconds, self.creepWave)
		end
		
		if self.circle then
			circleRender(self.circle, seconds)
		end
	end
}

function Board:new(args)
	local w = BW
	local h = BH
	local squareGrid = {}
	local creepWave = {}
	local squaresWithTowers = {}
	local theme = args.theme
	local timer = 	Stopwatch()

	local player = Player:new {
		name = "Player 1",
		gold = 2000,
		lives = 30
	}
	for i = 1, h do
      squareGrid[i] = {}
	end
	for i = 1, h do
		for j = 1, w do
			squareGrid[i][j] = Square:new {x = j, y = i}
			if (i <= 1 or j <= 1 or i > h - 1 or j > w - 1) then
				squareGrid[i][j].square[3] = FULL
			else
				squareGrid[i][j].square[3] = EMPTY
			end
			if (i >= 3 and i <= 7 and (j <=1 or j > w-1)) then
				squareGrid[i][j].square[3] = WALKABLE
			end
	   end
	end
	local object = {
		w = w,
		h = h,
		player = player,
		squareGrid = squareGrid,
		squaresWithTowers = squaresWithTowers,
		theme = theme,
		timer = timer,
		creepWave = creepWave,
   }
   setmetatable(object, self)
   self.__index = self
   return object
end

function Board:init()
	for i = 1, self.h do
		local total = ""
		for j = 1, self.w do
			total = total..self.squareGrid[i][j].square[3]
		end
		print(total)
	end
end

function Board:createBoard()

	local groups = {}
	self.timer:start()
	for i = 1, self.h do
		groups[i] = {}
		local g = groups[i]
		local s = self.squareGrid[i]
		for j = 1, self.w do
				g[j] = Group{w=SP, h=SP}--, name=self.squareGrid[i][j].square[3]}
	   end
	end
	backgroundImage = Image {src = self.theme.boardBackground }
	
	local b = Group{}
	screen:add(backgroundImage, b)
	local hl = Rectangle{h=SP, w=SP, color="A52A2A"}
	self.nodes = self:createNodes()

	BoardMenu = Menu.create(b, groups, hl)
	BoardMenu:create_key_functions()
	BoardMenu:button_directions()
	BoardMenu:create_buttons(0, "Sans 34px")
	BoardMenu:apply_color_change("FFFFFF", "000000")
	BoardMenu.buttons:grab_key_focus()
	BoardMenu:update_cursor_position()
	BoardMenu.hl.opacity = 255
	
	BoardMenu.container.opacity=255
	
	BoardMenu.buttons.extra.r = function()
	
		playertext.text = self.player.name
		goldtext.text = self.player.gold
	
		-- Populate the circle menu with buttons
		local list = {}
		
		-- Towers
		local towers = {"normalRobot", "wall", "slowTower"}
		local icons = {"normalRobotBuy","wall","slowTowerIcon"}
		
		local menuType
		
		if (self.squareGrid[BoardMenu.y][BoardMenu.x].square[3] == EMPTY) then
			menuType = "Empty"
			
			-- Make sure it's possible to build here without blocking the path
			local board = game.board:getPathData()
			board[BoardMenu.y][BoardMenu.x] = "X"
			
			if pathExists(board,{4,1},{4,BW}) then
				
				for i=1,#towers do
				
					list[#list+1] = AssetLoader:getImage( icons[i], { } )
					list[#list].extra.f = function()
						buildTowerIfEmpty( towers[i] )
					end
				end
			end
		elseif (self.squareGrid[BoardMenu.y][BoardMenu.x].square[3] == FULL and self.squareGrid[BoardMenu.y][BoardMenu.x].hasTower == true) then
			menuType = "Full"
		
			list[#list+1] = AssetLoader:getImage( "sellIcon", { } )
			list[#list].extra.f = function()
				self:removeTower()
				self:findPaths()
			end
			
			list[#list+1] = AssetLoader:getImage( "upgradeIcon", { } )
			list[#list].extra.f = function()
				--self:removeTower()
				--self:findPaths()
			end
		
		end
		
		if #list > 0 then
		
			list[#list+1] = AssetLoader:getImage( "backIcon", { } )
			list[#list].extra.f = function()
			end
			
			-- Put this list within a table... for menu purposes
			local params = {list}
				
			-- Create the circular menu
			self.circle = createCircleMenu( { GTP(BoardMenu.y)+SP/2, GTP(BoardMenu.x)+SP/2 }, 150, params, menuType )
		end
		
	end
	
	playertext.text = self.player.name
	goldtext.text = self.player.gold
		
	BoardMenu.buttons.extra.space = function()
		--[[if not self.zoom then
			self:zoomIn()
			self.zoom = true
		else
			self:zoomOut()
			self.zoom = nil
		end]]
		seconds_elapsed = WAIT_TIME
	end
	
	add_to_render_list(self)
	for i=1,#self.creepWave do
		--self.creepWave[i].creepGroup.x = i*100
		print(self.creepWave[i].creepGroup)
		screen:add(self.creepWave[i].creepGroup)
		assert(self.creepWave[i])
	end
end

function Board:findPaths()

	for i = 1, #self.creepWave do
		if (self.creepWave[i].creepGroup.x >= 0 and self.creepWave[i].creepGroup.x <= 1800) then
			local found
			if self.creepWave[i].path then
				local size = #self.creepWave[i].path
				if size > 0 then
					found, self.creepWave[i].path = astar.CalculatePath( self.nodes[ self.creepWave[i].path[size][1] ][ self.creepWave[i].path[size][2] ], self.nodes[CREEP_END[1]][CREEP_END[2]], MyNeighbourIterator, MyWalkableCheck, MyHeuristic, MyConditional)
				end
			end
		end
	end

end

function Board:zoomIn()
	print("in")
	screen:animate { duration = 500, scale={math.sqrt(2),2}, position = {-GTP(BoardMenu.x-4)*2,-GTP(BoardMenu.y-2)*2}}

--	screen.scale={2,2}
--	screen.position = {-GTP(BoardMenu.x-4)*2,-GTP(BoardMenu.y-2)*2}
end

function Board:zoomOut()
	print("out")
	screen:animate { duration = 500, scale = {0.5,0.5}, position = {0,0}}
	screen.position = {0, 0}
	screen.scale={.5,.5}
end

function Board:buildTower(selection)
	local current = self.squareGrid[BoardMenu.y][BoardMenu.x]

--self.theme.themeName .. self.theme.creeps[level].name

	-- in reality this would call the circle menu asking for what to do with the square
		if selection == "normalRobot" then current.tower = Tower:new(self.theme.towers.normalTower, self.theme.themeName.."NormalTower")
		elseif selection == "wall" then current.tower = Tower:new(self.theme.towers.wall, self.theme.themeName.."Wall")
		elseif selection == "slowTower" then current.tower = Tower:new(self.theme.towers.slowTower, self.theme.themeName.."SlowTower")
		end

	if (self.player.gold - current.tower.cost >=0) then

		current.tower.x = GTP(current.x)
		current.tower.y = GTP(current.y)
	
		print(GTP(current.x), GTP(current.y))
		--assert(nil)
	
		current.hasTower = true
		table.insert(self.squaresWithTowers, current)
		current.square[3] = FULL
		current:render()
		self.player.gold = self.player.gold - current.tower.cost
		goldtext.text = self.player.gold
		current.tower.timer:start()
		local n = current.square.children
		local m = current.square.cut

		if n.north then m.north = n.north n.north.children.south = nil end
		if n.south then m.south = n.south n.south.children.north = nil end
		if n.east then m.east = n.east n.east.children.west = nil end
		if n.west then m.west = n.west n.west.children.east = nil end
	end	
end

function Board:removeTower()

	-- in reality this would call the circle menu asking for whether you want to sell or upgrade tower
	local current = self.squareGrid[BoardMenu.y][BoardMenu.x]
	
	current.tower:destroy()
	current.square[3] = EMPTY	
	self.player.gold = self.player.gold + current.tower.cost * 0.5
	current.hasTower = false
	
	local m = current.square.cut
	
	if m.north then m.north.children.south = current.square m.north = nil end
	if m.south then m.south.children.north = current.square m.south = nil end
	if m.east then m.east.children.west = current.square m.east = nil end
	if m.west then m.west.children.east = current.square m.west = nil end	

end

function Board:p()
	for i = 1, self.h do
		local total = ""
		for j = 1, self.w do
			total = total..self.squareGrid[i][j].square[3]
		end
		print(total)
	end
end

function printTable(table)
	for i = 1, #table do
		local total = ""
		for j = 1, #table[i] do
			total = total..table[i][j]
		end
	
		print(total)
	end
end

function copyTable(old)

	local new = {}
	for k,v in ipairs(old) do
		new[k] = {}
		for key,val in ipairs(v) do
			new[k][key] = val
		end
	end
	return new

end

function Board:getPathData()

	local t = {}
	for i = 1, self.h do
		t[i] = {}
		for j = 1, self.w do
			if self.squareGrid[i][j].square[3] == FULL then
				t[i][j] = "X"
			else
				t[i][j] = 0
			end
		end
	end
	return t

end

-- Start and finish are {y, x}
function pathExists(board, st, fn)

	-- Some assertions
	assert(type(st) == "table", "Start must have an x and a y coordinate")
	assert(type(fn) == "table", "Finish must have an x and a y coordinate")
	--printTable(board)
	
	-- If start == finish
	if st[1] == fn[1] and st[2] == fn[2] then return true
	else board[ st[1] ][ st[2] ] = " " end
		
	local found = false
		
	-- Check all directions
	if st[2] > 1 and board[ st[1] ][ st[2]-1 ] == 0 and not found then
		found = pathExists(board, { st[1] , st[2]-1 }, fn) end
		
	if st[1] > 1 and board[ st[1]-1 ][ st[2] ] == 0 and not found then
		found = pathExists(board, { st[1]-1 , st[2] }, fn) end
		
	if st[1] < BH and board[ st[1]+1 ][ st[2] ] == 0 and not found then
		found = pathExists(board, { st[1]+1 , st[2] }, fn) end
		
	if st[2] < BW and board[ st[1] ][ st[2]+1 ] == 0 and not found then
		found = pathExists(board, { st[1] , st[2]+1 }, fn) end
	
	return found
end

function Board:createNodes()
	
	local nodes = {}
	
	for i = 1, self.h do
		nodes[i] = {}
		for j = 1, self.w do
			local n = self.squareGrid[i][j].square
			nodes[i][j] = n
			n.children = {}
			n.cut = {}
			local c = n.children
			
			if n[1] > 1 and self.squareGrid[i-1][j].square[3] ~= FULL then c.north = self.squareGrid[i-1][j].square end
			if n[1] < BH and self.squareGrid[i+1][j].square[3] ~= FULL then c.south = self.squareGrid[i+1][j].square end
			if n[2] > 1 and self.squareGrid[i][j-1].square[3] ~= FULL then c.west = self.squareGrid[i][j-1].square end			
			if n[2] < BW and self.squareGrid[i][j+1].square[3] ~= FULL then c.east = self.squareGrid[i][j+1].square end			
			
		end
	end
	
	return nodes

end

function MyNeighbourIterator(node)
	return pairs(node.children)
end

function MyWalkableCheck(current_node)
	if current_node[3] ~= FULL then
		return true
	else
		return false
	end
end

function MyHeuristic(node_a, node_b)
	return ( math.abs(node_a[1]-node_b[1]) + math.abs(node_a[2]-node_b[2]) )
end
