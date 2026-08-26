local ui=dofile("core/ui.lua")
local app={}
function app.new()
 local obj={}
 function obj.draw(win)
  local w,h=win.getSize(); ui.clear(colors.black,colors.white); ui.header("Task Manager",w)
  local mem=math.floor(collectgarbage("count")); local free=fs.getFreeSpace("/"); local cap=fs.getCapacity("/")
  ui.text(2,3,"Computer ID: "..os.getComputerID(),colors.white,colors.black)
  ui.text(2,4,"CraftOS: "..os.version(),colors.white,colors.black)
  ui.text(2,5,"Lua memory: "..mem.." KB",colors.white,colors.black)
  ui.text(2,6,"Disk: "..math.floor((cap-free)/math.max(1,cap)*100).."% used",colors.white,colors.black)
  ui.text(2,7,"Peripherals: "..#peripheral.getNames(),colors.white,colors.black)
  ui.text(2,9,"Connected devices",colors.cyan,colors.black)
  local y=10; for _,p in ipairs(peripheral.getNames()) do if y<h-2 then ui.text(3,y,p,colors.lightGray,colors.black); y=y+1 end end
 end
 function obj.handle() return false end
 return obj
end
return app
