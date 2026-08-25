local ui=dofile("ui.lua")
local W,H=term.getSize()
local lines={"OScctweaked Terminal","","Touch a command button below.",""}
local function add(s) table.insert(lines,s); while #lines>H-8 do table.remove(lines,1) end end
local function draw()
 W,H=term.getSize(); ui.clear(colors.black); ui.header("Terminal",true)
 ui.rect(2,3,W-1,H-7,colors.black,colors.lime)
 for i,l in ipairs(lines) do if i<=H-9 then ui.text(3,3+i,l,colors.lime,colors.black) end end
 local y=H-5
 ui.button(2,y,11,y+1,"LS",colors.blue); ui.button(13,y,22,y+1,"ID",colors.cyan); ui.button(24,y,34,y+1,"MEM",colors.purple)
 ui.button(2,y+2,11,y+3,"HELP",colors.gray); ui.button(13,y+2,22,y+3,"REBOOT",colors.orange); ui.button(24,y+2,34,y+3,"SHUTDOWN",colors.red)
end
draw()
while true do
 local e,_,x,y=os.pullEvent()
 if e=="mouse_click" or e=="monitor_touch" then
  if ui.hit(x,y,W-9,1,W,2) then return end
  local by=H-5
  if ui.hit(x,y,2,by,11,by+1) then add("$ ls"); for _,n in ipairs(fs.list("/")) do add("  "..n) end
  elseif ui.hit(x,y,13,by,22,by+1) then add("$ id"); add("Computer ID: "..os.getComputerID())
  elseif ui.hit(x,y,24,by,34,by+1) then add("$ mem"); add("Memory: "..math.floor(collectgarbage("count")).." KB")
  elseif ui.hit(x,y,2,by+2,11,by+3) then add("$ help"); add("LS  ID  MEM  REBOOT  SHUTDOWN")
  elseif ui.hit(x,y,13,by+2,22,by+3) then add("$ reboot"); draw(); sleep(0.3); os.reboot()
  elseif ui.hit(x,y,24,by+2,34,by+3) then os.shutdown() end
  draw()
 elseif e=="key" and _==keys.q then return end
 end
end
