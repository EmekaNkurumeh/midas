local Object = require "lib.classic"
local entity = Object:extend()

function entity:new(x,y,w,h,static,world,color,buffer)
  self.x, self.y = x or 0, y or 0
  self.w, self.h = w or 0, h or 0
  self.static = static
  if buffer then
    self.buffer = buffer
  else
    self.color = color
  end
  self.world = world
  self.canvas = juno.Buffer.fromBlank(self.w,self.h)
  if not self.static then
    self.speed = 15
    self.xvel = 0
    self.yvel = 0
  end
  self.world:add(self,self.x,self.y,self.w,self.h)

  self.animations = {}
  self.animation = nil
  self.animationTimer = 0
  self.animationFrame = 0

end

function entity:updateMovement(dt)
  if not self.static then
    dx = self.xvel
    dy = self.yvel + G.gravity
    self.xvel = self.xvel * (1 - math.min(dt * G.friction, 1))
    self.yvel = self.yvel * (1 - math.min(dt * G.friction, 1))
    self.x,self.y,G.cols,G.len = self.world:move(self,(self.x + dx)% G.width,(self.y + dy)% G.height)
  end
  
end

-- animation

function entity:addAnimation(name,frames,w,h,loop)
  self.animations[name] = {
    frames = frames,
    w = w,
    h = h,
    loop = loop,
    frame = 0
  }
end
function entity:play(name)
  self.animation = self.animations[name]
end
function entity:stop()
  self.animation = nil
end
function entity:updateAnimation(dt)
  self.animationTimer = self.animationTimer + dt
  if self.animationTimer > .1 then
    self.animation.frame = self.animation.frame + 1
    self.animationTimer = 0
  end
  if self.animation.frame > self.animation.frames and self.animation.loop then
    self.animation.frame = 1
  end
end

function entity:update(dt)
  self:updateMovement(dt)
  if #self.animations > 0 then
    self:updateAnimation(dt)
  end
end

function entity:draw(screen)
  if self.buffer then
    self.canvas:clear()
    self.canvas:drawBuffer(self.buffer,0,0)
  else
    self.canvas:drawRect(0,0,self.w,self.h,unpack(self.color))
  end
  screen:drawBuffer(self.canvas,self.x,self.y)
end

return entity
