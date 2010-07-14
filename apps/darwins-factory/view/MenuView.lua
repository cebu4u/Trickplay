MenuViewConstants = {
    cover_color = "#878787",
    cover_opacity = 100,
    top_z = 10,

    splash_bg_src     = "img/splash/splash_bg.jpg",
    splash_bg_width   = BarneyConstants.board_width,
    splash_bg_height  = BarneyConstants.board_height,
    splash_select_src = "img/splash/splash_selector.png",
    splash_select_x   = 1025,
    splash_select_y   = 750,
    splash_select_width  = 300,
    splash_select_height = 150,
    splash_select_move = 80,

    menu_bg_src       = "img/ingamemenu/ingamemenu_bg.png",
    menu_bg_width     = 800,
    menu_bg_height    = 500,
    menu_select_src   = "img/ingamemenu/ingamemenu_selector.png",
    menu_select_x   = 400,
    menu_select_y   = 400,
    menu_select_width  = 300,
    menu_select_height = 150,
    menu_select_move = 160,
    menu_duration = 1000,


    select_duration = 50,
    PLAY       = 1,
    DIRECTIONS = 2,
    EXIT       = 3
}

MenuView = class(function(self) 

    local MVC = MenuViewConstants

    self.splash_open = false
    self.menu_open = false

    self.option_selected = 0
    --grey transparancy
    self.grey_rectangle = Rectangle{
        width  = BarneyConstants.board_width,
        height = BarneyConstants.board_height,
        color  = MVC.cover_color,
        opacity = MVC.cover_opacity,
        z = MVC.top_z
    }
    --background after game won
    self.menu_bg = Images:load(MVC.menu_bg_src, {
        width  = MVC.menu_bg_width,
        height = MVC.menu_bg_height,
        z = MVC.top_z + 1
    })
    --metal hand selector
    self.menu_select_image = Images:load(MVC.menu_select_src, {
        width  = MVC.menu_select_width,
        height = MVC.menu_select_height,
        x = MVC.menu_select_x,
        y = MVC.menu_select_y,
        z = MVC.top_z + 2
    })
    --splash background
    self.splash_bg = Images:load(MVC.splash_bg_src, {
        width  = MVC.splash_bg_width,
        height =  MVC.splash_bg_height,
        z = MVC.top_z
    })
    --human hand selector
    self.splash_select_image = Images:load(MVC.splash_select_src, {
        width  = MVC.splash_select_width,
        height = MVC.splash_select_height,
        x = MVC.splash_select_x,
        y = MVC.splash_select_y,
        z = MVC.top_z + 1
    })

    self.barney_wins = Images:load("img/ingamemenu/barney_wins.png", {
        width  = 800,
        height = 500,
        x = BarneyConstants.board_height/2 + 60,
        y = 50,
        z = MVC.top_z + 2
    })

    self.roboy_wins = Images:load("img/ingamemenu/roboy_wins.png", {
        width  = 800,
        height = 500,
        x = BarneyConstants.board_height/2 + 60,
        y = 50,
        z = MVC.top_z + 2
    })

    self.ave_wins = Images:load("img/ingamemenu/ave_wins.png", {
        width  = 800,
        height = 500,
        x = BarneyConstants.board_height/2 + 60,
        y = 50,
        z = MVC.top_z + 2
    })

    self.ewall_wins = Images:load("img/ingamemenu/ewall_wins.png", {
        width  = 800,
        height = 500,
        x = BarneyConstants.board_height/2 + 60,
        y = 50,
        z = MVC.top_z + 2
    })

    screen:add(self.ewall_wins)
    screen:add(self.ave_wins)
    screen:add(self.roboy_wins)
    screen:add(self.barney_wins)
    screen:add(self.grey_rectangle)
    screen:add(self.splash_bg)
    screen:add(self.splash_select_image)
    screen:add(self.menu_select_image)
    screen:add(self.menu_bg)

    self.splash_bg:hide()
    self.splash_select_image:hide()
    self.grey_rectangle:hide()
    self.menu_bg:hide()
    self.menu_select_image:hide()
    self.ewall_wins:hide()
    self.ave_wins:hide()
    self.roboy_wins:hide()
    self.barney_wins:hide()

    self.group = Group()
    self.tut = nil
end)

function MenuView:showMenu()
    if(board.numberOfPlayers > 0) then
        self:animateWinner()
    end
    local MVC = MenuViewConstants

    self.menu_open = true
    self.grey_rectangle:show()

    self.selector      = self.menu_select_image
    self.selector_y    = BarneyConstants.board_height - MVC.menu_select_y
    self.selector_move = MVC.menu_select_move

    -- animate menu bg
    self.menu_select_image:show()
    self.menu_bg:show()

    self.menu_bg.y = MVC.menu_bg_height + BarneyConstants.board_height
    self.menu_bg.x = BarneyConstants.board_height/2 + 60
    self.menu_select_image.y = MVC.menu_select_y + MVC.menu_bg_height

    local timeline = Timeline{
        duration = MVC.menu_duration,
        on_new_frame = function(timeline, elapsed, progress)
            self.menu_select_image.y = BarneyConstants.board_height - progress * MVC.menu_select_y               
            self.menu_bg.y = BarneyConstants.board_height - progress * MVC.menu_bg_height
        end,
        on_completed = function(timeline)
            self.menu_bg.y = BarneyConstants.board_height - MVC.menu_bg_height
            self.menu_select_image.y = BarneyConstants.board_height - MVC.menu_select_y
        end
    }

    timeline:start()
end

function MenuView:animateWinner()
    print("\n\n\nplayers: "..board.numberOfPlayers.."\n\n\n")
    if(board.players[1].number == 1) then
        self.roboy_wins:show()
    elseif(board.players[1].number == 2) then
        self.barney_wins:show()
    elseif(board.players[1].number == 3) then
        self.ave_wins:show()
    else
        self.ewall_wins:show()
    end
end

function MenuView:showStart()
    local MVC = MenuViewConstants

    self.splash_open = true
    self.splash_bg:show()
    
    self.splash_select_image:show()
    --update current selector
    self.selector      = self.splash_select_image
    self.selector_y    = MVC.splash_select_y
    self.selector_move = MVC.splash_select_move

    screen:add(self.group)
    self.group.z = 20
    self:RoboToss()
--[=[
    self.splash_timeline = Timeline{
        duration = 300,
        on_new_frame = function(       
    }
--]=]
end

function MenuView:clear()
    local MVC = MenuViewConstants

    assert(self.menu_open or self.splash_open, "clearing without opening in MenuView")

    if self.menu_open then
        self.ewall_wins:hide()
        self.ave_wins:hide()
        self.roboy_wins:hide()
        self.barney_wins:hide()

        print("clearing menu open")
        -- animate menu close
        local timeline = Timeline{
            duration = MVC.menu_duration,
            on_new_frame = function(timeline, elapsed, progress)
                self.menu_bg.y   = BarneyConstants.board_height - MVC.menu_bg_height
                    + progress * MVC.menu_bg_height
                self.menu_select_image.y = BarneyConstants.board_height - MVC.menu_select_y
                    + progress * MVC.menu_select_y
            end,
            on_completed = function(timeline)
                self.grey_rectangle:hide()
                self.menu_select_image:hide()
                self.menu_bg:hide()

                self.menu_open = false
            end
        }

        timeline:start()
    else 
        self.splash_bg:hide()
        self.splash_select_image:hide()
--[=[
        self.splash_timeline:stop()
        self.splash_timeline = nil
--]=]
        self.splash_open = false
    end

    self.group:hide()

    self.option_selected = nil
    self.selector        = nil
    self.selector_y      = nil
    self.selector_move   = nil
end

function MenuView:selectOption(option_number)
    assert(option_number >= 1 and option_number <= 3, "invalid Menu option!")
    assert(self.menu_open or self.splash_open, "clearing without opening in MenuView")

    local MVC = MenuViewConstants
    local new_y
    if(self.menu_open) then
        new_y = option_number == MVC.PLAY and self.selector_y or self.selector_y
            + self.selector_move
    else
        new_y = self.selector_y + (option_number-1) * MVC.splash_select_move
    end

    self.selector:animate{
        duration = MVC.select_duration,
        y = new_y
    }
   
    self.option_selected = option_number
end

function MenuView:directions()
    local tut_img = Images:load("img/splash/tutorial.jpg")
    local tut_g = Group()
    tut_g:add(tut_img)
    screen:add(tut_g)
    tut_g.x=0
    tut_g.y=0
    tut_g.z=0
    self.tut = tut_g
    --[[
    tut_g.x=-1000
    tut_g.y=0
    tut_g.z=100
    self.group:add(tut_g)
    local function wait_7()
        local function go_away()
            local function del()
                tut_g:hide()
                tut_g:unparent()
                tut_g = nil
            end
            tut_g:animate{duration=700,x=tut_g.x-999,on_completed=del}
        end
        tut_g:animate{duration=7000,x=tut_g.x-1,on_completed=go_away}
    end
    tut_g:animate{duration=700,x=tut_g.x+2000,on_completed=wait_7}
    --]]
end
