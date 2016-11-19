local E = require "core.entity"
local player = E:extend()

function player:new(x,y,w,h,static,world,color)
  player.super:new(x,y,w,h,static,world,color)
end

function player:update(dt)
  player.super:update(dt)
  if juno.keyboard.isDown("right") and player.super.xvel < 100 then player.super.xvel = player.super.xvel + player.super.speed * dt end
  if juno.keyboard.isDown("left") and player.super.xvel > -100 then player.super.xvel = player.super.xvel - player.super.speed * dt end
end

function player:draw(screen)
  player.super:draw(screen)
end

function player:key(key)
  if key == "x" and player.super.yvel > -100 then
    player.super.yvel = player.super.yvel - 6
  end
end

return player
