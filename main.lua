local flux = require "lib.flux"
local coil = require "lib.coil"
local tick = require "lib.tick"
local stalker = require "lib.stalker"
local bump = require "lib.bump"
local entity = require "core.entity"
local player = require "player"

function juno.onLoad()
  juno.debug.setVisible(G.debug)
  juno.debug.setFocused(G.console)
  G.screen = juno.Buffer.fromBlank(juno.graphics.getSize())
  G.world = bump.newWorld(8)
  G.gs = juno.Buffer.fromFile("data/image/gs.png",16,16)
  G.ply = player(32,0,8,8,false,G.world,{.34,.7,.4})
  G.box = entity(34,64-8,8,13,false,G.world,{1,1,1},G.gs)
  G.box:addAnimation("walk",3,8,13,true)
  G.box:play("walk")
  G.grd = entity(0,64,128,8,true,G.world,{.5,.456,.65})
end

function juno.onUpdate(dt)
  stalker.update(dt)
  coil.update(dt)
  tick.update(dt)
  flux.update(dt)
  G.ply:update(dt)
  G.box:update(dt)
  G.grd:update(dt)
  print(G.box.animation.frame)
end

function juno.onDraw()
  G.screen:drawRect(0,0,256,256,unpack{.23,.23,.23})
  G.ply:draw(G.screen)
  G.grd:draw(G.screen)
  G.box:draw(G.screen)
  juno.graphics.copyPixels(G.screen, 0, 0, nil, G.scale)
  G.screen:clear()
  -- reset for drawing other buffers or whatever
end


function juno.onKeyDown(k)
  player:key(k)
  if k == "tab" then
    if G.debug == true then
      juno.debug.setVisible(false)
      G.debug = false
    elseif G.debug == false then
      juno.debug.setVisible(true)
      G.debug = true
    end
  elseif (k == "right ctrl" or k == "left ctrl") then
    if G.console == true then
      juno.debug.setFocused(false)
      G.console = false
    elseif G.console == false then
      juno.debug.setFocused(true)
      G.console = true
    end
  elseif k == "escape" then
    os.exit()
  end
end
