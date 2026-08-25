local ui=dofile("ui.lua")
local function draw()
  local W,H=term.getSize(); ui.clear(colors.black); ui.header("Clock",true)
  ui.center(6,os.date("%H:%M:%S"),colors.cyan)
  ui.center(8,os.date("%A"),colors.lightBlue)
  ui.center(10,os.date("%d %B %Y"),colors.white)
  ui.center(13,"Touch BACK to return",colors.lightGray)
end
while true do
  draw()
  local timer=os.startTimer(1)
  while true do
    local e,_,x,y=os.pullEvent()
    local W,H=term.getSize()
    if (e=="mouse_click" or e=="monitor_touch") and ui.hit(x,y,W-9,1,W,2) then return end
    if e=="timer" then break end
    if e=="key" and _==keys.q then return end
  end
end
