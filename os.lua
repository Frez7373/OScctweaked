local ui = dofile("ui.lua")

local W, H = term.getSize()
local startOpen = false
local locked = false
local notice = "Welcome to OScctweaked"
local noticeUntil = os.clock() + 5
local active = nil

local apps = {
  {name="Files", icon="F", file="apps/files.lua", color=colors.orange},
  {name="Calculator", icon="C", file="apps/calculator.lua", color=colors.blue},
  {name="Notepad", icon="N", file="apps/notepad.lua", color=colors.purple},
  {name="Clock", icon="T", file="apps/clock.lua", color=colors.cyan},
  {name="Paint", icon="P", file="apps/paint.lua", color=colors.red},
  {name="System", icon="S", file="apps/system.lua", color=colors.lime},
  {name="Settings", icon="G", file="apps/settings.lua", color=colors.gray},
  {name="Calendar", icon="D", file="apps/calendar.lua", color=colors.blue},
  {name="Terminal", icon=">_", file="apps/terminal.lua", color=colors.black},
  {name="Browser", icon="B", file="apps/browser.lua", color=colors.cyan},
  {name="About", icon="?", file="apps/about.lua", color=colors.purple}
}

local function post(text, seconds)
  notice = tostring(text or "")
  noticeUntil = os.clock() + (seconds or 3)
end

local function wallpaper()
  W, H = term.getSize()
  term.setBackgroundColor(colors.blue)
  term.clear()
  local bands = {colors.blue, colors.lightBlue, colors.cyan, colors.blue}
  for y = 1, H do
    term.setBackgroundColor(bands[((y - 1) % #bands) + 1])
    term.setCursorPos(1, y)
    write(string.rep(" ", W))
  end
end

local function topbar()
  ui.rect(1, 1, W, 2, colors.lightBlue, colors.white)
  ui.text(2, 1, "OScctweaked", colors.white, colors.lightBlue)
  ui.text(2, 2, "Windows-style touchscreen shell", colors.lightGray, colors.lightBlue)
  ui.text(math.max(1, W - 7), 1, os.date("%H:%M"), colors.white, colors.lightBlue)
  ui.text(math.max(1, W - 11), 2, "READY", colors.lime, colors.lightBlue)
end

local function taskbar()
  ui.rect(1, H - 2, W, H, colors.gray, colors.white)
  ui.button(1, H - 2, math.min(10, W), H, "START", colors.blue)
  if W >= 22 then
    ui.button(12, H - 2, 22, H, "DESKTOP", colors.cyan)
  end
  if active and W >= 24 then
    local x2 = math.min(W - 12, 35)
    if x2 >= 24 then
      ui.button(24, H - 2, x2, H, string.sub(active, 1, math.max(1, x2 - 23)), ui.colors.panel2, ui.colors.darkText)
    end
  end
  ui.text(math.max(1, W - 11), H - 1, "Day " .. math.floor(os.time()), colors.white, colors.gray)
end

local function tile(a, x, y, w, h)
  ui.rect(x, y, x + w - 1, y + h - 1, a.color, colors.white)
  ui.text(x + 2, y + 1, a.icon, colors.white, a.color)
  ui.text(x + 2, y + h - 2, a.name, colors.white, a.color)
end

local function desktop()
  wallpaper()
  topbar()
  ui.text(3, 4, "Welcome", colors.white, colors.blue)
  ui.text(3, 5, "Touch an app to open it", colors.lightGray, colors.blue)

  local cols = 4
  local tw = math.max(8, math.floor((W - 8) / cols))
  local th = 4
  for i, a in ipairs(apps) do
    local n = i - 1
    local col = n % cols
    local row = math.floor(n / cols)
    local x = 3 + col * (tw + 1)
    local y = 7 + row * (th + 1)
    if x + tw - 1 <= W and y + th <= H - 3 then
      tile(a, x, y, tw, th)
    end
  end

  if W >= 30 then
    ui.card(W - 25, 4, W - 3, 8, "SYSTEM", "Touchscreen ready", colors.lime)
    ui.text(W - 23, 6, "RAM: " .. math.floor(collectgarbage("count")) .. " KB", colors.white, colors.gray)
    ui.text(W - 23, 7, "ID: " .. os.getComputerID(), colors.lightGray, colors.gray)
  end

  taskbar()

  if os.clock() < noticeUntil and W >= 20 then
    local nx = math.max(2, W - 34)
    local ex = W - 2
    ui.rect(nx, 3, ex, 5, colors.gray, colors.white)
    ui.text(nx + 2, 4, notice:sub(1, math.max(1, ex - nx - 2)), colors.white, colors.gray)
  end

  if startOpen then
    local mw = math.min(40, math.max(18, W - 2))
    local mh = math.min(18, math.max(10, H - 4))
    local x = 2
    local y = H - 2 - mh
    ui.rect(x, y, math.min(W, x + mw), math.min(H, y + mh), colors.lightGray, colors.black)
    ui.rect(x, y, math.min(W, x + mw), math.min(H, y + 2), colors.blue, colors.white)
    ui.text(x + 2, y + 1, "START | OScctweaked", colors.white, colors.blue)

    local cols2 = 2
    local cell = math.max(6, math.floor((mw - 2) / cols2) - 1)
    for i = 1, #apps do
      local n = i - 1
      local col = n % cols2
      local row = math.floor(n / cols2)
      local bx = x + 1 + col * (cell + 1)
      local by = y + 3 + row * 2
      if by + 1 < y + mh - 2 then
        ui.button(bx, by, math.min(W, bx + cell), by + 1, apps[i].icon .. " " .. apps[i].name, apps[i].color)
      end
    end
    if y + mh - 1 <= H then
      ui.button(x + 1, y + mh - 1, math.min(W, x + 12), y + mh, "LOCK", colors.gray)
      ui.button(x + 14, y + mh - 1, math.min(W, x + 28), y + mh, "SHUTDOWN", colors.red)
    end
  end
end

local function lockscreen()
  term.setBackgroundColor(colors.black)
  term.clear()
  ui.center(math.floor(H / 2) - 2, "OScctweaked", colors.cyan, colors.black)
  ui.center(math.floor(H / 2), "TOUCH TO UNLOCK", colors.white, colors.black)
  ui.center(math.floor(H / 2) + 2, os.date("%H:%M"), colors.lightBlue, colors.black)
end

local function launch(a)
  if not a or not fs.exists(a.file) then
    post("Application unavailable", 4)
    desktop()
    return
  end
  active = a.name
  startOpen = false
  desktop()
  term.setCursorBlink(false)

  local ok, err = pcall(function()
    shell.run(a.file)
  end)

  active = nil
  if not ok then
    post(a.name .. " error: " .. tostring(err), 6)
  else
    post(a.name .. " closed", 2)
  end
  desktop()
end

local function hitapp(x, y)
  local cols = 4
  local tw = math.max(8, math.floor((W - 8) / cols))
  local th = 4
  for i, a in ipairs(apps) do
    local n = i - 1
    local col = n % cols
    local row = math.floor(n / cols)
    local bx = 3 + col * (tw + 1)
    local by = 7 + row * (th + 1)
    if ui.hit(x, y, bx, by, bx + tw - 1, by + th - 1) then
      return a
    end
  end
  return nil
end

desktop()

while true do
  os.startTimer(1)
  local e, p1, p2 = os.pullEvent()

  if e == "terminate" then
    break
  elseif locked then
    if e == "mouse_click" or e == "monitor_touch" or e == "key" then
      locked = false
      desktop()
    end
  elseif e == "term_resize" then
    W, H = term.getSize()
    desktop()
  elseif e == "timer" then
    desktop()
  elseif e == "mouse_click" or e == "monitor_touch" then
    local x, y = p1, p2

    if startOpen then
      local mw = math.min(40, math.max(18, W - 2))
      local mh = math.min(18, math.max(10, H - 4))
      local sx = 2
      local sy = H - 2 - mh

      if ui.hit(x, y, sx + 1, sy + mh - 1, sx + 12, sy + mh) then
        startOpen = false
        locked = true
        lockscreen()
      elseif ui.hit(x, y, sx + 14, sy + mh - 1, sx + 28, sy + mh) then
        os.shutdown()
      else
        local cell = math.max(6, math.floor((mw - 2) / 2) - 1)
        local col = math.floor((x - (sx + 1)) / (cell + 1))
        local row = math.floor((y - (sy + 3)) / 2)
        local idx = row * 2 + col + 1
        if idx >= 1 and idx <= #apps then
          launch(apps[idx])
        else
          startOpen = false
          desktop()
        end
      end
    elseif y >= H - 2 and y <= H then
      if ui.hit(x, y, 1, H - 2, math.min(10, W), H) then
        startOpen = true
        desktop()
      elseif W >= 22 and ui.hit(x, y, 12, H - 2, 22, H) then
        post("Desktop refreshed", 2)
        desktop()
      end
    elseif y <= 2 and x >= math.max(1, W - 12) then
      locked = true
      lockscreen()
    else
      local a = hitapp(x, y)
      if a then launch(a) end
    end
  end
end
