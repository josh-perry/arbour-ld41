boxCollision = require("boxCollision")
bump = require("libs/bump/bump")
sti = require("libs/sti/sti")

game = {}

game.init = =>
  @player = require("player")!
  _G.player = @player

  @overlay = love.graphics.newImage("img/overlay.png")

  @initMap("maps/house")

game.draw = =>
  tx = math.floor(@player.position.x - _G.lovebite.width / 2) + 8
  ty = math.floor(@player.position.y - _G.lovebite.height / 2) + 12

  @map\draw(-tx, -ty)

  love.graphics.setColor(1, 1, 1, @player.day*0.25)
  love.graphics.draw(@overlay, 0, 0)

  if @player.currentThought
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(@player.currentThought, 15, 15, _G.lovebite.width - 30, "left")

  love.graphics.setColor(1, 1, 1, 0.8)
  love.graphics.printf("Day: "..@player.day, 10, _G.lovebite.height - 30, _G.lovebite.width - 20, "left")

  if @player.hasFish
    love.graphics.printf("Fish", 10, _G.lovebite.height - 30, _G.lovebite.width - 20, "right")

  if @player.hasWater
    love.graphics.printf("Water", 10, _G.lovebite.height - 50, _G.lovebite.width - 20, "right")

  if @player.hasRod
    love.graphics.printf("Rod", 10, _G.lovebite.height - 70, _G.lovebite.width - 20, "right")

game.keyreleased = (key) =>

game.update = (dt) =>
  @map\update(dt)
  @player\update(dt)

  @player.position.x, @player.position.y, cols, len = @bumpWorld\move(@player, @player.position.x + @player.dx, @player.position.y + @player.dy)

  @player.currentThought = nil

  for k, o in pairs(@map.objects)
    x1, y1 = @player.position.x, @player.position.y
    w1, h1 = 16, 24

    x2, y2 = o.x, o.y
    w2, h2 = o.width, o.height

    colliding = boxCollision(x1, y1, w1, h1, x2, y2, w2, h2)

    if not colliding
      continue

    if o.type == "ThoughtText"
      @player.currentThought = o.properties.thoughtText or "..."
      break
    elseif o.type == "Warp"
      @initMap(o.properties.map, o.properties.x, o.properties.y)
      break

    elseif o.type == "FishingSpot"
      if @player.hasFish or @player.givenFishToday
        @player.currentThought = "I've caught enough for today"
      elseif @player.hasRod
        @player.currentThought = "I can try and catch a fish here"

        if love.keyboard.isDown("z", "space")
          _G.gamestate.switch(_G.gamestates.fishing)
          return
      else
        @player.currentThought = "I could try and catch a fish here if I had my rod"

      break

    elseif o.type == "Rod"
      @player.currentThought = "I can use this to catch fish"

      if love.keyboard.isDown("z", "space")
        @player.hasRod = true
        @map\removeLayer("Rod")
        return

      break

    elseif o.type == "Water"
      @player.currentThought = "There's water in the bucket"

      if love.keyboard.isDown("z", "space")
        @player.hasWater = true
        @map\removeLayer("Water")
        return

      break

    elseif o.type == "Bed"
      @player.currentThought = "I can't sleep yet, I have to take care of her"

      if @player.givenWaterToday and @player.givenFishToday
        @player.currentThought = "I hope tomorrow is better"

        if love.keyboard.isDown("z", "space")
          _G.gamestate.switch(_G.gamestates.sleeping)
          @player.givenWaterToday = false
          @player.givenFishToday = false
          @player.hasWater = false
          @player.hasFish = false

          return

    elseif o.type == "GiveUp"
      @player.currentThought = "..."

      if love.keyboard.isDown("z", "space")
        _G.gamestate.switch(_G.gamestates.sleeping)

    elseif o.type == "Girl"
      if @player.day == 4
        @player.currentThought = "There's no point"

      elseif not @player.givenWaterToday
        @player.currentThought = "She's probably thirsty..."

        if love.keyboard.isDown("z", "space") and @player.hasWater
          @player.givenWaterToday = true
          @player.hasWater = false

      elseif not @player.givenFishToday
        @player.currentThought = "She must be hungry..."

        if love.keyboard.isDown("z", "space") and @player.hasFish
          @player.givenFishToday = true
          @player.hasFish = false
      else
        @player.currentThought = "I need rest"

      break

game.initMap = (mapPath, x, y) =>
  if love.filesystem.getInfo(mapPath.."_day"..@player.day..".lua")
    mapPath = mapPath.."_day"..@player.day..".lua"
  else
    mapPath = mapPath..".lua"

  @bumpWorld = bump.newWorld!
  @map = sti(mapPath, {"bump"})
  @map\bump_init(@bumpWorld)

  layer = @map.layers["Sprites"]
  layer.player = @player

  if x and y
    @player.position.x = x * @map.tilewidth
    @player.position.y = y * @map.tileheight
  else
    for k, o in pairs(@map.objects)
      if o.name == "Player"
        @player.position.x = o.x
        @player.position.y = o.y

  if @player.hasRod and @map.layers["Rod"]
    @map\removeLayer("Rod")

  layer.draw = =>
    @player\draw!

  @bumpWorld\add(@player, @player.position.x, @player.position.y, 8, 12)

return game