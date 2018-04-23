print("")

log = require("libs/log/log")
lovebite = require("libs/lovebite/lovebite")

setupGlobals = ->
  _G.log = log
  _G.lovebite = lovebite
  _G.gamestates = {
    menu: require("menu"),
    game: require("game"),
    fishing: require("fishing"),
    sleeping: require("sleeping"),
  }

  _G.gamestate = require("libs/hump.gamestate")

setupScreen = ->
  lovebite\setMode({
    width: 320,
    height: 240,
    scale: 2,
    flags: {
      vsync: false
    }
  })

love.load = ->
  love.graphics.setDefaultFilter("nearest", "nearest")
  setupScreen!
  setupGlobals!

  love.graphics.setFont(love.graphics.newFont("fonts/hack.fnt"))

  _G.gamestate.registerEvents({"update", "keyreleased", "keypressed"})
  _G.gamestate.switch(_G.gamestates.game)

  log.info("Load complete")

love.draw = ->
  lovebite\startDraw!
  love.graphics.setColor(1, 1, 1)

  _G.gamestate.current!\draw!

  lovebite\endDraw!