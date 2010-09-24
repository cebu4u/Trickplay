   -- -- getters/setters
   -- function ctrl.get_players(ctrl) return state:get_players() end
   -- function ctrl.get_sb_qty(ctrl) return state:get_sb_qty() end
   -- function ctrl.get_bb_qty(ctrl) return state:get_bb_qty() end
   -- function ctrl.get_dealer(ctrl) return state:get_dealer() end
   -- function ctrl.get_sb_p(ctrl) return state:get_sb_p() end
   -- function ctrl.get_bb_p(ctrl) return state:get_bb_p() end
   -- function ctrl.get_deck(ctrl) return state:get_deck() end


GamePresentation = Class(nil,
function(pres, ctrl)
   local ctrl = ctrl
   local info_bb, info_bb_t, info_sb, info_sb_t, info_grp
   
   -- LOCAL FUNCTIONS
   local function create_pot_chips()
      if not model.potchips then
         model.potchips = chipCollection()
         model.potchips.group.position = model.default_bet_locations.POT
         screen:add(model.potchips.group)
         model.potchips:set(0)
         model.potchips.group:raise_to_top()
      else
         local pot = model.potchips
         pot.group:animate{
            opacity=0,
            duration=300,
            on_completed = function() screen:remove(pot) end
         }
         model.potchips:set(0)
         model.potchips = nil
         
         create_pot_chips()
      end
   end
   
   -- GAME FLOW
   function pres.display_ui(pres)
      -- put sb, bb, dealer markers down, plus player chip stacks
      if not model.dealerchip then
         model.dealerchip = Image{
            src = "assets/Chip_D.png",
            position = MSCL[ model.players[ ctrl:get_dealer() ].table_position ],
            name="dealerchip"
         }
         model.bbchip = Image{
            src = "assets/Chip_BB.png",
            position = MSCL[ model.players[ ctrl:get_bb_p() ].table_position ],
            name="bbchip"
         }
         model.sbchip = Image{
            src = "assets/Chip_SB.png",
            position = MSCL[ model.players[ ctrl:get_sb_p() ].table_position ],
            name="sbchip"
         }
         screen:add(model.dealerchip, model.bbchip, model.sbchip)
      end
      
      -- add the pot chips
      create_pot_chips()
      
      if not model.deck then
         model.deck = ctrl:get_deck()
         for i=#model.deck.cards, #model.deck.cards-7, -1 do
            local g = model.deck.cards[i].group
            g.position = MCL.DECK
            g.z_rotation={math.random(-5, 5), 0, 0}
            screen:add(g)
         end
      end
      
   end

   function pres.finish_hand(pres)

      -- Animate chips
      model.dealerchip:animate{ position = MSCL[ model.players[ctrl:get_dealer()].table_position ], duration = 400, mode="EASE_OUT_QUAD" }
      model.bbchip:animate{ position = MSCL[ model.players[ctrl:get_bb_p()].table_position ], duration = 400, mode="EASE_OUT_QUAD" }
      model.sbchip:animate{ position = MSCL[ model.players[ctrl:get_sb_p()].table_position ], duration = 400, mode="EASE_OUT_QUAD" }
      
      create_pot_chips()
      
      for _, card in ipairs(model.deck.cards) do
         card.group.opacity = 255
      end
      
      -- Reset deck
      for i=#model.deck.cards, #model.deck.cards-7, -1 do
         local g = model.deck.cards[i].group
         g.position = MCL.DECK
         g.z_rotation={math.random(-5, 5), 0, 0}
         if g.parent ~= screen then screen:add(g) end
      end
      
   end

   -- called when either human player no longer detected, or one player left.
   function pres:return_to_main_menu(human_won, reset)
      for _,player in ipairs(model.players) do
         if player.status then player.status:hide() end
         if player.betChips then player.betChips:remove() end
      end

      for _,card in ipairs(model.deck.cards) do
         card.group:unparent()
      end
      model.dealerchip:unparent()
      model.bbchip:unparent()
      model.sbchip:unparent()
      model.potchips.group:unparent()
      info_grp.opacity=0
      info_grp:unparent()
      screen:find_child("TableText"):unparent()
      
      --[[
      local text
      if human_won then
         text = Text{
            text="You win!",
            font="Sans 60px",
            color="FFFFFF",
            position={screen.w/2,400},
            opacity=0
         }
      else
         text = Text{
            text="You lose!",
            font="Sans 60px",
            color="FFFFFF",
            position={screen.w/2,400},
            opacity=0
         }
      end
      text.anchor_point = {text.w/2, text.h/2}
      screen:add(text)
      Popup:new{group = text, time = 3}
      --]]
      
      if not reset then 
         local r = Rectangle{ w=1920, h=1080, opacity = 0, color = "000000"}
         screen:add(r)
         local m
         if human_won then
            m = AssetLoader:getImage("Win",{})
         else
            m = AssetLoader:getImage("Lose",{})
         end
         m.anchor_point = {m.w/2, m.h/2}
         m.position = {screen.w/2, screen.h/2}
         screen:add(m)
      
         Popup:new{group = r, time = 5}
         Popup:new{group = m, time = 5}
      end

   end

   -- called when sb_qty and bb_qty updated
   function pres:update_blinds()
      if not info_grp or info_grp.opacity==0 then
         info_bb = Image{src=model.bbchip.src}
         info_bb_t = Text{position={60,5}, text=tostring(ctrl:get_bb_qty()), color="FFFFFF", font=PLAYER_NAME_FONT}
         info_sb = Image{src=model.sbchip.src,y=30}
         info_sb_t = Text{position={60,35}, text=tostring(ctrl:get_sb_qty()), color="FFFFFF", font=PLAYER_NAME_FONT}
         info_grp = Group{children={info_bb,info_sb,info_bb_t,info_sb_t},position={15,1000}}
         screen:add(info_grp)
      else
         info_bb_t.text = ctrl:get_bb_qty()
         info_sb_t.text = ctrl:get_sb_qty()
      end
   end
end)
