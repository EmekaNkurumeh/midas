local Object = require "lib.classic"
local entity = Object:extend()

function entity:new(x,y,w,h,screen,static,world)
  self.x, self.y = x or 0, y or 0
  self.w, self.h = w or 0, h or 0
  self.static = static
  self.screen = screen
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
    self.x = self.x + self.xvel
    self.y = self.y + self.yvel + G.gravity
    self.xvel = self.xvel * (1 - math.min(dt * G.friction, 1))
    self.yvel = self.yvel * (1 - math.min(dt * G.friction, 1))
  end
  if self.xvel ~= 0 or self.yvel ~= 0 then
    self.world:move(self, self.x, self.y)
    -- self.x,self.y = self.world\move(self.,self.x,self.y)
  end
end

function entity:draw()
  self.canvas:setColor(unpack{1,1,1})
  self.canvas:drawRect(0,0,16,16,unpack{.3,.7,.4})
  self.canvas:copyPixels(self.screen,self.x,self.y,nil)
end

function entity:key(key)
  -- body...
end

return entity
