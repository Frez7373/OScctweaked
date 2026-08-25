local ui=dofile("ui.lua")
local function draw()
 local W,H=term.getSize(); ui.clear(colors.black); ui.header("System Monitor",true)
 local label=os.getComputerLabel() or "Not set"
 ui.text(2,4,"Computer ID: "..os.getComputerID(),colors.white)
 ui.text(2,5,"Label: "..label,colors.white)
 ui.text(2,6,"CraftOS: "..os.version(),colors.white)
 ui.text(2,8,"Free space: "..tostring(fs.getFreeSpace("/")),colors.white)
 ui.text(2,9,"Used space: "..tostring(fs.getCapacity("/")-fs.getFreeSpace("/")),colors.white)
 ui.text(2,11,"Peripherals: "..tostring(#peripheral.getNames()),colors.white)
 ui.button(2,H-3,W-2,H-1,"BACK",colors.blue)
end
draw()
while true do
 local e,_,x,y=os.pullEvent()
 local W,H=term.getSize()
 if (e=="mouse_click" or e=="monitor_touch") and ui.hit(x,y,2,H-3,W-2,H-1) then return end
 if e=="key" and _==keys.q then return end
end
