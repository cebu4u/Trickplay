local TIME = 300
local MODE = "EASE_OUT_QUAD"

--realPrint = print
--print = function() end
local print = function() end --realPrint

HandPresentation = Class(nil,function(pres, ctrl)
   local ctrl = ctrl
   local allCards = {}
   local burnCards = {}
   
   potText = Text{ font = PLAYER_ACTION_FONT, color = Colors.WHITE, text = "", position = {MDBL.POT[1] + 40, MDBL.POT[2] + 60}}
   function potText.on_text_changed()
      potText.anchor_point = {potText.w/2, potText.h/2}
   end

   screen:add(potText)

   -------------------------LOCAL FUNCTIONS--------------------------
   
   -- Create a burn card
   local function create_burn_card()
      
      local burn = Card( Ranks.TWO, Suits.HEARTS )
      table.insert( burnCards, burn )
      burn.group.position = MCL.DECK
      screen:add( burn.group )
      burn.group:animate{
         position = {1145 + math.random(-1, 1), 647 + math.random(-1, 1)},
         mode=MODE,
         duration=TIME,
         z_rotation = math.random(-5, 5),
      }
      
   end
   
   -- Remove burn cards
   local function remove_burn_cards()
      
      for _, card in pairs(burnCards) do
         screen:remove(card.group)
      end
      
      burnCards = {}
      
   end

   -- Remove player chips
   local function remove_player_chips(player)
      if player.betChips then
         player.betChips:set(0)
         player.betChips.group:unparent()
         player.betChips:remove()
         player.betChips = nil
      end
   end
   
   -- Remove chips for all players
   local function remove_all_chips()
      for player, bet in pairs( ctrl:get_player_bets() ) do
         remove_player_chips(player)
      end
   end
   
   -- Add player chips
   local function add_player_chips(player)
      player.betChips = chipCollection()
      player.betChips.group.position = { MSCL[player.table_position][1] + 55, MSCL[player.table_position][2] }
      screen:add(player.betChips.group)
      player.betChips.group:raise_to_top()
   end
   
   -- Flip all cards up at the end of the hand
   local function all_cards_up()
      for _,card in pairs(allCards) do
         if not card.group.extra.face then
            flipCard(card.group)
         end
      end
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
                  screen:remove(card.group)
                  card.group.opacity = 255
               end
            }
         end
      end
   end
   
   -- Animate all chips to center and add them to the pot
   local function animate_chips_to_center()
      for _, player in pairs( ctrl:get_players() ) do
         if player.betChips then
            player.betChips.group:animate{
               position = model.potchips.group.position,
               duration=500,
               mode="EASE_OUT_QUAD",
               on_completed = function()
                  local to_show_glow = player.betChips:value() > 0
                  model.potchips:set( model.potchips:value() + player.betChips:value() )
                  potText.text = "$"..model.potchips:value()

                  -- flash the glow under the pot value text
                  local function show_glow(x)
                     if(x >= 6) then return end
                     x = x + 1
                     if(x%2 > 0) then
                        pot_glow_img:animate{duration=300, opacity=255,
                           on_completed = function() show_glow(x) end}
                     else
                        pot_glow_img:animate{duration=300, opacity=0,
                           on_completed = function() show_glow(x) end}
                     end
                  end
                  if to_show_glow then show_glow(0) end

                  remove_player_chips(player)
               end
            }
         end
      end
   end

   -- Animate all chips to winner
   local function animate_chips_to_winner(winner)
      for _, player in pairs( ctrl:get_players() ) do
         if player.betChips then
            player.betChips.group:animate{
               position = {
                   MSCL[winner.table_position][1] + 55,
                   MSCL[winner.table_position][2]
               },
               duration=500,
               mode="EASE_OUT_QUAD",
               on_completed = function()
                  if player ~= winner then
                     winner.betChips:set(
                        winner.betChips:value() + player.betChips:value()
                     )
                     player.betChips:set(0)
                  end
               end
            }
         end
      end
   end

   
   -- Give the pot to a player after he wins
   local function animate_pot_to_player(player)
      -- for the split pots case
      if type(player) == "table" then
         -- create a temporary group to store the animating groups
         local temp_group = Group()
         screen:add(temp_group)
         -- correctly adjust the amount of the pot to the division each player will
         -- receive
         model.potchips:set(math.floor(model.potchips:value()/3))
         -- add it to the temp group
         model.potchips.group:unparent()
         temp_group:add(model.potchips.group)
         model.potchips.group.opacity = 0
         -- create clones and animations
         for _,winner in ipairs(player) do
            local clone = Clone{
               source = model.potchips.group,
               position = Utils.deepcopy(model.potchips.group.position)
            }
            temp_group:add(clone)
            clone:animate{ 
               position = {
                   MSCL[winner.table_position][1] + 55,
                   MSCL[winner.table_position][2]
               },
               duration = 500,
               mode="EASE_OUT_QUAD"
            }
         end
         -- set the group to temp_group, variable is deleted in another function.
         -- this allows for easy deletion of both the original pot image and the
         -- clones
         model.potchips.group = temp_group
      else
      -- for any other case
         model.potchips.group:animate{
            position = {
                MSCL[player.table_position][1] + 55,
                MSCL[player.table_position][2]
            },
            duration = 500,
            mode="EASE_OUT_QUAD",
         }
      end
   end
   
   ------------------------- GAME FLOW --------------------------
   
   -- Initialize stuff
   function pres:display_hand()
      mediaplayer:play_sound(SHUFFLE_WAV)
      
      potText.text = ""
      pot_glow_img.opacity = 0
      
      -- Put community cards on the deck
      local cards = ctrl:get_community_cards()
      for i=5,1,-1 do
         cards[i].group.position = MCL.DECK
      end
      
      -- Put hole cards on the deck
      for player,hole in pairs( ctrl:get_hole_cards() ) do
         for _,card in pairs(hole) do
            card.group.position = MCL.DECK
            table.insert(allCards, card)
         end
         
         player.status:display()
--         player.status:update( "" )
         player.status:hide_bottom()
         player:show()

      end
      
      -- Initialize SB and BB player chip collections
      local sb_player = model.players[ ctrl:get_sb_p() ]
      local bb_player = model.players[ ctrl:get_bb_p() ]
      add_player_chips( sb_player )
      add_player_chips( bb_player )
      local player_bets = ctrl:get_player_bets()
      sb_player.betChips:set( player_bets[sb_player] )
      bb_player.betChips:set( player_bets[bb_player] )
      model:notify()
   end

   -- Deal community cards
   local function deal_cards(start, finish)
      mediaplayer:play_sound(DEAL_WAV)
      local cards = ctrl:get_community_cards()
      for i=start,(finish or start) do
         cards[i].group:animate{ position = MCL[i], duration = TIME, mode = MODE, z_rotation=-3 + math.random(5), on_completed = function() flipCard(cards[i].group) end }
         if not cards[i].group.parent then
             screen:add(cards[i].group)
         end
         print("NOW DEALING CARD", i)
         table.insert(allCards, cards[i])
      end
   end

   function pres:deal(round)
      
      if round ~= Rounds.HOLE then
         create_burn_card()
      end
      
      if round == Rounds.HOLE then
         -- Deal hole cards
         mediaplayer:play_sound(DEAL_WAV)
         for player,hole in pairs( ctrl:get_hole_cards() ) do
            
            local offset = 0
            local pos = {MPCL[player.table_position][1], MPCL[player.table_position][2]}
            
            for k,card in pairs(hole) do
               if not card.group.parent then
                   screen:add(card.group)
               end
               -- Animate and flip the card if the player is human
               card.group:animate{x = pos[1] + offset, y = pos[2] + offset, mode=MODE, duration=TIME, z_rotation=0, on_completed = function() if player.isHuman then flipCard(card.group) end end }
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
   
   -- End of the game
   function pres.showdown(pres, winners, poker_hand)
      mediaplayer:play_sound(SHOWDOWN_WAV)
      animate_chips_to_center()
      all_cards_up()
      print(poker_hand.name .. " passed to pres:showdown()")

      local won = {}
      for _,winner in ipairs(winners) do
         winner.status:update( poker_hand.name )
         won[winner] = true
      end

      for _,player in ipairs(ctrl:get_players()) do
         if not won[player] then
            player.status:hide()
         end
      end
      animate_pot_to_player(winners)
      if not game:game_won() then
          local text = Text{
             text="Press ENTER to continue!",
             font="Sans 36px",
             color="FFFFFF",
             position={screen.w/2,400},
             opacity=0
          }
          text.anchor_point = {text.w/2, text.h/2}
          screen:add(text)
          Popup:new{group = text, time = 1500}
      end

   end

   -- Clear everything
   function pres.clear_ui(pres)
      
      potText.text = ""
      pot_glow_img.opacity = 0
      
      -- clear cards
      for i,card in ipairs(allCards) do
         resetCardGroup(card.group)
         print(card.group.parent, screen, card.group.parent==screen)
         if card.group.parent == screen then screen:remove(card.group) end
      end
      
      allCards = {}
      
      -- remove burn cards
      remove_burn_cards()
      
      -- reset bets
      remove_all_chips()

      REMOVE_ALL_DA_CHIPS()
   end
   
   -------------------------PLAYER TURNS--------------------------
   
   -- START
   -- This is the players turn, deal with dog animations and chips
   function pres:start_turn(player)
   
      if not player.betChips then add_player_chips(player) end
      assert(player.betChips)
   
      player.status:update( GET_MYTURN_STRING() )
      local pos = player.table_position
      if DOG_ANIMATIONS then
          local params = DOG_ANIMATIONS[ pos ]
          if params and params.name then
             a = Animation(params.dog, params.frames, params.position, params.speed)
          end
      end
      
      player.glow.opacity = 255
      
      player.status:startFocus()
      
   end

   -- FOLD
   function pres:fold_player(player)
      local foldtimer = Timer{interval=200}
      function foldtimer.on_timer(t)
         t:stop()
--         remove_player_chips(player)
         remove_player_cards(player)
--         player.status:hide()
         player.status:dim()
         player:dim()
      end

      mediaplayer:play_sound(FOLD_WAV)
      player.status:update("Fold")
      foldtimer:start()
   end

   -- CHECK
   function pres:check_player(player)
      mediaplayer:play_sound(CHECK_WAV)
      local bet = ctrl:get_player_bets()[player]
      if not player.betChips then add_player_chips(player) end
      player.betChips:set(bet)
      player.status:update( "Check" )
   end
   -- CALL
   function pres:call_player(player)
      mediaplayer:play_sound(CALL_WAV)
      local bet = ctrl:get_player_bets()[player]
      if not player.betChips then add_player_chips(player) end
      player.betChips:set(bet)
      player.status:update( "Call "..bet )
   end
   
   -- RAISE
   function pres:raise_player(player)
      mediaplayer:play_sound(RAISE_WAV)
      local bet = ctrl:get_player_bets()[player]
      if not player.betChips then add_player_chips(player) end
      player.betChips:set(bet)
      player.status:update( "Raise to "..bet )
   end

   -- ALL IN
   function pres:all_in_player(player)
      mediaplayer:play_sound(RAISE_WAV)
      local bet = ctrl:get_player_bets()[player]
      if not player.betChips then add_player_chips(player) end
      player.betChips:set(bet)
      player.status:update( GET_ALLIN_STRING() )
   end

   -- FINISH TURN
   function pres:finish_turn(player)
      player.glow.opacity = 0
      player.status:stopFocus()
   end

   -- SOMEONE LEFT A SEAT
   function pres:remove_player(removed_player)
      local foldtimer = Timer{interval=1}
      function foldtimer.on_timer(t)
         t:stop()
         remove_player_cards(removed_player)
         
         removed_player.status:hide()
         removed_player:hide()
      end

      mediaplayer:play_sound(FOLD_WAV)
      foldtimer:start()
   end

   -- EVERYONE ELSE FOLDED
   function pres:win_from_bets(only_player)
      assert(only_player)
      only_player.status:update( "weaksauce" )
      animate_pot_to_player( only_player )
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
