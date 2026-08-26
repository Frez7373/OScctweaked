local ui=dofile("core/ui.lua")
local pm=dofile("core/peripherals.lua")
local app={}
function app.new()
 local c={name=nil,text="OScctweaked Monitor",scale=1}
 local obj={ctx=c}
 local function monitors(s)
  local out={}
  for _,p in ipairs(pm.scan()) do for _,t in ipairs(p.types) do if t=="monitor" then table.insert(out,p); break end end end
  return out
 end
 function obj.draw(win,s)
  local w,h=win.getSize(); ui.clear(colors.black,colors.white); ui.header("Monitor Studio",w)
  ui.text(2,3,"Monitor",colors.cyan,colors.black)
  local m=monitors(s); if #m==0 then ui.text(2,5,"No monitor connected.",colors.lightGray,colors.black)
  else
    if not s.name then s.name=m[1].name end
    ui.text(2,5,"Device: "..s.name,colors.white,colors.black)
    ui.button(2,7,12,8,"WRITE",colors.blue); ui.button(14,7,25,8,"CLEAR",colors.gray); ui.button(27,7,38,8,"SCALE +",colors.cyan)
    ui.text(2,10,"Text: "..s.text:sub(1,math.max(1,w-10)),colors.lightGray,colors.black)
    ui.button(2,h-2,20,h,"SEND TO MONITOR",colors.green)
  end
 end
 function obj.handle(ev,x,y,s)
  if ev~="click" then return false end
  local w,h=term.getSize(); local m=monitors(s)
  if ui.hit(x,y,14,7,25,8) and s.name then pm.safeCall(s.name,"clear"); return true end
  if ui.hit(x,y,27,7,38,8) and s.name then s.scale=math.min(5,s.scale+0.5); pm.safeCall(s.name,"setTextScale",s.scale); return true end
  if ui.hit(x,y,2,h-2,20,h) and s.name then local ok,err=pm.safeCall(s.name,"clear"); if ok then pm.safeCall(s.name,"setCursorPos",1,1); pm.safeCall(s.name,"write",s.text) else s.text=err end; return true end
  if y==7 and x>=2 and x<=12 then s.text="Hello from OScctweaked"; return true end
  return false
 end
 return obj
end
return app
