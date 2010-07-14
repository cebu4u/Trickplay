EffectsLayerConstants = {
    effect_properties = {
        width  = 100,
        height = 100
    },
    duration = 75
}

EffectsLayer = class(GridLayer, function(self, ...)

    local speed = BoardLayerConstants.duration
    -- call base class constructor
    GridLayer.init(self, speed, BoardLayerConstants.grid_width,
                                BoardLayerConstants.grid_height, 
                                BarneyConstants.rows, 
                                BarneyConstants.cols, ...) 

    self._class_name = "EffectsLayer"

    self.rotation_delta = 180/BoardLayerConstants.duration
end)

function EffectsLayer:animateRows(timeline, elapsed, progress, top_row)
	GridLayer.animateRows(self, timeline, elapsed, progress, top_row)
	local timeline_ratio = (timeline.delta/self._rotation_duration)
	local new_opacity = math.max(0, self.last_rows_group.opacity - 255*timeline_ratio)
	self.last_rows_group.opacity = new_opacity
    local old_rotation = self.last_rows_group.x_rotation
    --self.last_rows_group.x_rotation = {math.max(-180, old_rotation[1] - self.rotation_delta *timeline.delta), 400, -1}
end

function EffectsLayer:rotateLastRow(top_row)
	GridLayer.rotateLastRow(self, top_row)
    self.last_rows_group.opacity = 255
    --self.last_rows_group.x_rotation = {0, 0, 0}
end

function EffectsLayer:insert(src, row, col)
    assert(row <= self.grid_rows, self._class_name .. ":insert - invalid row")
    GridLayer.insert(self, src, row, col, EffectsLayerConstants.effect_properties)
end

function EffectsLayer:dissolve(row, col, callback)
    local effect_image = self:get(row, col)
    assert(effect_image, "trying to animate effect that DNE!")
    effect_image:animate({
        duration = EffectsLayerConstants.duration,
        opacity = 0,
        on_completed = function ()
            callback()
        end
    }, row, col)   
end
