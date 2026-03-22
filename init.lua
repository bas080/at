local up = vector.new(0, 1, 0)
local down = vector.new(0, -1, 0)
local neighbour_offsets = {
  {
    x = 1,
    y = 0,
    z = 0
  },
  {
    x = -1,
    y = 0,
    z = 0
  },
  {
    x = 0,
    y = 1,
    z = 0
  },
  {
    x = 0,
    y = -1,
    z = 0
  },
  {
    x = 0,
    y = 0,
    z = 1
  },
  {
    x = 0,
    y = 0,
    z = -1
  }
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
local Position
do
  local _class_0
  local _parent_0 = Conditional
  local _base_0 = {
    up = function()
      return at(vector.add(self, up))
    end,
    down = function()
      return at(vector.add(self, down))
    end,
    get_node = function()
      return Conditional.enhance(core.get_node(self))
    end,
    get_node_light = function()
      return core.get_node_light(self)
    end,
    neighbours = function()
      return Conditional.enhance(Iterable.map(function(offset)
        return Position.enhance(vector.add(self, offset))
      end))
    end,
    find_nodes_in_area = function(v1, v2, ...)
      local pos1 = vector.add(self, v1)
      local pos2 = vector.add(self, v2)
      return Conditional.enhance(core.find_nodes_in_area(pos1, pos2, ...))
    end,
    find_node_near = function(...)
      return Conditional.enhance(core.find_node_near(self, ...))
    end,
    get_meta = function()
      return core.get_meta(self)
    end
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
local at
at = function(pos)
  return Position.enhance(pos)
end
return at
