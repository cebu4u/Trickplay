local g = ... 


local image5 = Image
	{
		src = "/assets/explosion_1.png",
		clip = {0,0,412,301},
		scale = {1,1,0,0},
		x_rotation = {0,0,0},
		y_rotation = {0,0,0},
		z_rotation = {0,0,0},
		anchor_point = {206,150.5},
		name = "image5",
		position = {406,350,0},
		size = {412,301},
		opacity = 0,
		reactive = true,
	}

image5.extra.focus = {}

function image5:on_key_down(key)
	if image5.focus[key] then
		if type(image5.focus[key]) == "function" then
			image5.focus[key]()
		elseif screen:find_child(image5.focus[key]) then
			if image5.on_focus_out then
				image5.on_focus_out()
			end
			screen:find_child(image5.focus[key]):grab_key_focus()
			if screen:find_child(image5.focus[key]).on_focus_in then
				screen:find_child(image5.focus[key]).on_focus_in(key)
			end
			end
	end
	return true
end

image5.extra.reactive = true


local image6 = Image
	{
		src = "/assets/explosion_2.png",
		clip = {0,0,412,301},
		scale = {1,1,0,0},
		x_rotation = {0,0,0},
		y_rotation = {0,0,0},
		z_rotation = {0,0,0},
		anchor_point = {206,150.5},
		name = "image6",
		position = {1698,778,0},
		size = {412,301},
		opacity = 0,
		reactive = true,
	}

image6.extra.focus = {}

function image6:on_key_down(key)
	if image6.focus[key] then
		if type(image6.focus[key]) == "function" then
			image6.focus[key]()
		elseif screen:find_child(image6.focus[key]) then
			if image6.on_focus_out then
				image6.on_focus_out()
			end
			screen:find_child(image6.focus[key]):grab_key_focus()
			if screen:find_child(image6.focus[key]).on_focus_in then
				screen:find_child(image6.focus[key]).on_focus_in(key)
			end
			end
	end
	return true
end

image6.extra.reactive = true


local image7 = Image
	{
		src = "/assets/explosion_3.png",
		clip = {0,0,412,301},
		scale = {1,1,0,0},
		x_rotation = {0,0,0},
		y_rotation = {0,0,0},
		z_rotation = {0,0,0},
		anchor_point = {206,150.5},
		name = "image7",
		position = {1630,282,0},
		size = {412,301},
		opacity = 0,
		reactive = true,
	}

image7.extra.focus = {}

function image7:on_key_down(key)
	if image7.focus[key] then
		if type(image7.focus[key]) == "function" then
			image7.focus[key]()
		elseif screen:find_child(image7.focus[key]) then
			if image7.on_focus_out then
				image7.on_focus_out()
			end
			screen:find_child(image7.focus[key]):grab_key_focus()
			if screen:find_child(image7.focus[key]).on_focus_in then
				screen:find_child(image7.focus[key]).on_focus_in(key)
			end
			end
	end
	return true
end

image7.extra.reactive = true


local image8 = Image
	{
		src = "/assets/explosion_4.png",
		clip = {0,0,412,301},
		scale = {1,1,0,0},
		x_rotation = {0,0,0},
		y_rotation = {0,0,0},
		z_rotation = {0,0,0},
		anchor_point = {206,150.5},
		name = "image8",
		position = {1414,836,0},
		size = {412,301},
		opacity = 0,
		reactive = true,
	}

image8.extra.focus = {}

function image8:on_key_down(key)
	if image8.focus[key] then
		if type(image8.focus[key]) == "function" then
			image8.focus[key]()
		elseif screen:find_child(image8.focus[key]) then
			if image8.on_focus_out then
				image8.on_focus_out()
			end
			screen:find_child(image8.focus[key]):grab_key_focus()
			if screen:find_child(image8.focus[key]).on_focus_in then
				screen:find_child(image8.focus[key]).on_focus_in(key)
			end
			end
	end
	return true
end

image8.extra.reactive = true


local image9 = Image
	{
		src = "/assets/explosion_5.png",
		clip = {0,0,412,301},
		scale = {1,1,0,0},
		x_rotation = {0,0,0},
		y_rotation = {0,0,0},
		z_rotation = {0,0,0},
		anchor_point = {206,150.5},
		name = "image9",
		position = {1450,646,0},
		size = {412,301},
		opacity = 0,
		reactive = true,
	}

image9.extra.focus = {}

function image9:on_key_down(key)
	if image9.focus[key] then
		if type(image9.focus[key]) == "function" then
			image9.focus[key]()
		elseif screen:find_child(image9.focus[key]) then
			if image9.on_focus_out then
				image9.on_focus_out()
			end
			screen:find_child(image9.focus[key]):grab_key_focus()
			if screen:find_child(image9.focus[key]).on_focus_in then
				screen:find_child(image9.focus[key]).on_focus_in(key)
			end
			end
	end
	return true
end

image9.extra.reactive = true


local image10 = Image
	{
		src = "/assets/explosion_6.png",
		clip = {0,0,412,301},
		scale = {1,1,0,0},
		x_rotation = {0,0,0},
		y_rotation = {0,0,0},
		z_rotation = {0,0,0},
		anchor_point = {206,150.5},
		name = "image10",
		position = {1064,782,0},
		size = {412,301},
		opacity = 0,
		reactive = true,
	}

image10.extra.focus = {}

function image10:on_key_down(key)
	if image10.focus[key] then
		if type(image10.focus[key]) == "function" then
			image10.focus[key]()
		elseif screen:find_child(image10.focus[key]) then
			if image10.on_focus_out then
				image10.on_focus_out()
			end
			screen:find_child(image10.focus[key]):grab_key_focus()
			if screen:find_child(image10.focus[key]).on_focus_in then
				screen:find_child(image10.focus[key]).on_focus_in(key)
			end
			end
	end
	return true
end

image10.extra.reactive = true


local image11 = Image
	{
		src = "/assets/explosion_7.png",
		clip = {0,0,412,301},
		scale = {1,1,0,0},
		x_rotation = {0,0,0},
		y_rotation = {0,0,0},
		z_rotation = {0,0,0},
		anchor_point = {206,150.5},
		name = "image11",
		position = {382,754,0},
		size = {412,301},
		opacity = 0,
		reactive = true,
	}

image11.extra.focus = {}

function image11:on_key_down(key)
	if image11.focus[key] then
		if type(image11.focus[key]) == "function" then
			image11.focus[key]()
		elseif screen:find_child(image11.focus[key]) then
			if image11.on_focus_out then
				image11.on_focus_out()
			end
			screen:find_child(image11.focus[key]):grab_key_focus()
			if screen:find_child(image11.focus[key]).on_focus_in then
				screen:find_child(image11.focus[key]).on_focus_in(key)
			end
			end
	end
	return true
end

image11.extra.reactive = true


local image12 = Image
	{
		src = "/assets/explosion_8.png",
		clip = {0,0,412,301},
		scale = {1,1,0,0},
		x_rotation = {0,0,0},
		y_rotation = {0,0,0},
		z_rotation = {0,0,0},
		anchor_point = {206,150.5},
		name = "image12",
		position = {1232,296,0},
		size = {412,301},
		opacity = 0,
		reactive = true,
	}

image12.extra.focus = {}

function image12:on_key_down(key)
	if image12.focus[key] then
		if type(image12.focus[key]) == "function" then
			image12.focus[key]()
		elseif screen:find_child(image12.focus[key]) then
			if image12.on_focus_out then
				image12.on_focus_out()
			end
			screen:find_child(image12.focus[key]):grab_key_focus()
			if screen:find_child(image12.focus[key]).on_focus_in then
				screen:find_child(image12.focus[key]).on_focus_in(key)
			end
			end
	end
	return true
end

image12.extra.reactive = true


local image13 = Image
	{
		src = "/assets/explosion_9.png",
		clip = {0,0,412,301},
		scale = {1,1,0,0},
		x_rotation = {0,0,0},
		y_rotation = {0,0,0},
		z_rotation = {0,0,0},
		anchor_point = {206,150.5},
		name = "image13",
		position = {958,284,0},
		size = {412,301},
		opacity = 0,
		reactive = true,
	}

image13.extra.focus = {}

function image13:on_key_down(key)
	if image13.focus[key] then
		if type(image13.focus[key]) == "function" then
			image13.focus[key]()
		elseif screen:find_child(image13.focus[key]) then
			if image13.on_focus_out then
				image13.on_focus_out()
			end
			screen:find_child(image13.focus[key]):grab_key_focus()
			if screen:find_child(image13.focus[key]).on_focus_in then
				screen:find_child(image13.focus[key]).on_focus_in(key)
			end
			end
	end
	return true
end

image13.extra.reactive = true


local image14 = Image
	{
		src = "/assets/explosion_10.png",
		clip = {0,0,412,301},
		scale = {1,1,0,0},
		x_rotation = {0,0,0},
		y_rotation = {0,0,0},
		z_rotation = {0,0,0},
		anchor_point = {206,150.5},
		name = "image14",
		position = {746,730,0},
		size = {412,301},
		opacity = 0,
		reactive = true,
	}

image14.extra.focus = {}

function image14:on_key_down(key)
	if image14.focus[key] then
		if type(image14.focus[key]) == "function" then
			image14.focus[key]()
		elseif screen:find_child(image14.focus[key]) then
			if image14.on_focus_out then
				image14.on_focus_out()
			end
			screen:find_child(image14.focus[key]):grab_key_focus()
			if screen:find_child(image14.focus[key]).on_focus_in then
				screen:find_child(image14.focus[key]).on_focus_in(key)
			end
			end
	end
	return true
end

image14.extra.reactive = true


local image15 = Image
	{
		src = "/assets/explosion_11.png",
		clip = {0,0,412,301},
		scale = {1,1,0,0},
		x_rotation = {0,0,0},
		y_rotation = {0,0,0},
		z_rotation = {0,0,0},
		anchor_point = {206,150.5},
		name = "image15",
		position = {1118,432,0},
		size = {412,301},
		opacity = 0,
		reactive = true,
	}

image15.extra.focus = {}

function image15:on_key_down(key)
	if image15.focus[key] then
		if type(image15.focus[key]) == "function" then
			image15.focus[key]()
		elseif screen:find_child(image15.focus[key]) then
			if image15.on_focus_out then
				image15.on_focus_out()
			end
			screen:find_child(image15.focus[key]):grab_key_focus()
			if screen:find_child(image15.focus[key]).on_focus_in then
				screen:find_child(image15.focus[key]).on_focus_in(key)
			end
			end
	end
	return true
end

image15.extra.reactive = true


g:add(image5,image6,image7,image8,image9,image10,image11,image12,image13,image14,image15)

return {image5,image6,image7,image8,image9,image10,image11,image12,image13,image14,image15}

