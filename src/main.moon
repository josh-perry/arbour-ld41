print("")

log = require("libs/log/log")
lovebite = require("libs/lovebite/lovebite")
sti = require("libs/sti/sti")

setupGlobals = ->
  _G.log = log
  _G.lovebite = lovebite
  _G.gamestates = {
    menu: require("menu"),
    game: require("game")
  }

  _G.gamestate = require("libs/hump.gamestate")

setupScreen = ->
  lovebite\setMode({
    width: 640,
    height: 480,
    scale: 2,
    flags: {
      vsync: false
    }
  })

love.load = ->
  setupScreen!
  setupGlobals!

  _G.gamestate.registerEvents({"update"})
  _G.gamestate.switch(_G.gamestates.menu)

  log.info("Load complete")

love.draw = ->
  lovebite\startDraw!
  love.graphics.setColor(1, 1, 1)

  _G.gamestate.current!\draw!

  lovebite\endDraw!