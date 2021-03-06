local TIME = 300
local MODE = "EASE_OUT_QUAD"

--realPrint = print
--print = function() end
--local print = function() end --realPrint

HandPresentation = Class(nil,function(pres, ctrl)
    local ctrl = ctrl
    local all_cards = {}
    local burn_cards = {}
    local showdown_elements = {}

    local pot_chips = nil
    
    assetman:load_image("assets/UI/new/pot_glow.png", "pot_glow")
    local pot_glow_clone = assetman:get_clone("pot_glow",
        {opacity = 0, position = {839, 627}})
    local pot_text = assetman:create_text{
        font = PLAYER_ACTION_FONT,
        color = Colors.WHITE,
        text = "",
        position = {
            CHIP_COLLECTION_POSITIONS.POT[1] + 40,
            CHIP_COLLECTION_POSITIONS.POT[2] + 60
        }
    }
    function pot_text.on_text_changed()
        pot_text.anchor_point = {pot_text.w/2, pot_text.h/2}
    end

    screen:add(pot_glow_clone, pot_text)

    -------------------------LOCAL FUNCTIONS--------------------------

    local function create_pot_chips()
    print("pot_chips created")
        if not pot_chips then
            pot_chips = ChipCollection("POT")
            screen:add(pot_chips.group)
            pot_chips:set(0)
            pot_chips.group:raise_to_top()
        else
            pot_chips:dealloc()
            pot_chips = nil
            create_pot_chips()
        end
    end
   
    -- Create a burn card
    local function create_burn_card()
        local burn = Card(Ranks.TWO, Suits.HEARTS)
        table.insert(burn_cards, burn)
        burn.group.position = CARD_LOCATIONS.DECK
        screen:add(burn.group)
        burn.group:animate{
            position = {1145 + math.random(-1, 1), 647 + math.random(-1, 1)},
            mode = MODE,
            duration = TIME,
            z_rotation = math.random(-5, 5),
        }
    end
   
    -- Remove burn cards
    local function remove_burn_cards()
        for _,card in pairs(burn_cards) do
            card:dealloc()
        end
      
        burn_cards = {}
    end

    -- Remove player chips
    local function remove_player_chips(player)
        if player.bet_chips then
            player.bet_chips:dealloc()
            player.bet_chips = nil
        end
    end
   
   -- Remove chips for all players
   local function remove_all_chips()
      for player,bet in pairs(ctrl:get_player_bets()) do
         remove_player_chips(player)
      end
   end
   
   -- Add player chips
    local function add_player_chips(player)
        remove_player_chips(player)
        player.bet_chips = ChipCollection()
        player.bet_chips.group.position = {
            STATUS_CHIP_POSITIONS[player.table_position][1] + 55,
            STATUS_CHIP_POSITIONS[player.table_position][2]
        }
        screen:add(player.bet_chips.group)
        player.bet_chips.group:raise_to_top()
    end
   
    -- Remove a player's hole cards
    local function remove_player_cards(player)
        local hole_cards = ctrl:get_hole_cards()
        local hole = hole_cards[player]
        if hole then
            for k,card in pairs(hole) do
                card.group:animate{
                    opacity = 0,
                    duration=300,
                    on_completed = function()
                        card.group:unparent()
                        card.group.opacity = 255
                    end
                }
            end
        end
    end
   
    -- Animate all chips to center and add them to the pot
    local function animate_chips_to_center()
        if not pot_chips then create_pot_chips() end

        --[[
        local pots = ctrl:get_pots()
        if #pots > 1 then
            local pot_positions = {}
            -- figure out positions for side pots
            for i = 1,#pots do
                pot_positions[i] = {}
            end
            --send chips to side pots
            for i,pot in ipairs(pots) do
                for player,contribution in pairs(pot.contributions) do
                    remove_player_chips(player)
                    local chips = chipCollection()
                    chips.group.position = Utils.deepcopy(MDBL[player.table_position])
                    chips:set(contribution)
                    chips.group:animate{
                    }
                end
            end
        else
        --]]
            for _, player in pairs( ctrl:get_players() ) do
                if player.bet_chips then
                    player.bet_chips.group:animate{
                        position = CHIP_COLLECTION_POSITIONS.POT,
                        duration=500,
                        mode="EASE_OUT_QUAD",
                        on_completed = function()
                            local to_show_glow = player.bet_chips:value() > 0
                            pot_chips:set(pot_chips:value()
                                + player.bet_chips:value())
                            pot_text.text = "$"..pot_chips:value()

                            -- flash the glow under the pot value text
                            local function show_glow(x)
                                if(x >= 6) then return end
                                    x = x + 1
                                if(x%2 > 0) then
                                    pot_glow_clone:animate{duration=300, opacity=255,
                                    on_completed = function() show_glow(x) end}
                                else
                                    pot_glow_clone:animate{duration=300, opacity=0,
                                    on_completed = function() show_glow(x) end}
                                end
                            end
                            if to_show_glow then show_glow(0) end

                            remove_player_chips(player)
                        end
                    }
                end
            end
        --end
    end

    -- Animate all chips to winner
    local function animate_chips_to_winner(winner)
        print("chips to winner")
        for _,player in pairs(ctrl:get_players()) do
            if player.bet_chips then
                if not winner.bet_chips then error("no winner bet chips", 2) end
                player.bet_chips.group:animate{
                    position = {
                        STATUS_CHIP_POSITIONS[winner.dog_number][1] + 55,
                        STATUS_CHIP_POSITIONS[winner.dog_number][2]
                    },
                    duration = 500,
                    mode = "EASE_OUT_QUAD",
                    on_completed = function()
                        if player ~= winner then
                            winner.bet_chips:set(
                                winner.bet_chips:value() + player.bet_chips:value()
                            )
                            player.bet_chips:set(0)
                        end
                    end
                }
            end
        end
    end

   
    -- Give the pot to a player after he wins
    local function animate_pot_to_player(player)
        -- for the split pots case
        if not (player.is_a and player:is_a(Player)) then
            print("split pot animate")
            -- create a temporary group to store the animating groups
            local temp_group = assetman:create_group({name = "a_temp_group"})
            screen:add(temp_group)
            -- correctly adjust the amount of the pot to the division each player will
            -- receive
            -- TODO: im not sure how safe or accurate this is
            ---[[
            pot_chips:set(math.floor(pot_chips:value()/#player))
            --]]
            -- add it to the temp group
            pot_chips.group:unparent()
            temp_group:add(pot_chips.group)
            pot_chips.group.opacity = 0
            -- create clones and animations
            for _,winner in ipairs(player) do
                local clone = assetman:clone(pot_chips.group, {
                    position = Utils.deepcopy(pot_chips.group.position),
                    name = pot_chips.group.name.."clone"
                })
                temp_group:add(clone)
                clone:animate{ 
                    position = {
                        STATUS_CHIP_POSITIONS[winner.dog_number][1] + 55,
                        STATUS_CHIP_POSITIONS[winner.dog_number][2]
                    },
                    duration = 500,
                    mode = "EASE_OUT_QUAD",
                    callback = function()
                        if winner.bet_chips then
                            winner.bet_chips:set(
                                winner.bet_chips:value() + pot_chips:value()
                            )
                        end
                    end
                }
            end
            -- set the group to temp_group, variable is deleted in another function.
            -- this allows for easy deletion of both the original pot image and the
            -- clones
            pot_chips.group = temp_group
        else
            print("single pot animate")
        -- for any other case
            pot_chips.group:animate{
                position = {
                    STATUS_CHIP_POSITIONS[player.table_position][1] + 55,
                    STATUS_CHIP_POSITIONS[player.table_position][2]
                },
                duration = 500,
                mode = "EASE_OUT_QUAD",
                callback = function()
                    if player.bet_chips then
                        player.bet_chips:set(
                            player.bet_chips:value() + pot_chips:value()
                        )
                    end
                end
            }
        end
    end

    local border_group
    assetman:load_image("assets/help/button-done-on.png", "done_button")
    assetman:load_image("assets/hole-overlay.png", "hole_overlay")
    local function animate_winning_hands()
        for _,card in ipairs(ctrl:get_community_cards()) do
            card.group.opacity = 140
        end
        for _,card in ipairs(ctrl:get_deck()) do
            card.group.opacity = 140
        end
        -- make the place holders for the hands and the text
        if not border_group then
            border_group = assetman:create_group({name = "border_group"})
            local back = Canvas{
                size = {900, 146},
                name = "back_of_border_group"
            }
            back:begin_painting()
            back:set_source_color("024B23")
            back:round_rectangle(0, 0, 720, 146, 15)
            back:set_source_linear_pattern(0, 0, 0, back.h)
            back:add_source_pattern_color_stop(0, "010803")
            back:add_source_pattern_color_stop(1, "024B23")
            back:fill()
            back:finish_painting()
            if back.Image then
                back = back:Image()
            end
            local border = Canvas{
                size = {906, 152},
                name = "border_of_border_group"
            }
            border:begin_painting()
            border:set_source_color("FFFFFF")
            border:round_rectangle(0, 0, 726, 152, 15)
            border:fill()
            border:finish_painting()
            if border.Image then
                border = border:Image()
            end
            border.position = {-3, -3}
            border.opacity = 128

            border_group:add(border, back)
            border_group.opacity = 0
            screen:add(border_group)
        end

        local final_hands = ctrl:get_final_hands()
        local in_hands = ctrl:get_in_hands()
        local hole_cards = ctrl:get_hole_cards()

        local length = 0
        for i,hand in pairs(in_hands) do
            length = length + 1
        end
        local counter = 0
        for player,hand in pairs(in_hands) do
            local player_text = assetman:create_text{
                text = "Player "..player.player_number,
                name = "showdown_player_"..player.player_number,
                x = 685,
                font = WINNER_FONT,
                color = Colors.WHITE,
                opacity = 0
            }
            player_text.anchor_point = {player_text.w/2, player_text.h/2}
            local winner_text
            if final_hands[player] then
                winner_text = assetman:create_text{
                    text = "WINNER!",
                    name = "WINNER!"..tostring(player.player_number),
                    x = 685,
                    font = WINNER_FONT,
                    color = "E4D312",
                    opacity = 0
                }
                winner_text.anchor_point = {winner_text.w/2, winner_text.h/2}
            end
            back_clone = assetman:clone(border_group)
            back_clone.anchor_point = {back_clone.w/2, back_clone.h/2}
            back_clone.x = screen.w/2 + 85
            screen:add(back_clone, player_text, winner_text)
            for i,card in ipairs(hand) do
                local card_group = assetman:create_group{
                    position = Utils.deepcopy(card.group.position)
                }
                local clone = assetman:clone(card.group, {
                    name = "card_clone_"..getCardImageName(card).."_"..i
                })
                card_group.anchor_point = {
                    clone.w/2,
                    clone.h/2
                }
                card_group:add(clone)
                screen:add(card_group)
                if card:equals(hole_cards[player][1])
                or card:equals(hole_cards[player][2]) then
                    local overlay = assetman:get_clone("hole_overlay", {x = 5, y = 92})
                    card_group:add(overlay)
                end
                ---[[
                local x_length_between_centroids = card_group.w + 10
                local y_length_between_centroids = card_group.h + 30
                local total_x_length = x_length_between_centroids*(#hand-1)
                local total_y_length = y_length_between_centroids*(length-1)
                local start_x = screen.w/2 - total_x_length/2
                local start_y = screen.h/2 - total_y_length/2
                local pos = {
                    start_x + (i-1)*x_length_between_centroids + 75,
                    start_y + counter*y_length_between_centroids - 30
                }
                player_text.y = pos[2]
                back_clone.y = pos[2]
                if winner_text then
                    winner_text.y = pos[2] + 20
                    player_text.y = pos[2] - 20
                end
                card_group:animate{
                    position = Utils.deepcopy(pos),
                    duration = TIME,
                    mode = MODE,
                    --z_rotation=-3 + math.random(5),
                    on_completed = function() 
                        card_group:raise_to_top()
                        player_text.opacity = 255
                        if winner_text then winner_text.opacity = 255 end
                    end
                }
                --]]
                table.insert(showdown_elements, card_group)
            end
            local done_button = assetman:get_clone("done_button", {
                position = {screen.w/2, 1030}
            })
            done_button.anchor_point = {done_button.w/2, done_button.h/2}
            screen:add(done_button)
            -- for easy deletion
            table.insert(showdown_elements, player_text)
            table.insert(showdown_elements, done_button)
            if winner_text then
                table.insert(showdown_elements, winner_text)
            end
            table.insert(showdown_elements, back_clone)
            counter = counter + 1
        end
    end

 
   ------------------------- GAME FLOW --------------------------
   
    -- Initialize stuff
    function pres:display_hand()
        mediaplayer:play_sound(SHUFFLE_WAV)
      
        pot_text.text = ""
        pot_glow_clone.opacity = 0
      
        -- Put community cards on the deck
        local cards = ctrl:get_community_cards()
        for i = 5,1,-1 do
            if not cards[i].group.parent then screen:add(cards[i].group) end
            resetCardGroup(cards[i].group)
            cards[i].group.position = CARD_LOCATIONS.DECK
            cards[i].group.z_rotation = {
                -3 + math.random(5),
                cards[i].group.w/2,
                cards[i].group.h/2
            }
        end
      
        -- Put hole cards on the deck
        for player,hole in pairs(ctrl:get_hole_cards()) do
            for _,card in pairs(hole) do
                resetCardGroup(card.group)
                card.group.position = CARD_LOCATIONS.DECK
                table.insert(all_cards, card)
            end
         
            player.status:display()
            --player.status:update( "" )
            player.status:hide_bottom()
            player.dog_view:fade_in()
        end

        create_pot_chips()
        for k,player in pairs(ctrl:get_players()) do
            add_player_chips(player)
        end
      
        -- Initialize SB and BB player chip collections
        local sb_player = ctrl:get_players()[ctrl:get_sb_p()]
        local bb_player = ctrl:get_players()[ctrl:get_bb_p()]
        local player_bets = ctrl:get_player_bets()
        sb_player.bet_chips:set(player_bets[sb_player])
        bb_player.bet_chips:set(player_bets[bb_player])
        router:notify()
    end

    -- Deal community cards
    local function deal_cards(start, finish)
        mediaplayer:play_sound(DEAL_WAV)
        local cards = ctrl:get_community_cards()
        for i = start,(finish or start) do
            if not cards[i].group.parent then
                screen:add(cards[i].group)
            end
            cards[i].group:raise_to_top()
            -- TODO: for some reason i have to put this everywhere
            resetCardGroup(cards[i].group)
            --
            cards[i].group:animate{
                position = CARD_LOCATIONS[i], duration = TIME, mode = MODE,
                z_rotation = -3 + math.random(5),
                on_completed = function()
                    flipCard(cards[i].group)
                end
            }
            print("NOW DEALING CARD", i)
            table.insert(all_cards, cards[i])
        end
    end

    function pres:deal(round)
        if round ~= Rounds.HOLE then
            create_burn_card()
        end
      
        if round == Rounds.HOLE then
            -- Deal hole cards
            mediaplayer:play_sound(DEAL_WAV)
            for player,hole in pairs(ctrl:get_hole_cards()) do
                local offset = 0
                local pos = {
                    PLAYER_CARD_LOCATIONS[player.table_position][1],
                    PLAYER_CARD_LOCATIONS[player.table_position][2]
                }
                if player.controller then
                    player.controller:set_hole_cards(hole)
                end
            
                -- give the player their cards
                for k,card in pairs(hole) do
                    if not card.group.parent then
                        screen:add(card.group)
                    end
                    -- Animate and flip the card if the player is human
                    card.group:animate{
                        x = pos[1] + offset, y = pos[2] + offset,
                        mode = MODE, duration = TIME,
                        z_rotation = 0,
                        on_completed = function()
                            if player.is_human and not player.controller then
                                flipCard(card.group)
                            end
                        end
                    }
                    card.group:raise_to_top()
                    offset = offset + 30
                end
            end
        elseif round == Rounds.FLOP then
            -- Animate chips and deal flop
            deal_cards(1, 3)
        elseif round == Rounds.TURN then
            -- Animate chips and deal turn
            deal_cards(4)
        elseif round == Rounds.RIVER then
            -- Animate chips and deal river
            deal_cards(5)
        end
    end
   
    -- Flip all cards up at the end of the hand
    function pres:all_cards_up()
        for _,card in pairs(all_cards) do
            if not card.group.extra.face then
                flipCard(card.group)
            end
        end
    end
   
    -- End of the game
    function pres:showdown(winners, poker_hand)
        mediaplayer:play_sound(SHOWDOWN_WAV)
        animate_chips_to_center()
        pres:all_cards_up()
        print(poker_hand.name .. " passed to pres:showdown()")

        local won = {}
        for _,winner in ipairs(winners) do
            winner.status:update_text(poker_hand.name)
            won[winner] = true
        end

        for _,player in ipairs(ctrl:get_players()) do
            if not won[player] then
                player.status:hide()
            end
        end
    end
   
    function pres:showdown_animations(winners)
        animate_pot_to_player(winners)
        -- TODO: might want winning hands to animate a bit after pot to player
        animate_winning_hands()
    end

    function pres:clear_showdown()
        for i,element in pairs(showdown_elements) do
            element:dealloc()
        end

        showdown_elements = {}
    end

    -- Clear everything
    function pres:clear_ui()
        pot_text.text = ""
        pot_glow_clone.opacity = 0
        if pot_chips then
            pot_chips:dealloc()
            pot_chips = nil
        end
      
        -- clear cards
        for i,card in ipairs(all_cards) do
            resetCardGroup(card.group)
            --screen:remove(card.group)
            card.group:unparent()
        end
        for i,card in pairs(ctrl:get_community_cards()) do
            resetCardGroup(card.group)
            --screen:remove(card.group)
            card.group:unparent()
        end
        --dumptable(all_cards)
      
        all_cards = {}
      
        -- remove burn cards
        remove_burn_cards()
      
        -- reset bets
        remove_all_chips()

        -- if any showdown_elements are left destroy them
        self:clear_showdown()
    end
   
   -------------------------PLAYER TURNS--------------------------
   
    -- START
    -- This is the players turn, deal with dog animations and chips
    function pres:start_turn(player)
        if not player.bet_chips then add_player_chips(player) end
        assert(player.bet_chips)
   
        player.status:update_text(GET_MYTURN_STRING())
        if DOG_ANIMATIONS then
            local params = DOG_ANIMATIONS[player.dog_number]
            if params and params.name then
                a = Animation(params.dog, params.frames, params.position, params.speed)
            end
        end
      
        player.dog_view:glow_on()
      
        player.status:startFocus()
    end

    -- FOLD
    function pres:fold_player(player)
        local foldtimer = Timer{interval=200}
        function foldtimer.on_timer(t)
            t:stop()
            --remove_player_chips(player)
            remove_player_cards(player)
            --player.status:hide()
            player.status:dim()
            player:dim()
        end

        mediaplayer:play_sound(FOLD_WAV)
        player.status:update_text("Fold")
        foldtimer:start()
    end

    -- CHECK
    function pres:check_player(player)
        mediaplayer:play_sound(CHECK_WAV)
        local bet = ctrl:get_player_bets()[player]
        if not player.bet_chips then add_player_chips(player) end
        player.bet_chips:set(bet)
        player.status:update_text("Check")
    end

    -- CALL
    function pres:call_player(player)
        mediaplayer:play_sound(CALL_WAV)
        local bet = ctrl:get_player_bets()[player]
        if not player.bet_chips then add_player_chips(player) end
        player.bet_chips:set(bet)
        player.status:update_text("Call "..bet)
    end
   
    -- RAISE
    function pres:raise_player(player)
        mediaplayer:play_sound(RAISE_WAV)
        local bet = ctrl:get_player_bets()[player]
        if not player.bet_chips then add_player_chips(player) end
        player.bet_chips:set(bet)
        player.status:update_text("Raise to "..bet)
    end

    -- ALL IN
    function pres:all_in_player(player)
        mediaplayer:play_sound(RAISE_WAV)
        local bet = ctrl:get_player_bets()[player]
        if not player.bet_chips then add_player_chips(player) end
        player.bet_chips:set(bet)
        player.status:update_text(GET_ALLIN_STRING())
    end

    -- FINISH TURN
    function pres:finish_turn(player)
        player.dog_view:glow_off()
        player.status:stopFocus()
    end

    -- SOMEONE LEFT A SEAT
    function pres:remove_player(removed_player)
        if not removed_player then error("no removed_player", 2) end
        local foldtimer = Timer{interval=1}
        function foldtimer.on_timer(t)
            t:stop()
            remove_player_cards(removed_player)
         
            removed_player.status:hide()
            removed_player:fade_out()
        end

        mediaplayer:play_sound(FOLD_WAV)
        foldtimer:start()
    end

    -- EVERYONE ELSE FOLDED
    function pres:win_from_bets(only_player)
        assert(only_player)
        only_player.status:update_text("weaksauce")
        if not only_player.bet_chips then add_player_chips(only_player) end
        animate_pot_to_player(only_player)
        animate_chips_to_winner(only_player)
    end

    -- Betting round over, HandState has been set for next betting round
    function pres:betting_round_over()
        local out = ctrl:get_out_table()
        for _,player in ipairs(ctrl:get_players()) do
            if out[player] then player.status:hide()
            else player.status:hide_bottom() end
        end
        animate_chips_to_center()
    end

end)
