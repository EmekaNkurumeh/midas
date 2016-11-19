local Object = require "lib.classic"
local entity = Object:extend()

function entity:new(x,y,w,h,static,world,color)
  self.x, self.y = x or 0, y or 0
  self.w, self.h = w or 0, h or 0
  self.static = static
  self.color = color
  self.world = world
  self.canvas = juno.Buffer.fromBlank(self.w,self.h)
  if not self.static then
    self.speed = 15
    self.xvel = 0
    self.yvel = 0
  end
  self.world:add(self,self.x,self.y,self.w,self.h)
end

function entity:update(dt)
  if not self.static then
    dx = self.xvel
    dy = self.yvel + G.gravity
    self.xvel = self.xvel * (1 - math.min(dt * G.friction, 1))
    self.yvel = self.yvel * (1 - math.min(dt * G.friction, 1))
    self.x,self.y,G.cols,G.len = self.world:move(self,self.x + dx,self.y + dy)
  end

end

function entity:draw(screen)
  self.canvas:drawRect(0,0,self.w,self.h,unpack(self.color))
  screen:drawBuffer(self.canvas,self.x,self.y)
end

function entity:key(key)
  -- body...
end

return entity
