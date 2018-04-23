boxCollision = require("boxCollision")

Fish = require("fish")

sti = require("libs/sti/sti")

waterFriction = 20
waterGravity = 20

class Bob
  new: (power) =>
    @dx = -power
    @dy = 20
    @position = {x: 270, y: 40}
    @fishOnBob = nil

  update: (dt) =>
    @position.x += @dx * dt
    @position.y += @dy * dt

    if @position.y > 90 and not @inWater
      @inWater = true
      @dx = 0
      @dy = 10

    if @inWater
      @dx = @dx - (waterFriction * dt)
      @dy = @dy + (waterGravity * dt)

      if @dx < 0
        @dx = 0

      if @dy > waterGravity
        @dy = waterGravity

      if @position.y < 40
        if @fishOnBob
          @caughtFish = true
          return

        @inWater = false
        @lineBroken = true

      if @position.y > 220
        @position.y = 220

    if @position.x > 270
      @position.x = 270

  draw: =>
    love.graphics.circle("fill", @position.x, @position.y, 2)

fishing = {}

fishing.enter = =>
  @map = sti("maps/fishing.lua")
  @fish = @createFish!
  @bob = nil

  layer = @map\addCustomLayer("Fish", 5)
  layer.fish = @fish

  @throwPower = 0

  layer.draw = =>
    for i, v in ipairs(@fish)
      v\draw!

fishing.draw = =>
  @map\draw!

  if @bob
    @bob\draw!
  else
    love.graphics.print("Power", _G.lovebite.width - 120, 20)
    love.graphics.printf(math.floor(@throwPower), 0, 40, _G.lovebite.width - 80, "right")

fishing.update = (dt) =>
  @map\update(dt)

  if @bob
    @bob\update(dt)

    if @bob.caughtFish
      _G.player.hasFish = true
      _G.gamestate.switch(_G.gamestates.game)
    elseif not @bob.fishOnBob
      for i, v in ipairs(@fish)
        if boxCollision(@bob.position.x, @bob.position.y, 1, 1, v.position.x, v.position.y, v.w, v.h)
          @bob.fishOnBob = v
          v.onBob = true

    if @bob.fishOnBob
      @bob.fishOnBob.position.x = @bob.position.x
      @bob.fishOnBob.position.y = @bob.position.y

    if @bob.lineBroken
      @bob = nil

  else
    @throwPower += dt * 50

    if @throwPower > 100
      @throwPower = 0

  for i, v in ipairs(@fish)
    v\update(dt)

fishing.keypressed = (key) =>
  if key == "z" or key == "space"
    if not @bob
      @bob = Bob(@throwPower)
    elseif @bob.inWater
      @bob.dx += 20
      @bob.dy -= 10

fishing.createFish = =>
  f = {}

  for i = 0, 3 - _G.player.day
    table.insert(f, Fish!)

  return f

return fishing