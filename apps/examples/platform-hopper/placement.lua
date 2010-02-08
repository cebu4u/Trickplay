--[[
	Platform placement
	------------------
	One critical aspect of the game is placement of the platforms.  A jump must always be possible to move upward.  The platforms must not be too close together.
]]--


function place_new_platform( container, platform_prototype, jump_height )
	-- Find height of the highest platform already placed; new platform can be no higher than this height + jump_height
	local min_height = screen.h
	container:foreach_child(	function (child)
									if child.y < min_height then
										min_height = child.y
									end
								end
							)

	min_height = min_height - jump_height

	local candidate_position = {}

	local fail_count = 0
	-- We need to check that platforms are not too close to each other
	local too_close = false
	while fail_count < 10 do
		candidate_position =
								{
									x = (screen.w - platform_prototype.size[1]) * math.random(),
									y = ((screen.h - min_height) - platform_prototype.size[2]) * math.random() + min_height
								}

		too_close = false
		-- We're too close if we're within a platform width by 5 high of any existing platform
		container:foreach_child(	function (child)
										if (child.x - candidate_position.x)^2 + (child.y - candidate_position.y)^2 <
											(child.w^2 + (5*child.h)^2) then
											too_close=true
										end
									end
								)
		if not too_close then break end
		fail_count = fail_count+1
	end

	if too_close then return false end

	local platform = Clone {
								source = platform_prototype,
								position = { candidate_position.x, candidate_position.y },
							}
	container:add(platform)
end
