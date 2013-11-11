module(..., package.seeall)

clean = function()

    Runtime._functionListeners = nil

end

function new()

    local localGroup = display.newGroup()

    local listener = function()

        director:changeScene("game")

    end

    --local btnReload = display.newRoundedRect(20, 20, 100, 50, 5)

    --btnReload:addEventListener('touch', listener)
    timerStash.newTimer = timer.performWithDelay(1000, listener)

    return localGroup

end