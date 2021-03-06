
--all hardcoded numbers are from the spec
local gutter_sides        = 50
local top_gutter          = 26
local bottom_gutter       = 20
local mediaplayer_w       = 1308
local mediaplayer_h       = 735
local mediaplayer_y       = 124
local banner_y            = mediaplayer_y + mediaplayer_h + 25







--the group for the show page
mp_group = Group{}
screen:add(mp_group)
mp_group:hide()







--Container for the TweetStream
local TweetStream_Container = Class(function(self,...)
    local bg = Image{src="assets/mp_tweetstream_container.png"}
    local group = Group
    {
        x = screen_w - bg.w,
        y = screen_h-bg.h,
    }
    
    local Show_Name_Font  = "DejaVu Sans bold 26px"
    local Show_Name_Color = "#FFFFFF"
    
    local bg = Image{src="assets/mp_tweetstream_container.png"}

    
    local show_name = Text{
        text  = "show_name",
        font  = Show_Name_Font,
        color = Show_Name_Color,
        x     = 15,
        y     = 15
    }
    local show_more = Image{ src="assets/show_more.png", y = 15 }
    show_more.x = bg.w - show_more.w - 15
    
    
    local top_rule    = Image{src="assets/sp_top_rule.png",
        x = 15, y=70}
    
    group:add(bg,show_name,top_rule, show_more)
    mp_group:add(group)
    
    local curr_obj = nil
    
    function self:going_back()
        page = "sp"
        mp_group:hide()
        sp_group:show()
        curr_obj.tweetstream:get_group():unparent()
        curr_obj.tweetstream:out_view()
        sp.tweetstream:display(curr_obj)
        curr_obj = nil
        ---[[
        mediaplayer:set_viewport_geometry(
            gutter_sides  * screen.scale[1],
            mediaplayer_y * screen.scale[2],
            mediaplayer_w * screen.scale[1],
            mediaplayer_h * screen.scale[2]
        )--]]
    end
    function self:display(show_obj)
        
        curr_obj = show_obj
        
        show_name.text  = show_obj.show_name
        
        curr_obj.tweetstream:resize(bg.w+80,bg.h-(top_rule.y+1),false)
        --curr_obj.tweetstream:set_w(bg.w-30) --still okay from showpage
        curr_obj.tweetstream:set_pos(15-95,top_rule.y+1)
        group:add( curr_obj.tweetstream:get_group() )
        top_rule:raise_to_top()
        --for i = 1,#curr_obj.tweet_g_cache do
        --    tweet_clip:add(curr_obj.tweet_g_cache[i].group)
        --end
        curr_obj.tweetstream:in_view()
        ---[[
        mediaplayer:set_viewport_geometry(
            0,
            0,
            screen_w * screen.scale[1],
            screen_h * screen.scale[2]
        )--]]
    end
    function self:up()
        if curr_obj ~= nil then
           -- curr_obj.tweetstream:move_up()
        end
    end
    function self:down()
        if curr_obj ~= nil then
           -- curr_obj.tweetstream:move_down()
        end
    end

end)
mp = {
    tweetstream = TweetStream_Container(),
    focus       = "TWEETSTREAM",
    keys        = {
        ["TWEETSTREAM"] = {
            [keys.Down] = function()
                mp.tweetstream:down()
            end,
            [keys.Up] = function()
                mp.tweetstream:up()
            end,
            [keys.YELLOW] = function()
                mp.tweetstream:going_back()
            end,
            [keys.BackSpace] = function()
                mp.tweetstream:going_back()
            end,
            [keys.F9] = function()
                mp.tweetstream:going_back()
            end,
            [keys.BACK] = function()
                mp.tweetstream:going_back()
            end,
            [keys.F7] = function()
                mp.tweetstream:going_back()
            end,
            [keys["0"]] = function()
                if mediaplayer.state == mediaplayer.PAUSED then
                    mediaplayer:play()
                else
                    mediaplayer:pause()
                end
            end,
        }
    }
}