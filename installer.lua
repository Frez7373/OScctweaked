-- OScctweaked installer
-- Run: wget run https://raw.githubusercontent.com/Frez7373/OScctweaked/main/installer.lua

local BASE = "https://raw.githubusercontent.com/Frez7373/OScctweaked/main/"
local files = {
  {"os.lua", "os.lua"},
  {"apps/about.lua", "apps/about.lua"},
  {"apps/calculator.lua", "apps/calculator.lua"},
  {"apps/notepad.lua", "apps/notepad.lua"},
  {"apps/files.lua", "apps/files.lua"},
  {"apps/settings.lua", "apps/settings.lua"}
}

local function paint(bg, fg)
  term.setBackgroundColor(bg)
  term.setTextColor(fg)
  term.clear()
  term.setCursorPos(1, 1)
end

local function center(y, text, fg)
  local w = term.getSize()
  term.setCursorPos(math.max(1, math.floor((w - #text) / 2) + 1), y)
  term.setTextColor(fg)
  write(text)
end

local function get(url)
  local h, err = http.get(url, nil, true)
  if not h then return nil, err end
  local data = h.readAll()
  h.close()
  return data
end

paint(colors.black, colors.white)
center(3, "OScctweaked", colors.cyan)
center(4, "Touchscreen operating system", colors.lightBlue)
center(6, "Installing system files...", colors.white)

if not http then
  center(8, "HTTP API is disabled.", colors.red)
  center(9, "Enable HTTP in the CC:Tweaked config.", colors.orange)
  return
end

for i, item in ipairs(files) do
  local remote, localPath = item[1], item[2]
  term.setCursorPos(2, 11)
  term.setTextColor(colors.lightGray)
  write(string.format("[%d/%d] %-30s", i, #files, remote))

  local data, err = get(BASE .. remote)
  if not data then
    term.setCursorPos(2, 12)
    term.setTextColor(colors.red)
    print("Download failed: " .. tostring(err))
    return
  end

  local dir = fs.getDir(localPath)
  if dir ~= "" and not fs.exists(dir) then fs.makeDir(dir) end
  local f = fs.open(localPath, "w")
  f.write(data)
  f.close()
end

local startup = fs.open("startup.lua", "w")
startup.write("shell.run('os.lua')")
startup.close()

paint(colors.black, colors.white)
center(5, "Installation complete", colors.lime)
center(7, "Press any key to launch OScctweaked", colors.white)
os.pullEvent("key")
shell.run("os.lua")
