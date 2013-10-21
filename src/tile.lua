-------------------------
-- Mandatory Table
-------------------------

local T = {}


-------------------------
-- Requires
-------------------------

-------------------------
-- Aux Functions
-------------------------

local touchTile = function(event)
	if (event.phase == "began") then
		event.target.selected = true
	end
end


-------------------------
-- Callable Functions
-------------------------

T.refresh = refresh


-------------------------
-- Mandatory Constructor
-------------------------

local create = function(posX, posY)
	local tile = display.newImageRect("image/tile.png", 60, 60, false)
	tile:setReferencePoint(display.CenterReferencePoint)
	tile.x = posX
	tile.y = posY
	tile.selected = false
	tile.enabled = true
	tile:addEventListener("touch", touchTile)
	return tile
end

T.create = create


-------------------------
-- Mandatory Destructor
-------------------------

local destroy = function(tile)
	if (tile == nil) then return end
	display.remove(tile)
	tile = nil
end

T.destroy = destroy


-------------------------
-- Mandatory Return
-------------------------

return T