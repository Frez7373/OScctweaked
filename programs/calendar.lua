local ui=dofile("core/ui.lua")
local app={}
function app.new()
 local obj={offset=0}
 function obj.draw(win,ctx)
  local w,h=win.getSize(); ui.clear(colors.white,colors.black); ui.header("Calendar",w)
  local day=math.floor(os.time())+ctx.offset
  ui.text(2,3,"Minecraft world day: "..day,colors.blue,colors.white)
  ui.text(2,4,"Week day: "..os.date("%A"),colors.gray,colors.white)
  ui.button(2,h-2,12,h,"PREV",colors.blue); ui.button(14,h-2,24,h,"TODAY",colors.cyan); ui.button(26,h-2,36,h,"NEXT",colors.blue)
  local start=6
  for i=0,6 do
    local d=day+i
    ui.fill(2,start+i*2,w-2,start+i*2+1,(i==0 and colors.lightBlue or colors.lightGray),colors.black)
    ui.text(4,start+i*2+1,os.date("%A",os.time()+i*86400),colors.black,(i==0 and colors.lightBlue or colors.lightGray))
    ui.text(w-12,start+i*2+1,"DAY "..d,colors.blue,(i==0 and colors.lightBlue or colors.lightGray))
  end
 end
 function obj.handle(ev,x,y,c)
  if ev~="click" then return false end
  local w,h=term.getSize()
  if ui.hit(x,y,2,h-2,12,h) then c.offset=c.offset-1; return true end
  if ui.hit(x,y,14,h-2,24,h) then c.offset=0; return true end
  if ui.hit(x,y,26,h-2,36,h) then c.offset=c.offset+1; return true end
  return false
 end
 return obj
end
return app
