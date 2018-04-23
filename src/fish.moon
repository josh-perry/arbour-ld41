class Fish
  new: =>
    @position = {x: love.math.random(0, _G.lovebite.width/2), y: love.math.random(100, _G.lovebite.height - 40)}
    @sprite = love.graphics.newImage("img/fish.png")

    @w = @sprite\getWidth!
    @h = @sprite\getHeight!

    @facing = "left"
    @speed = love.math.random(20, 50)

    @lifetime = 0

  draw: =>
    love.graphics.setColor(1, 1, 1)

    xScale = 1

    if @facing == "left"
      xScale = -1

    love.graphics.draw(@sprite, @position.x, @position.y, 0, xScale, 1)

  update: (dt) =>
    @lifetime += dt

    if @onBob
      return

    if @facing == "left"
      @position.x -= @speed * dt

      if @position.x < 10
        @facing = "right"

    elseif @facing == "right"
      @position.x += @speed * dt

      if @position.x > 260
        @facing = "left"

return Fish