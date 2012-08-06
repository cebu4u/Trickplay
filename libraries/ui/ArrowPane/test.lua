
if not OVERRIDEMETATABLE then dofile("__UTILITIES/OverrideMetatable.lua")   end
if not TYPECHECKING      then dofile("__UTILITIES/TypeChecking.lua")        end
if not TABLEMANIPULATION then dofile("__UTILITIES/TableManipulation.lua")   end
if not CANVAS            then dofile("__UTILITIES/Canvas.lua")              end
if not MISC              then dofile("__UTILITIES/Misc.lua")                end
if not COLORSCHEME       then dofile("__CORE/ColorScheme.lua")              end
if not STYLE             then dofile("__CORE/Style.lua")                    end
if not WIDGET            then dofile("__CORE/Widget.lua")                   end
if not BUTTON            then dofile("Button/Button.lua")                   end
if not CLIPPINGREGION    then dofile("ClippingRegion/ClippingRegion.lua")   end
if not LISTMANAGER       then dofile("__UTILITIES/ListManagement.lua")      end
if not LAYOUTMANAGER     then dofile("LayoutManager/LayoutManager.lua")     end
if not ARROWPANE         then dofile("ArrowPane/ArrowPane.lua")             end


ap1 = ArrowPane()

ap2 = ArrowPane{x = 500,virtual_w = 400}

ap2:add(Rectangle{w=1000,h=1000,color="ffff00"},Rectangle{w=100,h=100,color="ff0000"},Rectangle{x = 300,y=300,w=100,h=100,color="00ff00"})
---[[
ap3 = ArrowPane{style = false,x = 1000,virtual_w = 400,virtual_h = 400}
ap3.style.border.colors.default = "00000000"
ap3.style.arrow.colors.default = "009999"
ap3.style.arrow.size = 40
ap3.style.arrow.offset = -45
ap3:add(Rectangle{w=1000,h=1000,color="ffff00"},Rectangle{w=100,h=100,color="ff0000"},Rectangle{x = 300,y=300,w=100,h=100,color="00ff00"})

ap3.virtual_w = 1000
--]]
screen:add(ap1,ap2,ap3)