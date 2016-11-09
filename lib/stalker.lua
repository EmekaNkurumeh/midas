--
-- stalker
--
-- Copyright (c) 2015 emekankurumeh
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--

-- Assumes lume is in the same directory as this file
local lume = require((...):gsub("[^/.\\]+$", "lume"))

local stalker = { _version = "1.0.1" }

local map = function(f, a, ...)
  local t = { }
  for _index_0 = 1, #a do
    local _ = a[_index_0]
    local _i = _index_0
    t[_i] = f(_, ...)
  end
  return t
end


local dir = juno.fs.listDir
local isdir = juno.fs.isDir
local time = juno.time.getTime or os.time
local lastmodified = juno.fs.getModified

local junocallbacknames = {
  "onUpdate",
  "onLoad",
  "onDraw",
  "onMouseMove",
  "onMouseButtonDown",
  "onMouseButtonUp",
  "onKeyDown",
  "onKeyUp",
  "onQuit",
}


function stalker.init()
  stalker.print("Initing stalker")
  stalker.path = "."
  stalker.preswap = function() end
  stalker.postswap = function() end
  stalker.interval = .5
  stalker.protected = true
  stalker.quiet = false
  stalker.lastscan = 0
  stalker.lasterrorfile = nil
  stalker.files = {}
  stalker.funcwrappers = {}
  stalker.junofuncs = {}
  stalker.state = "init"
  lume.each(stalker.getchanged(), stalker.resetfile)
  return stalker
end


function stalker.print(...)
  print("[stalker] " .. lume.format(...))
end


function stalker.listdir(path, recursive, skipdotfiles)
  path = (path == ".") and "" or path
  local function fullpath(x) return path .. "/" .. x end
  local t = {}
  for _, f in pairs(lume.map(dir(path), fullpath)) do
    if not skipdotfiles or not f:match("/%.[^/]*$") then
      if recursive and isdir(f) then
        t = lume.concat(t, stalker.listdir(f, true, true))
      else
        table.insert(t, lume.trim(f, "/"))
      end
    end
  end
  return t
end


function stalker.initwrappers()
  for _, v in pairs(junocallbacknames) do
    stalker.funcwrappers[v] = function(...)
      local args = {...}
      xpcall(function()
        return stalker.junofuncs[v] and stalker.junofuncs[v](unpack(args))
      end, stalker.onerror)
    end
    stalker.junofuncs[v] = juno[v]
  end
  stalker.updatewrappers()
end


function stalker.updatewrappers()
  for _, v in pairs(junocallbacknames) do
    if juno[v] ~= stalker.funcwrappers[v] then
      stalker.junofuncs[v] = juno[v]
      juno[v] = stalker.funcwrappers[v]
    end
  end
end


function stalker.onerror(e, nostacktrace)
  stalker.print("An error occurred; switching to error state")
  stalker.state = "error"

  -- Set up callbacks
  for _, v in pairs(junocallbacknames) do
    juno[v] = function() end
  end

  juno.onUpdate = stalker.update

  juno.onKeyDown = function(k)
    if k == "escape" then
      stalker.print("Exiting...")
      os.exit()
    end
  end

  local canvas = juno.Buffer.fromBlank(juno.graphics.getSize())
  local stacktrace = nostacktrace and "" or lume.trim((debug.traceback("", 2):gsub("\t", "")))
  local msg = lume.format("{1}\n\n{2}", {e, stacktrace})
  local colors = {{255/255, 30/255, 30/255}, {255/255, 240/255, 163/255}, {255/255, 146/255, 181/255}, {255/255, 102/255, 102/255}, {255/255, 205/255, 205/255}}
  canvas:reset()
  juno.graphics.reset()

  juno.onDraw = function()
    local pad = 25
    local width = canvas:getWidth()
    local function drawhr(pos, color1, color2)
      local animpos = lume.smooth(pad, width - pad - 8, lume.pingpong(time()))
      if color1 then canvas:setColor(unpack(color1)) end
      canvas:drawRect(pad, pos, width - pad*2, 1)
      if color2 then canvas:setColor(unpack(color2)) end
      canvas:drawRect(animpos, pos, 8, 1)
    end
    local function drawtext(str, x, y, color)
      canvas:setColor(unpack(color))
      canvas:drawText(juno.Font.fromEmbedded(12),str, x, y)
    end
    juno.graphics.setColor(unpack(colors[1]))
    canvas:clear()

    drawtext("An error has occurred", pad, pad, colors[2])
    drawtext("stalker", width - juno.Font.fromEmbedded(12):getWidth("stalker") -
             pad, pad, colors[4])
    drawhr(pad + 32, colors[4], colors[5])
    drawtext("If you fix the problem and update the file the program will " ..
             "resume", pad, pad + 46, colors[3])
    drawhr(pad + 72, colors[4], colors[5])
    drawtext(msg, pad, pad + 90, colors[5], width - pad * 2)
    juno.graphics.copyPixels(canvas, 0, 0, nil, 1)
    canvas:reset()
  end
end


function stalker.exitinitstate()
  stalker.state = "normal"
  if stalker.protected then
    stalker.initwrappers()
  end
end


function stalker.exiterrorstate()
  stalker.state = "normal"
  for _, v in pairs(junocallbacknames) do
    juno[v] = stalker.funcwrappers[v]
  end
end


function stalker.update()
  if stalker.state == "init" then
    stalker.exitinitstate()
  end
  local diff = time() - stalker.lastscan
  if diff > stalker.interval then
    stalker.lastscan = stalker.lastscan + diff
    local changed = stalker.scan()
    if #changed > 0 and stalker.lasterrorfile then
      local f = stalker.lasterrorfile
      stalker.lasterrorfile = nil
      stalker.hotswapfile(f)
    end
  end
end


function stalker.getchanged()
  local function fn(f)
    return f:match("%.lua$") and stalker.files[f] ~= lastmodified(f)
  end
  return lume.filter(stalker.listdir(stalker.path, true, true), fn)
end


function stalker.modname(f)
  return (f:gsub("%.lua$", ""):gsub("[/\\]", "."))
end


function stalker.resetfile(f)
  stalker.files[f] = lastmodified(f)
end


function stalker.hotswapfile(f)
  stalker.print("Hotswapping '{1}'...", {f})
  if stalker.state == "error" then
    stalker.exiterrorstate()
  end
  if stalker.preswap(f) then
    stalker.print("Hotswap of '{1}' aborted by preswap", {f})
    stalker.resetfile(f)
    return
  end
  local modname = stalker.modname(f)
  local t, ok, err = lume.time(lume.hotswap, modname)
  if ok then
    stalker.print("Swapped '{1}' in {2} secs", {f, t})
  else
    stalker.print("Failed to swap '{1}' : {2}", {f, err})
    if not stalker.quiet and stalker.protected then
      stalker.lasterrorfile = f
      stalker.onerror(err, true)
      stalker.resetfile(f)
      return
    end
  end
  stalker.resetfile(f)
  stalker.postswap(f)
  if stalker.protected then
    stalker.updatewrappers()
  end
end


function stalker.scan()
  if stalker.state == "init" then
    stalker.exitinitstate()
  end
  local changed = stalker.getchanged()
  lume.each(changed, stalker.hotswapfile)
  return changed
end


return stalker.init()
