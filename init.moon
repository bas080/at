up = vector.new(0, 1, 0)
down = vector.new(0, -1, 0)
north = vector.new(1, 0, 0)
south = vector.new(-1, 0, 0)
east = vector.new(0, 0, 1)
west = vector.new(0, 0, -1)
neighbour_offsets = { up, down, north, south, east, west }

class Conditional

  @enhance: (coords) ->
    setmetatable coords, @

  if_else: (pred, t, f) -> (...) ->
    pred(...) and t(...) or (f or -> nil)(...)

class Iterable extends Conditional
  reduce: (fn, acc) ->
    for item in @
      acc = fn acc, at(item)
    acc

  map: (fn) =>
    @reduce ((acc, item) ->
      table.insert acc, fn(item)
      acc
    ), {}

  each: (fn) =>
    @reduce ((acc, item) ->
      fn item
      acc
    ), nil

  filter: (pred) =>
    @reduce ((acc, item) ->
      if pred item
        table.insert acc, item
      acc
    ), {}

  find: (pred) ->
    for item in @
      return item if pred at(item)
    nil

-- Helpers for defining methods

partial = (fn, ...) ->
  fixed = {...}
  (...) -> fn unpack(fixed), ...

offsets_to_positions = (fn) -> (pos, v1, v2, ...) ->
  p1 = vector.add(pos, v1)
  p2 = vector.add(pos, v2)
  fn(p1, p2, ...)

tap = (fn) -> (...) ->
  fn(...)
  return ...

class Position extends Conditional

  @enhance: (pos) ->
    setmetatable pos, @ -- The @ refers to the class itself

  -- Position methods
  get_meta: core.get_meta
  get_node: core.get_node
  get_node_or_nil: core.get_node_or_nil
  get_node_timer: core.get_node_timer
  get_node_light: core.get_node_light
  get_natural_light: core.get_natural_light
  get_meta: core.get_meta
  find_node_near: core.find_node_near
  
  set_node: tap(core.set_node)

  -- Position methods that return nil
  set_node: tap(core.set_node)

  -- Direction methods
  up: partial(vector.add, up)
  down: partial(vector.add, down)
  north: partial(vector.add, north)
  south: partial(vector.add, north)
  west: partial(vector.add, north)
  east: partial(vector.add, north)
  
  -- Placed it here because it is related
  neighbours: () => Iterator.map(neighbour_offsets, n -> vector.add(n, @))

  -- Area methods
  find_nodes_in_radius: (radius, ...) -> @find_nodes_in_area(
    vector.new(-radius, -radius, -radius),
    vector.new(radius, radius, radius),
    ...
  )
  
  find_nodes_in_area_under_air: offsets_to_positions(core.find_nodes_in_area_under_air)
  find_nodes_in_area: offsets_to_positions(core.find_nodes_in_area)

at = (pos) ->
  Position.enhance(pos)

return at, Position
