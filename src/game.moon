game = {}

game.draw = =>
  love.graphics.print("fish game", 10, 10)

game.keyreleased = (key) =>
  if key == "space"
    _G.gamestate.switch(_G.gamestates.menu)

return game