
test_description = "Test set_ui_background with the 3 options "
test_steps = "View the device."
test_verify = "Verify the logo image shows Center, then Tile and then Stretch then removes the background ui."
test_group = "acceptance"
test_area = "set_ui_background"
test_api = "set_ui_background"


function generate_device_image (controller, factory)


	controller:declare_resource("logo", "assets/logo.png") 

	local first_stage = false
	local second_stage = false
	local third_stage = false
	local total = 0
 	function idle.on_idle( idle , seconds )
	      total = total + seconds
	      if total > 2 and first_stage == false then
				controller:set_ui_background("logo", "CENTER")
				first_stage = true
		  elseif total > 4 and second_stage == false then
				controller:set_ui_background("logo", "TILE")
				second_stage = true
		  elseif total > 6 and third_stage == false then
				controller:set_ui_background("logo", "STRETCH")
				third_stage = true
 		  elseif total > 8 then
				controller:clear_ui()
				idle.on_idle = nil
				total =nil		
	      end
    end

	return nil
end

function generate_match_image (resize_ratio_w, resize_ratio_h)

	local t1 = Text{x = 10 * resize_ratio_w, y = 10 * resize_ratio_h, w = 310 * resize_ratio_w, h = 50 * resize_ratio_h, markup = "3 backgrounds will display.", color = "FFFFFF", font = "Verdana 30px", use_markup = true}

	return t1
end

