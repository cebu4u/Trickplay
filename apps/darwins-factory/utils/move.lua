-- grid logic

function make_neighbors(y, x)
    return {{y-1, x}, {y+1, x}, {y, x+1}, {y, x-1}}
end

function calculateMoves(depth, y, x)
    local visited = {}
    for i=y-depth-1, y+depth+1 do
        visited[i] = {}
    end
    visited[y][x] = true
    local unique = {{y,x}}
    local function values(depth, y, x)
        for i,v in ipairs(make_neighbors(y, x)) do
            local row, col = unpack(v)
            if depth > 0 and not visited[row][col] then
                visited[row][col] = true
                unique[#unique+1] = {row, col}
                values(depth-1, row, col)
            end
        end
    end
    values(depth, y, x)
    return visited
end

--[[
visited = calculateMoves(2, 3, 3)

for row, cols in pairs(visited) do
    for col, element in pairs(cols) do
        if element then print("row: " .. row .. " col: " .. col) end
    end
end
--]]
--for i,v in ipairs(visited) do
--    print("y: " .. v[1] .. " x: " .. v[2])
--end


--- snap logic
--[[
local grid = {{}}

local to_x,   to_y
local from_x, from_y

for i,v in ipairs(make_neighbors(to_x, to_y)) do
    local x,y = v[1], v[2]
    if grid[x][y] and x ~= from_x and y ~= from_y then
        new_position = v
    end
end     
--]]
