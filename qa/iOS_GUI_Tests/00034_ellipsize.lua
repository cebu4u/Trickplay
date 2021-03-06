
test_description = "Ellipsize"
test_steps = "View the device"
test_verify = "Verify that that all items have been cleared."
test_group = "acceptance"
test_area = "Text"
test_api = "ellipsize"


function generate_device_image (controller, factory)

	controller:declare_resource("panda", "assets/medium_640x420_panda.jpg")

	local g = controller.factory:Group{ x = 0, y = 0}
	
	local t1 = controller.factory:Text{x = 10, y = 10, w = 250, h = 50, text = "The ellipsize property is applicable to non-editable Text objects only.", color = "FF00FF", font = "Verdana 20px", ellipsize = "END" }

	local t2 = controller.factory:Text{x = 10, y = 100, w = 250, h = 50, text = "The ellipsize property is applicable to non-editable Text objects only.", color = "FF00FF", font = "Verdana 20px", ellipsize = "NONE" }

	g:add(t1, t2)

	return g
end

function generate_match_image (resize_ratio_w, resize_ratio_h)

	local t1 = Text{x = 10 * resize_ratio_w, y = 10 * resize_ratio_h, w = 310 * resize_ratio_w, h = 50 * resize_ratio_h, markup = "The ellipsize property is applicable to non-editable Text objects only.", color = "FFFFFF", font = "Verdana 30px", ellipsize = "END"}

	return t1

end


	
