function juno.onLoad()
  juno.debug.setVisible(true)
  G.title_text = G.m5x7_font:render("Midasx57")
  G.screen = juno.Buffer.fromBlank(juno.graphics.getSize())
  G.world = G.bump.newWorld(cellSize)
  local updates = assert (io.popen ("sh lib/update_libs.sh"))
  for line in updates:lines() do
    print(line)
  end
  updates:close()
end

function juno.onUpdate(dt)
  G.stalker.update(dt)
  G.coil.update(dt)
  G.tick.update(dt)
  G.flux.update(dt)
end

function juno.onDraw()
  G.screen:drawBuffer(G.title_text,(G.width/2)-G.title_text:getWidth()/2,0)
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
