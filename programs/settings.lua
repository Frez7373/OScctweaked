local ui=dofile("core/ui.lua")
local app={}
function app.new(ctx0)
 local c={theme=ctx0.theme or "blue"}
 local obj={ctx=c}
 local themes={{id="blue",name="Windows Blue"},{id="dark",name="Dark Gray"},{id="green",name="Emerald"}}
 function obj.draw(win,s)
  local w,h=win.getSize(); ui.clear(colors.black,colors.white); ui.header("Settings",w)
  ui.text(2,3,"Appearance",colors.cyan,colors.black); ui.text(2,4,"Choose desktop theme",colors.gray,colors.black)
  for i,t in ipairs(themes) do local y=6+(i-1)*2; ui.button(2,y,w-2,y+1,t.name,(s.theme==t.id and colors.cyan or colors.gray)) end
  ui.text(2,14,"System",colors.cyan,colors.black); ui.button(2,15,w-2,16,"REBOOT COMPUTER",colors.orange); if h>=18 then ui.button(2,17,w-2,18,"SHUT DOWN",colors.red) end
 end
 function obj.handle(ev,x,y,s)
  if ev~="click" then return false end
  local w,h=term.getSize()
  for i,t in ipairs(themes) do if ui.hit(x,y,2,6+(i-1)*2,w-2,7+(i-1)*2) then s.theme=t.id; if ctx0.setTheme then ctx0.setTheme(t.id) end; return true end end
  if ui.hit(x,y,2,15,w-2,16) then os.reboot(); return true end
  if h>=18 and ui.hit(x,y,2,17,w-2,18) then os.shutdown(); return true end
  return false
 end
 return obj
end
return app
