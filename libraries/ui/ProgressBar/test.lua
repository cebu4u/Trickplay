
if not OVERRIDEMETATABLE then dofile("__UTILITIES/OverrideMetatable.lua")   end
if not TYPECHECKING      then dofile("__UTILITIES/TypeChecking.lua")        end
if not TABLEMANIPULATION then dofile("__UTILITIES/TableManipulation.lua")   end
if not CANVAS            then dofile("__UTILITIES/Canvas.lua")              end
if not MISC              then dofile("__UTILITIES/Misc.lua")                end
if not COLORSCHEME       then dofile("__CORE/ColorScheme.lua")              end
if not STYLE             then dofile("__CORE/Style.lua")                    end
if not WIDGET            then dofile("__CORE/Widget.lua")                   end
if not PROGRESSBAR       then dofile("ProgressBar/ProgressBar.lua")         end

local test_group = Group()
--[[
screen:add(test_group)
local tests = {
    function()
        local cr = ClippingRegion()
        test_group:add(cr)
        return ps.image == img and ps.animating == true and ps.duration == 3000
    end,
}

for i,test in ipairs(tests) do
    
    if not test() then print("test "..i.." failed") end
    test_group:clear()
end

test_group:unparent()
--]]






screen:show()


pb1 = ProgressBar()

pb1.progress = 1

screen:add(Rectangle{size=screen.size,color="003300"},pb1)

