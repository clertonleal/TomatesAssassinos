-------------------------
-- Mandatory Table
-------------------------

local T = {}
director = require "director"


-------------------------
-- Local Variables
-------------------------


local zombieSheetWalk = sprite.newSpriteSheetRetina("image/zombie.png", 60, 60)
local zombieSheetEat = sprite.newSpriteSheetRetina("image/zombie.png", 60, 60)
local zombieSheetDie = sprite.newSpriteSheetRetina("image/zombie.png", 60, 60)

local zombieSet = sprite.newSpriteMultiSet (
{
	{ sheet = zombieSheetWalk, frames = { 1 } },

    { sheet = zombieSheetEat, frames = { 1 } },
										
    { sheet = zombieSheetDie, frames = { 1 } },
})

sprite.add(zombieSet, "zombieWalk", 1, 1, 600, 0)
sprite.add(zombieSet, "zombieEat", 1, 1, 600, 0)
sprite.add(zombieSet, "zombieDie", 1, 1, 600, 0)


-------------------------
-- Aux Functions
-------------------------

local onTouch = function(self, event)
    print(event)
    print(self)
	if (event.phase == "ended") then
        _G.score = _G.score + 1
        _G.scoreText.text = "Score: " .. _G.score
        self.hits = self.hits - 1
        _G.zombieTime = _G.zombieTime + 20
        return true
	end
end


-------------------------
-- Callable Functions
-------------------------

local refresh = function(zombie, gameTime)
	if (zombie == nil or zombie.body == nil or zombie.x == nil) then
		return
	end
	
	if (zombie.body.eating) then
		zombie.body:setLinearVelocity(0, 0)
	
		if (zombie.lastEatTime < gameTime - zombie.eatTime) then
			zombie.lastEatTime = gameTime
			zombie.body.target.hits = zombie.body.target.hits - 1
			
			if (zombie.body.target.hits == 0) then
				zombie.body:setLinearVelocity(-1, 0)
				zombie.body.eating = false
				zombie.body.target = nil
			end
		end
	else
		
	end

	if (zombie.x <= 60) then
		if (_G.STOPGAME == false) then
			_G.STOPGAME = true
		end
	else
		zombie.x = zombie.body.x
		zombie.y = zombie.initY
		zombie.body.y = zombie.initY
	end

	if (_G.STOPGAME) then
		zombie.body:setLinearVelocity(0, 0)
	end
	
	if (zombie.body.hits == 0) then
		display.remove(zombie.body)
		zombie.body = nil
		display.remove(zombie)
		zombie = nil
	end
end

T.refresh = refresh

-------------------------
-- Mandatory Constructor
-------------------------

local create = function()
	local zombie = sprite.newSprite(zombieSet)
	zombie.definition = definition
	zombie:setReferencePoint(display.CenterReferencePoint)
	zombie.x = 500

	local randomPos = math.random(1, 5)

    if (randomPos == 1) then zombie.y = 40
	elseif (randomPos == 2) then zombie.y = 100
	elseif (randomPos == 3) then zombie.y = 160
	elseif (randomPos == 4) then zombie.y = 220
	elseif (randomPos == 5) then zombie.y = 280 end

	zombie.initY = zombie.y
	zombie.eatTime = 1000
	zombie.lastEatTime = 0

	zombie.body = display.newRect(zombie.x, zombie.y, zombie.width / 2, zombie.height / 1.5)
	zombie.body:setReferencePoint(display.CenterReferencePoint)
	zombie.body.x = zombie.x
	zombie.body.y = zombie.y

	physics.addBody(zombie.body, { density = 0, friction = 0, bounce = 0 })
	
	if (display.contentScaleX == .5) then
		zombie.body.xScale = zombie.body.xScale / 2
		zombie.body.yScale = zombie.body.yScale / 2
	end

	zombie.body.definition = definition
	zombie.body.isVisible = false
	zombie.bodyType = "dynamic"
	zombie.body.isFixedRotation = true
	zombie.body.hits = 1
	zombie.body:setLinearVelocity(-25, 0)
	zombie.body.isSensor = true
	zombie.body.eating = false
	zombie.body.target = nil
	
	zombie.body.touch = onTouch
	zombie:addEventListener("touch", zombie.body)

	return zombie
end

T.create = create


-------------------------
-- Mandatory Destructor
-------------------------

local destroyMgr = function()
	display.remove(T.zombieWalkSet)
	T.zombieWalkSet = nil
	T.zombieWalkSheet:dispose()
	T.zombieWalkSheet = nil
	T.zombieEatSheet:dispose()
	T.zombieEatSheet = nil
	T.zombieDieSheet:dispose()
	T.zombieDieSheet = nil
end

T.destroyMgr = destroyMgr

local destroy = function(zombie)
	if (zombie == nil) then return end
	display.remove(zombie.body)
	zombie.body = nil
display.remove(zombie)
end

T.destroy = destroy


-------------------------
-- Mandatory Return
-------------------------

return T