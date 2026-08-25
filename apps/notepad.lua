local ui = dofile("ui.lua")
local file = "notepad.txt"
local text = ""

if fs.exists(file) then
  local f = fs.open(file, "r")
  if f then
    text = f.readAll() or ""
    f.close()
  end
end

local W, H = term.getSize()
local keyboard = {
  {"Q","W","E","R","T","Y","U","I","O","P"},
  {"A","S","D","F","G","H","J","K","L"},
  {"Z","X","C","V","B","N","M"}
}

local function save()
  local f = fs.open(file, "w")
  if f then
    f.write(text)
    f.close()
  end
end

local function draw()
  W, H = term.getSize()
  ui.clear(colors.black)
  ui.header("Notepad", true)

  local editorBottom = math.min(8, H - 10)
  ui.rect(2, 3, W - 1, editorBottom, colors.white, colors.black)

  local maxChars = math.max(1, (W - 4) * math.max(1, editorBottom - 2))
  local shown = text:sub(math.max(1, #text - maxChars + 1))
  local y = 3
  for line in shown:gmatch("[^\n]*") do
    if y <= editorBottom then
      ui.text(3, y, line:sub(1, math.max(1, W - 4)), colors.black, colors.white)
      y = y + 1
    end
  end

  local start = math.max(editorBottom + 2, H - 9)
  for r, row in ipairs(keyboard) do
    local gap = math.max(3, math.floor((W - 4) / #row))
    for i, ch in ipairs(row) do
      local x = 2 + (i - 1) * gap
      if x <= W then
        ui.button(x, start + (r - 1) * 2, math.min(W, x + gap - 2), start + (r - 1) * 2 + 1, ch, colors.blue)
      end
    end
  end

  local bottom = H - 2
  ui.button(2, bottom, math.min(10, W), H - 1, "SPACE", colors.gray)
  if W >= 12 then ui.button(11, bottom, math.min(19, W), H - 1, "ENTER", colors.cyan) end
  if W >= 21 then ui.button(20, bottom, math.min(30, W), H - 1, "DELETE", colors.red) end
  if W >= 31 then ui.button(31, bottom, math.min(W - 1, W), H - 1, "SAVE", colors.green) end
end

draw()

while true do
  local e, p1, p2 = os.pullEvent()

  if e == "mouse_click" or e == "monitor_touch" then
    local x, y = p1, p2
    W, H = term.getSize()

    if ui.hit(x, y, math.max(1, W - 8), 1, W, 2) then
      save()
      return
    end

    local editorBottom = math.min(8, H - 10)
    local start = math.max(editorBottom + 2, H - 9)
    local handled = false

    for r, row in ipairs(keyboard) do
      local gap = math.max(3, math.floor((W - 4) / #row))
      local y1 = start + (r - 1) * 2
      local y2 = y1 + 1
      if ui.hit(x, y, 2, y1, W, y2) then
        local index = math.floor((x - 2) / gap) + 1
        if index >= 1 and index <= #row then
          text = text .. row[index]
          handled = true
        end
      end
    end

    if not handled and ui.hit(x, y, 2, H - 2, math.min(10, W), H - 1) then
      text = text .. " "
      handled = true
    end
    if not handled and W >= 12 and ui.hit(x, y, 11, H - 2, math.min(19, W), H - 1) then
      text = text .. "\n"
      handled = true
    end
    if not handled and W >= 21 and ui.hit(x, y, 20, H - 2, math.min(30, W), H - 1) then
      text = text:sub(1, -2)
      handled = true
    end
    if not handled and W >= 31 and ui.hit(x, y, 31, H - 2, W, H - 1) then
      save()
      handled = true
    end

    if handled then draw() end

  elseif e == "char" then
    text = text .. p1
    draw()

  elseif e == "key" and p1 == keys.q then
    save()
    return
  end
end
