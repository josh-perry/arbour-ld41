print("")

log = require("libs/log/log")
lovebite = require("libs/lovebite/lovebite")
sti = require("libs/sti/sti")

local map

setupGlobals = ->
  _G.log = log
  _G.lovebite = lovebite

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

  map = sti("libs/sti/tests/hex.lua")

  log.info("Load complete")

love.draw = ->
  lovebite\startDraw!
  love.graphics.setColor(1, 1, 1)

  map\draw!

  lovebite\endDraw!

love.update = (dt) ->
  map\update(dt)