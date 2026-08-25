local ui = dofile("ui.lua")

local W, H = term.getSize()
local startOpen = false
local locked = false
local activeApp = nil
local notice = "Welcome to OScctweaked"
local noticeUntil = os.clock() + 4
local desktopClock = os.clock()

local apps = {
  {name="Files",      icon="[ ]", file="apps/files.lua"},
  {name="Calculator", icon="[+ ]", file="apps/calculator.lua"},
  {name="Notepad",    icon="[_]", file="apps/notepad.lua"},
  {name="Clock",      icon="[o]", file="apps/clock.lua"},
  {name="Paint",      icon="[*]", file="apps/paint.lua"},
  {name="System",     icon="[S]", file="apps/system.lua"},
  {name="Settings",   icon="[G]", file="apps/settings.lua"},
  {name="Calendar",   icon="[D]", file="apps/calendar.lua"},
  {name="Terminal",   icon=">_",  file="apps/terminal.lua"},
  {name="Browser",    icon="[W]", file="apps/browser.lua"},
  {name="About",      icon="[?]", file="apps/about.lua"}
}

local function post(text, seconds)
  notice = text
  noticeUntil = os.clock() + (seconds or 3)
end

local function fillWallpaper()
  W, H = term.getSize()
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.clear()
end

local function drawTopBar()
  ui.rect(1, 1, W, 2, colors.blue, colors.white)
  ui.text(2, 1, "OScctweaked", colors.white, colors.blue)
  ui.text(2, 2, "Desktop", colors.lightBlue, colors.blue)
  ui.text(math.max(1, W - 8), 1, os.date("%H:%M"), colors.white, colors.blue)
end

local function drawShortcut(x, y, app)
  local icon = app.icon
  local label = app.name
  if #label > 10 then label = label:sub(1, 10) end

  -- Plain desktop shortcut: no colored tile, only icon + caption.
  ui.text(x, y, icon, colors.white, colors.blue)
  ui.text(x, y + 1, label, colors.white, colors.blue)
end

local function drawShortcuts()
  local cols = 4
  local gapX = math.max(11, math.floor(W / 5))
  local gapY = 4
  local startX = 2
  local startY = 5

  for i, app in ipairs(apps) do
    local n = i - 1
    local col = n % cols
    local row = math.floor(n / cols)
    local x = startX + col * gapX
    local y = startY + row * gapY
    if x + 10 <= W and y + 1 <= H - 3 then
      drawShortcut(x, y, app)
    end
  end
end

local function drawTaskbar()
  ui.rect(1, H - 2, W, H, colors.gray, colors.white)
  ui.button(1, H - 2, 10, H, "START", colors.blue)
  ui.button(12, H - 2, 21, H, "DESK", colors.cyan)

  if activeApp then
    local right = math.min(W - 14, 36)
    if right >= 23 then
      ui.button(23, H - 2, right, H, activeApp:sub(1, right - 22), colors.lightGray, colors.black)
    end
  end

  ui.text(math.max(1, W - 15), H - 1, "Day " .. math.floor(os.time()), colors.white, colors.gray)
  ui.text(math.max(1, W - 6), H, os.date("%H:%M"), colors.white, colors.gray)
end

local function drawNotification()
  if os.clock() >= noticeUntil or W < 28 then return end
  local width = math.min(30, W - 4)
  local x = W - width - 1
  ui.rect(x, 3, W - 2, 5, colors.gray, colors.white)
  local text = notice
  if #text > width - 4 then text = text:sub(1, width - 4) end
  ui.text(x + 2, 4, text, colors.white, colors.gray)
end

local function drawDesktop()
  fillWallpaper()
  drawTopBar()
  ui.text(3, 3, "Welcome", colors.white, colors.blue)
  ui.text(3, 4, "Touch an application", colors.lightBlue, colors.blue)
  drawShortcuts()
  drawTaskbar()
  drawNotification()
end

local function drawStartMenu()
  local mw = math.min(38, W - 2)
  local mh = math.min(18, H - 4)
  local x = 2
  local y = H - mh - 2

  ui.rect(x, y, x + mw, y + mh, colors.lightGray, colors.black)
  ui.rect(x, y, x + mw, y + 2, colors.blue, colors.white)
  ui.text(x + 2, y + 1, "START", colors.white, colors.blue)
  ui.text(x + 2, y + 4, "Applications", colors.blue, colors.lightGray)

  local cols = 2
  local cellW = math.floor((mw - 3) / cols)
  local firstY = y + 5

  for i = 1, math.min(#apps, 11) do
    local n = i - 1
    local col = n % cols
    local row = math.floor(n / cols)
    local bx = x + 1 + col * (cellW + 1)
    local by = firstY + row * 2
    if by + 1 <= y + mh - 3 then
      ui.button(bx, by, bx + cellW - 1, by + 1, apps[i].icon .. " " .. apps[i].name, colors.gray)
    end
  end

  ui.button(x + 1, y + mh - 1, x + 12, y + mh, "LOCK", colors.gray)
  ui.button(x + 14, y + mh - 1, x + 28, y + mh, "SHUTDOWN", colors.red)
end

local function drawLockScreen()
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
  term.clear()
  ui.center(math.max(2, math.floor(H / 2) - 3), "OScctweaked", colors.cyan, colors.black)
  ui.center(math.floor(H / 2) - 1, os.date("%H:%M"), colors.white, colors.black)
  ui.center(math.floor(H / 2) + 1, "TOUCH TO UNLOCK", colors.lightBlue, colors.black)
end

local function hitShortcut(x, y)
  local cols = 4
  local gapX = math.max(11, math.floor(W / 5))
  local gapY = 4
  local startX = 2
  local startY = 5

  for i, app in ipairs(apps) do
    local n = i - 1
    local col = n % cols
    local row = math.floor(n / cols)
    local bx = startX + col * gapX
    local by = startY + row * gapY
    if ui.hit(x, y, bx, by, bx + 9, by + 1) then
      return app
    end
  end
  return nil
end

local function launch(app)
  if not app or not fs.exists(app.file) then
    post("Application not found", 4)
    drawDesktop()
    return
  end

  activeApp = app.name
  startOpen = false
  drawDesktop()
  term.setCursorBlink(false)

  local ok = pcall(function()
    shell.run(app.file)
  end)

  activeApp = nil
  if not ok then
    post("Application error", 5)
  else
    post(app.name .. " closed", 2)
  end
  drawDesktop()
end

drawDesktop()

while true do
  local event, p1, p2 = os.pullEvent()

  if event == "terminate" then
    break

  elseif event == "term_resize" then
    W, H = term.getSize()
    if locked then drawLockScreen() else drawDesktop() end

  elseif locked then
    if event == "mouse_click" or event == "monitor_touch" or event == "key" then
      locked = false
      drawDesktop()
    end

  elseif event == "mouse_click" or event == "monitor_touch" then
    local x, y = p1, p2
    W, H = term.getSize()

    if startOpen then
      local mw = math.min(38, W - 2)
      local mh = math.min(18, H - 4)
      local sx = 2
      local sy = H - mh - 2

      if ui.hit(x, y, sx + 1, sy + mh - 1, sx + 12, sy + mh) then
        startOpen = false
        locked = true
        drawLockScreen()
      elseif ui.hit(x, y, sx + 14, sy + mh - 1, sx + 28, sy + mh) then
        os.shutdown()
      else
        local cols = 2
        local cellW = math.floor((mw - 3) / cols)
        local firstY = sy + 5
        local col = math.floor((x - (sx + 1)) / (cellW + 1))
        local row = math.floor((y - firstY) / 2)
        local idx = row * 2 + col + 1
        if idx >= 1 and idx <= #apps and x >= sx + 1 and x <= sx + mw - 1 and y >= firstY then
          launch(apps[idx])
        else
          startOpen = false
          drawDesktop()
        end
      end

    elseif ui.hit(x, y, 1, H - 2, 10, H) then
      startOpen = true
      drawDesktop()
      drawStartMenu()

    elseif ui.hit(x, y, 12, H - 2, 21, H) then
      post("Desktop refreshed", 2)
      drawDesktop()

    elseif ui.hit(x, y, math.max(1, W - 9), 1, W, 2) then
      locked = true
      drawLockScreen()

    else
      local app = hitShortcut(x, y)
      if app then launch(app) end
    end

  elseif event == "timer" then
    if not startOpen and not locked and os.clock() - desktopClock >= 1 then
      desktopClock = os.clock()
      drawDesktop()
    end
  end

  if not startOpen and not locked then
    desktopClock = os.clock()
    os.startTimer(1)
  end
end
