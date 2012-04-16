--[[
Function: buttonPicker

Creates a button picker ui element

Arguments:
	Table of Button picker properties

	skin - Modify the skin for the Button picker by changing this value
    	bwidth - Width of the Button picker 
    	bheight - Height of the Button picker 
        items - A table containing the items for the Button picker
    	text_font - Font of the Button picker items
    	text_color - Color of the Button picker items
    	border_color - Color of the Button 
    	focus_border_color - Focus color of the Button 
		selected_item - The number of the selected item 
		on_selection_change - function that is called by selected item number   

Return:
 		bp_group - Group containing the button picker 

Extra Function:
		set_focus() - Grab focus of button picker 
		clear_focus() - Release focus of button picker
		press_left() - Left key press event, apply the selection of button picker
		press_right() - Right key press event, apply the selection of button picker
		press_up() - Up key press event, apply the selection of button picker
		press_down() - Down key press event, apply the selection of button picker
		press_enter() - Enter key press event, apply the selection of button picker
		insert_item(item) - Add an item to the items table 
		remove_item(item) - Remove an item from the items table 
]]


function ui_element.buttonPicker(t) 
    local w_scale = 1
    local h_scale = 1

 --default parameters 
    local p = {
	skin = "CarbonCandy", 
	ui_width =  180,
	ui_height = 60,
	items = {"item", "item", "item"},
	text_font = "FreeSans Medium 30px" , 
	focus_text_font = "FreeSans Medium 30px" , 
	text_color = {255,255,255,255}, 
	focus_text_color = {255,255,255,255}, 
	border_color = {255,255,255,255},
	fill_color = {255,255,255,0},
	focus_border_color = {0,255,0,255},
	focus_fill_color = {0,255,0,0},
	on_selection_change = nil, 
    selected_item = 1, 
	direction = "horizontal", 
	ui_position = {300, 300, 0},  
	----------------------------------------------
	inspector = 0, 
    }

 --overwrite defaults
     if t ~= nil then 
        for k, v in pairs (t) do
	    p[k] = v 
        end 
     end 
     
 --the umbrella Group
     local items = Group{name = "items"}

     local bp_group = Group
     {
		name = "buttonPicker", 
		position = p.ui_position, 
        reactive = true, 
		extra = {type = "ButtonPicker"}
     }

     local index 

     local padding = 5
     local pos = {0, 0}    -- focus, unfocus 
     local t = nil

     local create_buttonPicker = function() 

     	local ring, focus_ring, unfocus, focus, left_un, left_sel, right_un, right_sel
		local button_w 

		bp_group:clear()
		items:clear()

		index = p.selected_item 
    	bp_group.size = { p.ui_width , p.ui_height}

		
		if p.skin == "Custom" then 

			local key = string.format( "ring:%d:%d:%s:%s" , p.ui_width, p.ui_height, color_to_string( p.border_color ), color_to_string( p.fill_color ))
	
			ring = assets( key , my_make_ring , p.ui_width, p.ui_height, p.border_color, p.fill_color, 1, 7, 7, 1)
        	ring:set{name="ring", position = { pos[1] , pos[2] }, opacity = 255 }

			key = string.format( "ring:%d:%d:%s:%s" , p.ui_width, p.ui_height, color_to_string( p.focus_border_color ), color_to_string( p.focus_fill_color ))

			focus_ring = assets( key , my_make_ring , p.ui_width, p.ui_height, p.focus_border_color, p.focus_fill_color, 1, 7, 7, 1)
        	focus_ring:set{name="focus_ring", position = { pos[1] , pos[2] }, opacity = 0}

			button_w = focus_ring.w 
   			bp_group:add(ring, focus_ring)

        	left_un   = assets(skin_list["default"]["buttonpicker_left_un"])
	    	left_sel  = assets(skin_list["default"]["buttonpciker_left_sel"])
	    	right_un  = assets(skin_list["default"]["buttonpicker_right_un"])
        	right_sel = assets(skin_list["default"]["buttonpicker_right_sel"])

		elseif p.skin == "inspector" then  

			local left, right, u1px 
     		unfocus = Group{} --name = "unfocus-button", reactive = true, position = {pos[1], pos[2]}}
			
			left = Image{src="lib/assets/picker-left-cap.png"} 
			right = Image{src="lib/assets/picker-right-cap.png", position = {p.ui_width - left.w, 0}} 
			u1px = Image{src="lib/assets/picker-repeat1px.png", position = {left.w, 0}, tile = {true, false}, width = p.ui_width - left.w - right.w}

			unfocus:add(left)
			unfocus:add(u1px)
			unfocus:add(right)

     		focus = Group{} --name = "focus-button", reactive = true, position = {pos[1], pos[2]}}

			local fleft, fright, f1px
			fleft = Image{src="lib/assets/picker-left-cap-focus.png"}
			fright = Image{src="lib/assets/picker-right-cap-focus.png", position = {p.ui_width - fleft.w, 0}}
			f1px = Image{src="lib/assets/picker-repeat1px-focus.png", position = {fleft.w, 0}, tile = {true, false}, width = p.ui_width - left.w - right.w}

			focus:add(fleft)
			focus:add(f1px)
			focus:add(fright)
			
			bp_group:add(unfocus, focus)

			button_w = focus.w

	    	left_un   = assets("lib/assets/picker-left-arrow.png")
	    	left_sel  = assets("lib/assets/picker-left-arrow-focus.png")
	    	right_un  = assets("lib/assets/picker-right-arrow.png")
        	right_sel = assets("lib/assets/picker-right-arrow-focus.png")
		else 
     		unfocus = assets(skin_list[p.skin]["buttonpicker"])
     		focus = assets(skin_list[p.skin]["buttonpicker_focus"])

			button_w = p.ui_width 
			bp_group:add(unfocus, focus)
			
			left_un   = assets(skin_list[p.skin]["buttonpicker_left_un"])
	    	left_sel  = assets(skin_list[p.skin]["buttonpciker_left_sel"])
	    	right_un  = assets(skin_list[p.skin]["buttonpicker_right_un"])
        	right_sel = assets(skin_list[p.skin]["buttonpicker_right_sel"])
 		end 

		left_un.scale = {w_scale, h_scale}
		left_sel.scale = {w_scale, h_scale}
		right_un.scale = {w_scale, h_scale}
		right_sel.scale = {w_scale, h_scale}

		if unfocus then 
     		unfocus:set{name = "unfocus",  position = {pos[1], pos[2]+padding}, size = {p.ui_width, p.ui_height}, opacity = 255, reactive = true}
		end 
		if focus then 
			focus:set{name = "focus",  position = {pos[1], pos[2]+padding}, size = {p.ui_width, p.ui_height}, opacity = 0}
		end 

		if p.direction == "horizontal" then 
			left_un:set{name = "left_un", position = {pos[1] - left_un.w*w_scale - padding, pos[2] + p.ui_height/5}, opacity = 255, reactive = true}
			left_sel:set{name = "left_sel", position = {pos[1] - left_un.w*w_scale - padding, pos[2] + p.ui_height/5}, opacity = 0}
			right_un:set{name = "right_un", position = {pos[1] + button_w + padding, pos[2] + p.ui_height/5}, opacity = 255, reactive = true}
			right_sel:set{name = "right_sel", position = {right_un.x, right_un.y},  opacity = 0}
		elseif p.direction == "vertical" then 
            left_un.anchor_point={left_un.w/2,left_un.h/2}
            left_un.z_rotation={90,0,0}
			left_un:set{name = "left_un", position = {pos[1] + p.ui_width/2 - left_un.w/2 + padding, pos[2] - left_un.h/2 + 12}, opacity = 255, reactive = true} -- top
			left_sel.anchor_point={left_un.w/2,left_un.h/2}
            left_sel.z_rotation={90,0,0}
			left_sel:set{name = "left_sel", position = {pos[1] + p.ui_width/2 - left_un.w/2 + padding, pos[2] - left_un.h/2+ 12 }, opacity = 0}

            right_un.anchor_point={right_un.w/2,right_un.h/2}
            right_un.z_rotation={90,0,0}
			right_un:set{name = "right_un", position = {pos[1] + p.ui_width/2 - left_un.w/2 + padding, pos[2] + p.ui_height + padding * 2+ 5 }, opacity = 255, reactive = true} -- bottom
            right_sel.anchor_point={right_un.w/2,right_un.h/2}
            right_sel.z_rotation={90,0,0}
			right_sel:set{name = "right_sel", position = {pos[1] + p.ui_width/2 - left_un.w/2 + padding, pos[2] + p.ui_height + padding * 2 + 5 },  opacity = 0}
		end

     	for i, j in pairs(p.items) do 
               items:add(Text{name="item"..tostring(i), text = j, font=p.text_font, color =p.text_color, opacity = 255})     
     	end 

		local j_padding = 0

		for i, j in pairs(items.children) do 
	  		if i == p.selected_item then  
               j.position = {p.ui_width/2 - j.width/2, p.ui_height/2 - j.height/2 - p.inspector }
	       	   j_padding = 5 * j.x -- 5 는 진정한 해답이 아니고.. 이걸 바꿔 줘야함.. 그리고 박스 크기가 문자열과 비례해서 적당히 커줘야하고.. ^^;;;
			   break
			end 
		end 

		for i, j in pairs(items.children) do 
	  		if i > p.selected_item then  -- i == 1
               j.position = {p.ui_width/2 - j.width/2 + j_padding, p.ui_height/2 - j.height/2}
	  		elseif i < p.selected_item then  -- i == 1
               j.position = {p.ui_width/2 - j.width/2 + j_padding, p.ui_height/2 - j.height/2}
	  		end 
     	end 

		if p.direction == "vertical" then 
			items.clip = { 0, 10, p.ui_width, p.ui_height-10 }
		else 
			items.clip = { 0, 0, p.ui_width, p.ui_height }
     	end 

   		bp_group:add(right_un, right_sel, left_un, left_sel, items) 

        t = nil

		if editor_lb == nil or editor_use then 

			if ring then 
				ring.reactive = true
				function ring:on_button_down (x,y,b,n)
					if current_focus then
   			         	current_focus.extra.clear_focus()
	        		 	current_focus = group
					end 
					bp_group.set_focus()
	            	bp_group:grab_key_focus()
		        	return true
				end 
			elseif unfocus then 
				unfocus.reactive = true
				function unfocus:on_button_down (x,y,b,n)
					if current_focus then
   			         	current_focus.extra.clear_focus()
	        		 	current_focus = group
					end 
					bp_group.set_focus()
	            	bp_group:grab_key_focus()
		        	return true
				end 
			end

			left_un.reactive = true 
			function left_un:on_button_down(x, y, b, n)
				if current_focus then
					current_focus.extra.clear_focus()
	        		current_focus = group
				end
				bp_group.set_focus()
	        	bp_group:grab_key_focus()
				if p.direction == "vertical" then 
					bp_group.press_up()
				else 
					bp_group.press_left()
				end 
				return true 
			end 

			right_un.reactive = true 
			function right_un:on_button_down(x, y, b, n)
				if current_focus then
					current_focus.extra.clear_focus()
	        		current_focus = group
				end
				bp_group.set_focus()
	        	bp_group:grab_key_focus()
				if p.direction == "vertical" then 
					bp_group.press_down()
				else
					bp_group.press_right()
				end 
				return true 
			end 
		end 

	end 
 
     create_buttonPicker()

	 

    function bp_group.extra.set_focus()
		local unfocus = bp_group:find_child("unfocus")
		local focus = bp_group:find_child("focus")
		local ring = bp_group:find_child("ring")
		local focus_ring = bp_group:find_child("focus_ring")

		current_focus = bp_group
		if(p.skin == "Custom") then 
            ring.opacity = 0 
	     	focus_ring.opacity = 255
        else 
            unfocus.opacity = 0
	     	focus.opacity   = 255
		end 
     	for i, j in pairs(p.items) do 
             bp_group:find_child("item"..tostring(i)).color = p.focus_text_color
		end 
	    bp_group:grab_key_focus()
     end

     function bp_group.extra.clear_focus()
		local unfocus = bp_group:find_child("unfocus")
		local focus = bp_group:find_child("focus")
		local ring = bp_group:find_child("ring")
		local focus_ring = bp_group:find_child("focus_ring")

		if(p.skin == "Custom") then 
        	ring.opacity = 255 
	     	focus_ring.opacity = 0
		else 
            unfocus.opacity = 255
	    	focus.opacity   = 0
		end 
     	for i, j in pairs(p.items) do 
             bp_group:find_child("item"..tostring(i)).color = p.text_color
		end
     end

     function bp_group.extra.press_left()
		local unfocus = bp_group:find_child("unfocus")
		local focus = bp_group:find_child("focus")
		local ring = bp_group:find_child("ring")
		local focus_ring = bp_group:find_child("focus_ring")

		local left_sel = bp_group:find_child("left_sel")
		local left_un = bp_group:find_child("left_un")
		local right_sel = bp_group:find_child("right_sel")
		local right_un  = bp_group:find_child("right_un")

     	local prev_i = index
        local next_i = (index-2)%(#p.items)+1

	    index = next_i

	    local j = (bp_group:find_child("items")):find_child("item"..tostring(index))
	    local prev_old_x = p.ui_width/2 - j.width/2
	    local prev_old_y = p.ui_height/2 - j.height/2 - p.inspector
		local next_old_x, prev_new_x

		if focus then  
	    	next_old_x = p.ui_width/2 - j.width/2 + focus.w
		else 
	    	next_old_x = p.ui_width/2 - j.width/2 + focus_ring.w
		end 

	    local next_old_y = p.ui_height/2 - j.height/2 - p.inspector 

		if focus then  
	    	prev_new_x = p.ui_width/2 - j.width/2 - focus.w
		else
	    	prev_new_x = p.ui_width/2 - j.width/2 - focus_ring.w
		end 

	    local prev_new_y = p.ui_height/2 - j.height/2 - p.inspector 
	    local next_new_x = p.ui_width/2 - j.width/2
	    local next_new_y = p.ui_height/2 - j.height/2 - p.inspector 

	    if t ~= nil then
	       t:stop()
	       t:on_completed()
	    end
	    t = Timeline
	    {
	       duration = 300,
	       direction = "FORWARD",
	       loop = false
	    }

	    function t.on_new_frame(t,msecs,p)
			if msecs <= 100 then
				left_sel.opacity = 255* msecs/100
			elseif msecs <= 200 then
				left_sel.opacity = 255
			else 
				left_sel.opacity = 255*(1- (msecs-200)/100)
			end
			items:find_child("item"..tostring(prev_i)).x = prev_old_x + p*(prev_new_x - prev_old_x)
			items:find_child("item"..tostring(prev_i)).y = prev_old_y + p*(prev_new_y - prev_old_y)
			items:find_child("item"..tostring(next_i)).x = next_old_x + p*(next_new_x - next_old_x)
			items:find_child("item"..tostring(next_i)).y = next_old_y + p*(next_new_y - next_old_y)
	    end

	    function t.on_completed()
			items:find_child("item"..tostring(prev_i)).x = prev_new_x
			items:find_child("item"..tostring(prev_i)).y = prev_new_y
			items:find_child("item"..tostring(next_i)).x = next_new_x
			items:find_child("item"..tostring(next_i)).y = next_new_y
			p.selected_item = next_i
			if p.on_selection_change then
	       		p.on_selection_change(next_i)
	    	end
			t = nil
	    end
	    t:start()
	end

	function bp_group.extra.press_right()
		local unfocus = bp_group:find_child("unfocus")
		local focus = bp_group:find_child("focus")
		local ring = bp_group:find_child("ring")
		local focus_ring = bp_group:find_child("focus_ring")

		local left_sel = bp_group:find_child("left_sel")
		local left_un = bp_group:find_child("left_un")
		local right_sel = bp_group:find_child("right_sel")
		local right_un  = bp_group:find_child("right_un")

	    local prev_i = index
        local next_i = (index)%(#p.items)+1
	    index = next_i

	    local j = (bp_group:find_child("items")):find_child("item"..tostring(index))
	    local prev_old_x = p.ui_width/2 - j.width/2
	    local prev_old_y = p.ui_height/2 - j.height/2 - p.inspector 
	    local next_old_x, prev_new_x 
		if focus then 
	    	next_old_x = p.ui_width/2 - j.width/2 - focus.w
		else 
	    	next_old_x = p.ui_width/2 - j.width/2 - focus_ring.w
		end

	    local next_old_y = p.ui_height/2 - j.height/2 - p.inspector 

		if focus then 
	    	prev_new_x = p.ui_width/2 - j.width/2 + focus.w
		else
	    	prev_new_x = p.ui_width/2 - j.width/2 + focus_ring.w
		end 

	    local prev_new_y = p.ui_height/2 - j.height/2 - p.inspector 
	    local next_new_x = p.ui_width/2 - j.width/2
	    local next_new_y = p.ui_height/2 - j.height/2 - p.inspector 

	    if t ~= nil then
		t:stop()
		t:on_completed()
     	    end

	    t = Timeline {
	        duration = 300,
		direction = "FORWARD",
		loop = false
	    }

	    function t.on_new_frame(t,msecs,p)
	        if msecs <= 100 then
		     right_sel.opacity = 255* msecs/100
		elseif msecs <= 200 then
		     right_sel.opacity = 255
		else 
		     right_sel.opacity = 255*(1- (msecs-200)/100)
		end

		items:find_child("item"..tostring(prev_i)).x = prev_old_x + p*(prev_new_x - prev_old_x)
		items:find_child("item"..tostring(prev_i)).y = prev_old_y + p*(prev_new_y - prev_old_y)
		items:find_child("item"..tostring(next_i)).x = next_old_x + p*(next_new_x - next_old_x)
		items:find_child("item"..tostring(next_i)).y = next_old_y + p*(next_new_y - next_old_y)
	    end
	    function t.on_completed()
	        items:find_child("item"..tostring(prev_i)).x = prev_new_x
		items:find_child("item"..tostring(prev_i)).y = prev_new_y
		items:find_child("item"..tostring(next_i)).x = next_new_x
		items:find_child("item"..tostring(next_i)).y = next_new_y
		p.selected_item = next_i
		if p.on_selection_change then
	       	     p.on_selection_change(next_i)
	    	end
		t = nil
	    end
	    t:start()
	end

 	function bp_group.extra.press_up()
		local unfocus = bp_group:find_child("unfocus")
		local focus = bp_group:find_child("focus")
		local ring = bp_group:find_child("ring")
		local focus_ring = bp_group:find_child("focus_ring")

		local left_sel = bp_group:find_child("left_sel")
		local left_un = bp_group:find_child("left_un")
		local right_sel = bp_group:find_child("right_sel")
		local right_un  = bp_group:find_child("right_un")

	    local prev_i = index

        local next_i = (index-2)%(#p.items)+1

	    index = next_i

	    local j = (bp_group:find_child("items")):find_child("item"..tostring(index))
	    
		local prev_old_x = p.ui_width/2 - j.width/2
	    local prev_old_y = p.ui_height/2 - j.height/2

	    local next_old_x = p.ui_width/2 - j.width/2 
	    local next_old_y, prev_new_y 

		if focus then 
	    	next_old_y = p.ui_height/2 - j.height/2 + focus.h
		else
	    	next_old_y = p.ui_height/2 - j.height/2 + focus_ring.h
		end

	    local prev_new_x = p.ui_width/2 - j.width/2 

		if focus then 
	    	prev_new_y = p.ui_height/2 - j.height/2 - focus.h
		else 
	    	prev_new_y = p.ui_height/2 - j.height/2 - focus_ring.h
		end 

	    local next_new_x = p.ui_width/2 - j.width/2
	    local next_new_y = p.ui_height/2 - j.height/2

	    if t ~= nil then
	       t:stop()
	       t:on_completed()
	    end
	    t = Timeline
	    {
	       duration = 300,
	       direction = "FORWARD",
	       loop = false
	    }

	    function t.on_new_frame(t,msecs,p)
			if msecs <= 100 then
				left_sel.opacity = 255* msecs/100
			elseif msecs <= 200 then
				left_sel.opacity = 255
			else 
				left_sel.opacity = 255*(1- (msecs-200)/100)
			end
			items:find_child("item"..tostring(prev_i)).x = prev_old_x + p*(prev_new_x - prev_old_x)
			items:find_child("item"..tostring(prev_i)).y = prev_old_y + p*(prev_new_y - prev_old_y)
			items:find_child("item"..tostring(next_i)).x = next_old_x + p*(next_new_x - next_old_x)
			items:find_child("item"..tostring(next_i)).y = next_old_y + p*(next_new_y - next_old_y)
	    end
	    function t.on_completed()
			items:find_child("item"..tostring(prev_i)).x = prev_new_x
			items:find_child("item"..tostring(prev_i)).y = prev_new_y
			items:find_child("item"..tostring(next_i)).x = next_new_x
			items:find_child("item"..tostring(next_i)).y = next_new_y
			p.selected_item = next_i
			if p.on_selection_change then
	       		     p.on_selection_change(next_i)
	    		end

			t = nil
	    end
	   
	    t:start()

		
	end

	function bp_group.extra.press_down()
		local unfocus = bp_group:find_child("unfocus")
		local focus = bp_group:find_child("focus")
		local ring = bp_group:find_child("ring")
		local focus_ring = bp_group:find_child("focus_ring")

		local left_sel = bp_group:find_child("left_sel")
		local left_un = bp_group:find_child("left_un")
		local right_sel = bp_group:find_child("right_sel")
		local right_un  = bp_group:find_child("right_un")

	    local prev_i = index
            local next_i = (index)%(#p.items)+1
	    index = next_i

	    local j = (bp_group:find_child("items")):find_child("item"..tostring(index))
	    local prev_old_x = p.ui_width/2 - j.width/2
	    local prev_old_y = p.ui_height/2 - j.height/2
	    local next_old_x = p.ui_width/2 - j.width/2 
	    local next_old_y, prev_new_y
		if focus then
	    	next_old_y = p.ui_height/2 - j.height/2 - focus.h
		else 
	    	next_old_y = p.ui_height/2 - j.height/2 - focus_ring.h
		end

	    local prev_new_x = p.ui_width/2 - j.width/2 

		if focus then 
	    	prev_new_y = p.ui_height/2 - j.height/2 + focus.h
		else 
	    	prev_new_y = p.ui_height/2 - j.height/2 + focus_ring.h
		end
	    local next_new_x = p.ui_width/2 - j.width/2
	    local next_new_y = p.ui_height/2 - j.height/2

	    if t ~= nil then
		t:stop()
		t:on_completed()
     	    end

	    t = Timeline {
	        duration = 300,
		direction = "FORWARD",
		loop = false
	    }

	    function t.on_new_frame(t,msecs,p)
	        if msecs <= 100 then
		     right_sel.opacity = 255* msecs/100
		elseif msecs <= 200 then
		     right_sel.opacity = 255
		else 
		     right_sel.opacity = 255*(1- (msecs-200)/100)
		end

		items:find_child("item"..tostring(prev_i)).x = prev_old_x + p*(prev_new_x - prev_old_x)
		items:find_child("item"..tostring(prev_i)).y = prev_old_y + p*(prev_new_y - prev_old_y)
		items:find_child("item"..tostring(next_i)).x = next_old_x + p*(next_new_x - next_old_x)
		items:find_child("item"..tostring(next_i)).y = next_old_y + p*(next_new_y - next_old_y)
	    end
	    function t.on_completed()
	        items:find_child("item"..tostring(prev_i)).x = prev_new_x
		items:find_child("item"..tostring(prev_i)).y = prev_new_y
		items:find_child("item"..tostring(next_i)).x = next_new_x
		items:find_child("item"..tostring(next_i)).y = next_new_y
		p.selected_item = next_i
		if p.on_selection_change then
	       	     p.on_selection_change(next_i)
	    	end
		t = nil
	    end
	    t:start()
	end

	function bp_group.extra.press_enter()
	end

	function bp_group.extra.insert_item(itm) 
		table.insert(p.items, itm) 
		create_buttonPicker()
        end 

	function bp_group.extra.remove_item() 
		table.remove(p.items)
		create_buttonPicker()
        end 
	--bp_group.out_focus()
        
        mt = {}
        mt.__newindex = function (t, k, v)

             if k == "bsize" then  
	    	p.ui_width = v[1] 	
		p.ui_height = v[2]  
		w_scale = v[1]/180
		h_scale = v[2]/60
             elseif k == "ui_width" then 
		w_scale = v/180
                p[k] = v
	     elseif k == "ui_height" then   
		h_scale = v/60
                p[k] = v
	     else 
                p[k] = v
             end
	     if k ~= "selected" and k ~= "org_x"  and k ~= "org_y" and 
		k ~= "is_in_group" and k ~= "group_position" then 
                 create_buttonPicker()
	     end 
        end 

        mt.__index = function (t,k)
             if k == "bsize" then 
	        return {p.ui_width, p.ui_height}  
             else 
	        return p[k]
             end 
        end 

        setmetatable (bp_group.extra, mt) 

        return bp_group 
end