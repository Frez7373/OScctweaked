local M = {}

local known = {
  monitor = "Monitor",
  printer = "Printer",
  modem = "Modem",
  speaker = "Speaker",
  drive = "Disk Drive",
  computer = "Computer",
  redstone_relay = "Redstone Relay",
  command = "Command Block",
  inventory = "Inventory",
  energy_storage = "Energy Storage",
  fluid_storage = "Fluid Storage"
}

local function types(name)
  local out = {}
  if not peripheral.isPresent(name) then return out end
  local ok, a,b,c,d = pcall(peripheral.getType, name)
  if ok then
    if a then table.insert(out,a) end
    if b then table.insert(out,b) end
    if c then table.insert(out,c) end
    if d then table.insert(out,d) end
  end
  return out
end

function M.scan()
  local list = {}
  for _, name in ipairs(peripheral.getNames()) do
    local ts = types(name)
    local label = ts[1] and (known[ts[1]] or ts[1]) or "Unknown"
    table.insert(list, {name=name, types=ts, label=label, present=true})
  end
  return list
end

function M.find(name, ty)
  if not peripheral.isPresent(name) then return nil end
  if ty then
    local ok, yes = pcall(function() return peripheral.hasType(name, ty) end)
    if ok and yes then return peripheral.wrap(name) end
    local ts = types(name)
    for _, t in ipairs(ts) do if t == ty then return peripheral.wrap(name) end end
    return nil
  end
  return peripheral.wrap(name)
end

function M.describe(p)
  local out = {name=p.name, label=p.label, types=p.types, methods={}}
  local methods = peripheral.getMethods(p.name) or {}
  for _, m in ipairs(methods) do table.insert(out.methods,m) end
  return out
end

function M.safeCall(name, method, ...)
  if not peripheral.isPresent(name) then return false, "Device disconnected" end
  local args = {...}
  local ok, a,b,c,d = pcall(function() return peripheral.call(name, method, table.unpack(args)) end)
  if not ok then return false, tostring(a) end
  return true, a,b,c,d
end

function M.typeLabel(ts)
  local labels={}
  for _,t in ipairs(ts or {}) do table.insert(labels, known[t] or t) end
  return table.concat(labels, ", ")
end

return M
