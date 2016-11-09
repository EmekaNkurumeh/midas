util = {}
util.unpack = table.unpack or unpack
util.pack = (...) -> {...}
util.typeof = (val) ->
  xval = type(val) == "table"
  xpcall ->
    if xval and val.__class.__name
      xval = val.__class.__name
    else
      xval = type val,
    -> xval = "table"
  xval
util.setfenv = setfenv or (fn, env) ->
  i = 1
  while true do
    name = debug.getupvalue fn, i
    if name == "_ENV"
      debug.upvaluejoin fn, i, (-> env), 1
      break
    elseif not name
      break
    i = i + 1
  fn

util.getfenv = getfenv or (fn) ->
  i = 1
  while true do
    name, val = debug.getupvalue fn, i
    if name == "_ENV"
      val
    elseif not name
      break
    i = i + 1

util.run_env = (env, fn, ...) ->
  setfenv fn, env
  fn ...
util.map = (f, a, ...) ->
   t = {}
   for _ in *a
     _i = _index_0
     t[_i] = f(_, ...)
   return t
util.foldr = (f, a, ...) ->
  t = 0
  for _ in *a
    t += f(_, ...)
  t
util.foldl = (f, a, ...) ->
  t = 0
  for i = #a, 1, -1
    _ = a[i]
    t += f(_, ...)
  t

{:util}
