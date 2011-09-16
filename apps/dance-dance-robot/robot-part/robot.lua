local robot = Group { name = "robot" }

local Left_Hand = Image { name = "Left_Hand", src = "assets/robot-part/robot/Left_Hand.png" }
Left_Hand.z_rotation = { 0, 0, 0 }
Left_Hand:move_anchor_point(145, 10)

local Left_Foot = Image { name = "Left_Foot", src = "assets/robot-part/robot/Left_Foot.png" }
Left_Foot:move_anchor_point(217, 8)

local Left_Lower_Leg = Image { name = "Left_Lower_Leg", src = "assets/robot-part/robot/Left_Lower_Leg.png" }
Left_Lower_Leg.z_rotation = { 0, 64, 211 }
Left_Lower_Leg:move_anchor_point(52, 6)

local Left_Thigh = Image { name = "Left_Thigh", src = "assets/robot-part/robot/Left_Thigh.png" }
Left_Thigh.z_rotation = { 0, -152, 105 }
Left_Thigh:move_anchor_point(189, 31)

local Left_Hip = Image { name = "Left_Hip", src = "assets/robot-part/robot/Left_Hip.png" }
Left_Hip.z_rotation = { 0, 0, 0 }
Left_Hip:move_anchor_point(217, 60)

local Body_Inside = Image { name = "Body_Inside", src = "assets/robot-part/robot/Body_Inside.png" }
Body_Inside:move_anchor_point(340, 360)

local Pelvis = Image { name = "Pelvis", src = "assets/robot-part/robot/Pelvis.png" }
Pelvis:move_anchor_point(119, 90)

local Pipe_In_Front = Image { name = "Pipe_In_Front", src = "assets/robot-part/robot/Pipe_In_Front.png" }
Pipe_In_Front:move_anchor_point(405, 50)

local Pipe_On_Back = Image { name = "Pipe_On_Back", src = "assets/robot-part/robot/Pipe_On_Back.png" }
Pipe_On_Back:move_anchor_point(21, 16)

local Mouth_Inside = Image { name = "Mouth_Inside", src = "assets/robot-part/robot/Mouth_Inside.png" }
Mouth_Inside:move_anchor_point(117, 50)

local Head = Image { name = "Head", src = "assets/robot-part/robot/Head.png" }
Head.z_rotation = { 0, 0, 0 }
Head:move_anchor_point(800, 594)

local Jaw = Image { name = "Jaw", src = "assets/robot-part/robot/Jaw.png" }
Jaw:move_anchor_point(280, 70)

local Tire = Image { name = "Tire", src = "assets/robot-part/robot/Tire.png" }
Tire:move_anchor_point(332, 290)
z_rotation = { 0, 0, 0 }

local Right_Hip = Image { name = "Right_Hip", src = "assets/robot-part/robot/Right_Hip.png" }
Right_Hip.z_rotation = { 0, 0, 0 }
Right_Hip:move_anchor_point(282, 80)

local Right_Thigh = Image { name = "Right_Thigh", src = "assets/robot-part/robot/Right_Thigh.png" }
Right_Thigh.z_rotation = { 0, 11, 174 }
Right_Thigh:move_anchor_point(80, 40)

local Right_Lower_Leg = Image { name = "Right_Lower_Leg", src = "assets/robot-part/robot/Right_Lower_Leg.png" }
Right_Lower_Leg.z_rotation = { 0, 152, 170 }
Right_Lower_Leg:move_anchor_point(50, 32)

local Right_Foot = Image { name = "Right_Foot", src = "assets/robot-part/robot/Right_Foot.png" }
Right_Foot:move_anchor_point(392, 20)

local Right_Hand = Image { name = "Right_Hand", src = "assets/robot-part/robot/Right_Hand.png" }
Right_Hand:move_anchor_point(260, 60)
Right_Hand.z_rotation = { 0, 0, 0 }

local Shadow = Image { name = "Shadow", src = "assets/robot-part/robot/Shadow.png" }
Shadow:move_anchor_point(Shadow.w/2, Shadow.h/2)

robot.extra.collision_sensor = Rectangle {
                                        name = "collision_sensor",
                                        size = { 600, 800 },
                                        position = { 0, 200 },
                                        color = { 198, 28, 111 },
                                        opacity = 0,
                                    }

robot.extra.states = AnimationState( {
                                        duration = 200,
                                        transitions = {
                                            {
                                                --  These positions done by eyeballing the original
                                                source = "*",
                                                target = "base",
                                                keys = {
                                                    { robot, "y", "EASE_IN_OUT_SINE",                   440, 0, 0 },

                                                    { Right_Foot, "position", "EASE_IN_OUT_SINE",       {   580,  960 }, 0, 0 },
                                                    { Right_Lower_Leg, "position", "EASE_IN_OUT_SINE",  {   430,  790 }, 0, 0 },
                                                    { Right_Lower_Leg, "z_rotation", "EASE_IN_OUT_SINE", 0, 0, 0 },
                                                    { Right_Thigh, "position", "EASE_IN_OUT_SINE",      {   440,  640 }, 0, 0 },
                                                    { Right_Thigh, "z_rotation", "EASE_IN_OUT_SINE",    0, 0, 0 },
                                                    { Right_Hip, "position", "EASE_IN_OUT_SINE",        {   600,  550 }, 0, 0 },
                                                    { Right_Hip, "z_rotation", "EASE_IN_OUT_SINE",      0, 0, 0 },

                                                    { Left_Foot, "position", "EASE_IN_OUT_SINE",        {   140,  910 }, 0, 0 },
                                                    { Left_Lower_Leg, "position", "EASE_IN_OUT_SINE",   {   100,  710 }, 0, 0 },
                                                    { Left_Lower_Leg, "z_rotation", "EASE_IN_OUT_SINE", 0, 0, 0 },
                                                    { Left_Thigh, "position", "EASE_IN_OUT_SINE",       {   240,  640 }, 0, 0 },
                                                    { Left_Thigh, "z_rotation", "EASE_IN_OUT_SINE",     0, 0, 0 },
                                                    { Left_Hip, "position", "EASE_IN_OUT_SINE",         {   400,  500 }, 0, 0 },
                                                    { Left_Hip, "z_rotation", "EASE_IN_OUT_SINE",       0, 0, 0 },

                                                    { Pelvis, "position", "EASE_IN_OUT_SINE",           {   370,  180 }, 0, 0 },
                                                    { Pipe_In_Front, "position", "EASE_IN_OUT_SINE",    {   340,   80 }, 0, 0 },
                                                    { Pipe_On_Back, "position", "EASE_IN_OUT_SINE",     {   440,  360 }, 0, 0 },

                                                    { Body_Inside, "position", "EASE_IN_OUT_SINE",      {   250,  -90 }, 0, 0 },

                                                    { Head, "position", "EASE_IN_OUT_SINE",             {     0,    0 }, 0, 0 },
                                                    { Head, "z_rotation", "EASE_IN_OUT_SINE",           0, 0, 0 },
                                                    { Jaw, "position", "EASE_IN_OUT_SINE",              {   -70,   55 }, 0, 0 },
                                                    { Mouth_Inside, "position", "EASE_IN_OUT_SINE",     {  -164,   83 }, 0, 0 },

                                                    { Left_Hand, "position", "EASE_IN_OUT_SINE",        {    50,  130 }, 0, 0 },
                                                    { Left_Hand, "z_rotation", "EASE_IN_OUT_SINE",      0, 0, 0 },
                                                    { Right_Hand, "position", "EASE_IN_OUT_SINE",       {   420,  -60 }, 0, 0 },
                                                    { Right_Hand, "z_rotation", "EASE_IN_OUT_SINE",     0,               0, 0 },
                                                    { Tire, "position", "EASE_IN_OUT_SINE",             {   420,  -60 }, 0, 0 },
                                                    { Tire, "z_rotation", "EASE_IN_OUT_SINE",           0,               0, 0 },

                                                    { Shadow, "opacity", "EASE_IN_OUT_SINE",            200, 0, 0 },
                                                    { Shadow, "position", "EASE_IN_OUT_SINE",           {   100, 1100 }, 0, 0 },
                                                    { Shadow, "scale", "EASE_IN_OUT_SINE",              {     1,    1 }, 0, 0 },
                                                },
                                            },
                                            {
                                                source = "*",
                                                target = "bounce",
                                                keys = {
                                                    { robot, "y", "EASE_IN_OUT_SINE",                   440, 0, 0 },
                                                    { Shadow, "y", "EASE_IN_OUT_SINE",                  1100, 0, 0 },
                                                    { Shadow, "scale", "EASE_IN_OUT_SINE",              {     1,    1 }, 0, 0 },
                                                    { Shadow, "opacity", "EASE_IN_OUT_SINE",            200, 0, 0 },
                                                    { Head, "position", "EASE_IN_OUT_SINE",             {     0,  -20 }, 0, 0 },
                                                    { Jaw, "position", "EASE_IN_OUT_SINE",              {   -60,    0 }, 0, 0 },
                                                    { Mouth_Inside, "position", "EASE_IN_OUT_SINE",     {  -154,   28 }, 0, 0 },
                                                    { Left_Foot, "position", "EASE_IN_OUT_SINE",        {   140,  910 }, 0, 0 },
                                                    { Left_Hand, "position", "EASE_IN_OUT_SINE",        {    40,  110 }, 0, 0 },
                                                    { Left_Hip, "position", "EASE_IN_OUT_SINE",         {   400,  490 }, 0, 0 },
                                                    { Left_Lower_Leg, "position", "EASE_IN_OUT_SINE",   {   100,  708 }, 0, 0 },
                                                    { Left_Thigh, "position", "EASE_IN_OUT_SINE",       {   240,  630 }, 0, 0 },
                                                    { Pelvis, "position", "EASE_IN_OUT_SINE",           {   370,  160 }, 0, 0 },
                                                    { Pipe_In_Front, "position", "EASE_IN_OUT_SINE",    {   340,   60 }, 0, 0 },
                                                    { Pipe_On_Back, "position", "EASE_IN_OUT_SINE",     {   440,  340 }, 0, 0 },
                                                    { Right_Foot, "position", "EASE_IN_OUT_SINE",       {   580,  960 }, 0, 0 },
                                                    { Right_Hand, "z_rotation", "EASE_IN_OUT_SINE",     10,               0, 0 },
                                                    { Right_Hip, "position", "EASE_IN_OUT_SINE",        {   600,  540 }, 0, 0 },
                                                    { Right_Lower_Leg, "position", "EASE_IN_OUT_SINE",  {   430,  788 }, 0, 0 },
                                                    { Right_Lower_Leg, "z_rotation", "EASE_IN_OUT_SINE", 0, 0, 0 },
                                                    { Right_Thigh, "position", "EASE_IN_OUT_SINE",      {   440,  630 }, 0, 0 },
                                                    { Body_Inside, "position", "EASE_IN_OUT_SINE",      {   250, -100 }, 0, 0 },
                                                    { Tire, "z_rotation", "EASE_IN_OUT_SINE",           2,              0, 0 },
                                                },
                                            },
                                            {
                                                source = "*",
                                                target = "crouch",
                                                keys = {
                                                    { robot, "y", "EASE_IN_OUT_SINE",                   440, 0, 0 },

                                                    { Right_Lower_Leg, "z_rotation", "EASE_OUT_SINE", -40, 0, 0 },
                                                    { Right_Thigh, "position", "EASE_OUT_SINE",      {   320,  800 }, 0, 0 },
                                                    { Right_Thigh, "z_rotation", "EASE_OUT_SINE",    40, 0, 0 },
                                                    { Right_Hip, "position", "EASE_OUT_SINE",        {   600,  820 }, 0, 0 },
                                                    { Right_Hip, "z_rotation", "EASE_OUT_SINE",      30, 0, 0 },

                                                    { Left_Lower_Leg, "position", "EASE_OUT_SINE",   {   100,  710 }, 0, 0 },
                                                    { Left_Lower_Leg, "z_rotation", "EASE_OUT_SINE", -40, 0, 0 },
                                                    { Left_Thigh, "position", "EASE_OUT_SINE",       {   100,  730 }, 0, 0 },
                                                    { Left_Thigh, "z_rotation", "EASE_OUT_SINE",     20, 0, 0 },
                                                    { Left_Hip, "position", "EASE_OUT_SINE",         {   300,  750 }, 0, 0 },
                                                    { Left_Hip, "z_rotation", "EASE_OUT_SINE",       20, 0, 0 },

                                                    { Pelvis, "position", "EASE_OUT_SINE",           {   370,  410 }, 0, 0 },
                                                    { Pipe_In_Front, "position", "EASE_OUT_SINE",    {   340,  310 }, 0, 0 },
                                                    { Pipe_On_Back, "position", "EASE_OUT_SINE",     {   440,  590 }, 0, 0 },

                                                    { Body_Inside, "position", "EASE_OUT_SINE",      {   250, 150 }, 0, 0 },

                                                    { Head, "position", "EASE_OUT_SINE",             {     0,  330 }, 0, 0 },
                                                    { Head, "z_rotation", "EASE_OUT_SINE",           -15, 0, 0 },
                                                    { Jaw, "position", "EASE_OUT_SINE",              {   -40,  350 }, 0, 0 },
                                                    { Mouth_Inside, "position", "EASE_OUT_SINE",     {  -134,  378 }, 0, 0 },

                                                    { Left_Hand, "position", "EASE_OUT_SINE",        {    40,  260 }, 0, 0 },
                                                    { Left_Hand, "z_rotation", "EASE_OUT_SINE",      -75, 0, 0 },
                                                    { Right_Hand, "position", "EASE_OUT_SINE",       {   420,  190 }, 0, 0 },
                                                    { Right_Hand, "z_rotation", "EASE_OUT_SINE",     -75,               0, 0 },
                                                    { Tire, "z_rotation", "EASE_OUT_SINE",           -30,              0, 0 },
                                                    { Tire, "position", "EASE_OUT_SINE",             {   420,  190 }, 0, 0 },

                                                    { Shadow, "y", "EASE_OUT_SINE",                  1100, 0, 0 },
                                                    { Shadow, "scale", "EASE_OUT_SINE",              {     1.1,    1.1 }, 0, 0 },
                                                    { Shadow, "opacity", "EASE_OUT_SINE",            220, 0, 0 },
                                                },
                                            },
                                            {
                                                source = "*",
                                                target = "jump",
                                                keys = {
                                                    { robot, "y", "EASE_OUT_QUAD",                   -600, 0, 0 },
                                                    { Shadow, "y", "EASE_OUT_QUAD",                  3180, 0, 0 },
                                                    { Shadow, "scale", "EASE_OUT_QUAD",              {     0.25,    0.25 }, 0, 0 },
                                                    { Shadow, "opacity", "EASE_OUT_QUAD",            100, 0, 0 },
                                                },
                                            },
                                            {
                                                source = "jump",
                                                target = "hover",
                                                duration = 3000,
                                                keys = {
                                                    { robot, "y", "LINEAR",                   -600, 0, 0 },
                                                    { Shadow, "y", "LINEAR",                  3180, 0, 0 },
                                                    { Shadow, "scale", "LINEAR",              {     0.25,    0.25 }, 0, 0 },
                                                    { Shadow, "opacity", "LINEAR",            100, 0, 0 },
                                                },
                                            },
                                            {
                                                source = "*",
                                                target = "fall",
                                                keys = {
                                                    { robot, "y", "EASE_IN_QUAD",                   0, 0, 0 },
                                                    { Shadow, "y", "EASE_IN_QUAD",                  1980, 0, 0 },
                                                    { Shadow, "scale", "EASE_IN_QUAD",              {     0.25,    0.25 }, 0, 0 },
                                                    { Shadow, "opacity", "EASE_IN_QUAD",            100, 0, 0 },
                                                },
                                            },
                                        },
})

robot.extra.sequence = {
                            'base',
                            'bounce',
                            'base',
                            'bounce',
                            'base',
                            'bounce',
                            'base',
                            'crouch',
                            'base',
                            'jump',
                            'hover',
                            'fall',
                            'base',
                            'crouch'
                        }
robot.extra.current_pos = 1

-- Dummy callback which should be replaced by caller
function robot.extra:score_callback()
    print("You're supposed to replace this function with something that records a score")
end

local did_collide = false
function robot.extra:collision()
    mediaplayer:play_sound("assets/robot-part/audio/puck_bad-1.mp3")
    did_collide = true
end

function robot.extra:next_position()
    robot.extra.current_pos = (robot.current_pos % #robot.sequence) + 1
    robot.states.state = robot.sequence[robot.current_pos]
    if(robot.sequence[robot.current_pos] == "hover") then
        robot:hover()
    elseif(robot.sequence[robot.current_pos] == "jump") then
        mediaplayer:play_sound("assets/robot-part/audio/Robot_Takeoff.mp3")
        did_collide = false
    end
end

function robot.states:on_completed()
    if(not did_collide and robot.current_pos == #robot.sequence) then
        robot:score_callback()
    end
    robot:next_position()
end

local robot_x_positions = {
                                screen.w  * 2/10,
                                screen.w  * 1/2,
                                screen.w  * 8/10
                            }

function robot.extra:hover()
    local sequence = {
                        math.random(1,3),
                        math.random(1,3),
                        math.random(1,3),
                        math.random(1,3)
                    }
    local cur = 1

    local animator = AnimationState( {
                                    duration = 600,
                                    transitions = {
                                                    {
                                                        source = "*",
                                                        target = "1",
                                                        keys = {
                                                            { self, "x", "EASE_IN_OUT_SINE", robot_x_positions[1], 0, 0 },
                                                        },
                                                    },
                                                    {
                                                        source = "*",
                                                        target = "2",
                                                        keys = {
                                                            { self, "x", "EASE_IN_OUT_SINE", robot_x_positions[2], 0, 0 },
                                                        },
                                                    },
                                                    {
                                                        source = "*",
                                                        target = "3",
                                                        keys = {
                                                            { self, "x", "EASE_IN_OUT_SINE", robot_x_positions[3], 0, 0 },
                                                        },
                                                    },
                                                },
                                })
    animator.on_completed = function()
        cur = cur + 1
        if(cur <= #sequence) then
            animator.state = sequence[cur]
        else
            cur = 1
        end
    end

    animator.state = math.random(1,3)
end

robot.states:warp(robot.sequence[robot.current_pos])
robot:next_position()

robot:add(Shadow)
robot:add(Left_Hand)
robot:add(Left_Foot)
robot:add(Left_Lower_Leg)
robot:add(Left_Thigh)
robot:add(Left_Hip)
robot:add(Body_Inside)
robot:add(Pipe_On_Back)
robot:add(Pelvis)
robot:add(Pipe_In_Front)
robot:add(Tire)
robot:add(Mouth_Inside)
robot:add(Head)
robot:add(Jaw)
robot:add(Right_Hip)
robot:add(Right_Foot)
robot:add(Right_Lower_Leg)
robot:add(Right_Thigh)
robot:add(Right_Hand)
robot:add(robot.collision_sensor)

robot.scale = { 1/2, 1/2 }
robot.position = { robot_x_positions[2], 440 }


return robot