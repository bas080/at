# at

> This document is the source code and the documentation.

A Luanti Lua API utility for working with positions/vectors.

## Example

```lua
local at = dofile(core.get_modpath('at') .. '/init.lua')

core.override_item("fire:unforgiving", {
  on_timer = on_timer(pos_arg)
    at(pos_arg):neightbors():each(function(npos)
      npos:get_node():if_else(is_flammable, function(_node)
        npos:remove_node()
      end)
    end)
  end
})
```

A concise and chainable API that allows for a bit of [point-free][point-free] style.

## Implementation

The `at` module returns the following.

```moonscript
at = (pos) ->
  Position.enhance(pos)

return at, Position
```

The `at` being the function you saw in action in the [example][example].
it is made to take a vector as argument: `{x=3,y=2,z=1}`.

The [setmetatable][setmetatable] is a lua feature that
allows for a more memory efficient implementation.

We use `setmetatable` to prevent creating more tables while we have a perfectly fine table here already. We just want to
enhance it with some methods.

The return value of `at` is the table itself. That allows us to still pass the return value of `at` to other Luanti APIs -
making it easy to adopt at project in your project as it works with the vector code you already have.

So how does something like `a(pos):get_node()` work? Where is that defined?

```moonscript
class Position extends Conditional

  @enhance: (pos) ->
    setmetatable pos, @ -- The @ refers to the class itself
```

> We would have had to write a bit more in Lua. An exercise for you would be to
> figure out the equivalent of writing this in Lua.

Not just `get_node` is defined; but many others.

```moonscript
up: =>
  at vector.add(@, up)

down: =>
  at vector.add(@, down)

get_node: =>
  Conditional.enhance core.get_node(@)

get_node_light: =>
  core.get_node_light(@)

neighbours: =>
  Conditional.enhance Iterable.map((offset) -> Position.enhance(vector.add(@, offset)))

find_nodes_in_area: (v1, v2, ...) =>
  pos1 = vector.add(@, v1)
  pos2 = vector.add(@, v2)
  Conditional.enhance core.find_nodes_in_area(pos1, pos2, ...)

find_node_near: (...) =>
  Conditional.enhance core.find_node_near(@, ...)

get_meta: =>
  core.get_meta(@)
```

A day after writing this I saw a very obvious pattern. Most of these helpers pass the `@` as first argument to a
function defined on Luanti's `core` namespace. We can use the core function that take
pos as first argument as is.

```moonscript
get_meta: core.get_meta
get_node: core.get_node
get_node_or_nil: core.get_node_or_nil
get_node_timer: core.get_node_timer
get_node_light: core.get_node_light
get_natural_light: core.get_natural_light
get_meta: core.get_meta
find_node_near: core.find_node_near

-- < Position methods that return nil
```

Some methods like `core.set_node` do a mutation to the world and do not return something.
These we can make a bit more chainable. In the [fp][fp] world the [higher order function][higher_order_function] that enables
that is often called `tap`.

```moonscript
tap = (fn) -> (...) -> fn(...); ...
```

```moonscript
set_node: tap(core.set_node)
```

Then we have a few helpers that require partial application.

```moonscript
up: partial(vector.add, up)
down: partial(vector.add, down)
north: partial(vector.add, north)
south: partial(vector.add, north)
west: partial(vector.add, north)
east: partial(vector.add, north)

-- Placed it here because it is related
neighbours: () => Iterator.map(neighbour_offsets, n -> vector.add(n, @))
```

The partial implementation:

```moonscript
partial = (fn, ...) ->
  fixed = {...}
  (...) -> fn unpack(fixed), ...
```

We also have the pattern where functions that allow for two positions to define an area could also be abstracted.

```moonscript
offsets_to_positions = (fn) -> (pos, v1, v2, ...) ->
  p1 = vector.add(pos, v1)
  p2 = vector.add(pos, v2)
  fn(p1, p2, ...)
```

```moonscript
find_nodes_in_area_under_air: offsets_to_positions(core.find_nodes_in_area_under_air)
find_nodes_in_area: offsets_to_positions(core.find_nodes_in_area)
```

> Finding a name for this function was the hardest part.

Here are the constants we need for those methods to work.

```moonscript
up = vector.new(0, 1, 0)
down = vector.new(0, -1, 0)
north = vector.new(1, 0, 0)
south = vector.new(-1, 0, 0)
east = vector.new(0, 0, 1)
west = vector.new(0, 0, -1)
neighbour_offsets = { up, down, north, south, east, west }
```

You might have noticed the `extends Conditional` and wondered what it looks like.

```moonscript
class Conditional

  @enhance: (coords) ->
    setmetatable coords, @

  if_else: (pred, t, f) -> (...) ->
    pred(...) and t(...) or (f or -> nil)(...)
```

With this defined and extended upon we can do `at(pos):if_else(is_under_water, hold_breath, breath)`.

Furthermore we want some helpers that make it easier to work with positions. This will allow us to write.
`at(pos):neighbours():map(f -> f:up!)`

These helpers are only meant to work on positions. You do not want to be enhancing things that do not
represent a position with position methods.

```moonscript
class Iterable extends Conditional
  reduce: (items, fn, acc) ->
    for item in items
      acc = fn(acc, at(item))
    acc

  map: (fn) ->
    @reduce((acc, item) ->
      table.insert acc, fn(item)
      acc
    , {})

  each: (fn) ->
    @reduce((acc, item) ->
      fn item
      acc
    , nil)

  filter: (pred) ->
    @reduce((acc, item) ->
      if pred item
        table.insert acc, item
      acc
    , {})

  find: (pred) ->
    for item in @
      return item if pred at(item)
    nil
```

Now for putting it all together.

```moonscript
-- < Constants

-- < Conditional class

-- < Iterable class

-- Helpers for defining methods

-- < partial

-- < offsets_to_positions

-- < tap

-- < Position class

  -- Position methods
  -- < Position methods

  -- Position methods that return nil
  -- < Position methods that return nil

  -- Direction methods
  -- < Direction methods

  -- Area methods
  -- < Area methods

-- < module return
```
```moonscript
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
  reduce: (items, fn, acc) ->
    for item in items
      acc = fn(acc, at(item))
    acc

  map: (fn) ->
    @reduce((acc, item) ->
      table.insert acc, fn(item)
      acc
    , {})

  each: (fn) ->
    @reduce((acc, item) ->
      fn item
      acc
    , nil)

  filter: (pred) ->
    @reduce((acc, item) ->
      if pred item
        table.insert acc, item
      acc
    , {})

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

tap = (fn) -> (...) -> fn(...); ...

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
  find_nodes_in_area_under_air: offsets_to_positions(core.find_nodes_in_area_under_air)
  find_nodes_in_area: offsets_to_positions(core.find_nodes_in_area)

at = (pos) ->
  Position.enhance(pos)

return at, Position
```


That is all the code for now. You can always check the [repository][repository] if you want to see if this document has changed.

> Remember that this document is the code. :)

I wish you fun and peace writing Lua and moonscript.

## Documentation

This is a literate project that uses [markatzea][markatzea] in concert with [woven][woven] to weave code from a markdown file.

You can generate both the README and the code with:

```bash
# Also writes the init.moon
markatzea README.mz > README.md
```

```bash
# Create the init.lua
moonc init.moon
```
