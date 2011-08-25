local factory = {}

-- Arrange Icon image
local icon_l = Image{src = "assets/left.png", opacity = 155}
local icon_r = Image{src = "assets/right.png", opacity = 155} 
local icon_t = Image{src = "assets/top.png", opacity = 155}
local icon_b = Image{src = "assets/bottom.png", opacity = 155} 
local icon_hc = Image{src = "assets/align-horizontally-center.png", opacity = 175} 
local icon_vc = Image{src = "assets/align-vertically-center.png", opacity = 175}
local icon_dhc = Image{src = "assets/distribute-horizontal-center.png", opacity = 185}
local icon_dvc = Image{src = "assets/distribute-vertical-center.png", opacity = 185}

local info_attr_t_idx = {"name","left", "top", "width", "height", "volume", "loop", "x", "y", "z", "w", "h", "ui_width", "ui_height", "bw", "bh", "skin","visible_w", "visible_h",  "virtual_w", "virtual_h","style","border_colorr", "border_colorg", "border_colorb", "border_colora","colorr", "colorg", "colorb", "colora","fr","fg","fb","fa","border_width","scale","clip","cx", "cy", "cw", "ch","font","wrap_mode","x_angle", "y_angle", "z_angle","opacity", "reactive",}

local more_attr_t_idx = {"r", "g", "b", "a","fr","fg","fb","fa","label","message", "button_colorr","button_colorg","button_colorb","button_colora","border_colorr", "border_colorg", "border_colorb", "border_colora","fill_colorr","fill_colorg","fill_colorb","fill_colora","focus_colorr","focus_colorg","focus_colorb","focus_colora","focus_fill_colorr","focus_fill_colorg","focus_fill_colorb","focus_fill_colora","cursor_colorr", "cursor_colorg", "cursor_colorb", "cursor_colora","focus_text_colorr","focus_text_colorg","focus_text_colorb","focus_text_colora","text_colorr","text_colorg","text_colorb","text_colora", "select_colorr",  "select_colorg",  "select_colorb",  "select_colora","label_colorr", "label_colorg", "label_colorb", "label_colora", "unsel_colorr", "unsel_colorg", "unsel_colorb", "unsel_colora", "text_font","colorr", "colorg", "colorb", "colora","title_colorr","title_colorg","title_colorb","title_colora","title_font","message_colorr","message_colorg","message_colorb","message_colora","message_font", "visible_w", "visible_h",  "virtual_w", "virtual_h", "bar_color_innerr", "bar_color_innerg","bar_color_innerb","bar_color_innera", "bar_color_outerr","bar_color_outerg","bar_color_outerb","bar_color_outera","bar_focus_color_innerr", "bar_focus_color_innerg","bar_focus_color_innerb","bar_focus_color_innera", "bar_focus_color_outerr","bar_focus_color_outerg","bar_focus_color_outerb","bar_focus_color_outera", "empty_color_innerr", "empty_color_innerg", "empty_color_innerb","empty_color_innera","empty_color_outerr","empty_color_outerg", "empty_color_outerb", "empty_color_outera", "frame_thickness", "frame_colorr","frame_colorg", "frame_colorb", "frame_colora",  "bar_thickness", "bar_offset", "arrow_sz", "arrow_dist_to_frame", "arrows_visible", "arrow_colorr", "arrow_colorg", "arrow_colorb", "arrow_colora", "arrow_focus_colorr", "arrow_focus_colorg", "arrow_focus_colorb", "arrow_focus_colora", "box_colorr","box_colorg","box_colorb","box_colora", "box_focus_colorr","box_focus_colorg","box_focus_colorb","box_focus_colora", "box_width", "box_height", "check_width", "check_height",  "rows","columns","cell_size", "cell_w","cell_h","cell_spacing_w","cell_spacing_h", "cell_timing","cell_timing_offset","cells_focusable","empty_top_colorr","empty_top_colorg","empty_top_colorb","empty_top_colora","empty_bottom_colorr","empty_bottom_colorg","empty_bottom_colorb","empty_bottom_colora","filled_top_colorr","filled_top_colorg","filled_top_colorb","filled_top_colora","filled_bottom_colorr","filled_bottom_colorg","filled_bottom_colorb","filled_bottom_colora","stroke_colorr","progress","overall_diameter","dot_diameter","dot_colorr","dot_colorg","dot_colorb","dot_colora","number_of_dots","cycle_time","padding", "border_width","border_corner_radius", "title_separator_colorr","title_separator_colorg","title_separator_colorb","title_separator_colora","color","font", "label_padding", "tab_position", "display_width", "display_height", "direction", "box_size", "bw", "bh", "check_size", "cw", "ch", "button_radius","select_radius", "line_space", "b_pos", "bx", "by", "item_pos", "ix", "iy", "br", "bg", "bb", "ba", "fr", "fg", "fb", "fa","menu_width","horz_padding","vert_spacing","horz_spacing","vert_offset","background_colorr","background_colorg","background_colorb","background_colora","separator_thickness","on_screen_duration","fade_duration","wrap_mode","rect_r", "rect_g", "rect_b", "rect_a", "bord_r", "bord_g", "bord_b", "bwidth","title_separator_thickness","expansion_location","selected_item","items","reactive", "focus"} 


local attr_t_idx 

local icon_map = 
{
	["Left Edge      "] = function() icon = icon_l return icon end, 
    ["Right Edge    "] = function() icon = icon_r return icon end, 
    ["Top             "] = function() icon = icon_t return icon end, 
    ["Bottom        "] = function() icon = icon_b return icon end, 
    ["Horiz. Center   "] = function() icon = icon_hc return icon end, 
    ["Vert. Center    "] = function() icon = icon_vc return icon end, 
    ["Horizontally	  "] = function() icon = icon_dhc return icon end,  
    ["Vertically 	  "] = function() icon = icon_dvc return icon end 
}

local item_map = 
{
    ["Undo".."\t\t\t".."[U]"]   = function()  return "undo" end,
    ["Redo".."\t\t\t".."[E]"]   = function()  return "redo" end,
    ["Clone".."\t\t\t".."[C]"]   = function() return "clone" end,
    ["Duplicate".."\t\t".."[D]"]   = function() return "duplicate" end,
    ["Delete".."\t\t     ".."[Del]"]   = function() return "delete" end,
    ["Group".."\t\t\t".."[G]"]   = function() return "group" end,
    ["UnGroup".."\t\t\t"..""]   = function() return "ungroup" end,
    ["Timeline".."\t\t\t".."[J]"]   = function() return "tline" end,
    ["Timeline Show".."\t".."[J]"]   = function() return "tline" end,
    ["Timeline Hide".."\t\t".."[J]"]   = function() return "tline" end,
	["Left Edge      "] = function() return "left" end, 
    ["Right Edge    "] = function() return "right" end, 
    ["Top             "] = function() return "top" end, 
    ["Bottom        "] = function() return "bottom" end, 
    ["Horiz. Center   "] = function() return "hcenter" end, 
    ["Vert. Center    "] = function() return "vcenter" end, 
    ["Horizontally	  "] = function() return "hspace" end,  
    ["Vertically 	  "] = function() return "vspace" end,
	["Bring To Front"] = function() return "bring_front" end,
    ["Bring Forward "] = function() return "bring_forward" end,
    ["Send To Back "] = function() return "send_back" end,
    ["Send Backward "] = function() return "send_backward"end,
	["Reference Image        "] = function() return "bgimage" end, 
	["Show Lines"] = function() return "guideline" end, 
	["Hide Lines"] = function() return "guideline" end,
}

local color_map =
{
        [ "Text" ] = function()  size = {490, 680} color = {25,25,25,100}  return size, color end,
        [ "Image" ] = function()  size = {490, 680} color ={25,25,25,100}  return size, color end,
        [ "Rectangle" ] = function()  size = {490, 680} color = {25,25,25,100}   return size, color end,
        [ "Clone" ] = function()  size = {490, 680} color = {25,25,25,100}   return size, color end,
        [ "Group" ] = function()  size = {490, 680} color = {25,25,25,100}   return size, color end,
        [ "Video" ] = function()  size = {490, 525} color = {25,25,25,100}   return size, color end,

        [ "Button" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "TextInput" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "DialogBox" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "ToastAlert" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "RadioButtonGroup" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "CheckBoxGroup" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "ButtonPicker" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "ProgressSpinner" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "ProgressBar" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "MenuBar" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "MenuButton" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "LayoutManager" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "ScrollPane" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "ArrowPane" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "ArrowPane" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "TabBar" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,
        [ "OSK" ] = function()  size = {510, 680} color = {25,25,25,100}  return size, color end,

        [ "widgets" ] = function() size = {600, 620} color = {25,25,25,100}  return size, color end,
        [ "Code" ] = function(file_list_size) size = {800, 600} color =  {25, 25, 25, 100}  return size, color end,
        [ "guidew" ] = function()  color =  {25,25,25,100} size = {700, 230} return size, color end,
        [ "msgw" ] = function(file_list_size) size = {900, file_list_size + 180} color = {25,25,25,100}  return size, color end,
        [ "file_ls" ] = function(file_list_size) size = {800, file_list_size + 180} color = {25,25,25,100}  return size, color end
}


-------------------------------------------------------------------------------
-- Makes a popup window background 
-------------------------------------------------------------------------------

function factory.make_popup_bg(o_type, file_list_size)

    local size, color = color_map[o_type](file_list_size)
    
    local BORDER_WIDTH= 3 
    local POINT_HEIGHT=34
    local POINT_WIDTH=60
    local BORDER_COLOR="FFFFFF"
    local CORNER_RADIUS=22
    local POINT_CORNER_RADIUS=2
    local H_BORDER_WIDTH = BORDER_WIDTH / 2

    local XBOX_SIZE = 25
    local PADDING = 10

    local function draw_path( c )

        c:new_path()

        c:move_to( H_BORDER_WIDTH + CORNER_RADIUS, POINT_HEIGHT - H_BORDER_WIDTH )

        c:line_to( ( c.w )- H_BORDER_WIDTH - CORNER_RADIUS, POINT_HEIGHT - H_BORDER_WIDTH )
        c:curve_to( c.w - H_BORDER_WIDTH , POINT_HEIGHT - H_BORDER_WIDTH ,
                    c.w - H_BORDER_WIDTH , POINT_HEIGHT - H_BORDER_WIDTH ,
                    c.w - H_BORDER_WIDTH , POINT_HEIGHT - H_BORDER_WIDTH + CORNER_RADIUS )

        c:line_to( c.w - H_BORDER_WIDTH , c.h - H_BORDER_WIDTH - CORNER_RADIUS )

        c:curve_to( c.w - H_BORDER_WIDTH , c.h - H_BORDER_WIDTH,
                    c.w - H_BORDER_WIDTH , c.h - H_BORDER_WIDTH,
                    c.w - H_BORDER_WIDTH - CORNER_RADIUS , c.h - H_BORDER_WIDTH )
        c:line_to( H_BORDER_WIDTH + CORNER_RADIUS , c.h - H_BORDER_WIDTH )

        c:curve_to( H_BORDER_WIDTH , c.h - H_BORDER_WIDTH,
                    H_BORDER_WIDTH , c.h - H_BORDER_WIDTH,
                    H_BORDER_WIDTH , c.h - H_BORDER_WIDTH - CORNER_RADIUS )

        c:line_to( H_BORDER_WIDTH , POINT_HEIGHT - H_BORDER_WIDTH + CORNER_RADIUS )

        c:curve_to( H_BORDER_WIDTH , POINT_HEIGHT - H_BORDER_WIDTH,
                    H_BORDER_WIDTH , POINT_HEIGHT - H_BORDER_WIDTH,
                    H_BORDER_WIDTH + CORNER_RADIUS, POINT_HEIGHT - H_BORDER_WIDTH )
    end

    local c = Canvas{ size = size }

    c:begin_painting()
    draw_path( c )

    -- Fill the whole thing with the color passed in and keep the path

    c:set_source_color(color) -- "050505")
    c:fill(true)

    -- Now, translate to the center and scale to its height. This will
    -- make the radial gradient elliptical.
    c:save()
    c:translate( c.w / 2 , c.h / 2 )
    c:scale( 2 , ( c.h / c.w ) )

    local rr = ( c.w / 2 )
    c:set_source_radial_pattern( 0 , 30 , 0 , 0 , 30 , c.w / 2 )
    c:add_source_pattern_color_stop( 0 , "00000000" )
    c:add_source_pattern_color_stop( 1 , "000000F0" )
    c:fill()
    c:restore()

    -- Draw the glossy glow    
    local R = c.w * 2.2

    c:new_path()
    c.op = "ATOP"
    c:arc( 0 , -( R - 240 ) , R , 0 , 360 )
    c:set_source_linear_pattern( c.w , 0 , 0 , c.h * 0.25 )
    c:add_source_pattern_color_stop( 0 , "FFFFFF20" )
    c:add_source_pattern_color_stop( 1 , "FFFFFF04" )
    c:fill()

    -- Now, draw the path again and stroke it with the border color
    draw_path( c )

    c:set_line_width( BORDER_WIDTH )
    c:set_source_color( BORDER_COLOR )
    c.op = "SOURCE"
    c:stroke( true )

  -- Draw title line
    if(o_type ~= "msgw" and o_type ~= "Code") then 
         c:new_path()
         c:move_to (0, 74)
         c:line_to (c.w, 74)
         c:set_line_width (3)
         c:set_source_color( BORDER_COLOR )
         c:stroke (true)
         c:fill (true)
    end

         c:finish_painting()
         c.position = {0,0}

    if c.Image then
  	 c= c:Image()
    end
    return c
end 


-------------------------------------------------------------------------------
-- Makes a messsage window button item 
-------------------------------------------------------------------------------

function factory.make_msgw_button_item( assets , caption)

    local STYLE         = { font = "FreeSans Medium 30px" , color = "FFFFFF" }
    local PADDING_X     = 7 
    local PADDING_Y     = 7
    local WIDTH         = 180
    local HEIGHT        = 60 
    local BORDER_WIDTH  = 1
    local BORDER_COLOR  = "FFFFFF"
    local BORDER_RADIUS = 12
    
    local function make_ring()
        local ring = Canvas{ size = { WIDTH , HEIGHT } }
        ring:begin_painting()
        ring:set_source_color( BORDER_COLOR )
        ring:round_rectangle(
            PADDING_X + BORDER_WIDTH / 2,
            PADDING_Y + BORDER_WIDTH / 2,
            WIDTH - BORDER_WIDTH - PADDING_X * 2 ,
            HEIGHT - BORDER_WIDTH - PADDING_Y * 2 ,
            BORDER_RADIUS )
        ring:stroke()
        ring:finish_painting()
        if ring.Image then
  	    ring= ring:Image()
    	end
        return ring
    end
    
    local text = Text{ text = caption }:set( STYLE )
    
    text.name = "caption"

    text.reactive = true

    local ring = make_ring ()
    
    local focus = assets( "assets/button-focus.png" )


    if ring.Image then
  	 ring= ring:Image()
    end

    local group = Group
    {
        size = { WIDTH , HEIGHT },
        children =
        {
            ring:set{ position = { 0 , 0 } },
            focus:set{ position = { 0 , 0 } , size = { WIDTH , HEIGHT } , opacity = 0 },
            text:set{ position = { (WIDTH  -text.w)/2, (HEIGHT - text.h)/2} }
        }
    }
    
    

    function group.extra.on_focus_in()
        focus.opacity = 255
	group:grab_key_focus(group)
    end
    
    function group.extra.on_focus_out()
        focus.opacity = 0
    end
	
    return group, text

end

---------------------------------------------------------
-- 	editor.ui_elements call this function 
---------------------------------------------------------

function factory.make_msgw_widget_item( assets , caption)

    local STYLE         = { font = "FreeSans Medium 25px" , color = "FFFFFF" }
    local PADDING_X     = 7 
    local PADDING_Y     = 7
    local WIDTH         = 280
    local HEIGHT        = 60 
    local BORDER_WIDTH  = 1
    local BORDER_COLOR  = "FFFFFF"
    local BORDER_RADIUS = 12
    
    local function make_ring()
        local ring = Canvas{ size = { WIDTH , HEIGHT } }
        ring:begin_painting()
        ring:set_source_color( BORDER_COLOR )
        ring:round_rectangle(
            PADDING_X + BORDER_WIDTH / 2,
            PADDING_Y + BORDER_WIDTH / 2,
            WIDTH - BORDER_WIDTH - PADDING_X * 2 ,
            HEIGHT - BORDER_WIDTH - PADDING_Y * 2 ,
            BORDER_RADIUS )
        ring:stroke()
        ring:finish_painting()
		if ring.Image then
  	 		ring= ring:Image()
        end

        return ring
    end
    
    local text = Text{ text = caption }:set( STYLE )
    
    text.name = "caption"

    text.reactive = true

    local ring = make_ring ()
    
    local focus = assets( "assets/button-focus.png" )

    local group = Group
    {
        size = { WIDTH , HEIGHT },
        children =
        {
            ring:set{ position = { 0 , 0 } },
            focus:set{ position = { 0 , 0 } , size = { WIDTH , HEIGHT } , opacity = 0 },
            text:set{ size = {WIDTH, HEIGHT}, position = { (WIDTH  -text.w)/2, (HEIGHT - text.h)/2} }
        }
    }
    
    function group.extra.on_focus_in()
        focus.opacity = 255
	group:grab_key_focus(group)
    end
    
    function group.extra.on_focus_out()
        focus.opacity = 0
    end
	
	group.reactive = true
    return group, text

end


-------------------------------------------------------------------------------
-- Makes a scroll bar item
-------------------------------------------------------------------------------

function factory.make_y_scroll_box()
    local PADDING_X     = 5 --7
    local PADDING_Y     = 5 --7
    local WIDTH         = 50
    local HEIGHT        = screen.h - 90 - 70 -- 90 is the menu bar height  
    local BORDER_WIDTH  = 1
    local BORDER_COLOR  = "FFFFFF"
    local BORDER_RADIUS = 1
    
    local function make_ring()
        local ring = Canvas{ size = { WIDTH , HEIGHT } }
        ring:begin_painting()
        ring:set_source_color( BORDER_COLOR )
        ring:round_rectangle(
            PADDING_X + BORDER_WIDTH / 2,
            PADDING_Y + BORDER_WIDTH / 2,
            WIDTH - BORDER_WIDTH - PADDING_X * 2 ,
            HEIGHT - BORDER_WIDTH - PADDING_Y * 2 ,
            BORDER_RADIUS )
        ring:stroke()
        ring:finish_painting()
	if ring.Image then
  	 ring= ring:Image()
        end

        return ring
    end
    ring = make_ring ()

    ring.name = "scroll_box"
    return ring
end


function factory.make_x_scroll_box()
    local PADDING_X     = 5 
    local PADDING_Y     = 5
    local WIDTH         = screen.w - 70 
    local HEIGHT        = 50
    local BORDER_WIDTH  = 1
    local BORDER_COLOR  = "FFFFFF"
    local BORDER_RADIUS = 1
    
    local function make_ring()
        local ring = Canvas{ size = { WIDTH , HEIGHT } }
        ring:begin_painting()
        ring:set_source_color( BORDER_COLOR )
        ring:round_rectangle(
            PADDING_X + BORDER_WIDTH / 2,
            PADDING_Y + BORDER_WIDTH / 2,
            WIDTH - BORDER_WIDTH - PADDING_X * 2 ,
            HEIGHT - BORDER_WIDTH - PADDING_Y * 2 ,
            BORDER_RADIUS )
        ring:stroke()
        ring:finish_painting()
	if ring.Image then
  	 ring= ring:Image()
        end
        return ring
    end
    ring = make_ring ()
    ring.name = "xscroll_box"
    return ring
end


function factory.make_msgw_scroll_box()

    local PADDING_X     = 7 
    local PADDING_Y     = 7
    local WIDTH         = 50
    local HEIGHT        = 500 
    local BORDER_WIDTH  = 1
    local BORDER_COLOR  = "FFFFFF"
    local BORDER_RADIUS = 12
    
    local function make_ring()
        local ring = Canvas{ size = { WIDTH , HEIGHT } }
        ring:begin_painting()
        ring:set_source_color( BORDER_COLOR )
        ring:round_rectangle(
            PADDING_X + BORDER_WIDTH / 2,
            PADDING_Y + BORDER_WIDTH / 2,
            WIDTH - BORDER_WIDTH - PADDING_X * 2 ,
            HEIGHT - BORDER_WIDTH - PADDING_Y * 2 ,
            BORDER_RADIUS )
        ring:stroke()
        ring:finish_painting()
	if ring.Image then
  	 ring= ring:Image()
        end
        return ring
    end
    ring = make_ring ()
    return ring
end

function factory.make_x_scroll_bar(canvas_sz)

    local PADDING_X     = 5 
    local PADDING_Y     = 5
    local WIDTH         = screen.w - 70 
    local HEIGHT        = 50 
    local S_HEIGHT      = 42
    local BORDER_WIDTH  = 1
    local BORDER_COLOR  = "FFFFFF"
    local BORDER_RADIUS = 12

    local S_WIDTH       = WIDTH / (canvas_sz/screen.w)
    
    local function make_scroll_bar()
        local ring = Canvas{ size = { S_WIDTH , S_HEIGHT } }
        ring:begin_painting()
        ring:set_source_color( BORDER_COLOR )
        ring:round_rectangle(
            PADDING_X + BORDER_WIDTH / 2,
            PADDING_Y + BORDER_WIDTH / 2,
            S_WIDTH - BORDER_WIDTH - PADDING_X * 2 ,
            S_HEIGHT - BORDER_WIDTH - PADDING_Y * 2 ,
            BORDER_RADIUS )
	ring:fill()
        ring:finish_painting()
	if ring.Image then
  	 ring= ring:Image()
        end
        return ring
    end

    local scroll_bar = make_scroll_bar ()
    
    scroll_bar.name = "xscroll_bar"
    scroll_bar.reactive = true 
    
    return scroll_bar
end

function factory.make_y_scroll_bar(canvas_sz)

    local PADDING_X     = 5 
    local PADDING_Y     = 5
    local WIDTH         = 50
    local SCROLL_Y_POS  = 90
    local HEIGHT        = screen.h - SCROLL_Y_POS -70
    local S_WIDTH       = 42
    local BORDER_WIDTH  = 1
    local BORDER_COLOR  = "FFFFFF"
    local BORDER_RADIUS = 12
    
    local S_HEIGHT = HEIGHT / (canvas_sz/screen.h)

    local function make_scroll_bar()
        local ring = Canvas{ size = { S_WIDTH , S_HEIGHT } }
        ring:begin_painting()
        ring:set_source_color( BORDER_COLOR )
        ring:round_rectangle(
            PADDING_X + BORDER_WIDTH / 2,
            PADDING_Y + BORDER_WIDTH / 2,
            S_WIDTH - BORDER_WIDTH - PADDING_X * 2 ,
            S_HEIGHT - BORDER_WIDTH - PADDING_Y * 2 ,
            BORDER_RADIUS )
		ring:fill()
        ring:finish_painting()
		if ring.Image then
  	 		ring= ring:Image()
        end
        return ring
    end

    local scroll_bar = make_scroll_bar ()
    
    scroll_bar.name = "scroll_bar"
    scroll_bar.reactive = true 
    
    return scroll_bar
end

function factory.make_msgw_scroll_bar(file_list_size)

    local PADDING_X     = 7 
    local PADDING_Y     = 7
    local WIDTH         = 50
    local HEIGHT        = 500 
    local S_HEIGHT      = 2*HEIGHT - file_list_size 
    local S_WIDTH       = 42
    local BORDER_WIDTH  = 1
    local BORDER_COLOR  = "FFFFFF"
    local BORDER_RADIUS = 12
    
    local function make_scroll_bar()
        local ring = Canvas{ size = { S_WIDTH , S_HEIGHT } }
        ring:begin_painting()
        ring:set_source_color( BORDER_COLOR )
        ring:round_rectangle(
            PADDING_X + BORDER_WIDTH / 2,
            PADDING_Y + BORDER_WIDTH / 2,
            S_WIDTH - BORDER_WIDTH - PADDING_X * 2 ,
            S_HEIGHT - BORDER_WIDTH - PADDING_Y * 2 ,
            BORDER_RADIUS )
	ring:fill()
        ring:finish_painting()
	if ring.Image then
  	 ring= ring:Image()
        end
        return ring
    end

    local scroll_bar = make_scroll_bar ()
    
    scroll_bar.name = "scroll_bar"
    scroll_bar.reactive = true 
    
    function scroll_bar:on_button_down(x,y,button,num_clicks)
	dragging = {scroll_bar, x- scroll_bar.x, y - scroll_bar.y }
        return true
    end 

    function scroll_bar:on_button_up(x,y,button,num_clicks)
	 if(dragging ~= nil) then 
	      local actor , dx , dy = unpack( dragging )
	      if (actor.extra.h_y < y-dy and y-dy < actor.extra.l_y) then 	
	           scroll_bar.y = y - dy 
	      end 
	      dragging = nil
	 end 
         return true
    end 

    return scroll_bar
end


-------------------------------------------------------------------------------
-- Makes an x(close) box
-------------------------------------------------------------------------------

function factory.make_xbox()
    local BORDER_WIDTH= 3 
    local BORDER_COLOR="FFFFFF5C"

    local XBOX_SIZE = 25
    local PADDING = 10

    local c = Canvas{ size = {XBOX_SIZE + PADDING, XBOX_SIZE + PADDING} }

    c:begin_painting()
    c:new_path()

  -- Draw x button
    local x=0 
    local y=0

    c:move_to ( x, y)
    c:line_to ( x + XBOX_SIZE, y + XBOX_SIZE)
    c:move_to ( x + XBOX_SIZE, y)
    c:line_to ( x, y + XBOX_SIZE)

  -- Draw x button box
    c:move_to ( x, y)
    c:line_to ( x + XBOX_SIZE, y)
    c:move_to ( x + XBOX_SIZE, y)
    c:line_to ( x + XBOX_SIZE, y + XBOX_SIZE)
    c:move_to ( x + XBOX_SIZE, y + XBOX_SIZE)
    c:line_to ( x, y + XBOX_SIZE)
    c:move_to ( x, y + XBOX_SIZE)
    c:line_to ( x, y)

    c:set_line_width (3)
    c:set_source_color( BORDER_COLOR )
    c:stroke (true)
    c:fill (true)

    c:finish_painting()

    if c.Image then
  	 c= c:Image()
    end
    return c
end 

-------------------------------------------------------------------------------
-- Makes a focus(green) ring 
-------------------------------------------------------------------------------
function factory.draw_focus_ring()
        local ring = Canvas{ size = {650, 60} }
        ring:begin_painting()
        ring:set_source_color("1b911b")
        ring:round_rectangle( 7 + 1/2, 7 + 1/2, 635, 45, 12)
    	ring:set_line_width (4)
        ring:stroke()
        ring:finish_painting()
	if ring.Image then
  	 ring= ring:Image()
        end

        return ring
end

function factory.draw_small_focus_ring()
        local ring = Canvas{ size = {375, 60} }
        ring:begin_painting()
        ring:set_source_color("1b911b")
        ring:round_rectangle( 7 + 1/2, 7 + 1/2, 365, 45, 12)
    	ring:set_line_width (4)
        ring:stroke()
        ring:finish_painting()
	if ring.Image then
  	 ring= ring:Image()
        end
        return ring
end

function factory.draw_tiny_focus_ring()
        local ring = Canvas{ size = {150, 50} }
        ring:begin_painting()
        ring:set_source_color("1b911b")
        ring:round_rectangle( 4, 4, 142, 42, 12)
    	ring:set_line_width (4)
        ring:stroke()
        ring:finish_painting()
	if ring.Image then
  	 ring= ring:Image()
        end
        return ring
end

-------------------------------------------------------------------------------
-- Makes a focus(white, input) ring 
-------------------------------------------------------------------------------
function factory.draw_ring()
	local ring = Canvas{ size = {650, 60} }
        ring:begin_painting()
        ring:set_source_color( "FFFFFFC0" )
        ring:round_rectangle( 7 + 1/2, 7 + 1/2, 635, 45, 12)
    	ring:set_line_width (4)
        ring:stroke()
        ring:finish_painting()
		if ring.Image then
  	 		ring= ring:Image()
        end
        return ring
end

function factory.draw_small_ring()
	local ring = Canvas{ size = {375, 60} }
    ring:begin_painting()
    ring:set_source_color( "FFFFFFC0" )
    ring:round_rectangle( 7 + 1/2, 7 + 1/2, 365, 45, 12)
    ring:set_line_width (4)
    ring:stroke()
    ring:finish_painting()
	if ring.Image then
  		ring= ring:Image()
    end
    return ring
end


function factory.draw_tiny_ring()
	local ring = Canvas{ size = {150, 50} }
    ring:begin_painting()
    ring:set_source_color( "FFFFFFC0" )
    ring:round_rectangle( 4, 4, 142, 42, 12 )
    ring:set_line_width (4)
    ring:stroke()
    ring:finish_painting()
	if ring.Image then
  		ring= ring:Image()
    end
    return ring
end

-------------------------------------------------------------------------------
-- Makes a line for categorizing menu items 
-------------------------------------------------------------------------------
function factory.draw_line()
    local PADDING_Y     = 7   
    local WIDTH         = 900
    local LINE_WIDTH    = 5
    local LINE_COLOR    = "FFFFFF"


	local line = Canvas{ size = {WIDTH, LINE_WIDTH + PADDING_Y} }
    line:begin_painting()
    line:new_path()
    line:move_to (0,0)
    line:line_to (WIDTH, 0)
    line:set_line_width (LINE_WIDTH)
    line:set_source_color(LINE_COLOR)
    line:stroke (true)
    line:fill (true)
    line:finish_painting()
	if line.Image then
  		line= line:Image()
    end
    return line
end 


local org_items    

-------------------------------------------------------------------------------
-- Makes a popup window contents (attribute name, input text, input button)
-------------------------------------------------------------------------------
function factory.make_filechooser(assets, inspector, v, item_n, item_v, item_s, save_items)
	local STYLE = {font = "FreeSans Medium 12px", color = {255,255,255,255}}
	local group = Group{}
	local PADDING_X     = 7 -- The focus ring has this much padding around it
    local PADDING_Y     = 7
 	group:clear()
	group.name = item_n
	group.reactive = true

	local text

	local function make_focus_ring(w, h)
		local ring = Canvas{ size = {w, h} }
        ring:begin_painting()
        ring:set_source_color({255,0,0,255})
        ring:round_rectangle( 1/2, 1/2, w - 1 , h - 1 , 0)
		ring:set_source_color( {50,0,0,255})
    	ring:fill(true)
		ring:set_line_width (1)
    	ring:set_source_color({255,0,0,255})
        ring:stroke(true)
        ring:finish_painting()
		if ring.Image then
  	 		ring= ring:Image()
        end
        return ring
    end

    local function make_ring(w, h)
		local ring = Canvas{ size = {w, h} }
        ring:begin_painting()
        ring:set_source_color({255,255,255,255})
        ring:round_rectangle( 1/2, 1/2, w - 1 , h - 1 , 0)
		ring:set_source_color( {0,0,0,255})
    	ring:fill(true)
		ring:set_line_width (1)
    	ring:set_source_color({255,255,255,255})
        ring:stroke(true)
        ring:finish_painting()
		if ring.Image then
  	 		ring= ring:Image()
        end
        return ring
    end

	
	input_box_width = 150
	ring = make_ring(input_box_width, 23) 
	ring.name = "ring"
	if (text) then 
		ring.position = {text.x+text.w+5, 0}
	else 
		ring.position = {0, 0}
  	end

    ring.opacity = 180
	ring.reactive = false
    group:add(ring)

	local file_name = string.sub(item_v,15,-1)

	input_text = Text {name = "file_name", text = item_v, font = "FreeSans Medium 12px", ellipsize="END", w = 140, color = {180,180,180,255}}
    input_text.position  = {ring.x + 5, ring.y + 5}
	group:add(input_text) 
	     
	editor_use = true
	local filechooser = ui_element.button{skin = "inspector", ui_width = 100, ui_height = 23, text_font ="FreeSans Medium 12px" , label = "Browse ...", }
	filechooser.name = "filechooser"
	filechooser.position = {ring.x + ring.w + 6, ring.y + 2 }
	editor_use = false

	local inspector_deactivate = function ()
		local rect = Rectangle {name = "deactivate_rect", color = {10,10,10,100}, size = {300,400}, position = {0,0}, reactive = true}
		inspector:add(rect)
	end 

	local inspector_activate = function ()
		inspector:remove(inspector:find_child("deactivate_rect"))
	end 

	if v.type == "Video" then 
		filechooser.pressed = function() editor.video(inspector) inspector_deactivate() end 
	else 
		filechooser.pressed = function() 
				local msgw_img = editor.image(nil,inspector) 
				inspector_deactivate() 
				if msgw_img:find_child("h_rect1") then 
					msgw_img:find_child("h_rect1"):grab_key_focus()
				end 
		end
	end
	--filechooser.released = function() inspector_activate() end 

	group:add(filechooser)
	return group
end 

function factory.make_itemslist(assets, inspector, v, item_n, item_v, item_s, save_items)
	local STYLE = {font = "FreeSans Medium 12px", color = {255,255,255,255}}
	local group = Group{}
	local PADDING_X     = 7 -- The focus ring has this much padding around it
    local PADDING_Y     = 7
	local plus, item_plus, label_plus, separator_plus, rows, org_items 

	if item_n == "tab_labels" then 
		rows = table.getn(v.tab_labels)
	else 
		rows = table.getn(v.items)
	end 

	if save_items == true then 
		if item_n == "tab_labels" then 
			org_items = util.table_copy(v.tab_labels)
		else 
			org_items = util.table_copy(v.items)
		end 
	end 

	group:clear()
	group.name = "itemsList"
	group.reactive = true

	local function text_reactive()
	for i, c in pairs(g.children) do
	     if(c.type == "Text") then 
	          c.reactive = true
	     end 
        end
    end 

	if v.extra.type == "ButtonPicker" or v.extra.type == "CheckBoxGroup" or v.extra.type == "RadioButtonGroup" then 
		local text = Text {name = "attr", text = item_s}:set(STYLE)
        --text.position  = {PADDING_X, 5}
        text.position  = {0,0}
    	group:add(text)

		plus = Image{src="lib/assets/li-btn-dim-plus.png"}
		plus.position = {text.x + text.w + PADDING_X, 0}
		plus.reactive = true
		group:add(plus)
		function plus:on_button_down(x,y)
			plus.src="lib/assets/li-btn-red-plus.png"
		end 
		function plus:on_button_up(x,y)
			table.insert(v.items, "item"..tostring(table.getn(v.items)+1)) 
			inspector_apply (v, inspector)
			local siy = inspector:find_child("si_items").content.y
			local ix = inspector.x
			local iy = inspector.y
			screen:remove(inspector)
			input_mode = hdr.S_SELECT
			current_inspector = nil
            screen:grab_key_focus(screen) 
			text_reactive()
			editor.n_selected(v, true)
			inspector:clear()
			editor.inspector(v, ix, iy, siy) --scroll position !!
			if v.extra.last then 
				v.extra.last = nil
			end 
			return true
		end 
	elseif v.extra.type =="TabBar" then 
		local text = Text {name = "attr", text = item_s}:set(STYLE)
        --text.position  = {PADDING_X, 5}
        text.position  = {0,0}
    	group:add(text)

		plus = Image{src="lib/assets/li-btn-dim-plus.png"}
		plus.position = {text.x + text.w + PADDING_X, 0}
		plus.reactive = true
		group:add(plus)
		function plus:on_button_down(x,y)
			plus.src="lib/assets/li-btn-red-plus.png"
		end 
		function plus:on_button_up(x,y)
			v:insert_tab(#v.tab_labels + 1)
			inspector_apply (v, inspector)
			local siy = inspector:find_child("si_items").content.y
			local ix = inspector.x
			local iy = inspector.y
			screen:remove(inspector)
			input_mode = hdr.S_SELECT
			current_inspector = nil
            screen:grab_key_focus(screen) 
			text_reactive()
			editor.n_selected(v, true)
			inspector:clear()
			editor.inspector(v, ix, iy, siy) --scroll position !!
			if v.extra.last then 
				v.extra.last = nil
			end 
			return true
		end 

	elseif v.extra.type =="MenuButton" then 
		editor_use = true 
		item_plus = ui_element.button{text_font ="FreeSans Medium 12px", label="Item +", ui_width=80, ui_height=23, skin="inspector", text_has_shadow = true, reactive = true }
		item_plus.name = "item_plus"
		item_plus.position = {0,0,0}
		item_plus.extra.reactive = true 

		label_plus = ui_element.button{text_font ="FreeSans Medium 12px", label="Label +", ui_width=80, ui_height=23, skin="inspector", text_has_shadow = true, reactove = true}
		label_plus.name = "label_plus"
		label_plus.position = {item_plus.w + 7,0,0}
		label_plus.extra.reactive = true

		separator_plus = ui_element.button{text_font ="FreeSans Medium 12px", label="Separator +", ui_width=80, ui_height=23, skin="inspector", text_has_shadow = true, reactive = true}
		separator_plus.name = "separator_plus"
		separator_plus.position = {label_plus.x + label_plus.w + 7,0,0}
		editor_use = false 

		group:add(item_plus, label_plus, separator_plus) 

		function separator_plus:on_button_down(x,y)
			separator_plus.on_focus_in()
			return true 

		end 
		function item_plus:on_button_down(x,y)
			item_plus.on_focus_in()
			return true 
		end 
		function label_plus:on_button_down(x,y)
			label_plus.on_focus_in()
			return true 
		end 
	    function separator_plus:on_button_up(x,y)
			table.insert(v.items, {type="separator"})
			inspector_apply (v, inspector)
			local siy = inspector:find_child("si_items").content.y
			local ix = inspector.x
			local iy = inspector.y
			screen:remove(inspector)
			input_mode = hdr.S_SELECT
			current_inspector = nil
            screen:grab_key_focus(screen) 
			text_reactive()
			editor.n_selected(v, true)
			inspector:clear()
			editor.inspector(v, ix, iy, siy) --scroll position !!
			if v.extra.last then 
				v.extra.last = nil
			end 
			return true 
	    end 

	    function item_plus:on_button_up(x,y)
			table.insert(v.items, {type="item", string="Item ...", f=nil})
			inspector_apply (v, inspector)
			local siy = inspector:find_child("si_items").content.y
			local ix = inspector.x
			local iy = inspector.y
			screen:remove(inspector)
			input_mode = hdr.S_SELECT
			current_inspector = nil
            screen:grab_key_focus(screen) 
			text_reactive()
			editor.n_selected(v, true)
			inspector:clear()
			editor.inspector(v, ix, iy, siy) --scroll position !!
			if v.extra.last then 
				v.extra.last = nil
			end 
			return true 
		end 

	    function label_plus:on_button_up(x,y)
			table.insert(v.items, {type="label", string="Label ..."})
			inspector_apply (v, inspector)
			local siy = inspector:find_child("si_items").content.y
			local ix = inspector.x
			local iy = inspector.y
			screen:remove(inspector)
			inspector:clear()
			input_mode = hdr.S_SELECT
			current_inspector = nil
            screen:grab_key_focus(screen) 
			text_reactive()
			editor.n_selected(v, true)
			inspector:clear()
			editor.inspector(v, ix, iy, siy) --scroll position !!
			if v.extra.last then 
				v.extra.last = nil
			end 
			return true 
		end 
	end 

	
	local list_focus = Rectangle{ name="Focus", size={ 355, 45}, color={0,255,0,0}, anchor_point = { 355/2, 45/2}, border_width=5, border_color={255,25,25,255}, }
	local items_list = ui_element.layoutManager{rows = rows, columns = 4, cell_w = 100, cell_h = 40, cell_spacing_w=5, cell_spacing_h=5, cell_size="variable", cells_focusable=false}
	if text then 
    	--items_list.position = {PADDING_X , text.y + text.h + PADDING_Y}
    	items_list.position = {0, text.y + text.h + 7}
	else 
        --items_list.position = {PADDING_X , plus.y + plus.h + PADDING_Y/2}
        items_list.position = {0 ,plus.y + plus.h + 7}
	end 
    items_list.name = "items_list"

	local itemsList 
	if v.tab_labels then 
		itemsList = v.tab_labels
	else 
		itemsList = v.items
	end 

	local input_txt, item_type 
	for i,j in pairs(itemsList) do 
	    if v.extra.type =="MenuButton" then 
			if j["type"] == "label" then 
		    	input_txt = j["string"] 
		     	item_type = "label"
		  	elseif j["type"] == "item" then 
		     	input_txt = "   "..j["string"] 
		     	item_type = "item"
		  	elseif j["type"] == "separator" then 
		     	input_txt = "--------------"
		     	item_type = "separator"
		  	end 
	    else 
		 	input_txt = j 
	    end  

        local item = ui_element.textInput{ui_width = 175, ui_height = 24, text = input_txt, text_font = "FreeSans Medium 12px", border_width = 1, border_corner_radius = 0, focus_color = {255,0,0,255}, focus_fill_color = {50,0,0,255}, fill_color = {0,0,0,255}} 
	    item.name = "item_text"..tostring(i)

		if item_type then 
        	--item:find_child("textInput").item_type = item_type
        	item.item_type = item_type
	    end 
	    --local minus = factory.draw_minus_item()
		local minus = Image{src="lib/assets/li-btn-dim-minus.png"}
	    minus.name = "item_minus"..tostring(i)
		minus.reactive = true
	    --local up = factory.draw_up()
		local up = Image{src="lib/assets/li-btn-dim-up.png"}
	    up.name = "item_up"..tostring(i)
		up.reactive = true
	    --local down = factory.draw_down()
		local down = Image{src="lib/assets/li-btn-dim-down.png"}
	    down.name = "item_down"..tostring(i)
		down.reactive = true

		function minus:on_button_down(x,y)
			if v.extra.type == "RadioButtonGroup" or v.extra.type == "ButtonPicker" then 
				if #v.items > 2 then 
					minus.src="lib/assets/li-btn-red-minus.png"
				else 
					v.extra.last = true
					editor.error_message("010","two",nil,nil,inspector)
				end 
			elseif v.extra.type == "TabBar" then 
				if #v.tab_labels > 2 then 
					minus.src="lib/assets/li-btn-red-minus.png"
				else 
					v.extra.last = true
					editor.error_message("010","two",nil,nil,inspector)
				end 
			else
				if #v.items > 1 then 
					minus.src="lib/assets/li-btn-red-minus.png"
				else 
					v.extra.last = true
					editor.error_message("010","one",nil,nil,inspector)
				end 
		    end 
		end 
	    function minus:on_button_up(x,y)
			if v.extra.last then 
				return 
			end 

			if v.tab_labels then 
				v:remove_tab(tonumber(string.sub(minus.name, 11,-1)))
			else 
				v.items = util.table_removekey(v.items, tonumber(string.sub(minus.name, 11,-1)))
			end 

			local siy = inspector:find_child("si_items").content.y
			local ix = inspector.x
			local iy = inspector.y

		    screen:remove(inspector)
		    input_mode = hdr.S_SELECT
		    current_inspector = nil
            screen:grab_key_focus(screen) 
		    text_reactive()
		    editor.n_selected(v, true)

			inspector:clear()
		    editor.inspector(v, ix, iy, siy)
		    return true 
	    end 

		function up:on_button_down(x,y)
			if v.extra.type == "TabBar" then 
				if #v.tab_labels > 1 then 
					up.src="lib/assets/li-btn-red-up.png"
				end 
			else 
				if #v.items > 1 then 
					up.src="lib/assets/li-btn-red-up.png"
				end
			end 
		end 

	    function up:on_button_up(x,y)
			if v.extra.type == "TabBar" then 
				if #v.tab_labels == 1 then 
					return 
				end 
			else 
				if  #v.items == 1  then 
					return 
				end 
			end

			if v.extra.type == "TabBar" then 
				if tonumber(string.sub(up.name, 8,-1))-1 >= 1 then 
					v:move_tab_down(tonumber(string.sub(up.name, 8,-1))-1)
				end 
			elseif v.extra.type == "ButtonPicker" or v.extra.type == "RadioButtonGroup" or v.extra.type == "CheckBoxGroup" then 
		    	for i, j in pairs (v.items) do
					v.items[i] = items_list:find_child("item_text"..tostring(i)):find_child("textInput").text
		     	end 
		   		util.table_move_up(v.items, tonumber(string.sub(up.name, 8,-1)))
		    else
		    	for i, j in pairs (v.items) do
					if j["type"] == "label" then 
		    			j["string"] = items_list:find_child("item_text"..tostring(i)):find_child("textInput").text
		  			elseif j["type"] == "item" then 
		     			j["string"] = items_list:find_child("item_text"..tostring(i)):find_child("textInput").text
					end
		     	end 
		   		util.table_move_up(v.items, tonumber(string.sub(up.name, 8,-1)))
		   end 

		   local siy = inspector:find_child("si_items").content.y
		   local ix = inspector.x
		   local iy = inspector.y

		   screen:remove(inspector)
		   input_mode = hdr.S_SELECT
		   current_inspector = nil
           screen:grab_key_focus(screen) 
		   text_reactive()
		   editor.n_selected(v, true)

		   inspector:clear()
		   editor.inspector(v, ix, iy, siy)
		   return true 
	     end 

		 function down:on_button_down(x,y)
		 	if v.extra.type == "TabBar" then 
				if #v.tab_labels > 1 then 
					down.src="lib/assets/li-btn-red-down.png"
				end 
			else
				if #v.items > 1 then 
					down.src="lib/assets/li-btn-red-down.png"
				end 
			end
		 end 
	     function down:on_button_up(x,y)
		    if v.extra.type == "TabBar" then 
				if #v.tab_labels == 1 then 
					return
				end 
			else
		 	 	if #v.items == 1 then 
					return 
			 	end 
			end 

			 if v.extra.type == "TabBar" then 
				 if tonumber(string.sub(up.name, 8,-1))+1 <= #v.tab_labels then 
					v:move_tab_up(tonumber(string.sub(up.name, 8,-1))+1)
				 end 
		     elseif v.extra.type == "ButtonPicker" or v.extra.type == "RadioButtonGroup" or v.extra.type == "CheckBoxGroup" then 
		          for i, j in pairs (v.items) do
						v.items[i] = items_list:find_child("item_text"..tostring(i)):find_child("textInput").text
		     	  end 
		     	util.table_move_down(v.items, tonumber(string.sub(down.name, 10,-1)))
		     else
		          for i, j in pairs (v.items) do
				      if j["type"] == "label" then 
		    		     j["string"] = items_list:find_child("item_text"..tostring(i)):find_child("textInput").text
		  			  elseif j["type"] == "item" then 
		     		     j["string"] = items_list:find_child("item_text"..tostring(i)):find_child("textInput").text
					  end
		     	  end 
		     	util.table_move_down(v.items, tonumber(string.sub(down.name, 10,-1)))
		     end

			 local siy = inspector:find_child("si_items").content.y
 			 local ix = inspector.x
			 local iy = inspector.y

		     screen:remove(inspector)
		     input_mode = hdr.S_SELECT
		     current_inspector = nil
             screen:grab_key_focus(screen) 
		     text_reactive()
		     editor.n_selected(v, true)

			 inspector:clear()
		     editor.inspector(v, ix, iy, siy)
		     return true 
	      end 

	      function item:on_button_down()
		 	 if current_focus then 
   			 	current_focus.extra.on_focus_out()
			 else
			 end 
	         current_focus = group
		     item.on_focus_in()
			 if item_type then 
                   item:find_child("textInput").extra.item_type = item_type
	         end 
			 return true
	      end 

	      function item:on_key_down(key)
			local item_group, si, item_group_name, si_name  
			if inspector:find_child("tabs").current_tab == 1 then 
				item_group_name = "item_group_info"
				si_name = "si_info"
				attr_t_idx = info_attr_t_idx
			else 
				item_group_name = "item_group_list"
				si_name = "si_items"
				attr_t_idx = more_attr_t_idx
			end
			item_group = inspector:find_child(item_group_name)
			si = inspector:find_child(si_name)

	       	if (key == keys.Tab and shift == false) then
		  	     item.on_focus_out()
		  		 local next_i = tonumber(string.sub(item.name, 10, -1)) + 1
		  		 if (item_group:find_child("item_text"..tostring(next_i))) then
					 item_group:find_child("item_text"..tostring(next_i)).extra.on_focus_in()
		  			 si.seek_to_middle(0,item_group:find_child("itemsList").y) 
		  		 else 	
		     		 for i, v in pairs(attr_t_idx) do
 		        		   if("itemsList" == v) then 
			  				   local function there()
		          			    while(item_group:find_child(attr_t_idx[i+1]) == nil) do 
		               			  i = i + 1
			       				  if(attr_t_idx[i+1] == nil) then return true end  
		          			    end 
		          			    if(item_group:find_child(attr_t_idx[i+1])) then
		               			  local n_item = attr_t_idx[i+1]
			       				  if item_group:find_child(n_item).extra.on_focus_in then 
			           				item_group:find_child(n_item).extra.on_focus_in()	
	       							current_focus = item_group:find_child(n_item)
		  			        		si.seek_to_middle(0,item_group:find_child("itemsList").y) 
			       				  else
				   					there()
			       				  end 
		          			    end
			  				    end 
			  			        there()
		        		    end 
    		     	  end
		  		 end
	       	elseif (key == keys.Tab and shift == true )then 
		     	item.on_focus_out()
		     	local prev_i = tonumber(string.sub(item.name, 10, -1)) - 1
		     	if (item_group:find_child("item_text"..tostring(prev_i))) then
					item_group:find_child("item_text"..tostring(prev_i)).extra.on_focus_in()
		  			si.seek_to_middle(0,item_group:find_child("itemsList").y) 
		     	else 	
		      		for i, v in pairs(attr_t_idx) do
						if("itemsList" == v) then 
			     			if(attr_t_idx[i-1] == nil) then return true end 
			     				while(item_group:find_child(attr_t_idx[i-1]) == nil) do 
				 					i = i - 1
			     				end 
			     				if(item_group:find_child(attr_t_idx[i-1])) then
			     					local p_item = attr_t_idx[i-1]
									item_group:find_child(p_item).extra.on_focus_in()	
	       							current_focus = item_group:find_child(p_item)
		  			        		si.seek_to_middle(0,item_group:find_child("itemsList").y) 
									break
			     				end
							end 
    		    		end
		    	end 
	       	elseif (key == keys.Up )then 
				item:find_child("textInput").cursor_position = 0 -- first charactor position 
				item:find_child("textInput").selection_end = 0 -- first charactor position 
	       	elseif (key == keys.Down )then 
				item:find_child("textInput").cursor_position = -1 -- first charactor position 
				item:find_child("textInput").selection_end = -1 -- first charactor position 
	       	end 
	    	end 
			items_list:replace(i,1,item)
	    	items_list:replace(i,2,minus)
	    	items_list:replace(i,3,up)
	    	items_list:replace(i,4,down)
	end
	function group.extra.on_focus_in()
		current_focus = group --0701 
		a = items_list.tiles[1][1]
		a.on_focus_in()
		a:grab_key_focus()
    end

    function group.extra.on_focus_out()
		for i,j in pairs(items_list.children) do 
			if j.on_focus_out then 
				j.on_focus_out()
		    end 
		end 
		return true
    end 
	group.reactive = true
	group:add(items_list) 

	return group
end 

function factory.make_buttonpicker(assets, inspector, v, item_n, item_v, item_s, save_items)

		local STYLE = {font = "FreeSans Medium 12px", color = {255,255,255,255}}
		local group = Group{}
		group:clear()
		group.name = item_n
		group.reactive = true

	
	 	if item_v == "NONE" or item_v == "CHAR" or item_v == "WORD" or item_v =="WORD_CHAR" or 
	 	item_v == "LEFT" or item_v == "CENTER" or item_v =="RIGHT" then item_v = string.lower(item_v) end 

		text = Text {name = "attr", text = item_s}:set(STYLE)
        text.position  = {0, 3}
    	group:add(text)
	
		local selected = 1
  		local itemLists
	
		if item_n == "skin" then 
			itemLists = hdr.inspector_skins -- skins 
		elseif item_n == "wrap_mode" then 
			itemLists = {"none", "char", "word", "word_char"} 
			if v.wrap == false then 
				item_v = "none" 	
			end  
		elseif item_n == "expansion_location" then 
			itemLists = {"above", "below"} 
		elseif item_n == "cell_size" then 
			itemLists = {"fixed", "variable"} 
		elseif item_n == "style" then 
			itemLists = {"orbitting", "spinning"} 
		elseif item_n == "direction" then 
			itemLists = {"vertical", "horizontal"} 
		elseif item_n == "tab_position" then 
			itemLists = {"top", "right"} 
		elseif item_n == "alignment" then 
			itemLists = {"left", "center", "right"} 
		end

		for i,j in pairs(itemLists) do 
	    	if(item_v == j)then 
			selected = i 
	    	end
		end

		editor_use = true
        local item_picker = ui_element.buttonPicker{skin = "inspector", items = itemLists, text_font = "FreeSans Medium 12px", selected_item = selected, inspector  = 5}
		item_picker.ui_height = 45
		if item_n == "expansion_location" or "cell_size" then 
			item_picker.ui_width = 110
		else 
			item_picker.ui_width = 150
		end
		--item_picker.text_font = "FreeSans Medium 12px"
		if item_n == "style" then 
        	item_picker.position = {text.x + text.w + 17 , -5}
		else 
        	item_picker.position = {text.x + text.w + 20 , -5}
		end
		item_picker.name = "item_picker"
		editor_use = false

		unfocus = item_picker:find_child("unfocus")
		function unfocus:on_button_down (x,y,b,n)
			if current_focus then 
   				current_focus.extra.on_focus_out()
			end 
	        current_focus = group
			item_picker.on_focus_in()
	        item_picker:grab_key_focus()
			return true
		end 

        left_arrow = item_picker:find_child("left_un")
		left_arrow.reactive = true 
		function left_arrow:on_button_down(x, y, b, n)
			if current_focus then 
				current_focus.extra.on_focus_out()
			end 
	        current_focus = group
			item_picker.on_focus_in()
	        item_picker:grab_key_focus()
			item_picker.press_left()
			return true 
		end 

		right_arrow = item_picker:find_child("right_un")
		right_arrow.reactive = true 
		function right_arrow:on_button_down(x, y, b, n)
			if current_focus then 
				current_focus.extra.on_focus_out()
			end 
	        current_focus = group
			item_picker.on_focus_in()
	        item_picker:grab_key_focus()
			item_picker.press_right()
			return true 
		end 

		function item_picker:on_key_down(key)
			local item_group, si, item_group_name, si_name  
			if inspector:find_child("tabs").current_tab == 1 then 
				item_group_name = "item_group_info"
				si_name = "si_info"
				attr_t_idx = info_attr_t_idx
			else 
				item_group_name = "item_group_more"
				si_name = "si_more"
				attr_t_idx = more_attr_t_idx
			end
			item_group = inspector:find_child(item_group_name)
			si = inspector:find_child(si_name)

	       	if key == keys.Left then 
		     	item_picker.press_left()
	       	elseif key == keys.Right then  
		     	item_picker.press_right()
	       	elseif (key == keys.Tab and shift == false) then
		     	item_picker.on_focus_out()
		     	for i, v in pairs(attr_t_idx) do
		     		if(item_n == v or item_v == v) then 
		          		while(item_group:find_child(attr_t_idx[i+1]) == nil) do 
		               		i = i + 1
			       			if(attr_t_idx[i+1] == nil) then return true end  
		          		end 
		          		if(item_group:find_child(attr_t_idx[i+1])) then
		               		local n_item = attr_t_idx[i+1]
							if item_group:find_child(n_item).extra.on_focus_in then 
			       				item_group:find_child(n_item).extra.on_focus_in()	
	       						current_focus = item_group:find_child(n_item)
			       				si.seek_to_middle(0, item_group:find_child(n_item).y)
							end 
			        		break
		          		end
		     		end 
    		     end
	       elseif (key == keys.Tab and shift == true )then 
		     item_picker.on_focus_out()
		      for i, v in pairs(attr_t_idx) do
			if(item_n == v or item_v == v) then 
			     if(attr_t_idx[i-1] == nil) then return true end 
			     while(item_group:find_child(attr_t_idx[i-1]) == nil) do 
				 i = i - 1
			     end 
			     if(item_group:find_child(attr_t_idx[i-1])) then
			     	local p_item = attr_t_idx[i-1]
				item_group:find_child(p_item).extra.on_focus_in()	
	       		current_focus = item_group:find_child(p_item)
				si.seek_to_middle(0, item_group:find_child(p_item).y)
				break
			     end
			end 
    		    end
	       end 
		end 

        function group.extra.on_focus_in()
		 group:find_child("item_picker").extra.on_focus_in()
	         group:find_child("item_picker"):grab_key_focus()
        end

        function group.extra.on_focus_out()
		 group:find_child("item_picker").extra.on_focus_out()
        end 
		group:add(item_picker)
		group.h = 23
        return group
end 

function factory.make_onecheckbox(assets, inspector, v, item_n, item_v, item_s, save_items)
	local STYLE = {font = "FreeSans Medium 12px", color = {255,255,255,255}}
	local group = Group{}
	local reactive_checkbox
	group:clear()
	group.name = item_n
	group.reactive = true

	text = Text {name = "attr", text = item_s}:set(STYLE)
    text.position  = {0, 0}
    group:add(text)
	
	editor_use = true
	if item_v == "true" then 
	     --reactive_checkbox = ui_element.checkBoxGroup {skin = "inspector", ui_width = 21, ui_height = 22, items = {""}, selected_items = {1}}
	     reactive_checkbox = editor_ui.checkBoxGroup {skin = "inspector", ui_width = 21, ui_height = 22, items = {""}, selected_items = {1}}
	else 
	     --reactive_checkbox = ui_element.checkBoxGroup {skin = "inspector", ui_width = 21, ui_height = 22, items = {""}, selected_items = {}}
	     reactive_checkbox = editor_ui.checkBoxGroup {skin = "inspector", ui_width = 21, ui_height = 22, items = {""}, selected_items = {}}
	end 
	editor_use = false

	reactive_checkbox.position = {text.x + text.w + 5, 0}
	reactive_checkbox.name = "bool_check"..item_n
	group:add(reactive_checkbox)
	if item_n ~= "vert_bar_visible" and item_n ~= "horz_bar_visible" then 
		group.size = {255,18}
	else 
		group.size = {110,18}
	end

	return group
end 

function factory.make_anchorpoint(assets, inspector, v, item_n, item_v, item_s, save_items)

	local STYLE = {font = "FreeSans Medium 12px", color = {255,255,255,255}}

	local text = Text {name = "attr", text = item_s}:set(STYLE)
    local group = Group {}
	group.name = "anchor_point"
    group:clear()

    text.position  = {0, 0}
    group:add(text)
	local anchor_pnt = factory.draw_anchor_point(v)
	anchor_pnt.position = {text.x + text.w + 5, 0}
	group:add(anchor_pnt)
	group.w = 255

    return group
end

function factory.make_focuschanger(assets, inspector, v, item_n, item_v, item_s, save_items)
-- item group  
    local PADDING_X     = 0
    local WIDTH         = 260

    local group = Group {}
    group:clear()
    	
    -- item group's children 
    local text, input_text, ring, focus, line, button	--, checkbox, radio_button, button_picker
	
	if(item_n == "focus") then  
		group:clear()
		group.name = "focusChanger"
		group.reactive = true
		local focus_changer = factory.draw_focus_changer(v)

		local focus_map = {[keys.Up] = "U",  [keys.Down] = "D", [keys.Return] = "E", [keys.Left] = "L", [keys.Right] = "R", 
	                   [keys.RED] = "Red", [keys.GREEN] = "G", [keys.YELLOW] = "Y", [keys.BLUE] = "B"}

	
		local function deactive_tab(tab_type) 
			focus_changer:find_child("text"..tab_type).text = v.name 
			focus_changer:find_child("text"..tab_type).color = {255,255,255,100}
			focus_changer:find_child("focuschanger_bg"..tab_type).opacity = 100 
			focus_changer:find_child("g"..tab_type).reactive = false 
		end 

		local function active_tab(tab_type, txt) 
			if txt then 
				focus_changer:find_child("text"..tab_type).text = txt
		    end 
			focus_changer:find_child("text"..tab_type).color = {255,255,255,255}
			focus_changer:find_child("focuschanger_bg"..tab_type).opacity = 255 
			focus_changer:find_child("g"..tab_type).reactive = true 
		end 

		if v.extra.type == "Button" or v.extra.type == "MenuButton" then
			deactive_tab("E") 
		elseif v.extra.type == "TextInput" then 
			deactive_tab("E") 
			deactive_tab("L") 
			deactive_tab("R") 
		elseif v.extra.type == "ButtonPicker" then 
			if v.direction == "vertical" then 
				--들어 있으나 아래코드서 덮어 써짐 
				active_tab("L","") 
				active_tab("R","") 
				--여기 까지 

				deactive_tab("E") 
				deactive_tab("U") 
				deactive_tab("D") 
			else 

				deactive_tab("E") 
				deactive_tab("L") 
				deactive_tab("R") 

					--들어 있으나 아래코드서 덮어 써짐 
				active_tab("U","") 
				active_tab("D","") 
					--여기 까지 
			end 

		elseif v.extra.type == "TabBar" then 
			if v.tab_position == "top" then 
				focus_changer.extra.tabs = {}
				for q=1,#v.tab_labels,1 do
					focus_changer.extra.tabs[q] = {}
					focus_changer.extra.tabs[q].up_focus = v.tabs[q].extra.up_focus 
					focus_changer.extra.tabs[q].down_focus = v.tabs[q].extra.down_focus 
				end 

				if v.tabs[1].extra.up_focus then
					focus_changer:find_child("textU").text = v.tabs[1].extra.up_focus 
				else 
					focus_changer:find_child("textU").text = ""
				end 
				if v.tabs[1].extra.down_focus then 
					focus_changer:find_child("textD").text = v.tabs[1].extra.down_focus 
				else 
					focus_changer:find_child("textD").text = ""
				end 

				if v.extra.focus then 
					if v.extra.focus[keys.Left] ~= nil then 
						focus_changer:find_child("textL").text = v.extra.focus[keys.Left] 
						focus_changer.extra.tabs[1].left_focus = v.extra.focus[keys.Left] 
					end 

					if v.extra.focus[keys.Right] ~= nil then 
						focus_changer.extra.tabs[#v.tab_labels].right_focus = v.extra.focus[keys.Right] 
					end 
				end 

				deactive_tab("E") 
				deactive_tab("R") 
			else
				focus_changer.extra.tabs = {}
				for q=1,#v.tab_labels,1 do
					focus_changer.extra.tabs[q] = {}
					focus_changer.extra.tabs[q].up_focus = v.tabs[q].extra.up_focus 
					focus_changer.extra.tabs[q].down_focus = v.tabs[q].extra.down_focus 
				end 

				if v.tabs[1].extra.left_focus then
					focus_changer:find_child("textL").text = v.tabs[1].extra.left_focus 
				else 
					focus_changer:find_child("textL").text = ""
				end 
				if v.tabs[1].extra.right_focus then 
					focus_changer:find_child("textR").text = v.tabs[1].extra.right_focus 
				else 
					focus_changer:find_child("textR").text = ""
				end 

				if v.extra.focus then 
					if v.extra.focus[keys.Up] ~= nil then 
						focus_changer:find_child("textU").text = v.extra.focus[keys.Up] 
						focus_changer.extra.tabs[1].up_focus = v.extra.focus[keys.Up] 
					end 

					if v.extra.focus[keys.Down] ~= nil then 
						focus_changer.extra.tabs[#v.tab_labels].down_focus = v.extra.focus[keys.Down] 
					end 
				end 

				deactive_tab("E") 
				deactive_tab("D") 
			end
		end 	

		--ER_1 : 버튼 피커 일경우나.. 여기를 덮어 써버리는 구먼 H방향 에서 V방향으로 바뀔때 이거 생각해 보고 고치기 나중에.. 

		if v.extra.focus and v.extra.type ~= "TabBar" then 
			for m, n in pairs (v.extra.focus) do
		     	if type(n) ~= "function" then 
		          	focus_changer:find_child("text"..focus_map[m]).text = n
		     	else 
		          	focus_changer:find_child("text"..focus_map[m]).text = v.name
		          	focus_changer:find_child("text"..focus_map[m]).color = {150,150,150,150}
		          	focus_changer:find_child("text"..focus_map[m]).reactive = false
		     	end 
			end 	
		end

		if focus_changer then 
    		focus_changer.position  = {0 , 5}
	    	return focus_changer
		end 

end 
end 

function factory.make_text_input_item(assets, inspector, v, item_n, item_v, item_s, save_items, old_inspector) 
    local STYLE = {font = "FreeSans Medium 12px", color = {255,255,255,255}}
    local TEXT_SIZE     = 12
    local PADDING_X     = 0
    local PADDING_Y     = 3   
    local PADDING_B     = 13 
    local WIDTH         = 255
    local HEIGHT        = TEXT_SIZE  + ( PADDING_Y * 2 )
    local BORDER_WIDTH  = 1
    local BORDER_COLOR  = {255,255,255,255}
    local FOCUS_COLOR  = {0,255,0,255}
    local LINE_COLOR    = {255,255,255,255}  --"FFFFFF"
    local BORDER_RADIUS = 0
    local LINE_WIDTH    = 1
    local input_box_width     
    local item_group 

	local non_textInput_items = {"title", "line", "button", "focus", "tab_labels", "items", "skin", "wrap_mode", 
		"expansion_location", "cell_size", "style", "direction", "reactive", "loop", "vert_bar_visible", "horz_bar_visible", 
		"cells_focusable", "lock", "icon", "source", "src", "anchor_point", }

	if old_inspector ~= nil then 
		for i, j  in pairs (non_textInput_items) do 
			if j == item_n then 
				return 
			end 
		end 
	end 	

    local function text_reactive()
	for i, c in pairs(g.children) do
	     if(c.type == "Text") then 
	          c.reactive = true
	     end 
        end
    end 

    local function make_focus_ring(w, h)
		local ring = Canvas{ size = {w, h} }
        ring:begin_painting()
        ring:set_source_color({255,0,0,255})
        ring:round_rectangle( 1/2, 1/2, w - 1 , h - 1 , 0)
		ring:set_source_color( {50,0,0,255})
    	ring:fill(true)
		ring:set_line_width (1)
    	ring:set_source_color({255,0,0,255})
        ring:stroke(true)
        ring:finish_painting()
		if ring.Image then
  	 		ring= ring:Image()
        end
        return ring

    end

    local function make_ring(w, h)
		local ring = Canvas{ size = {w, h} }
        ring:begin_painting()
        ring:set_source_color({255,255,255,255})
        ring:round_rectangle( 1/2, 1/2, w - 1 , h - 1 , 0)
		ring:set_source_color( {0,0,0,255})
    	ring:fill(true)
		ring:set_line_width (1)
    	ring:set_source_color({255,255,255,255})
        ring:stroke(true)
        ring:finish_painting()
		if ring.Image then
  	 		ring= ring:Image()
        end
        return ring
    end

    -- item group 
    local group = Group {}
    group:clear()
    	
    -- item group's children 
    local text, input_text, ring, focus, line, button --, checkbox, radio_button, button_picker

    if(item_n == "caption") then
    	text = Text {text = item_v}:set(STYLE)
		text.position = {0, 0} -- 0,0 
    	group:add(text)
		if item_v ~= "Visible" or item_v ~= "Virtual" then 
        	group.w = 255
		end 
        group.h = 12
		return group
    else 	---- Attributes with focusable ring 

		group.name = item_n
		group.reactive = true

		local text

	    if item_n == "name" or item_n == "text" or item_n == "message" or item_n == "label" then 
			-- no property name text, long textInput Box
	     	input_box_width = WIDTH + 5
        else  
			-- properties' name 
    	    text = Text {name = "attr", text = item_s}:set(STYLE)
            text.position  = {0, 4.5}
    	    group:add(text)

	     	input_box_width = 39 
            if item_n:find("font") then 
	          input_box_width = WIDTH + 5
			  group:remove(text)
			  text = nil
            elseif string.find(item_n,"duration") or string.find(item_n,"time") then 
	          input_box_width = 49 
	     	end
        end 


        ring = make_ring(input_box_width, HEIGHT + 5 ) 
		ring.name = "ring"
		if text then 
			if item_n == "menu_width" then 
	     		ring.position = {text.x+text.w+9, 0}
			else 
	     		ring.position = {text.x+text.w+5, 0}
			end 
		else 
	     	ring.position = {0, 0}
		end
        ring.opacity = 255
        group:add(ring)

        focus = make_focus_ring(input_box_width, HEIGHT + 5)
        focus.name = "focus"
		if (text) then 
	     	focus.position = {text.x+text.w+5, 0}
		else 
            focus.position = {0, 0}
		end

        focus.opacity = 0
		group:add(focus)



    	input_text = Text {name = "input_text", text =item_v, editable=true,
        reactive = true, wants_enter = true, cursor_visible = false,single_line = true, width = input_box_width - 10}:set(STYLE)

		if (text) then 
			if item_n == "menu_width" then 
             	input_text.position  = {text.x+text.w+14, 4.5}
			else
             	input_text.position  = {text.x+text.w+10, 4.5}
			end 
		else 
             input_text.position  = {5,4.5}
		end

		function input_text:on_button_down(x,y,button,num_clicks)

		   	if current_focus then 
				if current_focus.extra then 
					if current_focus.extra.type == "Button" then 
						 local pt = current_focus.parent
						 pt = pt.extra.type
						 if pt ~= "TabBar" then 
							current_focus.extra.on_focus_out()
		   				end 
					else 
						current_focus.extra.on_focus_out()
					end
				end
			end 
	       	current_focus = group
	       	group.extra.on_focus_in()
           	return true
        end

		function group:on_button_down(x,y,button,num_clicks)
			if current_focus then 
 	       		current_focus.extra.on_focus_out()
			end 
	        current_focus = group
	        group.extra.on_focus_in()
            return true
        end

  		function input_text:on_key_down(key)
			local item_group, si, item_group_name, si_name  
			if inspector:find_child("tabs").current_tab == 1 then 
				item_group_name = "item_group_info"
				si_name = "si_info"
				attr_t_idx = info_attr_t_idx
			else 
				item_group_name = "item_group_more"
				si_name = "si_more"
				attr_t_idx = more_attr_t_idx
			end
			item_group = inspector:find_child(item_group_name)
			si = inspector:find_child(si_name)

	    	if key == keys.Return or (key == keys.Tab and shift == false)  then
	       		group.extra.on_focus_out()
		 		for i, j in pairs(attr_t_idx) do
		    		if(item_n == j or item_v == j) then 
		          		while(item_group:find_child(attr_t_idx[i+1]) == nil ) do 
		                	i = i + 1
			       			if(attr_t_idx[i+1] == nil) then return true end 
		          		end 
		          		if item_group:find_child("skin") then end 	
		          		if(item_group:find_child(attr_t_idx[i+1])) then
		               		local n_item = attr_t_idx[i+1]
			       			if item_group:find_child(n_item).extra.on_focus_in then 
			       				item_group:find_child(n_item).extra.on_focus_in()	
	       						current_focus = item_group:find_child(n_item)
			       			if (si) then 
				    			si.seek_to_middle(0, item_group:find_child(n_item).y)
			       			end
			       			break
			      			elseif n_item == "src" or n_item == "icon" or n_item == "source" then 
			       			elseif n_item == "items" then 
			       			elseif n_item == "reactive" then 
			       			end --added 
		          		end
		     		end 
    			end
	     elseif (key == keys.Tab and shift == true )then 
		    group.extra.on_focus_out()
 		    for i, v in pairs(attr_t_idx) do
				if(item_n == v or item_v == v) then 
			     	if(attr_t_idx[i-1] == nil) then return true end  
			     		local function here ()
			     			while(item_group:find_child(attr_t_idx[i-1]) == nil) do 
				 				i = i - 1
								if attr_t_idx[i-1] == nil then return end 
			     			end 
			     			if(item_group:find_child(attr_t_idx[i-1])) then
			     				local p_item = attr_t_idx[i-1]
								if item_group:find_child(p_item).extra.on_focus_in then 	
				     				item_group:find_child(p_item).extra.on_focus_in()	
	       							current_focus = item_group:find_child(p_item)
			             			if (si) then 
				          				si.seek_to_middle(0, item_group:find_child(p_item).y)
			             			end
								else 
				     				i = i -1
				     				here()
								end 
			     			end
			     		end 
			     		here()
					end 
    		    end
	     	elseif (key == keys.Up )then 
				group:find_child("input_text").cursor_position = 0 
				group:find_child("input_text").selection_end = 0 
	     	elseif (key == keys.Down )then 
				group:find_child("input_text").cursor_position = -1 
				group:find_child("input_text").selection_end = -1 
        	end
   		end 

    	group:add(input_text)
        function group.extra.on_focus_in()
	         current_focus = group --0701
             ring.opacity = 0
             input_text.cursor_visible = true
             focus.opacity = 255
	         input_text:grab_key_focus(input_text)
        end
        function group.extra.on_focus_out()
             focus.opacity = 0
             input_text.cursor_visible = false
             ring.opacity = 255
        end 
    end

	if item_n == "z" then 
		group.w = group.w + 50
	elseif item_n == "h" or item_n == "virtual_h" then 
		group.w = group.w + 100
	elseif item_n == "cell_timing" then 
		group.w = group.w + 200
	end 

	if item_n == "cell_timing_offset" or item_n == "cell_timing" then -- or item_n == "cell_spacing" then 
        input_text.position = {130, 4.5}
        ring.position = {125, 0}
        focus.position ={125, 0} 
	end 

    return group
end
 
function factory.draw_anchor_point(v, inspector)
    local h_pos = 0
    local v_pos = 0
    local cur_posint = left_top
    local object, center, left_top, left_mid, left_bottom, mid_top, mid_bottom, right_top, right_mid, right_bottom

    local function find_current_anchor (v)
        if(v.anchor_point == nil) then 
	     return h_pos, v_pos
        end 
        if (v.anchor_point[1] < v.w/2) then h_pos = 0
        elseif (v.anchor_point[1] > v.w/2) then h_pos = 2 
        else h_pos = 1
        end 

        if (v.anchor_point[2] < v.h/2) then v_pos = 0 
        elseif (v.anchor_point[2] > v.h/2) then v_pos = 2 
        else v_pos = 1 
        end 
    end 

    local function mark_current_anchor()
	if(h_pos == 0 and v_pos == 0) then 
		left_top.src = "lib/assets/anchor-point-on.png" --color = {200,0,0,200}
		cur_point = left_top
		anchor_pnt.extra.anchor_point = {0, 0}
	elseif(h_pos == 0 and v_pos == 1) then 
		left_mid.src = "lib/assets/anchor-point-on.png"--color = {200,0,0,200} 
		cur_point = left_mid
		anchor_pnt.extra.anchor_point = {0, v.h/2}
	elseif(h_pos == 0 and v_pos == 2) then 
		left_bottom.src = "lib/assets/anchor-point-on.png"--color = {200,0,0,200}
		cur_point = left_bottom
		anchor_pnt.extra.anchor_point = {0, v.h}
	elseif(h_pos == 1 and v_pos == 0) then 
		mid_top.src = "lib/assets/anchor-point-on.png"--color = {200,0,0,200} 
		cur_point = mid_top
		anchor_pnt.extra.anchor_point = {v.w/2, 0}
	elseif(h_pos == 1 and v_pos == 1) then 
		center.src = "lib/assets/anchor-point-on.png"--color = {200,0,0,200} 
		cur_point = center
		anchor_pnt.extra.anchor_point = {v.w/2, v.h/2}
	elseif(h_pos == 1 and v_pos == 2) then 
		mid_bottom.src = "lib/assets/anchor-point-on.png"--color = {200,0,0,200} 
		cur_point = mid_bottom
		anchor_pnt.extra.anchor_point = {v.w/2, v.h}
	elseif(h_pos == 2 and v_pos == 0) then 
		right_top.src = "lib/assets/anchor-point-on.png"--color = {200,0,0,200} 
		cur_point = right_top
		anchor_pnt.extra.anchor_point = {v.w, 0}
	elseif(h_pos == 2 and v_pos == 1) then 
		right_mid.src = "lib/assets/anchor-point-on.png"--color = {200,0,0,200} 
		cur_point = right_mid
		anchor_pnt.extra.anchor_point = {v.w, v.h/2}
	elseif(h_pos == 2 and v_pos == 2) then 
		right_bottom.src = "lib/assets/anchor-point-on.png" -- color = {200,0,0,200} 
		cur_point = right_bottom
		anchor_pnt.extra.anchor_point = {v.w, v.h}
	end 
    end 

    function create_point_on_button_down(point)
		function point:on_button_down(x,y,button,num)
			cur_point.src = "lib/assets/anchor-point-off.png" --color = {25,25,25,250}

			if(point.name == "center") then h_pos = 1 v_pos = 1
			elseif(point.name == "left_top") then h_pos = 0 v_pos = 0
			elseif(point.name == "left_mid") then h_pos = 0 v_pos = 1
			elseif(point.name == "left_bottom") then h_pos = 0 v_pos = 2
			elseif(point.name == "mid_top") then h_pos = 1 v_pos = 0
			elseif(point.name == "mid_bottom") then h_pos = 1 v_pos = 2
			elseif(point.name == "right_top") then h_pos = 2 v_pos = 0
			elseif(point.name == "right_mid") then h_pos = 2 v_pos = 1
			elseif(point.name == "right_bottom") then h_pos = 2 v_pos = 2
			end 

        	mark_current_anchor()
			cur_point = point
		end 
    end

    find_current_anchor (v)

	object = Image{src = "lib/assets/anchor-point-box.png", name = "rect0", position = {0,0}}
	mid_top = Image{src = "lib/assets/anchor-point-off.png", name = "mid_top", position = {15,0}}
	center = Image{src = "lib/assets/anchor-point-off.png", name = "center", position = {15,15}}
	mid_bottom = Image{src = "lib/assets/anchor-point-off.png", name = "mid_bottom", position = {15,30}}
	right_mid = Image{src = "lib/assets/anchor-point-off.png", name = "right_mid", position = {30,15}}
	right_top = Image{src = "lib/assets/anchor-point-off.png", name = "right_top", position = {30,0}}
	right_bottom = Image{src = "lib/assets/anchor-point-off.png", name = "right_bottom", position = {30,30}}
	left_mid = Image{src = "lib/assets/anchor-point-off.png", name = "left_mid", position = {0,15}}
	left_top = Image{src = "lib/assets/anchor-point-off.png", name = "left_top", position = {0,0}}
	left_bottom = Image{src = "lib/assets/anchor-point-off.png", name = "left_bottom", position = {0,30}}

    mid_top.reactive = true
    center.reactive = true
    mid_bottom.reactive = true

    right_mid.reactive = true
    right_top.reactive = true
    right_bottom.reactive = true

    left_top.reactive = true
    left_mid.reactive = true
    left_bottom.reactive = true

    create_point_on_button_down(mid_top)
    create_point_on_button_down(center)
    create_point_on_button_down(mid_bottom)

    create_point_on_button_down(right_top)
    create_point_on_button_down(right_mid)
    create_point_on_button_down(right_bottom)
    
    create_point_on_button_down(left_top)
	create_point_on_button_down(left_mid)
    create_point_on_button_down(left_bottom)

    anchor_pnt = Group
	{
		name="anchor",
		position = {0,0},
		children = {object,center,mid_top,mid_bottom,right_mid,right_top,left_mid,right_bottom,left_bottom,left_top},
		opacity = 255
	}
 
     mark_current_anchor()

    return anchor_pnt
end 

function factory.draw_anchor_pointer() 

sero = Rectangle { name="sero", border_color={255,255,255,192}, border_width=0, color={255,25,25,255}, size = {4,30}, anchor_point = {0,0}, x_rotation={0,0,0}, y_rotation={0,0,0}, z_rotation={0,0,0}, position = {12.5,0}, opacity = 255 }

garo = Rectangle { name="garo", border_color={255,255,255,192}, border_width=0, color={255,25,25,255}, size = {30,4}, anchor_point = {0,0}, x_rotation={0,0,0}, y_rotation={0,0,0}, z_rotation={0,0,0}, position = {0,12}, opacity = 255 }

anchor_point = Group { size={30,30}, position = {0,0}, children = {sero, garo}, scale = {1,1,0,0}, anchor_point = {0,0}, x_rotation={0,0,0}, y_rotation={0,0,0}, z_rotation={0,0,0}, opacity = 255 }

	anchor_point.anchor_point = {anchor_point.w/2, anchor_point.h/2}
	anchor_point.scale = {0.5, 0.5}
	return anchor_point
end 

function factory.draw_mouse_pointer() 

sero = Rectangle { name="sero", border_color={255,255,255,192}, border_width=0, color={255,255,255,255}, size = {5,30}, anchor_point = {0,0}, x_rotation={0,0,0}, y_rotation={0,0,0}, z_rotation={0,0,0}, position = {12.5,0}, opacity = 255 }

garo = Rectangle { name="garo", border_color={255,255,255,192}, border_width=0, color={255,255,255,255}, size = {30,5}, anchor_point = {0,0}, x_rotation={0,0,0}, y_rotation={0,0,0}, z_rotation={0,0,0}, position = {0,12}, opacity = 255 }

mouse_pointer = Group { name="mouse_pointer", size={30,30}, position = {300,300}, children = {sero, garo}, scale = {1,1,0,0}, anchor_point = {0,0}, x_rotation={0,0,0}, y_rotation={0,0,0}, z_rotation={0,0,0}, opacity = 255 }

	mouse_pointer.anchor_point = {mouse_pointer.w/2, mouse_pointer.h/2}
	return mouse_pointer
end 

function factory.draw_minus_item()
local l_col = {150,150,150,200}
local l_wid = 4
local l_scale = 1

rect_minus = Rectangle { color = {255,255,255,0}, border_color = l_col, border_width = l_wid, name = "rect_minus", position = {0,0,0}, size = {30,30}, opacity = 255, }


text_minus = Text { color = l_col, font = "FreeSans bold 30px", text = "-", editable = false, wants_enter = false, wrap = false, wrap_mode = "CHAR", name = "text_minus", cursor_visible = false, position = {10,-5,0}, size = {30,30}, opacity = 255, }


minus = Group { scale = {l_scale,l_scale,0,0}, name = "minus", position = {536,727,0}, size = {30,30}, opacity = 255, children = {rect_minus,text_minus}, reactive = true, }

return minus
end

function factory.draw_up()
local l_col = {150,150,150,200}
local l_wid = 4
local l_scale = 0.8
rect_up = Rectangle { color = {255,255,255,0}, border_color = l_col, border_width = l_wid, name = "rect_up", position = {0,0,0}, size = {30,30}, opacity = 255, }


img_up = Image { src = "/lib/assets/left.png", scale = {l_scale,l_scale,0,0}, z_rotation = {90,0,0}, anchor_point = {0,0}, name = "img_up", position = {30,5,0}, opacity = 255, }


up = Group { name = "up", position = {0,0,0}, size = {30,30}, opacity = 255, children = {rect_up,img_up}, reactive = true, }

return up
end


function factory.draw_down()
local l_col = {150,150,150,200}
local l_wid = 4
local l_scale = 0.8

rect_down = Rectangle { color = {255,255,255,0}, border_color = l_col, border_width = l_wid, name = "rect_down", position = {0,0,0}, size = {30,30}, opacity = 255, }


img_down = Image { src = "lib/assets/left.png", scale = {l_scale,l_scale,0,0}, z_rotation = {270,0,0}, anchor_point = {0,0}, name = "img_down", position = {0,23,0}, opacity = 255, }


down = Group { name = "down", position = {0,0,0}, size = {30,30}, opacity = 255, children = {rect_down,img_down}, reactive = true, }

return down
end


function factory.draw_plus_item()
local l_col = {150,150,150,200}
local l_wid = 4
local l_scale = 1

rect_plus = Rectangle { color = {255,255,255,0}, border_color = l_col, border_width = l_wid, scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "rect_plus", position = {0,0,0}, size = {30,30}, opacity = 255, }


text_plus = Text { color = l_col, font = "FreeSans bold 30px", text = "+", editable = false, wants_enter = false, wrap = false, wrap_mode = "CHAR", scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "text_plus", position = {3,-5,0}, size = {30,30}, opacity = 255, cursor_visible = false, }


plus = Group { scale = {l_scale,l_scale,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "plus", position = {0,0,0}, size = {30,30}, opacity = 255, children = {rect_plus,text_plus}, reactive = true, }

return plus
end

function factory.draw_plus_items()
local l_col = {150,150,150,200}
local l_wid = 4
local l_scale = 1

text_label = Text { color = {255,255,255,255}, font = "FreeSans Medium 12px", text = "Label +", name = "text_label", position = {7,0,0}, opacity = 255, }

rect_label = ui_element.button{font ="FreeSans Medium 12px", label="Label +", ui_width=100, ui_hieght=25, skin="inspector"}
rect_label.name = "rect_label"
rect_label.position = {0,0,0}


label_plus = Group { scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "label_plus", position = {0,0,0}, size = {127,35}, opacity = 255, children = {text_label,rect_label}, reactive = true, }


text_item = Text { color = {255,255,255,255}, font = "FreeSans Medium 26px", text = "Item +", editable = false, wants_enter = true, wrap = false, wrap_mode = "CHAR", scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "text_item", position = {10,0,0}, size = {120,30}, opacity = 255, } 

rect_item = Rectangle { color = {255,255,255,0}, border_color = l_col, border_width = l_wid, scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "rect_item", position = {0,0,0}, size = {110,35}, opacity = 255, }

item_plus = Group { scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "item_plus", position = {129,0,0}, size = {130,35}, opacity = 255, children = {text_item,rect_item}, reactive = true, }


text_separator = Text { color = {255,255,255,255}, font = "FreeSans Medium 26px", text = "Separator +", editable = false, wants_enter = true, wrap = false, wrap_mode = "CHAR", scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "text_separator", position = {7,0,0}, size = {180,30}, opacity = 255, }


rect_separator = Rectangle { color = {255,255,255,0}, border_color = l_col, border_width = l_wid, scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "rect_separator", position = {0,0,0}, size = {180,35}, opacity = 255, }

separator_plus = Group { scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "separator_plus", position = {249,0,0}, size = {187,35}, opacity = 255, children = {text_separator,rect_separator}, reactive = true, }


items_plus = Group { scale = {l_scale,l_scale,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "items_plus", position = {335,534,0}, size = {436,46}, opacity = 255, children = {label_plus,item_plus,separator_plus}, }

return items_plus

end

function factory.draw_plus_minus()

local l_col = {150,150,150,200}
local l_wid = 4
local l_scale = 0.9

rect1 = Rectangle { color = l_col, border_color = {255,255,255,255}, border_width = 0, scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "rect1", position = {13,4,0}, size = {l_wid,25}, opacity = 255, }


rect2 = Rectangle { color = l_col, border_color = {255,255,255,255}, border_width = 0, scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "rect2", position = {2,12,0}, size = {25,l_wid}, opacity = 255, }


rect0 = Rectangle { color = {25,25,25,0}, border_color = l_col, border_width = l_wid, scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "rect0", position = {0,0,0}, size = {29,29}, opacity = 255, }


plus = Group { scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "plus", position = {0,0,0}, size = {29,29}, opacity = 255, children = {rect1,rect2,rect0}, }


rect5 = Rectangle { color = l_col, border_color = {255,255,255,255}, border_width = 0, scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "rect5", position = {2,12,0}, size = {25, l_wid}, opacity = 255, }


rect4 = Rectangle { color = {255,255,255,0}, border_color = l_col, border_width = l_wid, scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "rect4", position = {0,0,0}, size = {29,29}, opacity = 255, }


minus = Group { scale = {1,1,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "minus", position = {36,0,0}, size = {29,29}, opacity = 255, children = {rect5,rect4}, }


	plus_minus = Group { scale = {l_scale,l_scale,0,0}, x_rotation = {0,0,0}, y_rotation = {0,0,0}, z_rotation = {0,0,0}, anchor_point = {0,0}, name = "plus_minus", position = {0,0,0}, size = {65,29}, opacity = 255, children = {plus, minus},
	}

	return plus_minus
end 

function factory.draw_focus_changer(v)

	local focus = Group
	{
		name = "focusChanger",
		position = {0,0,0},
		reactive = true,
	}

	focus_changer_bgU = Image{src = "lib/assets/assign-focus-up.png", name = "focuschanger_bgU", position = {85,25}}
	focus_changer_bgD = Image{src = "lib/assets/assign-focus-down.png", name = "focuschanger_bgD", position = {85,195}}
	focus_changer_bgR = Image{src = "lib/assets/assign-focus-right.png", name = "focuschanger_bgR", position = {170, 110}}
	focus_changer_bgL = Image{src = "lib/assets/assign-focus-left.png", name = "focuschanger_bgL", position = {0,110}}
	focus_changer_bgE = Image{src = "lib/assets/assign-focus-ok.png", name = "focuschanger_bgE", position = {85,110}}

	if v.extra.type == "TabBar" then 
		local space = 0
		tabs = Group {name = "tabs_focus", position = {0,0,0}, reactive = true}
		for i=1, #v.tab_labels, 1 do 
			local tab_txt = Text{name = tostring(i), color = {255,255,255,255}, font = "FreeSans Medium 12px", text = "Tab_"..tostring(i).." | ", x = space, reactive == true}
			if i == 1 then 
				tab_txt.color = {255,25,25,255}
			end

			tabs:add(tab_txt)
			space = space + 45
		end
	else 
		text11 = Text { color = {255,255,255,255}, font = "FreeSans Medium 12px", text = "Assign Focus".."["..v.name.."]", name = "text11", position = {0,0,0}, }
	end 


	gU = Rectangle { name = "gU", position = {85,25,0}, size = {85,85}, opacity = 255, color = {255,255,255,0}, reactive = true, } 

	textU = Text { color = {255,255,255,255}, font = "FreeSans Medium 12px", text = "", wants_enter = true, wrap = true, wrap_mode = "CHAR", name = "textU", position = {89,67}, size = {77,36}, opacity = 255, alignment = "CENTER" }

	gL = Rectangle { name = "gL", position = {0,110,0}, size = {85, 85}, opacity = 255, color = {255,255,255,0}, reactive = true, } 

	textL = Text { color = {255,255,255,255}, font = "FreeSans Medium 12px", text = "", wants_enter = true, wrap = true, wrap_mode = "CHAR", name = "textL", position = {4,152,0}, size = {77, 36}, opacity = 255, alignment = "CENTER" }

	gE = Rectangle { name = "gE", position = {85,110}, size = {85,85}, opacity = 255, color = {255,255,255,0}, reactive = true, }

	textE = Text { color = {255,255,255,255}, font = "FreeSans Medium 12px", text = "", wants_enter = true, wrap = true, wrap_mode = "CHAR", name = "textE", position = {89,152,0}, size = {77,36}, opacity = 255, alignment = "CENTER" }

	gR = Rectangle { name = "gR", position = {170,110}, size = {85,85}, opacity = 255, color = {255,255,255,0}, reactive = true, }

	textR = Text { color = {255,255,255,255}, font = "FreeSans Medium 12px", text = "", wants_enter = true, wrap = true, wrap_mode = "CHAR", name = "textR", position = {174, 152}, size = {77,36}, opacity = 255, alignment = "CENTER" }

	gD = Rectangle { name = "gD", position = {85,195} , size = {85,85}, opacity = 255, color = {255,255,255,0}, reactive = true, }

	textD = Text { color = {255,255,255,255}, font = "FreeSans Medium 12px", text = "", wants_enter = true, wrap = true, wrap_mode = "CHAR", name = "textD", position = {90,237}, size = {75,45}, opacity = 255, alignment = "CENTER" }

	if v.extra.type =="TabBar" then 
		focus:add(tabs, focus_changer_bgU, focus_changer_bgD, focus_changer_bgL, focus_changer_bgR, focus_changer_bgE, textU, gU, textL, gL, textE, gE, textR, gR, textD, gD)
	else 
		focus:add(text11, focus_changer_bgU, focus_changer_bgD, focus_changer_bgL, focus_changer_bgR, focus_changer_bgE, textU, gU, textL, gL, textE, gE, textR, gR, textD, gD)
	end 
	
	function focus.extra.on_focus_in()
	 	if current_focus then 
	 		current_focus.extra.on_focus_out()
	 	end 
	 	current_focus = focus
	 	for i,j in pairs(focus.children) do
			if j.type == "Rectangle" then 
		     	local focus_t= j.name:sub(2,-1)
		     	j.border_color = {255,255,255,0}
			end 
	 	end 
	end 

	function focus.extra.on_focus_out(call_by_inspector)
		focus_type = ""
		input_mode = hdr.S_POPUP
        for i,j in pairs(focus.children) do
			if j.type == "Rectangle" then 
		     	local focus_t= j.name:sub(2,-1)
		     	j.border_color = {255,255,255,0}
			end 
		end 
	end 

	function make_on_button_down_f(r)
     	function r:on_button_down(x,y,b,n)
	 		if focus then 
				if focus.extra.on_focus_in then 
        			focus.extra.on_focus_in()
				end 
			end
	   		focus_type = r.name:sub(2,-1)
	   		r.border_color = {255,25,25,255} 
	   		r.border_width = 2

			local tabs_focus = focus:find_child("tabs_focus")
			if tabs_focus then 
				for i,j in pairs (tabs_focus.children) do 
					if j.color[2] == 25 then --활성화 되어 있는 탭 
						if tab_dir == "top" then 
							if focus_type == "U" then 
	   							if (focus:find_child("text"..focus_type).text ~= "") then
									focus.extra.tabs[i].up_focus = ""
	   							end   
							elseif focus_type == "D" then 
	   							if (focus:find_child("text"..focus_type).text ~= "") then
									focus.extra.tabs[i].down_focus = ""
	   							end   
							elseif focus_type == "R" then 
								focus.extra.tabs[i].right_focus = ""
							elseif focus_type == "L" then 
								focus.extra.tabs[i].left_focus = ""
							end 
						else 
							if focus_type == "L" then 
	   							if (focus:find_child("text"..focus_type).text ~= "") then
									focus.extra.tabs[i].left_focus = ""
	   							end   
							elseif focus_type == "R" then 
	   							if (focus:find_child("text"..focus_type).text ~= "") then
									focus.extra.tabs[i].right = ""
	   							end   
							elseif focus_type == "U" then 
								focus.extra.tabs[i].up_focus = ""
							elseif focus_type == "D" then 
								focus.extra.tabs[i].down_focus = ""
							end 
						end 
					end 
				end 
			end 
	   		if (focus:find_child("text"..focus_type).text ~= "") then
				focus:find_child("text"..focus_type).text = ""
	   		end   
	   		input_mode = hdr.S_FOCUS
	   		return true 
		end 
	end 

	for i,j in pairs (focus.children) do 
     	j.reactive = true 
     	if (j.type == "Rectangle") then 
          	make_on_button_down_f(j)
		elseif j.name == "tabs_focus" then 
			local current_tabs_focus = 1
			local tab_dir = v.tab_position 

			local f_n_map = {
				["U"] = function(focus_tab_n) return focus.tabs[focus_tab_n].up_focus end, 
				["D"] = function(focus_tab_n) return focus.tabs[focus_tab_n].down_focus end, 
				["R"] = function(focus_tab_n) return focus.tabs[focus_tab_n].right_focus end, 
				["L"] = function(focus_tab_n) return focus.tabs[focus_tab_n].left_focus end, 
			}
			local f_n_map2 = {
				["U"] = function(focus_tab_n) return v.tabs[focus_tab_n].extra.up_focus  end, 
				["D"] = function(focus_tab_n) return v.tabs[focus_tab_n].extra.down_focus end, 
				["R"] = function(focus_tab_n) return v.tabs[focus_tab_n].extra.right_focus end, 
				["L"] = function(focus_tab_n) return v.tabs[focus_tab_n].extra.left_focus end, 
			}

			local function update_tab_f(n, focus_t)
				if f_n_map[focus_t](n) ~= nil then 
					focus:find_child("text"..focus_t).text = f_n_map[focus_t](n)
				else 
					if  f_n_map2[focus_t](n) then 
						focus:find_child("text"..focus_t).text = f_n_map2[focus_t](n)
					else 
						focus:find_child("text"..focus_t).text = ""
					end 
				end 
			end 

			local function deactive_tab(tab_type) 
				focus:find_child("text"..tab_type).text = v.name 
				focus:find_child("text"..tab_type).color = {255,255,255,100}
				focus:find_child("focuschanger_bg"..tab_type).opacity = 100 
				focus:find_child("g"..tab_type).reactive = false 
			end 

			local function active_tab(tab_type, txt) 
				if txt then 
					focus_changer:find_child("text"..tab_type).text = txt
		    	end 
				focus:find_child("text"..tab_type).color = {255,255,255,255}
				focus:find_child("focuschanger_bg"..tab_type).opacity = 255 
				focus:find_child("g"..tab_type).reactive = true 
			end 

			for k=1, #v.tab_labels, 1 do 
				local aa = j:find_child(tostring(k))
     			aa.reactive = true 
				function aa:on_button_down(x,y,b,n)
					j:find_child(tostring(current_tabs_focus)).color = {255,255,255,255}
					aa.color = {255,25,25,255} 
					local focus_tab_n = tonumber(aa.name) -- same with k 

					if  focus_tab_n == 1 then 
						
						if tab_dir == "top" then 
							update_tab_f(focus_tab_n, "U")
							update_tab_f(focus_tab_n, "D")
							update_tab_f(focus_tab_n, "L")

							active_tab("L") 
							deactive_tab("E") 
							deactive_tab("R") 
						else 
							update_tab_f(focus_tab_n, "L")
							update_tab_f(focus_tab_n, "R")
							update_tab_f(focus_tab_n, "U")

							active_tab("U") 
							deactive_tab("E") 
							deactive_tab("D") 
						end 

					elseif tonumber(aa.name) == #v.tab_labels then 
					
						if tab_dir == "top" then 
							update_tab_f(focus_tab_n, "U")
							update_tab_f(focus_tab_n, "D")
							update_tab_f(focus_tab_n, "R")

							active_tab("R") 
							deactive_tab("L") 
							deactive_tab("E") 
						else
							update_tab_f(focus_tab_n, "L")
							update_tab_f(focus_tab_n, "R")
							update_tab_f(focus_tab_n, "D")

							active_tab("D") 
							deactive_tab("U") 
							deactive_tab("E") 
						end

					else

						if tab_dir == "top" then 
							update_tab_f(focus_tab_n, "U")
							update_tab_f(focus_tab_n, "D")

							deactive_tab("L") 
							deactive_tab("E") 
							deactive_tab("R") 
						else
							update_tab_f(focus_tab_n, "L")
							update_tab_f(focus_tab_n, "R")

							deactive_tab("U") 
							deactive_tab("E") 
							deactive_tab("D") 
						end 
					end 

					current_tabs_focus = k
					input_mode = hdr.S_FOCUS
					return true
				end 
			end
     	end
	end
	return focus
end 

function factory.create_tiny_input_box(txt)
     	local box_g = Group {}
     	local box = factory.draw_tiny_ring()
     	local box_focus = factory.draw_tiny_focus_ring()
	box_g.name = "input_b"
        box.position  = {0,0}
        box.reactive = true
        box.opacity = 255
	box_g:add(box)
	box_focus.opacity = 0 
	box_g:add(box_focus)
    	box_g:add(txt)

        function box_g.extra.on_focus_in()
		txt:grab_key_focus(txt)
		txt.cursor_visible = true
	        box.opacity = 0 
            	box_focus.opacity = 255
		msgw_focus = "input_b"
        end

        function box_g.extra.on_focus_out()
	        box.opacity = 255 
            	box_focus.opacity = 0
		txt.cursor_visible = false
        end

	return box_g
end 



function factory.create_small_input_box(txt)
     	local box_g = Group {}
     	local box = factory.draw_small_ring()
     	local box_focus = factory.draw_small_focus_ring()

		box_g.name = "input_b"
        box.position  = {0,0}
        box.reactive = true
        box.opacity = 255
		box_g:add(box)
		box_focus.opacity = 0 
		box_g:add(box_focus)
    	box_g:add(txt)

        function box_g.extra.on_focus_in()
		txt:grab_key_focus(txt)
		txt.cursor_visible = true
	        box.opacity = 0 
            	box_focus.opacity = 255
		msgw_focus = "input_b"
        end

        function box_g.extra.on_focus_out()
	        box.opacity = 255 
            	box_focus.opacity = 0
		txt.cursor_visible = false
        end

	return box_g
end 


function factory.create_input_box()
     	local box_g = Group {}
        local input_l = Text { name="input", font= "FreeSans Medium 30px", color = "FFFFFF" ,
              position = {25, 10}, text = project.."/screens/" } --hhhhhh
        input_t = Text { name="input", font= "FreeSans Medium 30px", color = "FFFFFF" , ellipsize = "END",
        -- 0111 position = {input_l.w + 25, 10}, text = "" , editable = true , reactive = true, wants_enter = false, w = screen.w , h = 50 }
        position = {input_l.w + 25, 10}, text = strings[""] , editable = true , reactive = true, wants_enter = false, w = screen.w , h = 50 }
     	local box = factory.draw_ring()
     	local box_focus = factory.draw_focus_ring()
	box_g.name = "input_b"
        box.position  = {0,0}
        box.reactive = true
        box.opacity = 255
	box_g:add(box)
	box_focus.opacity = 0 
	box_g:add(box_focus)
    	box_g:add(input_l)
    	box_g:add(input_t)

        function box_g.extra.on_focus_in()
		input_t:grab_key_focus(input_t)
	        box.opacity = 0 
            	box_focus.opacity = 255
		msgw_focus = "input_b"
		input_t.cursor_visible = true
        end

        function box_g.extra.on_focus_out()
	        box.opacity = 255 
            	box_focus.opacity = 0
		input_t.cursor_visible = false
        end

	return box_g
end 

function factory.make_scroll (x_scroll_from, x_scroll_to, y_scroll_from, y_scroll_to)  
     
     local x_scroll_box, y_scroll_box 
     local x_scroll_bar, y_scroll_bar 

     if(x_scroll_to == 0)then 
	 x_scroll_to = screen.w
     end
     if(y_scroll_to == 0)then 
	 y_scroll_to = screen.h
     end

     g.extra.canvas_h = y_scroll_to - y_scroll_from -- y 전체 캔버스 사이즈가 되겠구 
     g.extra.canvas_w = x_scroll_to - x_scroll_from -- x 전체 캔버스 사이즈가 되겠구 
     g.extra.canvas_f = y_scroll_from
     g.extra.canvas_xf = x_scroll_from
     g.extra.canvas_t = y_scroll_to
     g.extra.canvas_xt = x_scroll_to

     screen_rect =  Rectangle{
                name="screen_rect",
                border_color= {2, 25, 25, 140},
                border_width=2,
                color= {255,255,255,0},
                size = {screen.w+1,screen.h+1},
                position = {0,0,0}, 
     }
     screen_rect.reactive = false
     g:add(screen_rect)


     
    if (g.extra.canvas_w > screen.w) then 
	local SCROLL_X_POS = 10
	local BOX_BAR_SPACE = 6
	
        x_scroll_box = factory.make_x_scroll_box()
        x_scroll_bar = factory.make_x_scroll_bar(g.extra.canvas_w)

	x_scroll_box.position = {SCROLL_X_POS, screen.h - 60}
	x_scroll_bar.position = {SCROLL_X_POS + BOX_BAR_SPACE, screen.h - 56}

	
        x_scroll_bar.extra.org_x = 16
	x_scroll_bar.extra.h_x = 16
	x_scroll_bar.extra.l_x = x_scroll_box.x + x_scroll_box.w - x_scroll_bar.w - BOX_BAR_SPACE -- 스크롤 되는 영역의 길이 

	screen:add(x_scroll_box) 
	screen:add(x_scroll_bar) 

        -- 요 값은 스크롤 바가 움직일때 오브젝의 와이 포지션이 밖뀌는 값을 나타내는건데 이름이 너무 헤깔리는군 
        g.extra.scroll_dx = ((g.extra.canvas_w - screen.w)/(x_scroll_bar.extra.l_x - x_scroll_bar.extra.h_x))

		
	local x0 = - g.extra.canvas_xf/g.extra.scroll_dx + 10 
	local x1920 = (-g.extra.canvas_xf+1080)/g.extra.scroll_dx + 10

	x_0_mark= Rectangle {
		name="x_0_mark",
		border_color={255,255,255,255},
		border_width=0,
		color={100,255,25,255},
		size = {2, 40},
		anchor_point = {0,0},
		x_rotation={0,0,0},
		y_rotation={0,0,0},
		z_rotation={0,0,0},
		position = {SCROLL_X_POS + x0, screen.h - 55, 0},
		opacity = 255
        }

	x_1920_mark= Rectangle {
		name="x_1920_mark",
		border_color={255,255,255,255},
		border_width=0,
		color={100,255,25,255},
		size = {2, 40},
		anchor_point = {0,0},
		x_rotation={0,0,0},
		y_rotation={0,0,0},
		z_rotation={0,0,0},
		position = {SCROLL_X_POS + x1920, screen.h - 55, 0},
		opacity = 255
        }
  
	screen:add(x_0_mark)
	screen:add(x_1920_mark) 

        -- 스크롤 바 넣고 원래 좌표를 기억해 두는기지요 
	for n,m in pairs (g.children) do 
		m.extra.org_x = m.x
	end 
         
        function x_scroll_bar:on_button_down(x,y,button,num_clicks)
		dragging = {x_scroll_bar, x-x_scroll_bar.x, y-x_scroll_bar.y }

		if table.getn(selected_objs) ~= 0 then
		     for q, w in pairs (selected_objs) do
			 local t_border = screen:find_child(w)
			 local i, j = string.find(t_border.name,"border")
		         local t_obj = g:find_child(string.sub(t_border.name, 1, i-1))	
		         if(t_obj ~= nil) then 
			      screen:remove(screen:find_child(t_obj.name.."a_m"))
			 end
		     end
		end

        	return true
    	end 

    	function x_scroll_bar:on_button_up(x,y,button,num_clicks)
	 	if(dragging ~= nil) then 
	      		local actor , dx , dy = unpack( dragging )
			local dif
	      		if (actor.extra.h_x <= x-dx and x-dx <= actor.extra.l_x) then -- 스크롤 되는 범위안에 있으면	
	           		dif = x - dx - x_scroll_bar.extra.org_x -- 스크롤이 이동한 거리 
	           		x_scroll_bar.x = x - dx 
	      		elseif (actor.extra.h_x > x-dx ) then
				dif = actor.extra.h_x - x_scroll_bar.extra.org_x 
	           		x_scroll_bar.x = actor.extra.h_x
	      		elseif (actor.extra.l_x < x-dx ) then
				dif = actor.extra.l_x- x_scroll_bar.extra.org_x 
	           		x_scroll_bar.x = actor.extra.l_x
			end 
			dif = dif * g.extra.scroll_dx -- 스클롤된 길이 * 그 길이가 나타내는 와이값 증감 
			for i,j in pairs (g.children) do 
	           	     j.position = {j.extra.org_x-dif-x_scroll_from, j.y, j.z}
			end 

			if table.getn(selected_objs) ~= 0 then
			     for q, w in pairs (selected_objs) do
				 local t_border = screen:find_child(w)
				 local i, j = string.find(t_border.name,"border")
		                 local t_obj = g:find_child(string.sub(t_border.name, 1, i-1))	
		                 if(t_obj ~= nil) then 
			              t_border.x = t_obj.x 
				 end
			     end
			end

			g.extra.scroll_x = math.floor(dif) 
	      		dragging = nil
	 	end 
         	return true
    	end 
     end 


     if(g.extra.canvas_h > screen.h) then 


	local SCROLL_Y_POS = 90
	local BOX_BAR_SPACE = 6

	y_scroll_box = factory.make_y_scroll_box()
        y_scroll_bar = factory.make_y_scroll_bar(g.extra.canvas_h) 

	y_scroll_box.position = {screen.w - 60, SCROLL_Y_POS}
	y_scroll_bar.position = {screen.w - 56, SCROLL_Y_POS + BOX_BAR_SPACE}

        y_scroll_bar.extra.org_y = 96
	y_scroll_bar.extra.h_y = 96
	y_scroll_bar.extra.l_y = y_scroll_box.y + y_scroll_box.h - y_scroll_bar.h - BOX_BAR_SPACE -- 스크롤 되는 영역의 길이 

	screen:add(y_scroll_box) 
	screen:add(y_scroll_bar) 

        -- 요 값은 스크롤 바가 움직일때 오브젝의 와이 포지션이 밖뀌는 값을 나타내는건데 이름이 너무 헤깔리는군 
        g.extra.scroll_dy = ((g.extra.canvas_h - screen.h)/(y_scroll_bar.extra.l_y - y_scroll_bar.extra.h_y))
  
	
	local y0 = - g.extra.canvas_f/g.extra.scroll_dy + 10 
	local y1080 = (-g.extra.canvas_f+1080)/g.extra.scroll_dy + 10

	y_0_mark= Rectangle {
		name="y_0_mark",
		border_color={255,255,255,255},
		border_width=0,
		color={100,255,25,255},
		size = {40,2},
		anchor_point = {0,0},
		x_rotation={0,0,0},
		y_rotation={0,0,0},
		z_rotation={0,0,0},
		position = {screen.w - 55, SCROLL_Y_POS + y0, 0},
		opacity = 255
        }

	y_1080_mark= Rectangle {
		name="y_1080_mark",
		border_color={255,255,255,255},
		border_width=0,
		color={100,255,25,255},
		size = {40,2},
		anchor_point = {0,0},
		x_rotation={0,0,0},
		y_rotation={0,0,0},
		z_rotation={0,0,0},
		position = {screen.w - 55, SCROLL_Y_POS + y1080, 0},
		opacity = 255
       }
  
	screen:add (y_0_mark)
	screen:add (y_1080_mark)

        -- 스크롤 바 넣고 원래 좌표를 기억해 두는기지요 
	for n,m in pairs (g.children) do 
		m.extra.org_y = m.y
	end 
         
        function y_scroll_bar:on_button_down(x,y,button,num_clicks)
		dragging = {y_scroll_bar, x-y_scroll_bar.x, y-y_scroll_bar.y }
		if table.getn(selected_objs) ~= 0 then
			for q, w in pairs (selected_objs) do
				 local t_border = screen:find_child(w)
				 local i, j = string.find(t_border.name,"border")
		                 local t_obj = g:find_child(string.sub(t_border.name, 1, i-1))	
		                 if(t_obj ~= nil) then 
				      screen:remove(screen:find_child(t_obj.name.."a_m"))
				 end
			end
		end

        	return true
    	end 

    	function y_scroll_bar:on_button_up(x,y,button,num_clicks)
	 	if(dragging ~= nil) then 
	      		local actor , dx , dy = unpack( dragging )
			local dif
	      		if (actor.extra.h_y <= y-dy and y-dy <= actor.extra.l_y) then -- 스크롤 되는 범위안에 있으면	
	           		dif = y - dy - y_scroll_bar.extra.org_y -- 스크롤이 이동한 거리 
	           		y_scroll_bar.y = y - dy 
	      		elseif (actor.extra.h_y > y-dy ) then
				dif = actor.extra.h_y - y_scroll_bar.extra.org_y 
	           		y_scroll_bar.y = actor.extra.h_y
	      		elseif (actor.extra.l_y < y-dy ) then
				dif = actor.extra.l_y- y_scroll_bar.extra.org_y 
	           		y_scroll_bar.y = actor.extra.l_y
			end 
			dif = dif * g.extra.scroll_dy -- 스클롤된 길이 * 그 길이가 나타내는 와이값 증감 
			for i,j in pairs (g.children) do 
	           	     j.position = {j.x, j.extra.org_y-dif-y_scroll_from, j.z}
			end 

			if table.getn(selected_objs) ~= 0 then
			     for q, w in pairs (selected_objs) do
				 local t_border = screen:find_child(w)
				 local i, j = string.find(t_border.name,"border")
		                 local t_obj = g:find_child(string.sub(t_border.name, 1, i-1))	
		                 if(t_obj ~= nil) then 
			              t_border.y = t_obj.y 
				 end
			     end
			end

			g.extra.scroll_y = math.floor(dif) 
	      		dragging = nil
	 	end 
         	return true
    	end 
     end 
end

return factory
