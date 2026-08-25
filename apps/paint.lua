local ui=dofile("ui.lua")
local W,H=term.getSize()
local current=colors.white
local swatches={colors.white,colors.red,colors.orange,colors.yellow,colors.lime,colors.cyan,colors.blue,colors.purple,colors.pink,colors.black}
local canvasTop=5
local function draw()
 W,H=term.getSize(); ui.clear(colors.black); ui.header("Paint",true)
 for i,c in ipairs(swatches) do
   local x=2+(i-1)*3
   if x+2<=W then ui.button(x,3,x+2,4,"  ",c, c==colors.black and colors.white or colors.black) end
 end
 ui.rect(2,canvasTop,W-1,H-2,colors.white,colors.black," ")
 ui.button(2,H-1,12,H,"CLEAR",colors.red)
end
draw()
while true do
 local e,_,x,y=os.pullEvent()
 if e=="mouse_click" or e=="monitor_touch" then
   if ui.hit(x,y,W-9,1,W,2) then return end
   if y>=3 and y<=4 then
     local idx=math.floor((x-2)/3)+1
     if idx>=1 and idx<=#swatches then current=swatches[idx] end
   elseif y>=canvasTop and y<=H-2 and x>=2 and x<=W-1 then
     term.setBackgroundColor(current); term.setCursorPos(x,y); write(" ")
   elseif ui.hit(x,y,2,H-1,12,H) then draw() end
 elseif e=="key" and _==keys.q then return end
 end
end
