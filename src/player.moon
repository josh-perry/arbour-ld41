cron = require("libs/cron/cron")

class Player
  new: =>
    @position = {x: 50, y: 50}
    @sprite = love.graphics.newImage("img/man.png")

    @hasRod = false

    @day = 1

    sw, sh = @sprite\getWidth!, @sprite\getHeight!

    @animations = {
      IdleDown: { love.graphics.newQuad(0, 0, 16, 24, sw, sh) }
      WalkDown: {
        love.graphics.newQuad(16, 0, 16, 24, sw, sh),
        love.graphics.newQuad(32, 0, 16, 24, sw, sh)
      },

      IdleUp: { love.graphics.newQuad(48, 0, 16, 24, sw, sh) }
      WalkUp: {
        love.graphics.newQuad(64, 0, 16, 24, sw, sh),
        love.graphics.newQuad(80, 0, 16, 24, sw, sh)
      },

      IdleRight: { love.graphics.newQuad(96, 0, 16, 24, sw, sh) }
      WalkRight: {
        love.graphics.newQuad(112, 0, 16, 24, sw, sh),
        love.graphics.newQuad(128, 0, 16, 24, sw, sh)
      }

      IdleLeft: { love.graphics.newQuad(144, 0, 16, 24, sw, sh) }
      WalkLeft: {
        love.graphics.newQuad(160, 0, 16, 24, sw, sh),
        love.graphics.newQuad(176, 0, 16, 24, sw, sh)
      }
    }

    @state = "Walk"
    @facing = "Down"

    @currentFrame = 1
    @frameDuration = 0.200
    @frameTimer = cron.every(@frameDuration, @nextFrame, self)

    @walkSpeed = 75

    @dx = 0
    @dy = 0

  draw: =>
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(@sprite, @animations[@currentAnimation][@currentFrame], math.floor(@position.x) - 4,math.floor(@position.y) - 12)

  update: (dt) =>
    @dx = 0
    @dy = 0

    if love.keyboard.isDown("q")
      @walkSpeed = 400
    else
      @walkSpeed = 75

    oldState = @state

    if love.keyboard.isDown("up")
      @facing = "Up"
      @dy -= @walkSpeed * dt
      -- @position.y -= @walkSpeed * dt
      @state = "Walk"
    elseif love.keyboard.isDown("down")
      @facing = "Down"
      @dy += @walkSpeed * dt
      -- @position.y += @walkSpeed * dt
      @state = "Walk"
    elseif love.keyboard.isDown("left")
      @facing = "Left"
      @dx -= @walkSpeed * dt
      -- @position.x -= @walkSpeed * dt
      @state = "Walk"
    elseif love.keyboard.isDown("right")
      @facing = "Right"
      @dx += @walkSpeed * dt
      -- @position.x += @walkSpeed * dt
      @state = "Walk"
    else
      @state = "Idle"

    if @state ~= oldState
      @currentFrame = 1

    @currentAnimation = @state..@facing
    @frameTimer\update(dt)

  nextFrame: =>
    @currentFrame += 1

    if @currentFrame > #@animations[@currentAnimation]
      @currentFrame = 1

return Player