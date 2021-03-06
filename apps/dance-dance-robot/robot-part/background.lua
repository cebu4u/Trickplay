local SCREEN_JIGGLE_DISTANCE = 10

local background = Image { src = "assets/robot-part/screen/Background.jpg" }

local ratio = (screen.h + SCREEN_JIGGLE_DISTANCE) / background.h

background.anchor_point = { SCREEN_JIGGLE_DISTANCE/ratio, SCREEN_JIGGLE_DISTANCE/ratio }

background.scale = { ratio, ratio }

local timeline = Timeline { }
local alpha = Alpha { mode = "EASE_IN_OUT_BOUNCE", timeline = timeline }
local path = Path()
path:move_to(0, 0)
path:line_to( SCREEN_JIGGLE_DISTANCE, SCREEN_JIGGLE_DISTANCE * 1/4)
path:line_to(-SCREEN_JIGGLE_DISTANCE, SCREEN_JIGGLE_DISTANCE * 2/4)
path:line_to( SCREEN_JIGGLE_DISTANCE, SCREEN_JIGGLE_DISTANCE * 3/4)
path:line_to(-SCREEN_JIGGLE_DISTANCE, SCREEN_JIGGLE_DISTANCE * 4/4)
path:line_to( SCREEN_JIGGLE_DISTANCE, SCREEN_JIGGLE_DISTANCE * 3/4)
path:line_to(-SCREEN_JIGGLE_DISTANCE, SCREEN_JIGGLE_DISTANCE * 2/4)
path:line_to( SCREEN_JIGGLE_DISTANCE, SCREEN_JIGGLE_DISTANCE * 1/4)
path:line_to(0, 0)

background.extra.jiggle = function(self,duration)
        mediaplayer:play_sound("assets/robot-part/audio/Robot_Landing.mp3")
        timeline.duration = duration
        function timeline:on_new_frame(msecs, progress)
            background.position = path:get_position(alpha.alpha)
        end
        timeline:start()
end

return background
