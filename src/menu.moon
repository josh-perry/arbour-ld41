menu = {}

menu.draw = =>
  love.graphics.print("menu", 10, 10)

menu.keyreleased = (key) =>
  if key == "space"
    _G.gamestate.switch(_G.gamestates.game)

return menu