-- OScctweaked installer
-- Run: wget run https://raw.githubusercontent.com/Frez7373/OScctweaked/main/installer.lua

local BASE = "https://raw.githubusercontent.com/Frez7373/OScctweaked/main/"
local files = {
  {"ui.lua", "ui.lua"},
  {"os.lua", "os.lua"},
  {"apps/about.lua", "apps/about.lua"},
  {"apps/calculator.lua", "apps/calculator.lua"},
  {"apps/notepad.lua", "apps/notepad.lua"},
  {"apps/files.lua", "apps/files.lua"},
  {"apps/settings.lua", "apps/settings.lua"},
  {"apps/clock.lua", "apps/clock.lua"},
  {"apps/system.lua", "apps/system.lua"},
  {"apps/paint.lua", "apps/paint.lua"}
}
local function clear()
 term.setBackgroundColor(colors.black); term.setTextColor(colors.white); term.clear(); term.setCursorPos(1,1)
end
local function center(y,text,color)
 local w=term.getSize(); term.setCursorPos(math.max(1,math.floor((w-#text)/2)+1),y); term.setTextColor(color or colors.white); write(text)
end
local function get(url)
 local h,err=http.get(url,nil,true); if not h then return nil,err end; local data=h.readAll(); h.close(); return data
end
clear(); center(3,"OScctweaked",colors.cyan); center(4,"Touchscreen operating system",colors.lightBlue); center(6,"Installing system files...",colors.white)
if not http then center(8,"HTTP API is disabled.",colors.red); center(9,"Enable HTTP in the CC:Tweaked config.",colors.orange); return end
for i,item in ipairs(files) do
 local remote,localPath=item[1],item[2]
 term.setCursorPos(2,11); term.setTextColor(colors.lightGray); write(string.format("[%d/%d] %-30s",i,#files,remote))
 local data,err=get(BASE..remote)
 if not data then term.setCursorPos(2,12); term.setTextColor(colors.red); print("Download failed: "..tostring(err)); return end
 local dir=fs.getDir(localPath); if dir~="" and not fs.exists(dir) then fs.makeDir(dir) end
 local f=fs.open(localPath,"w"); if not f then print("Cannot write "..localPath); return end; f.write(data); f.close()
end
local startup=fs.open("startup.lua","w"); startup.write("shell.run('os.lua')"); startup.close()
clear(); center(5,"Installation complete",colors.lime); center(7,"Touch to launch OScctweaked",colors.white)
while true do local e= os.pullEvent(); if e=="mouse_click" or e=="monitor_touch" or e=="key" then break end end
shell.run("os.lua")
