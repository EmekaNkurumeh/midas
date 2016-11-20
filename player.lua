local E = require "core.entity"
local player = E:extend()

function player:new(x,y,w,h,static,world,color)
  player.super:new(x,y,w,h,static,world,color)
end

function player:update(dt)
  player.super:update(dt)
  --[[ dx = player.super.xvel
  dy = player.super.yvel + G.gravity
  self.xvel = self.xvel * (1 - math.min(dt * G.friction, 1))
  self.yvel = self.yvel * (1 - math.min(dt * G.friction, 1))
  player.super.x,player.super.y,G.cols,G.len = player.super.world:move(player.super,player.super.x + dx,player.super.y + dy,function(item,other) if other.isSpring then return "bounce" else return "slide" end end)
  for i = 1, G.len do
    local other = G.cols[i].other
    if other.isSpring then
      self:jump(9)
    end
  end --]]
  if juno.keyboard.isDown("right") and player.super.xvel < 100 then
    player.super.xvel = player.super.xvel + player.super.speed * dt
  elseif juno.keyboard.isDown("left") and player.super.xvel > -100 then
    player.super.xvel = player.super.xvel - player.super.speed * dt
  end
end

function player:draw(screen)
  player.super:draw(screen)
end


function player:jump(h)
    player.super.yvel = player.super.yvel - h
end

function player:key(key)
  if key == "x" and player.super.yvel > -100 then
    self:jump(6)
  end
end

return player
