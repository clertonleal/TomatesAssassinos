-------------------------
-- Requires
-------------------------

require "sprite"
require "retinaSupport"
physics = require "physics"
director = require "director"


-------------------------
-- Settings
-------------------------

display.setStatusBar(display.HiddenStatusBar)
system.setIdleTimer(false)
io.output():setvbuf("no")

-- Define music variables
local gameMusic = audio.loadStream( "sounds/sound.mp3" )

-- Play the music
local gameMusicChannel = audio.play( gameMusic, { loops = -1 } )


-------------------------
-- Global Variables
-------------------------

-- Globals to set screen size
_G.W = display.contentWidth
_G.H = display.contentHeight

-- Memory monitor on Console
_G.DEBUGMONITOR = false

-- Global to stop creating zombies at completion or failing
_G.STOPGAME = false

-- Global to access sun collected from everywhere
_G.SUN = 3


-------------------------
-- Memory Warning (iOS only)
-------------------------

local handleLowMemory = function( event )
	print("OS memory warning received!")
end
 
Runtime:addEventListener("memoryWarning", handleLowMemory)


-------------------------
-- Memory Monitor
-------------------------

local monitorMem = function()
    collectgarbage()
    print( "MemUsage: " .. collectgarbage("count") )
    local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
    print( "TexMem:   " .. textMem )
end

if (_G.DEBUGMONITOR) then
	Runtime:addEventListener("enterFrame", monitorMem)
end


-------------------------
-- Timer Cancel
-------------------------

timerStash = {}

cancelAllTimers = function()
    local k, v

    for k,v in pairs(timerStash) do
        timer.cancel( v )
        v = nil; k = nil
    end

    timerStash = nil
    timerStash = {}
end


-------------------------
-- Transition Cancel
-------------------------

transitionStash = {}

cancelAllTransitions = function()
    local k, v

    for k,v in pairs(transitionStash) do
        transition.cancel( v )
        v = nil; k = nil
    end

    transitionStash = nil
    transitionStash = {}
end


-------------------------
-- Main Function
-------------------------

local mainGroup = display.newGroup()

local main = function()
	math.randomseed(os.time())
	mainGroup:insert(director.directorView)
	director:changeScene("loadGame")
	return true
end


-------------------------
-- Mandatory Call
-------------------------

main()