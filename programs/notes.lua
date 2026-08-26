local ui=dofile("core/ui.lua")
local app={}
function app.new()
 local c={text="",caps=false}
 local rows={{"Q","W","E","R","T","Y","U","I","O","P"},{"A","S","D","F","G","H","J","K","L"},{"Z","X","C","V","B","N","M"}}
 if fs.exists("documents/notes.txt") then local f=fs.open("documents/notes.txt","r"); if f then c.text=f.readAll() or ""; f.close() end end
 local function save() if not fs.exists("documents") then fs.makeDir("documents") end; local f=fs.open("documents/notes.txt","w"); f.write(c.text); f.close() end
 local obj={ctx=c}
 function obj.draw(win,s)
  local w,h=win.getSize(); ui.clear(colors.white,colors.black); ui.header("Notepad",w)
  ui.fill(2,3,w-1,7,colors.white,colors.black); local lines=ui.wrap(s.text,w-4); for i=1,math.min(#lines,5) do ui.text(3,2+i,lines[i],colors.black,colors.white) end
  local start=9; local gap=math.max(2,math.floor((w-4)/10))
  for r,row in ipairs(rows) do for i,ch in ipairs(row) do local x=2+(i-1)*gap; local label=s.caps and ch or ch:lower(); ui.button(x,start+(r-1)*2,x+gap-2,start+(r-1)*2+1,label,colors.blue) end end
  ui.button(2,h-2,11,h,"SPACE",colors.gray); ui.button(13,h-2,22,h,"ENTER",colors.cyan); ui.button(24,h-2,34,h,"DELETE",colors.red); ui.button(36,h-2,w-1,h,"SAVE",colors.green)
 end
 function obj.handle(ev,x,y,s)
  if ev~="click" then return false end
  local w,h=term.getSize(); local start=9; local gap=math.max(2,math.floor((w-4)/10))
  for r,row in ipairs(rows) do if y>=start+(r-1)*2 and y<=start+(r-1)*2+1 then local i=math.floor((x-2)/gap)+1; if row[i] then s.text=s.text..(s.caps and row[i] or row[i]:lower()); return true end end end
  if ui.hit(x,y,2,h-2,11,h) then s.text=s.text.." "
  elseif ui.hit(x,y,13,h-2,22,h) then s.text=s.text.."\n"
  elseif ui.hit(x,y,24,h-2,34,h) then s.text=s.text:sub(1,-2)
  elseif ui.hit(x,y,36,h-2,w-1,h) then save()
  else return false end
  return true
 end
 return obj
end
return app
