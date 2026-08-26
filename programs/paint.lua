local ui=dofile("core/ui.lua")
local app={}
function app.new()
 local c={color=colors.blue,marks={}}
 local palette={colors.black,colors.red,colors.orange,colors.yellow,colors.lime,colors.cyan,colors.blue,colors.purple,colors.white}
 local obj={ctx=c}
 function obj.draw(win,s)
  local w,h=win.getSize(); ui.clear(colors.white,colors.black); ui.header("Paint",w)
  for i,col in ipairs(palette) do local x=2+(i-1)*3; if x+1<w then ui.button(x,3,x+1,4,"  ",col,col==colors.black and colors.white or colors.black) end end
  ui.fill(2,6,w-1,h-3,colors.white,colors.black)
  for _,m in ipairs(s.marks) do if m.x>=2 and m.x<=w-1 and m.y>=6 and m.y<=h-3 then term.setBackgroundColor(m.c); term.setCursorPos(m.x,m.y); write(" ") end end
  ui.text(3,7,"Touch the canvas to paint",colors.gray,colors.white)
  ui.button(2,h-2,12,h,"CLEAR",colors.red)
 end
 function obj.handle(ev,x,y,s)
  if ev~="click" then return false end
  local w,h=term.getSize()
  if ui.hit(x,y,2,h-2,12,h) then s.marks={}; return true end
  if y>=3 and y<=4 then local i=math.floor((x-2)/3)+1; if palette[i] then s.color=palette[i]; return true end end
  if y>=6 and y<=h-3 and x>=2 and x<=w-1 then table.insert(s.marks,{x=x,y=y,c=s.color}); return true end
  return false
 end
 return obj
end
return app
