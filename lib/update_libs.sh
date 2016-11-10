#!/bin/bash

# Downloads the current version of all the libs

echo "Downloading libs..."

wget -nv -N "https://raw.githubusercontent.com/rxi/classic/master/classic.lua"
wget -nv -N "https://raw.githubusercontent.com/rxi/coil/master/coil.lua"
wget -nv -N "https://raw.githubusercontent.com/rxi/flux/master/flux.lua"
# wget -nv -N "https://raw.githubusercontent.com/rxi/log.lua/master/log.lua"
wget -nv -N "https://raw.githubusercontent.com/rxi/lume/master/lume.lua"
wget -nv -N "https://raw.githubusercontent.com/rxi/tick/master/tick.lua"
wget -nv -N "https://raw.githubusercontent.com/kikito/bump.lua/master/bump.lua"
# wget -nv -N "https://gist.githubusercontent.com/EmekaNkurumeh/8038aef0f10e635857c0c2f8338c2696/raw/a24895c0b3c67d4792732005171597d15a926dea/stalker.lua"

echo "Done"
