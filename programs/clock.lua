local ui=dofile("core/ui.lua")
local app={}
function app.new()
 local obj={}
 function obj.draw(win,ctx)
  local w,h=win.getSize(); ui.clear(colors.black,colors.white); ui.header("Clock",w)
  ui.fill(3,3,w-2,h-3,colors.gray,colors.white)
  ui.center(3,w-2,6,os.date("%H:%M:%S"),colors.cyan,colors.gray)
  ui.center(3,w-2,9,os.date("%A"),colors.white,colors.gray)
  ui.center(3,w-2,11,os.date("%d %B %Y"),colors.lightBlue,colors.gray)
  ui.center(3,w-2,h-4,"Minecraft day "..math.floor(os.time()),colors.white,colors.gray)
 end
 function obj.tick() return true end
 function obj.handle() return false end
 return obj
end
return app
