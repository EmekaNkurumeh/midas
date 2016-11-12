local flux = require "lib.flux"
local coil = require "lib.coil"
local tick = require "lib.tick"
local stalker = require "lib.stalker"
local bump = require "lib.bump"
local entity = require "core.entity"

function juno.onLoad()
  juno.debug.setVisible(true)
  G.screen = juno.Buffer.fromBlank(juno.graphics.getSize())
  G.world = bump.newWorld(cellSize)
  G.gs = juno.Buffer.fromFile("data/image/gs.png",16,16)
  G.ply = entity(32,0,16,16,G.screen,false,G.world)
  G.grd = entity(0,64,16,64,G.screen,true,G.world)
end

function juno.onUpdate(dt)
  stalker.update(dt)
  coil.update(dt)
  tick.update(dt)
  flux.update(dt)
  G.ply:update(dt)
  G.grd:update(dt)
  printf("Player: (%d,%d)",G.ply.x,G.ply.y)
end

function juno.onDraw()
  -- juno.graphics.setColor(.5,.7,.4)
  G.screen:drawRect(0,0,256,256,unpack{1,1,1})
  -- G.screen:drawRect(0,16,256,56,unpack{1,1,0})
  G.screen:setColor(1,1,1)

  -- G.ply.screen:drawRect(G.ply.x,G.ply.y,16,16,unpack{.3,.7,.4})
  G.ply:draw()
  G.grd.screen:drawRect(G.grd.x,G.grd.y,16,16,unpack{1,0,0})
  G.grd:draw()

  G.screen:drawBuffer(G.gs,0,64)
  juno.graphics.copyPixels(G.screen, 0, 0, nil, G.scale)
  G.screen:clear()
  -- reset for drawing other buffers or whatever
end

function juno.onKeyDown(k)
  if k == "tab" then
    if G.debug == true then
      juno.debug.setVisible(false)
      G.debug = false
    elseif G.debug == false then
      juno.debug.setVisible(true)
      G.debug = true
    end
  elseif k == "escape" then
    os.exit()
  end
end
