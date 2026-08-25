local ui=dofile("ui.lua")
local W,H=term.getSize()
local startOpen=false
local selected=nil
local apps={
 {name="Files",icon="F",file="apps/files.lua"},
 {name="Calculator",icon="#",file="apps/calculator.lua"},
 {name="Notepad",icon="N",file="apps/notepad.lua"},
 {name="Clock",icon="C",file="apps/clock.lua"},
 {name="Paint",icon="P",file="apps/paint.lua"},
 {name="System",icon="S",file="apps/system.lua"},
 {name="Settings",icon="G",file="apps/settings.lua"},
 {name="About",icon="i",file="apps/about.lua"}
}
local function appGrid()
 W,H=term.getSize(); local cols=math.max(1,math.floor((W-2)/12)); local top=4
 for i,a in ipairs(apps) do
   local col=(i-1)%cols; local row=math.floor((i-1)/cols)
   local x=2+col*12; local y=top+row*5
   if x+8<=W and y+3<=H-2 then
     ui.rect(x,y,x+8,y+3,selected==i and colors.blue or colors.gray,colors.white)
     ui.text(x+4,y,a.icon,colors.cyan,selected==i and colors.blue or colors.gray)
     ui.text(x+1,y+2,a.name,colors.white,selected==i and colors.blue or colors.gray)
   end
 end
end
local function draw()
 W,H=term.getSize(); ui.clear(colors.black)
 ui.rect(1,1,W,2,colors.blue,colors.white)
 ui.text(2,1,"OScctweaked",colors.white,colors.blue)
 ui.text(math.max(2,W-7),1,os.date("%H:%M"),colors.white,colors.blue)
 ui.text(2,3,"Desktop",colors.lightBlue,colors.black)
 appGrid()
 ui.rect(1,H-2,W,H,colors.gray,colors.white)
 ui.button(2,H-2,11,H,"START",colors.blue)
 ui.text(13,H-1,"Touch an app to open",colors.lightGray,colors.gray)
 if startOpen then
   local mw=math.min(32,W-2); local mh=math.min(H-4,18); local x=2; local y=H-3-mh
   ui.rect(x,y,x+mw,y+mh,colors.lightGray,colors.black)
   ui.text(x+2,y+1,"OScctweaked",colors.blue,colors.lightGray)
   for i,a in ipairs(apps) do
     local by=y+2+(i-1)*2
     if by+1<=y+mh-1 then ui.button(x+1,by,x+mw-1,by+1,a.icon.."  "..a.name,colors.blue) end
   end
 end
end
local function launch(a)
 if fs.exists(a.file) then shell.run(a.file) end
 selected=nil; draw()
end
draw()
while true do
 local e,_,x,y=os.pullEvent()
 if e=="term_resize" then draw()
 elseif (e=="mouse_click" or e=="monitor_touch") then
   W,H=term.getSize()
   if ui.hit(x,y,2,H-2,11,H) then startOpen=not startOpen; draw()
   elseif startOpen then
     local mw=math.min(32,W-2); local mh=math.min(H-4,18); local sx=2; local sy=H-3-mh
     local idx=math.floor((y-(sy+2))/2)+1
     if x>=sx+1 and x<=sx+mw-1 and idx>=1 and idx<=#apps then startOpen=false; launch(apps[idx]) else startOpen=false; draw() end
   else
     local cols=math.max(1,math.floor((W-2)/12)); local col=math.floor((x-2)/12); local row=math.floor((y-4)/5)
     local idx=row*cols+col+1
     if x>=2 and y>=4 and idx>=1 and idx<=#apps then selected=idx; draw(); sleep(0.08); launch(apps[idx]) end
   end
 elseif e=="key" and _==keys.q then return end
 end
end
