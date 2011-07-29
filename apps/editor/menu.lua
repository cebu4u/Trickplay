editor_use = true
local menu = {}

local menu_bar = Image
	{
		src = "assets/menu-bar.png",
		clip = {0,0,1920,60},
		scale = {1,1,0,0},
		name = "menu_bar",
		position = {0,0,0},
		size = {1920,60},
		reactive = true,
	}

local menuButton_file = ui_element.menuButton
	{
		ui_width = 142,
		ui_height = 61,
		skin = "editor",
		label = "File",
		focus_color = {27,145,27,255},
		text_color = "#cccccc",
		text_font = "FreeSans Bold 28px",
		focus_text_color = "#cccccc", 
		border_width = 1,
		border_corner_radius = 12,
		reactive = true,
		border_color = {255,255,255,255},
		fill_color = {255,255,255,0},
		items = {},
		menu_width = 250,
		horz_padding = 24,
		vert_spacing = 0,
		horz_spacing = 0,
		vert_offset = 4,
		background_color = {255,0,0,0},
		separator_thickness = 0,
		expansion_location = "below",
		focus_fill_color = {27,145,27,0},
		label_text_font ="FreeSans Bold 20px", 
    	label_text_color = "#808080",
        item_text_font = "FreeSans Bold 20px",
    	item_text_color = "#ffffff",
		ui_position = {249,28,0}
	}

menuButton_file.insert_item(1,{type="item", string="New\t\t\t\t     N", bg=assets("assets/menu-item.png"), focus=assets("assets/menu-item-focus.png"), f=editor.close, parameter=true, mstring="New\t\t\t\t     <span foreground=\"#a6a6a6\">N</span>"})
menuButton_file.insert_item(2,{type="item", string="Open...\t\t\t     O", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.open, mstring="Open...\t\t\t     <span foreground=\"#a6a6a6\">O</span>"})
menuButton_file.insert_item(3,{type="item", string="Save    \t\t\t     S", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.save, parameter=true, mstring="Save    \t\t\t     <span foreground=\"#a6a6a6\">S</span>"}) 
menuButton_file.insert_item(4,{type="item", string="Save As...\t\t     A", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.save, parameter=false, mstring="Save As...\t\t     <span foreground=\"#a6a6a6\">A</span>" })
menuButton_file.insert_item(5,{type="item", string="New Project...\t\t     P", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=new_project, parameter=false, mstring="New Project...\t\t     <span foreground=\"#a6a6a6\">F</span>"})
menuButton_file.insert_item(6,{type="item", string="Open Project...\t     P", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=open_project, parameter=false, mstring="Open Project...\t     <span foreground=\"#a6a6a6\">P</span>"})
menuButton_file.insert_item(7,{type="item", string="Quit\t\t\t\t     Q", bg=assets("assets/menu-item-bottom.png"), focus= assets("assets/menu-item-bottom-focus.png"), f=function() if editor.close() == nil then exit() end end, mstring="Quit\t\t\t\t     <span foreground=\"#a6a6a6\">Q</span>"}) 

menuButton_file.name = "menuButton_file"
menuButton_file.anchor_point = {71,30.5}
menuButton_file.extra.focus = {[65293] = "menuButton_file", [65363] = "menuButton_edit",  [65364]=menuButton_file.press_down, [65362]=menuButton_file.press_up}

function menuButton_file:on_key_down(key)
	if menuButton_file.focus[key] then
		if type(menuButton_file.focus[key]) == "function" then
			menuButton_file.focus[key]()
		elseif screen:find_child(menuButton_file.focus[key]) then
			if screen:find_child(menuButton_file.focus[key]) ~= menuButton_file then
				if menuButton_file.on_focus_out then 
					menuButton_file.on_focus_out()
				end
				if screen:find_child(menuButton_file.focus[key]).on_focus_in then
					screen:find_child(menuButton_file.focus[key]).on_focus_in()
				end
				screen:find_child(menuButton_file.focus[key]):grab_key_focus()
			else 

				if menuButton_file.get_index() ~= 0 then 
				    menuButton_file.press_enter()
			    end

				menuButton_file.on_focus_out()
				screen:grab_key_focus()
			end 
		end
	end
	return true
end

menuButton_file.extra.reactive = true

local menuButton_edit = ui_element.menuButton
	{
		ui_width = 142,
		ui_height = 61,
		skin = "editor",
		label = "Edit",
		focus_color = {27,145,27,255},
		text_color = "#cccccc",
		text_font = "FreeSans Bold 28px",
		border_width = 1,
		border_corner_radius = 12,
		reactive = true,
		border_color = {255,255,255,255},
		fill_color = {255,255,255,0},
		items = {
		},
		menu_width = 250,
		horz_padding = 24,
		vert_spacing = 0,
		horz_spacing = 0,
		vert_offset = 4,
		background_color = {255,0,0,0},
		separator_thickness = 0,
		expansion_location = "below",
		focus_fill_color = {27,145,27,0},
		focus_text_color = "#cccccc", --{255,255,255,255},
		label_text_font ="FreeSans Bold 20px", 
    	label_text_color = "#808080",
        item_text_font = "FreeSans Bold 20px",
    	item_text_color = "#ffffff",
		ui_position = {489,28,0}, 
	}

menuButton_edit.insert_item(1,{type="item", string="Undo\t\t\t     Z", bg=assets("assets/menu-item.png"), focus=assets("assets/menu-item-focus.png"), f=function() screen:grab_key_focus() end, mstring="Undo\t\t\t     <span foreground=\"#a6a6a6\">Z</span>"}) --editor.undo} )
menuButton_edit.insert_item(2,{type="item", string="Redo\t\t\t     E", bg=assets("assets/menu-item.png"), focus=assets("assets/menu-item-focus.png"), f=function() screen:grab_key_focus() end, mstring="Redo\t\t\t     <span foreground=\"#a6a6a6\">E</span>"}) --editor.redo} )
menuButton_edit.insert_item(3,{type="item", string="Insert UI Element\t     I", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.the_ui_elements, mstring="Insert UI Element\t     <span foreground=\"#a6a6a6\">I</span>"})
menuButton_edit.insert_item(4,{type="item", string="Timeline...\t\t     J", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.timeline, mstring="Timeline...\t\t     <span foreground=\"#a6a6a6\">J</span>"}) --icon=assets("assets/menu-checkmark.png")
menuButton_edit.insert_item(5,{type="item", string="Delete", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.delete, icon=assets("assets/delete-menu-icon.png")})



menuButton_edit.insert_item(6,{type="item", string="Duplicate\t\t\t     D", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.duplicate, mstring="Duplicate\t\t\t     <span foreground=\"#a6a6a6\">D</span>"}) 
menuButton_edit.insert_item(7,{type="item", string="Clone\t\t\t     C", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.clone, mstring="Clone\t\t\t     <span foreground=\"#a6a6a6\">C</span>"}) 
menuButton_edit.insert_item(8,{type="item", string="Group\t\t\t     G", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.group, mstring="Group\t\t\t     <span foreground=\"#a6a6a6\">G</span>"}) 
menuButton_edit.insert_item(9,{type="item", string="UnGroup\t\t\t     U", bg=assets("assets/menu-item-bottom.png"), focus= assets("assets/menu-item-bottom-focus.png"), f=editor.ugroup, mstring="UnGroup\t\t\t     <span foreground=\"#a6a6a6\">U</span>"}) 

menuButton_edit.name = "menuButton_edit"
menuButton_edit.anchor_point = {71,30.5}
menuButton_edit.extra.focus = {[65363] = "menuButton_arrange", [65293] = "menuButton_edit", [65361] = "menuButton_file", [65364]=menuButton_edit.press_down, [65362]=menuButton_edit.press_up}

function menuButton_edit:on_key_down(key)
	if menuButton_edit.focus[key] then
		if type(menuButton_edit.focus[key]) == "function" then
			menuButton_edit.focus[key]()
		elseif screen:find_child(menuButton_edit.focus[key]) then
			if screen:find_child(menuButton_edit.focus[key]) ~= menuButton_edit then
				if menuButton_edit.on_focus_out then 
					menuButton_edit.on_focus_out()
				end
				if screen:find_child(menuButton_edit.focus[key]).on_focus_in then
					screen:find_child(menuButton_edit.focus[key]).on_focus_in()
				end
				screen:find_child(menuButton_edit.focus[key]):grab_key_focus()
			else 
				if menuButton_edit.get_index() ~= 0 then 
				    menuButton_edit.press_enter()
			    end
				menuButton_edit.on_focus_out()
				screen:grab_key_focus()
			end 
		end
	end
	return true
end

menuButton_edit.extra.reactive = true


local menuButton_arrange = ui_element.menuButton
	{
		ui_width = 142,
		ui_height = 61,
		skin = "editor",
		label = "Arrange",
		focus_color = {27,145,27,255},
		text_color = "#cccccc",
		text_font = "FreeSans Bold 28px",
		border_width = 1,
		border_corner_radius = 12,
		reactive = true,
		border_color = {255,255,255,255},
		fill_color = {255,255,255,0},
		items = {
		},
		menu_width = 250,
		horz_padding = 24,
		vert_spacing = 0,
		horz_spacing = 0,
		vert_offset = 4,
		background_color = {255,0,0,0},
		separator_thickness = 0,
		expansion_location = "below",
		focus_fill_color = {27,145,27,0},
		focus_text_color = "#cccccc", 
		label_text_font ="FreeSans Bold 20px", 
    	label_text_color = "#808080",
        item_text_font = "FreeSans Bold 20px",
    	item_text_color = "#ffffff",
		ui_position = {729,28,0}, 
	}

menuButton_arrange.insert_item(1,{type="label", string="  Align:", bg=assets("assets/menu-item-label.png")} )
menuButton_arrange.insert_item(2,{type="item", string="Left", bg=assets("assets/menu-item.png"), focus=assets("assets/menu-item-focus.png"), f=editor.left, icon=assets("assets/icon-align-left.png")} )
menuButton_arrange.insert_item(3,{type="item", string="Right", bg=assets("assets/menu-item.png"), focus=assets("assets/menu-item-focus.png"), f=editor.right, icon=assets("assets/icon-align-right.png")} )
menuButton_arrange.insert_item(4,{type="item", string="Top", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.top, icon=assets("assets/icon-align-top.png")})
menuButton_arrange.insert_item(5,{type="item", string="Bottom", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.bottom, icon=assets("assets/icon-align-bottom.png")}) 
menuButton_arrange.insert_item(6,{type="item", string="Horizontal Center", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.hcenter, icon=assets("assets/icon-align-hcenter.png")})
menuButton_arrange.insert_item(7,{type="item", string="Vertical Center", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.vcenter, icon=assets("assets/icon-align-vcenter.png")}) 
menuButton_arrange.insert_item(8,{type="label", string="  Distribute:", bg=assets("assets/menu-item-label.png")} )
menuButton_arrange.insert_item(9,{type="item", string="Horizontally", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.hspace, icon=assets("assets/icon-align-distributeh.png")}) 
menuButton_arrange.insert_item(10,{type="item", string="Vertically", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.vspace, icon=assets("assets/icon-align-distributev.png")}) 
menuButton_arrange.insert_item(11,{type="label", string="  Arrange:", bg=assets("assets/menu-item-label.png")} )
menuButton_arrange.insert_item(12,{type="item", string="Bring to Front", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.bring_to_front}) 
menuButton_arrange.insert_item(13,{type="item", string="Bring Forward", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.bring_forward}) 
menuButton_arrange.insert_item(14,{type="item", string="Send to Back", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.send_to_back}) 
menuButton_arrange.insert_item(15,{type="item", string="Send Backward", bg=assets("assets/menu-item-bottom.png"), focus= assets("assets/menu-item-bottom-focus.png"), f=editor.send_backward}) 

menuButton_arrange.name = "menuButton_arrange"
menuButton_arrange.anchor_point = {71,30.5}
menuButton_arrange.extra.focus = {[65363] = "menuButton_view", [65293] = "menuButton_arrange", [65361] = "menuButton_edit", [65364]=menuButton_arrange.press_down, [65362]=menuButton_arrange.press_up }

function menuButton_arrange:on_key_down(key)
	if menuButton_arrange.focus[key] then
		if type(menuButton_arrange.focus[key]) == "function" then
			menuButton_arrange.focus[key]()
		elseif screen:find_child(menuButton_arrange.focus[key]) then
			if screen:find_child(menuButton_arrange.focus[key]) ~= menuButton_arrange then
				if menuButton_arrange.on_focus_out then 
					menuButton_arrange.on_focus_out()
				end
				if screen:find_child(menuButton_arrange.focus[key]).on_focus_in then
					screen:find_child(menuButton_arrange.focus[key]).on_focus_in()
				end
				screen:find_child(menuButton_arrange.focus[key]):grab_key_focus()
			else 
				if menuButton_arrange.get_index() ~= 0 then 
				    menuButton_arrange.press_enter()
			        end
				menuButton_arrange.on_focus_out()
				screen:grab_key_focus()
			end
		end
	end
	return true
end

menuButton_arrange.extra.reactive = true


local menuButton_view = ui_element.menuButton
	{
		ui_width = 142,
		ui_height = 61,
		skin = "editor",
		label = "View",
		focus_color = {27,145,27,255},
		text_color = "#cccccc",
		text_font = "FreeSans Bold 28px",
		border_width = 1,
		border_corner_radius = 12,
		reactive = true,
		border_color = {255,255,255,255},
		fill_color = {255,255,255,0},
		items = {
		},
		menu_width = 250,
		horz_padding = 24,
		vert_spacing = 0,
		horz_spacing = 0,
		vert_offset = 4,
		background_color = {255,0,0,0},
		separator_thickness = 0,
		expansion_location = "below",
		focus_fill_color = {27,145,27,0},
		focus_text_color = "#cccccc", --{255,255,255,255},
		label_text_font ="FreeSans Bold 20px", 
    	label_text_color = "#808080",
        item_text_font = "FreeSans Bold 20px",
    	item_text_color = "#ffffff",
		ui_position = {971,28,0}, 
	}


menuButton_view.insert_item(1,{type="label", string="  Background:", bg=assets("assets/menu-item-label.png")} )
menuButton_view.insert_item(2,{type="item", string="Image...", bg=assets("assets/menu-item.png"), focus=assets("assets/menu-item-focus.png"), f=editor.reference_image, 
			       			icon=assets("assets/menu-checkmark.png")})
menuButton_view.items[2]["icon"].opacity = 0
menuButton_view.insert_item(3,{type="item", string="Small Grid", bg=assets("assets/menu-item.png"), focus=assets("assets/menu-item-focus.png"), f=editor.small_grid, icon=assets("assets/menu-checkmark.png")} )
menuButton_view.items[3]["icon"].opacity = 0
menuButton_view.insert_item(4,{type="item", string="Medium Grid", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=function() print ("JJJJJJ") editor.medium_grid() end , icon=assets("assets/menu-checkmark.png")})
menuButton_view.insert_item(5,{type="item", string="Large Grid", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.large_grid, icon=assets("assets/menu-checkmark.png")}) 
menuButton_view.items[5]["icon"].opacity = 0
menuButton_view.insert_item(6,{type="item", string="White", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.white_bg, icon=assets("assets/menu-checkmark.png")})
menuButton_view.items[6]["icon"].opacity = 0
menuButton_view.insert_item(7,{type="item", string="Black", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.black_bg, icon=assets("assets/menu-checkmark.png")}) 
menuButton_view.items[7]["icon"].opacity = 0


function menu.clearMenuButtonView_BGIcons() 
	menuButton_view.items[2]["icon"].opacity = 0
	menuButton_view.items[3]["icon"].opacity = 0
	menuButton_view.items[4]["icon"].opacity = 0
	menuButton_view.items[5]["icon"].opacity = 0
	menuButton_view.items[6]["icon"].opacity = 0
	menuButton_view.items[7]["icon"].opacity = 0
end 

menuButton_view.insert_item(8,{type="label", string="  Guides:", bg=assets("assets/menu-item-label.png")} )
menuButton_view.insert_item(9,{type="item", string="Add Horizontal Guide   H", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.h_guideline, mstring="Add Horizontal Guide   <span foreground=\"#a6a6a6\">H</span>"}) 
menuButton_view.insert_item(10,{type="item", string="Add Vertical Guide        V", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.v_guideline, mstring="Add Virtical Guide        <span foreground=\"#a6a6a6\">V</span>"}) 
menuButton_view.insert_item(11,{type="item", string="Show Guides", bg=assets("assets/menu-item.png"), focus= assets("assets/menu-item-focus.png"), f=editor.show_guides, icon=assets("assets/menu-checkmark.png")}) 
menuButton_view.insert_item(12,{type="item", string="Snap to Guides", bg=assets("assets/menu-item-bottom.png"), focus= assets("assets/menu-item-bottom-focus.png"), f=editor.snap_guides, icon=assets("assets/menu-checkmark.png")}) 

menuButton_view.name = "menuButton_view"
menuButton_view.anchor_point = {71,30.5}
menuButton_view.extra.focus = {[65293] = "menuButton_view", [65361] = "menuButton_arrange", [65364]=menuButton_view.press_down, [65362]=menuButton_view.press_up }

function menuButton_view:on_key_down(key)
	if menuButton_view.focus[key] then
		if type(menuButton_view.focus[key]) == "function" then
			menuButton_view.focus[key]()
		elseif screen:find_child(menuButton_view.focus[key]) then
			if screen:find_child(menuButton_view.focus[key]) ~= menuButton_view then
				if menuButton_view.on_focus_out then
					menuButton_view.on_focus_out()
				end
				if screen:find_child(menuButton_view.focus[key]).on_focus_in then
					screen:find_child(menuButton_view.focus[key]).on_focus_in()
				end
				screen:find_child(menuButton_view.focus[key]):grab_key_focus()
			else

			      if menuButton_view.get_index() ~= 0 then 
				    menuButton_view.press_enter()
			      end
			      menuButton_view.on_focus_out()
				  screen:grab_key_focus()
			end
		end
	end
	return true
end

menuButton_view.extra.reactive = true


local menu_text = Text
	{
		color = "#cccccc",
		font = "FreeSans Bold 20px",
		text = "",
		editable = true,
		wants_enter = false,
		wrap = false,
		wrap_mode = "CHAR",
		scale = {1,1,0,0},
		x_rotation = {0,0,0},
		y_rotation = {0,0,0},
		z_rotation = {0,0,0},
		anchor_point = {350,30.5},
		name = "menu_text",
		position = {1500,47,0},
		size = {700,20},
		opacity = 255,
		reactive = false,
		cursor_visible =false,
		alignment ="RIGHT",
	}
	

local menu_text_shadow = Text
	{
		color = "000000",
		font = "FreeSans Bold 20px",
		text = "",
		editable = true,
		wants_enter = false,
		wrap = false,
		wrap_mode = "CHAR",
		scale = {1,1,0,0},
		x_rotation = {0,0,0},
		y_rotation = {0,0,0},
		z_rotation = {0,0,0},
		anchor_point = {350,30.5},
		name = "menu_text_shadow",
		position = {1501,48,0},
		size = {700,20},
		opacity = 255/2,
		reactive = false,
		cursor_visible =false,
		alignment ="RIGHT",
	}

screen:add(menu_bar,menuButton_file,menuButton_edit,menuButton_arrange,menuButton_view,menu_text,menu_text_shadow)

----------------------------------------------------------------------------
-- Hides Menu 
----------------------------------------------------------------------------
    menu.menuHide = function()
	screen:find_child("menu_bar"):hide()
	screen:find_child("menuButton_file"):hide()
	screen:find_child("menuButton_edit"):hide()
	screen:find_child("menuButton_arrange"):hide()
	screen:find_child("menuButton_view"):hide()
	screen:find_child("menu_text"):hide()
	screen:find_child("menu_text_shadow"):hide()
	screen:grab_key_focus()
    end 

----------------------------------------------------------------------------
-- Show Menu
----------------------------------------------------------------------------
    
    menu.menuShow = function()
	screen:find_child("menu_bar"):show()
	screen:find_child("menu_bar"):raise_to_top()
	screen:find_child("menuButton_file"):show()
	screen:find_child("menuButton_file"):raise_to_top()
	screen:find_child("menuButton_edit"):show()
	screen:find_child("menuButton_edit"):raise_to_top()
	screen:find_child("menuButton_arrange"):show()
	screen:find_child("menuButton_arrange"):raise_to_top()
	screen:find_child("menuButton_view"):show()
	screen:find_child("menuButton_view"):raise_to_top()
	screen:find_child("menu_text"):show()
	screen:find_child("menu_text"):raise_to_top()
	screen:find_child("menu_text_shadow"):show()
	screen:find_child("menu_text_shadow"):raise_to_top()

	screen:grab_key_focus()
    end 

----------------------------------------------------------------------------
-- Menu Raise To Top
----------------------------------------------------------------------------
function menu.menu_raise_to_top() 
	menu.menuShow()
end 

screen:add(g)
menu.menu_raise_to_top()
editor_use = false

return menu