-- OScctweaked installer 2.x
-- Designed for CC:Tweaked on older Minecraft versions such as 1.16.5.
-- Run:
-- wget run https://raw.githubusercontent.com/Frez7373/OScctweaked/main/installer.lua

local BASE="https://raw.githubusercontent.com/Frez7373/OScctweaked/main/"
local files={
 {"core/ui.lua","core/ui.lua"},{"core/apps.lua","core/apps.lua"},{"core/peripherals.lua","core/peripherals.lua"},{"os.lua","os.lua"},
 {"programs/explorer.lua","programs/explorer.lua"},{"programs/calculator.lua","programs/calculator.lua"},{"programs/notes.lua","programs/notes.lua"},
 {"programs/paint.lua","programs/paint.lua"},{"programs/clock.lua","programs/clock.lua"},{"programs/calendar.lua","programs/calendar.lua"},
 {"programs/settings.lua","programs/settings.lua"},{"programs/system.lua","programs/system.lua"},{"programs/browser.lua","programs/browser.lua"},
 {"programs/mail.lua","programs/mail.lua"},{"programs/store.lua","programs/store.lua"},{"programs/terminal.lua","programs/terminal.lua"},
 {"programs/devices.lua","programs/devices.lua"},{"programs/monitor.lua","programs/monitor.lua"},{"programs/printer.lua","programs/printer.lua"},
 {"programs/sound.lua","programs/sound.lua"},{"programs/network.lua","programs/network.lua"},{"programs/disks.lua","programs/disks.lua"},{"programs/redstone.lua","programs/redstone.lua"}
}
local function clear() term.setBackgroundColor(colors.black); term.setTextColor(colors.white); term.clear(); term.setCursorPos(1,1) end
local function center(y,s,c) local w=term.getSize(); term.setCursorPos(math.max(1,math.floor((w-#s)/2)+1),y); term.setTextColor(c or colors.white); write(s) end
local function get(url) local h,err=http.get(url,nil,true); if not h then return nil,err end; local d=h.readAll(); h.close(); return d end
clear(); center(3,"OScctweaked",colors.cyan); center(4,"Windows-style RP Computer",colors.lightBlue); center(6,"Installing system components...",colors.white)
if not http then center(8,"HTTP API is disabled.",colors.red); center(9,"Enable HTTP in CC:Tweaked config.",colors.orange); return end
if not fs.exists("documents") then fs.makeDir("documents") end
for i,item in ipairs(files) do
 local remote,localPath=item[1],item[2]
 term.setCursorPos(2,11); term.setTextColor(colors.lightGray); term.clearLine(); write(string.format("[%02d/%02d] %-38s",i,#files,remote))
 local data,err=get(BASE..remote)
 if not data then term.setCursorPos(2,13); term.setTextColor(colors.red); print("Download failed: "..tostring(err)); return end
 local dir=fs.getDir(localPath); if dir~="" and not fs.exists(dir) then fs.makeDir(dir) end
 local f=fs.open(localPath,"w"); if not f then print("Cannot write "..localPath); return end; f.write(data); f.close()
end
local startup=fs.open("startup.lua","w"); startup.write("shell.run('os.lua')"); startup.close()
clear(); center(5,"Installation complete",colors.lime); center(7,"OScctweaked is ready",colors.white); center(9,"Touch or press a key to start",colors.lightBlue)
while true do local e=os.pullEvent(); if e=="mouse_click" or e=="monitor_touch" or e=="key" then break end end
shell.run("os.lua")
