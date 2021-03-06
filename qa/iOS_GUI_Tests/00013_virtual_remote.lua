
test_description = "Show and hide the Virtual Remote"
test_steps = "View the device."
test_verify = "Verify the remote control displays for 2 seconds then is removed."
test_group = "acceptance"
test_area = "virtual_remote"
test_api = "hide/show_virtual_remote"


function generate_device_image (controller, factory)
	
	local r1 = factory:Rectangle{color = "0070E0", x = 0, y =  0, size = { 40 , 40 }}	
	controller.screen:add(r1)

	local first_stage = false
	local total = 0
 	function idle.on_idle( idle , seconds )
	      total = total + seconds
	      if total > 2 and first_stage == false then
				first_stage = true
				controller:show_virtual_remote()
		  elseif total > 4 and first_stage == true then
			controller:hide_virtual_remote()
			idle.on_idle = nil
			controller.screen:remove(r1)
			first_stage =nil
			r1 = nil
			total =nil
	      end
    end
	
	return nil

end


function generate_match_image (resize_ratio_w, resize_ratio_h)

	local t1 = Text{x = 10 * resize_ratio_w, y = 10 * resize_ratio_h, w = 310 * resize_ratio_w, h = 50 * resize_ratio_h, markup = "A remote control should display.", color = "FFFFFF", font = "Verdana 30px", use_markup = true}

	return t1
end
