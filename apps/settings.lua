local ui=dofile("ui.lua")
local function draw()
  local W,H=term.getSize(); ui.clear(colors.black); ui.header("Settings",true)
  ui.text(2,4,"System",colors.cyan)
  ui.button(2,5,W-2,7,"SYSTEM INFORMATION",colors.blue)
  ui.button(2,8,W-2,10,"REBOOT COMPUTER",colors.orange)
  ui.button(2,11,W-2,13,"SHUT DOWN",colors.red)
  ui.text(2,15,"Touch a button to continue.",colors.lightGray)
end
draw()
while true do
  local e,_,x,y=os.pullEvent()
  if e=="mouse_click" or e=="monitor_touch" then
    local W,H=term.getSize()
    if ui.hit(x,y,W-9,1,W,2) then return end
    if ui.hit(x,y,2,5,W-2,7) then
      ui.clear(colors.black); ui.header("System Information",true)
      ui.text(2,4,"Computer ID: "..os.getComputerID(),colors.white)
      ui.text(2,5,"Label: "..(os.getComputerLabel() or "Not set"),colors.white)
      ui.text(2,6,"CraftOS: "..os.version(),colors.white)
      ui.button(2,9,W-2,11,"BACK",colors.blue)
      while true do
        local ev,_,bx,by=os.pullEvent()
        if (ev=="mouse_click" or ev=="monitor_touch") and ui.hit(bx,by,2,9,W-2,11) then draw(); break end
      end
    elseif ui.hit(x,y,2,8,W-2,10) then os.reboot()
    elseif ui.hit(x,y,2,11,W-2,13) then os.shutdown() end
  elseif e=="key" and _==keys.q then return end
end
