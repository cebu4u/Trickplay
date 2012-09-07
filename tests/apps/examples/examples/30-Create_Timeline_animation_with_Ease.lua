    -- Create the Rectangle to animate
   	movingRect = Rectangle{ position = { -100, 400 },
	                        size = { 100, 100 },
	                        color = { 225, 225, 0, 255 } }

	-- Show it on the screen
	screen:add( movingRect )

	-- Define Interval ranges for animating the Rectangle
	acrossScreen = Interval( -100, 2020 )  -- points along X-axis
	fullCircle   = Interval( 0, 360 )      -- degrees rotation around X-axis

	-- Define an Ease transition for the movement along the X-axis
	-- Note: If desired, a second Ease transition could also be defined and applied in the same manner on the rotation.
	movementEase = Ease( "EASE_IN_OUT_QUAD" )
	
	-- Animate the Rectangle using a Timeline
	movingRect_tl = Timeline{ duration = 5000,  -- 5 seconds
							  loop = true,      -- loop forever

		-- Event handler
		on_new_frame = function( self, msecs, progress )
		
			-- X changes along range specified in acrossScreen and transformed by the movementEase
			movingRect.x = acrossScreen:get_value( movementEase:get_value( progress ) )
			
			-- X rotation around range specified in fullCircle
			movingRect.x_rotation = { fullCircle:get_value( progress ), 0, 0 }
		end
	}
	
	-- Start the Timeline animation
	movingRect_tl:start()

