G = {
  title = "midas",
  width = 128,
  height = 128,
  scale = 4,
  debug = true,
  stalker_font = juno.Font.fromFile("data/font/m3x6.ttf",32),
  m3x6_font = juno.Font.fromFile("data/font/m3x6.ttf",16),
  m5x7_font = juno.Font.fromFile("data/font/m3x6.ttf",16),
  gravity = 1.5,
  friction = 7,
  classic = require("lib.classic"),
  coil = require("lib.coil"),
  flux = require("lib.flux"),
  lume = require("lib.lume"),
  stalker = require("lib.stalker"),
  tick = require("lib.tick"),
  bump = require("lib.bump"),
  -- util = require("lib.util"),
}

return {
  title = G.title,
  width = G.width * G.scale,
  height = G.height * G.scale,
}
