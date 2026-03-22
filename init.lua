local up = vector.new(0, 1, 0)
local down = vector.new(0, -1, 0)
local north = vector.new(1, 0, 0)
local south = vector.new(-1, 0, 0)
local east = vector.new(0, 0, 1)
local west = vector.new(0, 0, -1)
local neighbour_offsets = {
  up,
  down,
  north,
  south,
  east,
  west
}
local Conditional
do
  local _class_0
  local _base_0 = {
    if_else = function(pred, t, f)
      return function(...)
        return pred(...) and t(...) or (f or function()
          return nil
        end)(...)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Conditional"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.enhance = function(coords)
    return setmetatable(coords, self)
  end
  Conditional = _class_0
end
local Iterable
do
  local _class_0
  local _parent_0 = Conditional
  local _base_0 = {
    map = function(fn)
      for item in self do
        fn(item)
      end
    end,
    each = function(fn)
      for item in self do
        fn(item)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Iterable",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Iterable = _class_0
end
local partial
partial = function(fn, ...)
  local fixed = {
    ...
  }
  return function(...)
    return fn(unpack(fixed), ...)
  end
end
local offsets_to_positions = fn(function()
  return function(pos, v1, v2, ...)
    local p1 = vector.add(pos, v1)
    local p2 = vector.add(pos, v2)
    return fn(p1, p2, ...)
  end
end)
local Position
do
  local _class_0
  local _parent_0 = Conditional
  local _base_0 = {
    get_meta = core.get_meta,
    get_node = core.get_node,
    get_node_light = core.get_node_light,
    get_meta = core.get_meta,
    find_node_near = core.find_node_near,
    up = partial(vector.add, up),
    down = partial(vector.add, down),
    north = partial(vector.add, north),
    south = partial(vector.add, north),
    west = partial(vector.add, north),
    east = partial(vector.add, north),
    neighbours = function(self)
      return Iterator.map(neighbour_offsets, n(function()
        return vector.add(n, self)
      end))
    end,
    find_nodes_in_area_under_air = offsets_to_positions(core.find_nodes_in_area_under_air),
    find_nodes_in_area = offsets_to_positions(core.find_nodes_in_area)
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Position",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.enhance = function(pos)
    return setmetatable(pos, self)
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Position = _class_0
  return _class_0
end
