--umbrella group for all members of the splash screen
game_screen = Group{}
--back icon
local back_button = Assets:Clone{src="assets/button-back.png",x=28,y=870}
local back_focus  = Assets:Clone{src="assets/focus-back-btn.png"}
back_button:move_anchor_point(back_button.w/2,back_button.h/2)
back_focus:move_anchor_point(back_focus.w/2,back_focus.h/2)
back_focus.position={back_button.x,back_button.y}
--background
game_screen:add(Assets:Clone{src="assets/background-game.jpg"})
screen:add(game_screen)
--game_screen:hide()

--the Focus indicator, and its index-position
local focus = Assets:Clone{src="assets/focus-square-tiles.png"}
focus.anchor_point      = {focus.w/2,focus.h/2}

local focus_i = {1,1}

--container for the tiles
local board = Group{}

--positioning info
local spacing   =  36

--local global for storing the first tile that was selected
local first_selected   = nil



--function that determines the position of a tile based on its index
local function x_y_from_index(i,j)

    return     (board_spec[game_state.difficulty][1] +
         (i-.5)*board_spec[game_state.difficulty][3]*tile_size +
         (i- 1)*spacing),
               (board_spec[game_state.difficulty][2] +
         (j-.5)*board_spec[game_state.difficulty][3]*tile_size +
         (j- 1)*spacing)
end
local back_sel = false
game_screen:add(back_focus,back_button,focus,focus_next,board)


local cascade_delay = 200
local duration_per_tile = 400
local fade_out = {
        duration = {500},
        stages = {
            function(self,delta,p)
                game_screen.opacity=255*(1-p)
            end
        }
    }
    
local fading_in = false
    
local fade_in = {
        duration = {500},
        setup = function()
            fading_in = true
            for i = 1, #game_state.board  do
				for j = 1, #game_state.board[i] do
                    if game_state.board[i][j] ~= 0 then
                        game_state.board[i][j].opacity=0
                    end
                end
            end
        end,
        stages = {
            function(self,delta,p)
                game_screen.opacity=255*(p)
            end,
            function(self,delta,p)
                local item
                local msecs = p*self.duration[2]
				for i = 1, #game_state.board  do
					for j = 1, #game_state.board[i] do
                        if game_state.board[i][j] ~= 0 then
						item = game_state.board[i][j].group
						if msecs > item.delay and msecs < (item.delay+duration_per_tile) then
							prog = (msecs-item.delay) / duration_per_tile
							item.scale = {board_spec[game_state.difficulty][3]*prog,board_spec[game_state.difficulty][3]}--y_rotation = {90*(1-prog),0,0}
							item.opacity = 255*prog
						elseif msecs > (item.delay+duration_per_tile) then
							item.scale = {board_spec[game_state.difficulty][3],board_spec[game_state.difficulty][3]}--y_rotation = {0,0,0}
							item.opacity = 255
						end
                        end
					end
				end
            end
        },
        on_remove = function()
            local item
			for i = 1, #game_state.board  do
				for j = 1, #game_state.board[i] do
                    if game_state.board[i][j] ~= 0 then
                        item = game_state.board[i][j].group
                        item.scale = {board_spec[game_state.difficulty][3],board_spec[game_state.difficulty][3]}--y_rotation = {0,0,0}
                        item.opacity = 255
                    end
                end
            end
            fading_in = false
        end
    }



function game_fade_in(previous_board)
    board:clear()
    
    game_state.tot = board_spec[game_state.difficulty][5] * board_spec[game_state.difficulty][4]
    game_state.board_size = {board_spec[game_state.difficulty][5], board_spec[game_state.difficulty][4]}
    
    if previous_board == nil then
        local options = {}
        for i = 1, board_spec[game_state.difficulty][5] do
            game_state.board[i] = {}
            for j = 1, board_spec[game_state.difficulty][4] do
                options[#options+1] = {i,j}
            end
        end
        local placement_order = {}
        while #options > 0 do
            placement_order[#placement_order+1] = table.remove(options,math.random(1,#options))
        end
        local t
        for i = 1, #placement_order do
            local index = math.ceil(i/2)
            index = index%#tile_faces + 1
            t = Tile(index, {placement_order[i][1] , placement_order[i][2]})
            --t.group.position={200*placement_order[i][1],200*placement_order[i][2]}
            t.group.x, t.group.y = x_y_from_index(placement_order[i][1],placement_order[i][2])
            t.group.delay = cascade_delay*(placement_order[i][1] + placement_order[i][2] - 1)
            t.group.scale = {board_spec[game_state.difficulty][3],board_spec[game_state.difficulty][3]}
            board:add(t.group)
            game_state.board[ placement_order[i][1] ][ placement_order[i][2] ] = t
        end
    else
        local t
        for i = 1, #previous_board do
            game_state.board[i] = {}
            for j = 1, #previous_board[i] do
                if previous_board[i][j] ~= 0 and previous_board[i][j] ~= nil then
                    t = Tile(previous_board[i][j], {i,j})
                    --t.group.position={200*i,200*j}
                    t.group.x, t.group.y = x_y_from_index(i,j)
                    t.group.delay = cascade_delay*(i + j - 1)
                    t.group.scale = {board_spec[game_state.difficulty][3],board_spec[game_state.difficulty][3]}
                    board:add(t.group)
                    game_state.board[ i ][ j ] = t
                else
                    game_state.board[ i ][ j ] = 0
                    game_state.tot = game_state.tot - 1
                end
            end
        end
    end
    focus.scale={board_spec[game_state.difficulty][3],board_spec[game_state.difficulty][3]}
    back_sel = false
    first_selected   = nil
    --game_screen:show()
    back_focus.opacity=0
    focus.opacity=255
    focus.x, focus.y = x_y_from_index(1,1)
    focus_i = {1,1}
    collectgarbage("collect")
    fade_in.duration[2] = cascade_delay*(#game_state.board+#game_state.board[1]-1)+ duration_per_tile
    animate_list[fade_out]=nil
    animate_list[fade_in]=fade_in
end
function get_gs_focus()
    return focus
end
function game_fade_out()
    animate_list[fade_in]=nil
    animate_list[fade_out]=fade_out
end


local anim_focus = {
    duration = {200},
    mode   = {"EASE_OUT_CIRC"},
    setup  = function(self)
        self.curr_x = focus.x
        self.curr_y = focus.y
    end,
    stages = {
        function(self,delta,p)
            focus.x = self.curr_x + (self.targ_x-self.curr_x)*p
            focus.y = self.curr_y + (self.targ_y-self.curr_y)*p
        end
    }
}
local corner_get_focus = {
    duration = {200},
    stages = {
        function(self,delta,p)
            back_focus.opacity = 255*(p)
            focus.opacity = 255*(1-p)
        end
    }
}

local corner_lose_focus = {
    duration = {200},
    stages = {
        function(self,delta,p)
            back_focus.opacity = 255*(1-p)
            focus.opacity = 255*(p)
        end
    }
}

------------------------
---- key handler
------------------------

local board_key_handler = {
    [keys.OK] = function()
        if fading_in then return end
        
        if game_state.board[focus_i[1]][focus_i[2]] == 0 or
           game_state.board[focus_i[1]][focus_i[2]] == nil then
            play_sound_wrapper(audio.blank_space)
            return
        elseif first_selected == nil then
            local next
            next   = game_state.board[focus_i[1]][focus_i[2]]
            if next.flip(nil) then
                first_selected = next
            end
            
        else -- second selected
            if game_state.board[focus_i[1]][focus_i[2]].flip(first_selected) then
            first_selected = nil
            end
        end
    end,
    [keys.Up] = function()
        if focus_i[2] > 1 then
            focus_i[2] = focus_i[2] - 1
            --anim_focus( x_y_from_index(focus_i[1],focus_i[2]) )
			
            anim_focus.targ_x, anim_focus.targ_y = x_y_from_index(focus_i[1],focus_i[2])
            --table.insert(animate_list,anim_focus)
			if animate_list[anim_focus] then
				anim_focus:setup()
				anim_focus.elapsed = 0
			else
				animate_list[anim_focus]=anim_focus
			end
            --focus.y    = 200*focus_i[2]
            back_sel   = false
            play_sound_wrapper(audio.move_focus)
        end
    end,
    [keys.Down] = function()
        if focus_i[2] < board_spec[game_state.difficulty][4] then
            focus_i[2] = focus_i[2] + 1
            --focus.y    = 200*focus_i[2]
            --anim_focus( x_y_from_index(focus_i[1],focus_i[2])
            anim_focus.targ_x, anim_focus.targ_y = x_y_from_index(focus_i[1],focus_i[2])
            --table.insert(animate_list,anim_focus)
            if animate_list[anim_focus] then
				anim_focus:setup()
				anim_focus.elapsed = 0
			else
				animate_list[anim_focus]=anim_focus
			end
            play_sound_wrapper(audio.move_focus)
            --)
        end
    end,
    [keys.Right] = function()
        if focus_i[1] < board_spec[game_state.difficulty][5] then
            focus_i[1] = focus_i[1] + 1
            --anim_focus( x_y_from_index(focus_i[1],focus_i[2]))
            anim_focus.targ_x, anim_focus.targ_y = x_y_from_index(focus_i[1],focus_i[2])
            --table.insert(animate_list,anim_focus)
            if animate_list[anim_focus] then
				anim_focus:setup()
				anim_focus.elapsed = 0
			else
				animate_list[anim_focus]=anim_focus
			end
            play_sound_wrapper(audio.move_focus)
            --focus.x = 200*focus_i[1]
        end
    end,
    [keys.Left] = function()
        play_sound_wrapper(audio.move_focus)
        if focus_i[1] >1 then
            focus_i[1] = focus_i[1] - 1
            --anim_focus( x_y_from_index(focus_i[1],focus_i[2]))
            anim_focus.targ_x, anim_focus.targ_y = x_y_from_index(focus_i[1],focus_i[2])
            --table.insert(animate_list,anim_focus)
            if animate_list[anim_focus] then
				anim_focus:setup()
				anim_focus.elapsed = 0
			else
				animate_list[anim_focus]=anim_focus
			end
            --focus.x = 200*focus_i[1]
        else
            --table.insert(animate_list,corner_get_focus)
            animate_list[corner_get_focus]=corner_get_focus
            --corner_get_focus()
            back_sel = true
        end
    end,
    [keys.w] = function()
        for i = 1, #game_state.board do
            for j = 1, #game_state.board[i] do
                
                animate_list[game_state.board[i][j].remove]=game_state.board[i][j].remove
            end
        end
    end
}

back_button_key_handler = {
    [keys.OK] = function()
        game_state.in_game = false
        if first_selected ~= nil then
            first_selected.flip_b()
        end
        give_keys("SPLASH")
        play_sound_wrapper(audio.button)
    end,
    [keys.Right] = function()
        back_sel = false
        --table.insert(animate_list,corner_lose_focus)
        animate_list[corner_lose_focus]=corner_lose_focus
        play_sound_wrapper(audio.move_focus)
        --corner_lose_focus()
    end,
}

game_on_key_down = function(key)
    
    if back_sel and back_button_key_handler[key] then
        back_button_key_handler[key]()
    elseif not back_sel and board_key_handler[key] then
        board_key_handler[key]()
    else
        print("Game Screen Key handler does not support the key "..key)
    end
end