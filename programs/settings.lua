local ui=dofile("core/ui.lua")
local app={}
function app.new(ctx0)
 local c={theme=ctx0.theme or "blue"}
 local obj={ctx=c}
 local themes={{id="blue",name="Windows Blue",bg=colors.blue},{id="dark",name="Dark Gray",bg=colors.gray},{id="green",name="Emerald",bg=colors.green}}
 function obj.draw(win,s)
  local w,h=win.getSize(); ui.clear(colors.black,colors.white); ui.header("Settings",w)
  ui.text(2,3,"Appearance",colors.blue,colors.black)
  ui.text(2,4,"Choose desktop theme",colors.gray,colors.black)
  for i,t in ipairs(themes) do local y=6+(i-1)*2; ui.button(2,y,w-2,y+1,t.name,(s.theme==t.id and colors.cyan or colors.gray)) end
  ui.text(2,14,"System",colors.blue,colors.black)
  ui.button(2,15,w-2,16,"REBOOT",colors.orange)
  ui.button(2,17,w-2,18,"SHUT DOWN",colors.red)
 end
 function obj.handle(ev,x,y,s)
  if ev~="click" then return false end
  local w,h=term.getSize()
  for i,t in ipairs(themes) do if ui.hit(x,y,2,6+(i-1)*2,w-2,7+(i-1)*2) then s.theme=t.id; return true end end
  if ui.hit(x,y,2,15,w-2,16) then os.reboot() end
  if ui.hit(x,y,2,17,w-2,18) then os.shutdown() end
  return false
 end
 return obj
end
return app
