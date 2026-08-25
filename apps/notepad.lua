-- OScctweaked Notepad
local text = ""
if fs.exists("notepad.txt") then
  local f = fs.open("notepad.txt", "r")
  text = f.readAll() or ""
  f.close()
end

term.setBackgroundColor(colors.white)
term.setTextColor(colors.black)
term.clear()
term.setCursorPos(1,1)
print("OScctweaked Notepad")
print("Type text. Press Ctrl+S to save, Ctrl+Q to exit.")
print(string.rep("-", math.min(term.getSize())))
print(text)

local lines = {}
for line in (text .. "\n"):gmatch("(.-)\n") do table.insert(lines, line) end
if #lines == 0 then lines = {""} end

local function save()
  local f = fs.open("notepad.txt", "w")
  f.write(table.concat(lines, "\n"))
  f.close()
end

while true do
  local e, p1 = os.pullEvent()
  if e == "key" and p1 == keys.q and keys.isDown(keys.leftCtrl) then
    save()
    return
  elseif e == "key" and p1 == keys.s and keys.isDown(keys.leftCtrl) then
    save()
  elseif e == "char" then
    lines[#lines] = lines[#lines] .. p1
    term.write(p1)
  elseif e == "key" and p1 == keys.enter then
    lines[#lines + 1] = ""
    term.setCursorPos(1, select(2, term.getCursorPos()) + 1)
  elseif e == "key" and p1 == keys.backspace then
    if #lines[#lines] > 0 then
      lines[#lines] = lines[#lines]:sub(1, -2)
      local x, y = term.getCursorPos()
      if x > 1 then term.setCursorPos(x - 1, y); term.write(" "); term.setCursorPos(x - 1, y) end
    end
  end
end
