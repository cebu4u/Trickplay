GridLayer = class(BoardLayer, function(self, duration, grid_width, grid_height, 
                                       grid_rows, grid_cols, parent_group,
                                       table_properties, child_properties)

    self._class_name = "GridLayer"

    -- call base class constructor
    BoardLayer.init(self, duration)

    self.parent_group = parent_group

    self.grid_width  = grid_width
    self.grid_height = grid_height
    self.grid_rows   = grid_rows
    self.grid_cols   = grid_cols

    -- calculate amount of movement per ms
    self.shift_per_ms = BoardLayerConstants.grid_height/duration

    self.child_properties = child_properties 
    self.table_properties = table_properties

    self.group = Group{
        width  = self.grid_width * grid_cols,
        height = self.grid_height * grid_rows
    }

    self.middle_rows_group = Group()
    self.last_rows_group = Group()
    self.group:add(self.middle_rows_group)
    self.group:add(self.last_rows_group)

    Utils.mixin(self.group, table_properties)
    --Utils.mixin(self.middle_rows_group, table_properties)
    --Utils.mixin(self.last_rows_group, table_properties)

    self._child_table = {}
    -- keep track of items in the grid for animation
    for i=1,self.grid_rows do
        self._child_table[i] = {}
    end

    self.rotate_timeline_start = {
        function(...) self:rotateMiddleRows(...) end
    }

    self.rotate_timeline_newframe = {
        function(...) self:animateRows(...) end
    }

    self.rotate_timeline_callbacks = {
        function(...) self:rotateTopRow(...) end,
        function(...) self:rotateLastRow(...) end
    }

    self.parent_group:add(self.group)
end)


function GridLayer:calculateXY(image, x, y)
    local grid_x, grid_y = self.grid_width  * (y-1), self.grid_height * (x - self.num_rotations+1)
    grid_y = grid_y - image.height - self.grid_height
    return grid_x, grid_y
end

function GridLayer:get(row, col)
    assert(row and col, self._class_name .. ":get - invalid row and call")
    --assert(self._child_table[row], "try to index invalid row: " .. row)
    return self._child_table[row] and self._child_table[row][col]
end

function GridLayer:insert(src, row, col, properties)
    local image = Images:load(src, properties)
    if not self._child_table[row] then self._child_table[row] = {} end
    self._child_table[row][col] = image
    image.x, image.y = self:calculateXY(image, row, col)
    local group
    if row ~= self.grid_rows then
        group = self.middle_rows_group
    else 
        group = self.last_rows_group
    end
    group:add(image)
    return image
end

function GridLayer:remove(row, col)
    assert(row and col, self._class_name ..":remove - expects row and col")
    assert(self._child_table[row] and self._child_table[row][col],
           self._class_name .. ":remove - childtable does not contain element for row: "..row ..", col:"..col )
    local image = self._child_table[row][col]
    image:unparent()
    self._child_table[row][col] = nil
end

function GridLayer:animate(properties, row, col, dest_row, dest_col)
    assert(self._child_table[row] and self._child_table[row][col], 
           self._class_name .. ":animate - nothing to animate for row: " .. row .. " col: " .. col)
    assert(properties.duration, self._class_name ..":animate - must have duration!")

    local image = self._child_table[row][col]
    assert(image, self._class_name .. ":animate - must have image to animate!")

    local anim_properties = {}
    Utils.mixin(anim_properties, properties)
    if dest_row and dest_col then 
        if dest_row == self.grid_rows then
            image:unparent()
            self.middle_rows_group:add(image)
        end
        anim_properties.x, anim_properties.y = 
                                    self:calculateXY(image, dest_row, dest_col)
        self._child_table[row][col] = nil
        self._child_table[dest_row][dest_col] = image
    end
    image:animate(anim_properties)
end

function GridLayer:rotateTopRow(timeline, top_row)

    if top_row then
        for i, src in pairs(top_row) do
            local image = self:insert(src, 1, i)
        end
    end

end

function GridLayer:rotateMiddleRows(top_row)

    assert(not self._child_table[self.grid_rows+1],
           self._class_name .. ":rotateMiddleRows - extra row was not removed for row: " .. self.grid_rows+1)
    for i=self.grid_rows+1,2,-1 do
        self._child_table[i] = self._child_table[i-1]
    end

    self._child_table[1] = {}

    self.shift_remaining = self.grid_height

    self.rotation_pixels_left = self.grid_height
end

function GridLayer:rotateLastRow(top_row)

    local last_row = self._child_table[self.grid_rows+1]

    assert(last_row, self._class_name .. ":rotateLastRow - no last row added!")

    self._child_table[self.grid_rows+1] = nil

    if last_row then
        for i, image in pairs(last_row) do
            
           -- assert(image.parent, self._class_name .. ":rotateLastRow - " ..
           --    "trying to remove image that does not belong to a group, row: " ..i)
            if image.parent then
                assert(image.parent == self.last_rows_group, self._class_name .. ":rotateLastRow - " ..
                       "somehow removing image with wrong parent")
		        image:unparent() 
            end
        end
    end
    
    local new_last = self._child_table[self.grid_rows]
    if new_last then
        for i, image in pairs(new_last) do
            image:unparent()
            self.last_rows_group:add(image) 
        end 
    end 
end

function GridLayer:animateRows(timeline, elapsed, progress, top_row)
    local distance = math.floor(self.shift_per_ms * timeline.delta)
    distance = Utils.clamp(0, distance, self.shift_remaining)
    self.group.y = self.group.y + distance
    self.shift_remaining = self.shift_remaining - distance
end

function GridLayer:clear()
    for row=1,#self._child_table do
        for col=1,#self._child_table[row] do
            if self._child_table[row] and self._child_table[row][col] then
                self:remove(row, col)
            end
        end
    end
end
