local _ = require "lib.lume"

local palettes = {
  [ "oldschool"   ] = { "#183442", "#529273", "#ADD794", "#EFFFDE" },
  [ "tweet"       ] = { "#292F33", "#0084B4", "#E5F2F7", "#FFFFFF" },
  [ "7soul"       ] = { "#1A111F", "#9C4CB0", "#95C7E9", "#FCFFFF" },
  [ "retrostark"  ] = { "#34342C", "#70695A", "#AD9B5C", "#ECD893" },
  [ "love"        ] = { "#232323", "#91505A", "#CEB1AF", "#E0D7C3" },
  [ "tokyo"       ] = { "#191919", "#1E5D7C", "#F32860", "#FFFFFF" },
  [ "hacker"      ] = { "#A1FFC0", "#2CAF50", "#052312", "#1F4E34" },
  [ "electro"     ] = { "#FFFFFF", "#FF4D9B", "#151E2F", "#7000FF" },
}
palettes = _.map(palettes, function(x)
  return _.map(x, function(y) return { _.color(y) } end)
end)

function palette.list()
  return _.keys(palettes)
end

return palette
