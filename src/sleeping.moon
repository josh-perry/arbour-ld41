cron = require("libs/cron/cron")

sleeping = {}

sleeping.enter = =>
  @dayTimer = cron.after(3, @nextDay)

sleeping.draw = =>
  if _G.player.day == 1
    love.graphics.printf("no...", 0, _G.lovebite.height/2, _G.lovebite.width, "center")
  elseif _G.player.day == 2
    love.graphics.printf("I can't", 0, _G.lovebite.height/2, _G.lovebite.width, "center")
  elseif _G.player.day == 3
    love.graphics.printf("You have to stop", 0, _G.lovebite.height/2, _G.lovebite.width, "center")
  elseif _G.player.day == 4
    love.graphics.printf("...", 0, _G.lovebite.height/2, _G.lovebite.width, "center")


sleeping.update = (dt) =>
  @dayTimer\update(dt)

sleeping.keypressed = (key) =>

sleeping.nextDay = =>
  if _G.player.day == 4
    love.event.quit!
    return

  _G.gamestate.switch(_G.gamestates.game)
  _G.player.day += 1

return sleeping