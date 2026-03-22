up = vector.new(0, 1, 0)
down = vector.new(0, -1, 0)
neighbour_offsets = {
  {x:1, y:0, z:0}, {x:-1, y:0, z:0},
  {x:0, y:1, z:0}, {x:0, y:-1, z:0},
  {x:0, y:0, z:1}, {x:0, y:0, z:-1}
}
class Conditional

  @enhance: (coords) ->
    setmetatable coords, @

  if_else: (pred, t, f) -> (...) ->
    pred(...) and t(...) or (f or -> nil)(...)

class Position extends Conditional

  @enhance: (pos) ->
    setmetatable pos, @ -- The @ refers to the class itself

  up: ->
    at vector.add(@, up)
  
  down: ->
    at vector.add(@, down)
  
  get_node: ->
    Conditional.enhance core.get_node(@)
  
  get_node_light: ->
    core.get_node_light(@)
  
  neighbours: ->
    Conditional.enhance Iterable.map((offset) -> Position.enhance(vector.add(@, offset)))
  
  find_nodes_in_area: (v1, v2, ...) ->
    pos1 = vector.add(@, v1)
    pos2 = vector.add(@, v2)
    Conditional.enhance core.find_nodes_in_area(pos1, pos2, ...)
  
  find_node_near: (...) ->
    Conditional.enhance core.find_node_near(@, ...)
  
  get_meta: ->
    core.get_meta(@)

class Iterable extends Conditional
  map: (fn) ->
    for item in @
      fn(item)

  each: (fn) ->
    for item in @
      fn(item)

at = (pos) ->
  Position.enhance(pos)

return at
