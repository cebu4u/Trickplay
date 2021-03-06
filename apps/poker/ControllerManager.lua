-- Load up the controller specific classes
dofile("phone/RemoteButton.lua")
dofile("phone/controllers/RemoteCharacterSelectionController.lua")
dofile("phone/controllers/RemoteWaitingRoomController.lua")
dofile("phone/controllers/RemoteBettingController.lua")

ControllerStates = {
    SPLASH = 1,
    CHOOSE_DOG = 2,
    NAME_DOG = 3,
    WAITING = 4,
    BETTING = 5
}

RemoteComponents = {
    SPLASH = 1,
    CHOOSE_DOG = 2,
    NAME_DOG = 3,
    WAITING = 4,
    BETTING = 5
}

ControllerManager = Class(nil,
function(ctrlman, start_accel, start_touch, resources, max_controllers)
    if resources ~= nil and not type(resources) == "table" then
        error("all resources must be declared as strings in a table", 3)
    end
    if not max_controllers then max_controllers = 4 end

    local number_of_ctrls = 0
    local active_ctrls = {}

    function ctrlman:delegate(event)
        for _,controller in pairs(active_ctrls) do
            controller.router:delegate(event)
        end
    end

    function ctrlman:set_active_component(comp)
        for _,controller in pairs(active_ctrls) do
            controller.router:set_active_component(comp)
            controller.router:notify()
        end
    end

    function ctrlman:declare_resource(asset_name, asset)
        if not asset_name or not asset then
            error("Usage: declare_resource(name, object)", 2)
        end
        for _,controller in pairs(active_ctrls) do
            controller:declare_resource(asset_name, asset)
        end
    end

    --[[
        Hook up the connect, disconnect and ui controller events
    --]]
    function controllers:on_controller_connected(controller)
        if not controller.has_ui then return end
        print("on_controller_connected controller.name = "..controller.name)

        controller.state = ControllerStates.SPLASH
        controller.router = Router()

        local x_ratio = controller.ui_size[1]/640
        local y_ratio = controller.ui_size[2]/870
        controller.x_ratio = x_ratio
        controller.y_ratio = y_ratio


---------------Advanced UI Junk----------------
        
        local advanced_ui_ready = false
        local character_selection
        local waiting_room
        local betting
        local function create_advanced_ui_objects()
            character_selection = RemoteCharacterSelectionController(router, controller)
            controller.router:notify()
            advanced_ui_ready = true
        end

---------------General UI Junk----------------

        local function declare_necessary_resources()
            --[[
                Declare resources to be used by the phone
            --]]
            -- all the cards
            for _,card in ipairs(Cards) do
                controller:declare_resource(getCardImageName(card),
                    "assets/cards/"..getCardImageName(card)..".png")
            end

            -- buttons for betting
            --controller:declare_resource("buttons", "assets/phone/buttons.png")
            -- buttons for dog selection
            controller:declare_resource("dog_1", "assets/phone/chip1.png")
            controller:declare_resource("dog_2", "assets/phone/chip2.png")
            controller:declare_resource("dog_3", "assets/phone/chip3.png")
            controller:declare_resource("dog_4", "assets/phone/chip4.png")
            controller:declare_resource("dog_5", "assets/phone/chip5.png")
            controller:declare_resource("dog_6", "assets/phone/chip6.png")
            -- phone splash screen
            controller:declare_resource("splash", "assets/phone/splash.jpg")
            -- blank background
            controller:declare_resource("bkg", "assets/phone/bkgd-blank.jpg")

            -- headers which help instruct the player
            controller:declare_resource("hdr_choose_dog",
                "assets/phone/text-choose-your-dog.png")
            controller:declare_resource("hdr_name_dog",
                "assets/phone/text-name-your-dog.png")

            -- Waiting Room stuff
            controller:declare_resource("click_label",
                "assets/phone/waiting_screen/label-clicktoadd.png")
            controller:declare_resource("comp_label",
                "assets/phone/waiting_screen/label-computer.png")
            controller:declare_resource("human_label",
                "assets/phone/waiting_screen/label-human.png")
            controller:declare_resource("ready_label",
                "assets/phone/waiting_screen/label-ready.png")
            controller:declare_resource("start_button",
                "assets/phone/waiting_screen/button-startplaying.png")
            controller:declare_resource("select_opponent_text",
                "assets/phone/waiting_screen/text-opponent.png")
            controller:declare_resource("please_wait",
                "assets/phone/waiting_screen/text-wait_for_hand.png")
            for i = 1,6 do
                controller:declare_resource("player_"..i,
                    "assets/phone/waiting_screen/player"..i..".png")
            end
            controller:declare_resource("wooden_bar",
                "assets/camera/help/lower-menu-bar.png")

            controller:declare_resource("frame", "assets/camera/frame-overlay.png")
            controller:declare_resource("chip_touch",
                "assets/phone/chip-touch.png")

            -- Remote Betting Controller Resources
            controller:declare_resource("buttons", "assets/phone/betting/buttons.png")
            controller:declare_resource("call_button_on_touch",
                "assets/phone/betting/button-touch-call.png")
            controller:declare_resource("bet_button_on_touch",
                "assets/phone/betting/button-touch-bet.png")
            controller:declare_resource("check_button_on_touch",
                "assets/phone/betting/button-touch-check.png")
            controller:declare_resource("fold_button_on_touch",
                "assets/phone/betting/button-touch-fold.png")
            controller:declare_resource("minus_button_on_touch",
                "assets/phone/betting/button-touch-minus.png")
            controller:declare_resource("plus_button_on_touch",
                "assets/phone/betting/button-touch-plus.png")
            controller:declare_resource("check_button_off_touch",
                "assets/phone/betting/button-check.png")
            controller:declare_resource("exit_button",
                "assets/phone/betting/button-exit.png")
            controller:declare_resource("help_button",
                "assets/phone/betting/button-help.png")
            controller:declare_resource("new_game_button",
                "assets/phone/betting/button-new-game.png")
            controller:declare_resource("folded_text",
                "assets/phone/betting/text-folded.png")
            controller:declare_resource("continue_button",
                "assets/phone/betting/button-continue.png")
            controller:declare_resource("continue_button_on",
                "assets/phone/betting/button-touch-continue.png")

            controller:declare_resource("click_sound",
                "assets/sounds/enter.mp3")

            controller:clear_and_set_background("splash")
        end

        function controller:add_image(image_name, x, y, width, height)
            if not image_name then error("no image name", 2) end
            
            return
                controller:set_ui_image(image_name, math.floor(x*x_ratio),
                    math.floor(y*y_ratio), math.floor(width*x_ratio),
                    math.floor(height*y_ratio))
        end

        function controller:correct_for_resolution(x, y, w, h)
            return x*x_ratio, y*y_ratio, w*x_ratio, h*y_ratio
        end

        local current_bkg = nil
        function controller:clear_and_set_background(image_name, hard)
            print("\n\nClear and Set Background with image name:", image_name, "\n\n")
            if current_bkg ~= image_name or hard then
                controller:clear_ui()
                --controller.screen:set_background(image_name)
                controller:set_ui_background(image_name)
                current_bkg = image_name
            end
        end

        function controller:on_key_down(key)
            print("controller keypress:", key)
            --[[
            if controller.name == "Keyboard" then return true end
            print("key consumed")

            return false
            --]]
            return true
        end


        print("CONNECTED", controller.name)
        
        function controller:on_disconnected()
            print("DISCONNECTED", controller.name)

            controller.set_hole_cards = nil
            controller.name_dog = nil
            controller.photo_dog = nil
            controller.choose_dog = nil
            controller.state = nil
            controller.add_image = nil
            controller.clear_and_set_background = nil
            controller.on_key_down = nil
            controller.on_disconnected = nil
            controller.on_accelerometer = nil
            controller.on_touch_down = nil
            controller.on_touch_up = nil
            controller.on_touch_move = nil
            controller.waiting_room = nil
            controller.update_waiting_room = nil

            for i,ctrl in ipairs(active_ctrls) do
                if ctrl == controller then
                    table.remove(active_ctrls, i)
                end
            end
            number_of_ctrls = number_of_ctrls - 1
        end

        if start_accel and controller.has_accelerometer then
            function controller:on_accelerometer(x, y, z)
                print("accelerometer: x", x, "y", y, "z", z)
            end
            controller:start_accelerometer("L", 1)
        end

        if start_touch and controller.has_touches then
            print("can accept touches!")
            function controller:on_touch_down(finger, x, y)
                print("touch down:", controller.name, x, y)

                print("component "..tostring(router:get_active_component())
                .." handling click")
                router:get_active_controller():handle_click(controller, x, y)
            end
            function controller:on_touch_up(finger, x, y)
            end
            function controller:on_touch_move(finger, x, y)
            end
            function controller:on_key_down(key)
                if key == keys.Escape or key == keys.EXIT then
                    return true
                end
                return false
            end
            controller:start_touches()
        end

        function controller:choose_dog(players)
            print("controller", controller.name, "choosing dog")

            controller:clear_and_set_background("bkg", true)
            controller.router:set_active_component(RemoteComponents.CHOOSE_DOG)
            controller.router:notify()
            if advanced_ui_ready then
                controller.router:get_active_controller():reset()
                controller.router:get_active_controller():init_character_selection(
                    router:get_controller(Components.CHARACTER_SELECTION):get_players()
                )
            end

            controller.state = ControllerStates.CHOOSE_DOG
        end

        function controller:update_choose_dog(player, cntrl)
            character_selection:update_character_selection(player, cntrl)
        end

        function controller:on_ui_event(text)
            print("ui_event!")
        end

        --[[
            Brings up the name your dog screen on the iphone. Player may enter a name
            that replaces the Player # on their dogs name bubble.

            @parameter pos : the dogs number/position (1-6). Determines which dog icon
                to show on the iphone.
        --]]
        local name_dog = nil
        local dog_coin = nil
        function controller:name_dog(pos)
            print("naming dog")
            controller.router:set_active_component(RemoteComponents.NAME_DOG)
            controller.router:notify()
            controller.state = ControllerStates.NAME_DOG

            --controller:clear_and_set_background("bkg")
            --controller:add_image("hdr_name_dog", 109, 30, 422, 50)
            if not name_dog then
                name_dog = controller.factory:Image{
                    src = "hdr_name_dog",
                    position = {109*x_ratio, 30*y_ratio},
                    size = {422*x_ratio, 50*y_ratio}
                }
                controller.screen:add(name_dog)
            else
                name_dog:show()
            end
            --controller:add_image("dog_"..pos, 192, 80, 256, 256)
            if dog_coin then
                dog_coin:unparent()
            end
            dog_coin = controller.factory:Image{
                src = "dog_"..pos,
                position = {192*x_ratio, 80*y_ratio},
                size = {256*x_ratio, 256*y_ratio}
            }
            controller.screen:add(dog_coin)

            local default_name = settings[controller.name] or "Name Your Dog"
            if controller.has_text_entry
            and controller:enter_text("Name Your Dog", default_name) then
                function controller:on_ui_event(text)
                    if text ~= "" and text ~= "Name Your Dog" then
                        settings[controller.name] = text
                        controller.player.status:update_name(text)
                    end
                    controller.on_ui_event = function() end
                    controller:photo_dog(pos)
                end
                return
            end
            
            controller:photo_dog(pos)
        end

        --[[
            Returns true if photo functionality works.
        --]]
        function controller:photo_dog(pos)
            print("giving dog a photo")
            local function handle_next_state()
                name_dog:hide()
                dog_coin:hide()
                if controller.state == ControllerStates.BETTING then
                    controller.router:set_active_component(RemoteComponents.BETTING)
                    controller:set_hole_cards(controller.hole_cards)
                else
                    controller.router:set_active_component(RemoteComponents.WAITING)
                    controller:waiting_room()
                end
            end
            -- .4 is the constant of proportionality between the frame overlay
            -- on the camera and the frame for the poker dawgz replacement image
            if controller.has_images
            and controller:request_image({640*.4, 783*.4}, true, "frame",
            "Select Avatar Image", "Default dog") then
                function controller:on_image(bitmap)
                    local image = bitmap:Image()
                    controller.player.dog_view:reset_images()
                    controller.player.dog_view:edit_images(image)
                    handle_next_state()
                end
                function controller:on_image_cancelled()
                    handle_next_state()
                end

                return true
            end
            handle_next_state()

            return false
        end

        function controller:waiting_room()
            if controller.router:get_active_component() == RemoteComponents.NAME_DOG then
                return
            end
            controller:clear_and_set_background("bkg")

            if advanced_ui_ready then
                if not waiting_room then
                    waiting_room = RemoteWaitingRoomController(router, controller)
                end
                controller.router:set_active_component(RemoteComponents.WAITING)
                controller.router:notify()
            end

            controller.state = ControllerStates.WAITING
        end

        function controller:update_waiting_room(player)
            if controller.router:get_active_component() == RemoteComponents.WAITING then
                controller.router:get_active_controller():update_waiting_room(player)
            end
        end

        function controller:set_hole_cards(hole)
            assert(hole[1])
            assert(hole[2])
            controller.hole_cards = hole
            if controller.router:get_active_component() ~= RemoteComponents.NAME_DOG then
                if not betting then
                    betting = RemoteBettingController(router, controller)
                end
                controller:clear_and_set_background("bkg")
                controller.router:set_active_component(RemoteComponents.BETTING)
                controller.router:notify()

                controller.router:get_active_controller():set_hole_cards(hole)
            end

            controller.state = ControllerStates.BETTING
        end
        
        function controller:call_or_check(string)
            ctrl = controller.router:get_active_controller()
            if ctrl ~= betting or not betting then
                return
            end

            betting:call_or_check(string)
        end

---------------On Connected Junk---------------


        number_of_ctrls = number_of_ctrls + 1

        table.insert(active_ctrls, controller)

        if resources then
            for name,resource in pairs(resources) do
                controller:declare_resource(name, resource)
            end
        end
        declare_necessary_resources()
        function controller:on_advanced_ui_ready()
            print("AdvancedUI Ready")
            advanced_ui_ready = true
            local class_table = dofile("advanced_ui/AdvancedUIClasses.lua")
            controller.factory = loadfile("advanced_ui/AdvancedUIAPI.lua")(controller, class_table)
            create_advanced_ui_objects()
            if controller.state == ControllerStates.CHOOSE_DOG
            and character_selection
            and controller.router:get_active_controller() == character_selection then
                character_selection:init_character_selection(
                    router:get_controller(Components.CHARACTER_SELECTION):get_players()
                )
            elseif controller.state == ControllerStates.WAITING then
                controller:waiting_room()
                local players = router:get_controller(Components.GAME):get_players()
                for _,player in pairs(players) do
                    if player.old_controller_id
                    and player.old_controller_id == controller.id then
                        player:add_controller(controller)
                        return
                    end
                end
            end

            -- Add a group to disply popups
            controller.popup_group = controller.factory:Group{size = controller.ui_size}
            controller.screen:add(controller.popup_group)
        end
        router:get_active_controller():add_controller(controller)
        if controller.is_advanced_ui_ready then
            controller:on_advanced_ui_ready()
        end
    end

---------------Controller states---------------

    -- run the on connected for all controllers already connected
    -- before application startup
    function ctrlman:initialize()
        for i,controller in ipairs(controllers.connected) do
            print("adding controller "..controller.name)
            if controller.has_ui then
                controllers:on_controller_connected(controller)
                -- hack to get controllers working that weren't before
                -- TODO: fix hack
                controller:on_advanced_ui_ready()
            end
        end
    end

    -- put all controllers into the choose your dog mode
    function ctrlman:choose_dog(players)
        for i,controller in ipairs(active_ctrls) do
            controller:choose_dog(players)
        end
    end

    function ctrlman:update_choose_dog(player, cntrllr)
        for i,controller in ipairs(active_ctrls) do
            if controller.state == ControllerStates.CHOOSE_DOG
            and controller ~= cntrllr then
                controller:update_choose_dog(player, cntrllr)
            end
        end
    end

    function ctrlman:waiting_room(players)
        for i,controller in ipairs(active_ctrls) do
            if controller.state ~= ControllerStates.WAITING then
                controller:waiting_room(players)
            end
        end
    end

    -- update the waiting room for all controllers
    function ctrlman:update_waiting_room(players)
        print("updating waiting room")
        for i,controller in ipairs(active_ctrls) do
            if controller.state == ControllerStates.WAITING then
                controller:update_waiting_room(players)
            end
        end
    end

    function ctrlman:end_hand()
        for i,controller in ipairs(active_ctrls) do
            if controller.router:get_active_component() == RemoteComponents.BETTING then
                controller.router:get_active_controller():end_hand()
            end
        end
    end

    function ctrlman:enable_on_key_down()
        print("ctlrman enabling on_key_down")
        for i,controller in ipairs(active_ctrls) do
            function controller:on_key_down()
                return true
            end
        end
    end

    function ctrlman:disable_on_key_down()
        print("ctrlman disabling on_key_down")
        for i,controller in ipairs(active_ctrls) do
            function controller:on_key_down()
                return true
            end
        end
    end

    function ctrlman:show_virtual_remote()
        for i,controller in ipairs(active_ctrls) do
            if controller.has_virtual_remote then
                controller:show_virtual_remote()
            end
        end
    end

    function ctrlman:hide_virtual_remote()
        for i,controller in ipairs(active_ctrls) do
            if controller.has_virtual_remote then
                controller:hide_virtual_remote()
            end
        end
    end

    function ctrlman:popup(string)
        assert(string)
        for i,controller in ipairs(active_ctrls) do
            local size = controller.ui_size
            controller.popup_group:add(controller.factory:Rectangle{
                size = size, color = "101010", opacity = 255/2
            })
        end
    end

end)
