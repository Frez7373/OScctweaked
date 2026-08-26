local ui=dofile("core/ui.lua")
local app={}
function app.new()
 local c={expr="",result=""}; local obj={ctx=c}
 function obj.draw(win,s)
  local w,h=win.getSize(); ui.clear(colors.white,colors.black); ui.header("Calculator",w)
  ui.fill(2,3,w-1,5,colors.lightBlue,colors.black); ui.text(3,3,s.expr=="" and "0" or s.expr,colors.black,colors.lightBlue); ui.text(3,5,s.result,colors.blue,colors.lightBlue)
  local bh=2; local top=7; local gap=1; local bw=math.max(4,math.floor((w-5)/4)); local vals={{"7","8","9","/"},{"4","5","6","*"},{"1","2","3","-"},{"0",".","=","+"}}
  for r=1,4 do for col=1,4 do local x=2+(col-1)*(bw+gap); local y=top+(r-1)*(bh+gap); if y+bh-1<h-1 then ui.button(x,y,math.min(w-1,x+bw-1),y+bh-1,vals[r][col],vals[r][col]=="=" and colors.green or colors.blue) end end end
  ui.button(2,h-1,w-1,h,"CLEAR",colors.red)
 end
 function obj.handle(ev,x,y,s)
  if ev~="click" then return false end
  local w,h=term.getSize(); local bh=2; local top=7; local gap=1; local bw=math.max(4,math.floor((w-5)/4)); local vals={{"7","8","9","/"},{"4","5","6","*"},{"1","2","3","-"},{"0",".","=","+"}}
  if ui.hit(x,y,2,h-1,w-1,h) then s.expr=""; s.result=""; return true end
  for r=1,4 do for col=1,4 do local bx=2+(col-1)*(bw+gap); local by=top+(r-1)*(bh+gap); if ui.hit(x,y,bx,by,bx+bw-1,by+bh-1) then local v=vals[r][col]; if v=="=" then local fn=load("return "..s.expr); if not fn then s.result="Invalid" else local ok,res=pcall(fn); s.result=ok and tostring(res) or "Error" end else s.expr=s.expr..v; s.result="" end; return true end end end
  return false
 end
 return obj
end
return app
