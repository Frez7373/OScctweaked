local ui=dofile("ui.lua")
local function draw()
 local W,H=term.getSize(); ui.clear(colors.black); ui.header("Calendar",true)
 ui.card(2,4,W-1,8,"MINECRAFT DATE","World day "..math.floor(os.time()),colors.cyan)
 ui.center(6,os.date("%A"),colors.white,colors.gray)
 ui.center(10,"CURRENT WORLD DAY",colors.lightGray)
 ui.center(12,tostring(math.floor(os.time())%1000),colors.lime)
 ui.text(2,14,"Calendar is synced to the Minecraft world clock.",colors.lightGray)
 ui.button(2,H-3,W-2,H-1,"BACK",colors.blue)
end
draw()
while true do
 local e,_,x,y=os.pullEvent()
 if e=="mouse_click" or e=="monitor_touch" then local W,H=term.getSize(); if ui.hit(x,y,2,H-3,W-2,H-1) or ui.hit(x,y,W-9,1,W,2) then return end
 elseif e=="key" and _==keys.q then return end
end
