PlayerStatusView = Class(View,
function(self, model, args, player,...)
   
   -- Register view
   self._base.init(self,model)
   
   -- Show player info
   self.player = player
   self.show = true
   
   local color
   if player.isHuman then
      color = "Green"
   else
      color = "Black"
   end
   
   self.top = AssetLoader:getImage("Bubble"..color,{})
   self.bottom = AssetLoader:getImage("BubbleGray",{})
   self.bottom_group = Group{y=60}
   self.bottom_group:add(self.bottom)
   
   self.group = Group{ children={self.bottom_group, self.top}, opacity=0, position = MPBL[player.table_position] }
   
   -- Blinking red focus
   self.focus = Group{ children = { AssetLoader:getImage("BubbleRed",{}) }, opacity = 0 }
   self.group:add(self.focus)
   self.popup = Popup:new{
      group = self.focus,
      noRender = true,
      animate_in = {duration=500, opacity=255},
      animate_out = {duration=500, opacity=0},
      loop = true,
      --on_fade_in = function() end,
      --on_fade_out = function() end,
   }
   
   function self:startFocus()
      self.popup:start_loop()
      --self.popup.fade = "in"
      --self.popup:render()
   end
   
   function self:stopFocus()
      self.popup:pause_loop()
      --self.popup.fade = "out"
      --self.popup:render()
   end
   
   -- Player text
   self.title = Text{ font = PLAYER_NAME_FONT, color = Colors.WHITE, text = ""}
   self.title.on_text_changed = function()
      self.title.anchor_point = { self.title.w/2, self.title.h/2 }
      self.title.position = { self.top.w/2, self.top.h/2 }
   end
   self.title.text = "Player "..player.number

   self.action = Text{ font = PLAYER_ACTION_FONT, color = Colors.BLACK, text = GET_IMIN_STRING()}
   self.action.on_text_changed = function()
      self.action.anchor_point = { self.action.w/2, self.action.h/2 }
      self.action.position = { self.bottom.w/2, self.bottom.h/2 + self.bottom.y }
   end
   
   -- Align player attributes
   self.attributes = { self.title, self.action }
   self.group:add(self.title)
   self.bottom_group:add(self.action)
   
   for i,v in ipairs(self.attributes) do
      v.anchor_point = {v.w/2, v.h/2}
   end

   print(#self.group.children)
   screen:add(self.group)
   
   if args then for k,v in pairs(args) do
         self[k] = v
      end
   end
   
   function self:initialize()
      --if self.show then self.group.opacity = 240 end
   end
   
   function self:update(text)
      --if self.show then self.group.opacity = 240 else self.group.opacity = 0 end
      self.title.text = "Player "..player.number.."  $"..self.player.money
      
      if text then
         self.action.text = text 
         self.bottom_group:animate{opacity=255,duration=300, y = 60}
      end
      self.action.anchor_point = {self.action.w/2, self.action.h/2}
      self.action.position = { self.bottom.w/2, self.bottom.h/2 + self.bottom.y }
   end

   function self:hide_bottom()
      self.bottom_group:animate{opacity=0,duration=300, y = 0}
   end
   
   function self:dim()
      self.group.opacity = 100
      --self.show = 2
   end
   
   function self:hide()
      self.group:animate{opacity = 0, duration=300}
      --self.show = 0
   end
   
   function self:display()
      self.group:animate{opacity = 240, duration=300}
      --self.show = 1
   end
   
end)
