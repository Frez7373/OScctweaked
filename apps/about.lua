local ui=dofile("ui.lua")
local function draw()
  local W,H=term.getSize(); ui.clear(colors.black); ui.header("About OScctweaked",true)
  ui.center(5,"OScctweaked",colors.cyan)
  ui.center(7,"Touchscreen Edition",colors.lightBlue)
  ui.center(9,"A Windows-inspired OS for CC:Tweaked",colors.white)
  ui.center(11,"Built for computers, monitors and touch",colors.lightGray)
  ui.button(2,H-3,W-2,H-1,"BACK",colors.blue)
end
draw()
while true do
  local e,_,x,y=os.pullEvent()
  local W,H=term.getSize()
  if (e=="mouse_click" or e=="monitor_touch") and ui.hit(x,y,2,H-3,W-2,H-1) then return end
  if e=="key" and _==keys.q then return end
end
