-------------------------
-- Mandatory Table
-------------------------

local T = {}


-------------------------
-- Local Variables
-------------------------

T.levelGroup = nil
T.tiles = {}
T.zombies = {}
T.human = nil
T.background = nil
T.startTime = 0
T.endTime = 0
T.zombieTime = 0
T.lastZombieTime = 0


-------------------------
-- Requires
-------------------------

local tileMgr = require "tile"
local zombieMgr = require "zombie"


-------------------------
-- Aux Functions
-------------------------

local createBackground = function()
	T.background = display.newImageRect("image/background.png", _G.W, _G.H, false)
	T.background:setReferencePoint(display.CenterReferencePoint)
	T.background.x = _G.W / 2
	T.background.y = _G.H / 2
	T.levelGroup:insert(T.background)
end

local createTiles = function()
	local tile = nil
	local column = 0
	local row = 0
	local x = 90
	local y = 40

	for row = 1, 5 do
		for column = 1, 7 do
			tile = tileMgr.create(x, y)
			T.tiles[#T.tiles + 1] = tile
			T.levelGroup:insert(tile)
			x = x + 60
		end
		
		x = 90
		y = y + 60
	end
end

local createHuman = function()
    local y = -20;
    for x = 1, 5 do
        T.human = display.newImageRect("image/human.png", 30, 60, false)
        T.human:setReferencePoint(display.CenterReferencePoint)
        T.human.x = 30
        y = y + 60
        T.human.y = y
        T.levelGroup:insert(T.human)
    end
end

local createZombie = function()
	local zombie = zombieMgr.create()
	T.zombies[#T.zombies + 1] = zombie
end

local loadScene = function()
	createBackground()
	createTiles()
	createHuman()
end

local destroyZombies = function()
	for index = 1, #T.zombies do
		zombieMgr.destroy(T.zombies[index])
		T.zombies[index] = nil
	end
	
	if (zombieMgr ~= nil) then
		zombieMgr.destroyMgr()
		zombieMgr = nil
	end
end

local destroyTiles = function()
	for index = 1, #T.tiles do
		tileMgr.destroy(T.tiles[index])
		T.tiles[index] = nil
	end
	
	if (tileMgr ~= nil) then
		tileMgr.destroyMgr()
		tileMgr = nil
	end
end

-------------------------
-- Callable Functions
-------------------------

local refresh = function(gameTime)
	local index = 0
	local zombiesLeft = 0
	
	for index = 1, #T.zombies do
		if (T.zombies[index] ~= nil) then
			zombieMgr.refresh(T.zombies[index], gameTime)
		end
	end	

	if (gameTime <= T.endTime and T.startTime < gameTime and _G.STOPGAME == false) then
		if (T.lastZombieTime < gameTime - T.zombieTime) then
			T.lastZombieTime = gameTime
			createZombie()
		end
	end
	
	if (gameTime >= T.endTime) then
		for index = 1, #T.zombies do
			if (T.zombies[index].body ~= nil) then
				zombiesLeft = zombiesLeft + 1
			end
		end
		
		if (zombiesLeft == 0 and _G.STOPGAME == false) then
			_G.STOPGAME = true
			native.showAlert("PvZ", "YOU WON! THERE ARE NO MORE ZOMBIES LEFT!")
		end
	end
	
end

T.refresh = refresh


-------------------------
-- Mandatory Constructor
-------------------------

local create = function(startTime, endTime, zombieTime)
	physics.start(true)
	physics.setGravity(0, 0)
	T.levelGroup = display.newGroup()
	T.levelGroup.isVisible = false
	T.startTime = startTime
	T.endTime = endTime
	T.zombieTime = zombieTime
	loadScene()
	return T.levelGroup
end

T.create = create


-------------------------
-- Mandatory Destructor
-------------------------

local destroyMgr = function()
end

T.destroyMgr = destroyMgr

local destroy = function()
	physics.stop()
	destroyZombies()
	destroyTiles()
	display.remove(T.levelGroup)
	T.levelGroup = nil
end

T.destroy = destroy


-------------------------
-- Mandatory Return
-------------------------

return T