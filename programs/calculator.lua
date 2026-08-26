local ui=dofile("core/ui.lua")
local app={}
function app.draw(win,ctx)
 local w,h=win.getSize(); ui.clear(colors.white,colors.black); ui.header("Calculator",w)
 ui.fill(2,3,w-1,5,colors.lightBlue,colors.black)
 ui.text(3,3,ctx.expr=="" and "0" or ctx.expr,colors.black,colors.lightBlue)
 ui.text(3,5,ctx.result,colors.blue,colors.lightBlue)
 local bw=math.max(5,math.floor((w-5)/4)); local bh=2
 local vals={{"7","8","9","/"},{"4","5","6","*"},{"1","2","3","-"},{"0",".","=","+"}}
 for r=1,4 do for c=1,4 do
   local x=2+(c-1)*(bw+1); local y=7+(r-1)*(bh+1)
   ui.button(x,y,x+bw-1,y+bh-1,vals[r][c],vals[r][c]=="=" and colors.green or colors.blue)
 end end
 ui.button(2,17,w-1,18,"CLEAR",colors.red)
end
function app.new()
 local ctx={expr="",result=""}
 local obj={ctx=ctx}
 function obj.draw(win,c) app.draw(win,c) end
 function obj.handle(ev,x,y,c)
  if ev~="click" then return end
  local w=term.getSize(); local bw=math.max(5,math.floor((w-5)/4)); local bh=2
  if ui.hit(x,y,2,17,w-1,18) then c.expr=""; c.result=""; return true end
  local vals={{"7","8","9","/"},{"4","5","6","*"},{"1","2","3","-"},{"0",".","=","+"}}
  for r=1,4 do for col=1,4 do
    local bx=2+(col-1)*(bw+1); local by=7+(r-1)*(bh+1)
    if ui.hit(x,y,bx,by,bx+bw-1,by+bh-1) then
      local v=vals[r][col]
      if v=="=" then
        local fn=load("return "..c.expr)
        if not fn then c.result="Invalid" else local ok,res=pcall(fn); c.result=ok and tostring(res) or "Error" end
      else c.expr=c.expr..v; c.result="" end
      return true
    end
  end end
  return false
 end
 return obj
end
return app
