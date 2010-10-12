Components = {
    COMPONENTS_FIRST = 1,
    GAME = 1,
    MENU = 2,
    NO_MOVES_DIALOG = 3,
    COMPONENTS_LAST = 3
}

Events = {
    KEYBOARD = 1,
    TIMER = 2,
    NOTIFY = 3
}

dofile("DoFiles.lua")

local splash = Image{src = "assets/Mahjong_Splash.jpg"}
local start_button_focus = Image{
    src = "assets/StartGlow.png",
    opacity = 0,
    position = {800,650}
}
screen:add(splash, start_button_focus)
screen:show()

local timer = Timer()
timer.interval = 7000
timer.on_timer = function(timer)
    timer:stop()
    timer.on_timer = nil

    start_button_focus:animate{duration = 1000, opacity = 255,
    on_completed = function()

        -- Router initialization
        router = Router()
        dofile("EventHandling.lua")


        GridPositions = {}
        for i = 1,GRID_WIDTH do
            GridPositions[i] = {}
            for j = 1,GRID_HEIGHT do
                GridPositions[i][j] = {}
                for k = 1,GRID_DEPTH do
                    GridPositions[i][j][k] = {47*(i-1) - (k-1)*16, 59*(j-1) - (k-1)*21}
                end
            end
        end
        GridPositions.TOP = Utils.deepcopy(GridPositions[7][4][4])
        GridPositions.TOP[1] = GridPositions.TOP[1] + 40
        GridPositions.TOP[2] = GridPositions.TOP[2] + 40

        -- Animation loop initialization
        gameloop = GameLoop()

        -- View/Controller initialization
        game = GameControl(router, Components.GAME)
        game_menu = MenuView(router)
        game_menu:initialize()
        local no_moves_dialog = DialogBox("Sorry!\nThere are no\nmore moves", Components.NO_MOVES_DIALOG,
            router)

        splash:unparent()

        router:start_app(Components.GAME)
        --router:start_app(Components.NO_MOVES_DIALOG)
    end}
end

timer:start()

screen.on_key_down = function()
    screen.on_key_down = nil
    timer:on_timer(timer)
end
