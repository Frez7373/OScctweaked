local ui=dofile("core/ui.lua")
local app={}
function app.new()
 local c={}
 local obj={ctx=c}
 local function add(s) c.last=s end
 function obj.draw(win,s)
  local w,h=win.getSize(); ui.clear(colors.black,colors.lime); ui.header("Command Center",w)
  ui.fill(2,3,w-1,h-5,colors.black,colors.lime); ui.text(3,4,"Friendly tools - no commands required",colors.lime,colors.black)
  ui.button(2,h-4,12,h-3,"FILES",colors.blue); ui.button(14,h-4,24,h-3,"REBOOT",colors.orange); ui.button(26,h-4,w-2,h-3,"SHUTDOWN",colors.red)
  ui.text(3,h-6,s.last or "Choose an action",colors.lime,colors.black)
 end
 function obj.handle(ev,x,y,s)
  if ev~="click" then return false end
  local w,h=term.getSize()
  if ui.hit(x,y,2,h-4,12,h-3) then add("File Explorer is available from Start")
  elseif ui.hit(x,y,14,h-4,24,h-3) then os.reboot()
  elseif ui.hit(x,y,26,h-4,w-2,h-3) then os.shutdown()
  else return false end
  return true
 end
 return obj
end
return app
