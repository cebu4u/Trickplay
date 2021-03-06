--[[
Filename: Path2.lua
Author: Peter von dem Hagen
Date: January 24, 2011
Description:  Testing clear and add_string_path
--]]


local myTextProperties={font="Sans 38px",color="FF0066",text="It's tricky"}

-- Create a path using add_string_path
local myText1 = Text ( myTextProperties )
test_group:add(myText1)
local path1 = Path()
path1:add_string_path ("M 1400, 700 C 1400,610 1675,610 1675,700")

-- Create a path and then clear it.
local myText2 = Text ( myTextProperties )
test_group:add(myText2)
local path2 = Path()
path2:add_string_path ("M 1300, 400 C 1100,210 1375,210 1375,500")
path2:clear()

local timeline = Timeline
{
	duration = 2000,
	on_new_frame =
		function( timeline , duration , progress )
			myText1.position = path1:get_position( progress )
			myText2.position = path2:get_position( progress )
		end
}

timeline:start()

-- Tests --

-- Create a string path then verify it finishes at the last position.
function test_Path_add_string_path ()
    assert_equal( myText1.position[1] , 1675 , "Result: "..myText1.position[1].." Expected: 1675" )
    assert_equal( myText1.position[2] , 700 ,  "Result: "..myText1.position[2].." Expected: 700" )
end

-- Create a path then use clear to remove it. Verify the final position is 0,0
function test_Path_clear ()
    assert_equal( myText2.position[1] , 0 , "Result: "..myText2.position[1].." Expected: 0" )
    assert_equal( myText2.position[2] , 0 , "Result: "..myText2.position[2].." Expected: 0" )
end


-- Test Tear down --













