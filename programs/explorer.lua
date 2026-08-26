local ui=dofile("core/ui.lua")
local app={}
function app.new()
 local ctx={path="/",selected=nil}
 local obj={ctx=ctx}
 local function list(path) return fs.list(path) end
 function obj.draw(win,c)
  local w,h=win.getSize(); ui.clear(colors.white,colors.black); ui.header("File Explorer",w)
  ui.fill(2,2,w-1,3,colors.lightBlue,colors.black); ui.text(3,3,c.path,colors.black,colors.lightBlue)
  local names=list(c.path); local max=math.max(1,h-8)
  for i=1,math.min(#names,max) do
   local n=names[i]; local full=fs.combine(c.path,n); local dir=fs.isDir(full); local y=5+i
   local bg=(c.selected==i and colors.blue or colors.white); local fg=(c.selected==i and colors.white or colors.black)
   ui.fill(2,y,w-2,y,bg,fg); ui.text(3,y,(dir and "[DIR] " or "      ")..n,fg,bg)
  end
  ui.button(2,h-2,10,h,"UP",colors.blue); ui.button(12,h-2,22,h,"HOME",colors.gray)
 end
 function obj.handle(ev,x,y,c)
  if ev~="click" then return false end
  local w,h=term.getSize()
  if ui.hit(x,y,2,h-2,10,h) then
   if c.path~="/" then c.path=fs.getDir(c.path:gsub("/$","")); if c.path=="" then c.path="/" end; if c.path:sub(-1)~="/" then c.path=c.path.."/" end end
   return true
  end
  if ui.hit(x,y,12,h-2,22,h) then c.path="/"; return true end
  if y>=6 and y<=h-8 then
   local idx=y-5; local names=list(c.path); local n=names[idx]
   if n then c.selected=idx; local full=fs.combine(c.path,n)
    if fs.isDir(full) then c.path=full.."/"; c.selected=nil
    else c.openFile=full end
   end
   return true
  end
  return false
 end
 return obj
end
return app
