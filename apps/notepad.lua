local ui=dofile("ui.lua")
local file="notepad.txt"
local text=""
if fs.exists(file) then local f=fs.open(file,"r"); text=f.readAll() or ""; f.close() end
local W,H=term.getSize()
local keys={
 {"Q","W","E","R","T","Y","U","I","O","P"},
 {"A","S","D","F","G","H","J","K","L"},
 {"Z","X","C","V","B","N","M"}
}
local function save()
 local f=fs.open(file,"w"); f.write(text); f.close()
end
local function draw()
 W,H=term.getSize(); ui.clear(colors.black); ui.header("Notepad",true)
 ui.rect(2,3,W-1,8,colors.white,colors.black)
 local shown=text:sub(math.max(1,#text-((W-3)*5)+1))
 local y=3
 for line in shown:gmatch("[^\n]*") do if y<=8 then ui.text(3,y,line,colors.black,colors.white); y=y+1 end end
 local start=H-9
 for r,row in ipairs(keys) do
   local gap=math.floor((W-4)/#row)
   for i,ch in ipairs(row) do
     local x=2+(i-1)*gap
     ui.button(x,start+(r-1)*2,x+gap-2,start+(r-1)*2+1,ch,colors.blue)
   end
 end
 ui.button(2,H-2,10,H-1,"SPACE",colors.gray)
 ui.button(11,H-2,19,H-1,"ENTER",colors.cyan)
 ui.button(20,H-2,30,H-1,"DELETE",colors.red)
 ui.button(31,H-2,W-2,H-1,"SAVE",colors.green)
end
draw()
while true do
 local e,_,x,y=os.pullEvent()
 if e=="mouse_click" or e=="monitor_touch" then
   local W,H=term.getSize()
   if ui.hit(x,y,W-9,1,W,2) then save(); return end
   local start=H-9
   local done=false
   for r,row in ipairs(keys) do
     if y>=start+(r-1)*2 and y<=start+(r-1)*2+1 then
       local gap=math.floor((W-4)/#row)
       local i=math.floor((x-2)/gap)+1
       if i>=1 and i<=#row then text=text..row[i]; done=true end
     end
   end
   if not done and ui.hit(x,y,2,H-2,10,H-1) then text=text.." " end
   if not done and ui.hit(x,y,11,H-2,19,H-1) then text=text.."\n" end
   if not done and ui.hit(x,y,20,H-2,30,H-1) then text=text:sub(1,-2) end
   if not done and ui.hit(x,y,31,H-2,W-2,H-1) then save() end
   draw()
 elseif e=="char" then text=text.._ ; draw()
 elseif e=="key" and _==keys.q then save(); return end
 end
end
