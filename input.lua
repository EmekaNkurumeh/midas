local _ = require "lib.lume"

local bindings = {
  action  = function() end,
  attack  = function() end,
  down    = function() end,
  jump    = function() end,
  left    = function() end,
  right   = function() end,
  select  = function() end,
  up      = function() end
}

local keymap = {
  action  = "up",
  attack  = "c",
  down    = "down",
  jump    = "x",
  left    = {"left",
  right   = {"right"},
  select  = {"return", "space", "x", "k", "c", "j"},
  up      = {"up", "w"},
}


function handler(input)
  local action = bindings[input]
  if action then return action() end
end
