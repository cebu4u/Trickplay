--[[
Filename: Alpha2.lua
Author: Peter von dem Hagen
Date: January 24, 2011
Description:  Verify that on_alpha is being called.
--]]

local image1 = Image ()
image1.src = "packages/engine_unit_tests/tests/assets/logo.png"
image1.position = { 600, 600 }
test_group:add (image1)

local myTimeline = Timeline ()
myTimeline.duration = 1000

on_alpha_called = false

local alpha5 = Alpha ()
alpha5.timeline = myTimeline

alpha5.on_alpha = function (alpha, progress )
	on_alpha_called = true
end

myTimeline:start()


-- Tests --

-- verify that on_alpha is being called
function test_Alpha_mode_on_alpha ()
	assert_true ( on_alpha_called, "on_alpha not called")
end

-- Test Tear down --












