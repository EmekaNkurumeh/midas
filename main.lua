function juno.onLoad()
  juno.debug.setVisible(true)
  G.screen = juno.Buffer.fromBlank(juno.graphics.getSize())
  G.world = G.bump.newWorld(cellSize)
end

function juno.onUpdate(dt)
  G.stalker.update(dt)
  G.coil.update(dt)
  G.tick.update(dt)
  G.flux.update(dt)
end

function juno.onDraw()
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
  end
end
