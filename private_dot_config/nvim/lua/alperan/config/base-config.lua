-- BaseConfig Module
--- @module 'alperan.config.base-config'


--- @class BaseConfig
--- @field _cache table Cache for required modules
--- @field new function Constructor for BaseConfig
--- @field require_once function Method to require a module only once
local BaseConfig = {}
BaseConfig.__index = BaseConfig

BaseConfig.new = function()
  return setmetatable({
    _cache = {},
  }, BaseConfig)
end

BaseConfig.require_once = function(self, module_name)
  if not self._cache[module_name] then
    -- Logar que o modulo está sendo carregado
    -- print("[BaseConfig] Requiring module:", module_name)
    self._cache[module_name] = require(module_name)
  end
    -- Logar que o modulo foi carregado do cache
  -- print("[BaseConfig] Loaded module from cache:", module_name)
  return self._cache[module_name]
end

return BaseConfig