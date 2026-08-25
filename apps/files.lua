local ui=dofile("ui.lua")
local path="/"
local function draw()
 local W,H=term.getSize(); ui.clear(colors.black); ui.header("File Explorer",true)
 ui.rect(2,3,W-1,4,colors.lightGray,colors.black); ui.text(3,3,path,colors.black,colors.lightGray)
 local list=fs.list(path); local max=math.max(1,H-9)
 for i=1,math.min(#list,max) do
  local name=list[i]; local full=fs.combine(path,name); local dir=fs.isDir(full); local y=5+i
  ui.button(2,y,W-9,y+1,(dir and "DIR  " or "FILE ")..name,dir and colors.blue or colors.gray)
  ui.button(W-8,y,W-2,y+1,"OPEN",colors.cyan)
 end
 ui.button(2,H-3,11,H-1,"UP",colors.blue); ui.button(13,H-3,24,H-1,"HOME",colors.gray)
end
draw()
while true do
 local e,_,x,y=os.pullEvent()
 if e=="mouse_click" or e=="monitor_touch" then
  local W,H=term.getSize()
  if ui.hit(x,y,W-9,1,W,2) then return end
  if ui.hit(x,y,2,H-3,11,H-1) then
   if path~="/" then path=path:gsub("/$",""); local parent=path:match("^(.+)/[^/]+$"); path=parent and (parent.."/") or "/" end; draw()
  elseif ui.hit(x,y,13,H-3,24,H-1) then path="/"; draw()
  elseif y>=6 and y<=H-10 and x>=W-8 then
   local idx=y-5; local list=fs.list(path); local name=list[idx]
   if name and fs.isDir(fs.combine(path,name)) then path=fs.combine(path,name); draw() end
  elseif y>=6 and y<=H-10 then
   local idx=y-5; local list=fs.list(path); local name=list[idx]
   if name and not fs.isDir(fs.combine(path,name)) then
     ui.clear(colors.black); ui.header(name,true); local f=fs.open(fs.combine(path,name),"r"); local text=f and f.readAll() or ""; if f then f.close() end
     local lines=ui.wrap(text,math.max(10,W-4)); for i=1,math.min(#lines,H-5) do ui.text(2,3+i,lines[i],colors.lightGray,colors.black) end; ui.button(2,H-2,W-2,H,"BACK",colors.blue); ui.waitTouch(); draw()
   end
  end
 elseif e=="key" and _==keys.q then return end
 end
end
