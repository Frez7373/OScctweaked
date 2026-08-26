local ui=dofile("core/ui.lua")
local app={}
function app.new(ctx)
 local c={selected=1}; local obj={ctx=c}
 function obj.draw(win,s)
  local w,h=win.getSize(); ui.clear(colors.white,colors.black); ui.header("App Center",w)
  ui.text(2,3,"Built-in applications",colors.blue,colors.white)
  local list=ctx.apps or {}
  for i,a in ipairs(list) do local y=5+(i-1)*2; if y<h-2 then ui.button(2,y,w-2,y+1,a.icon.."  "..a.title,(s.selected==i and colors.blue or colors.gray)) end end
 end
 function obj.handle(ev,x,y,s)
  if ev~="click" then return false end
  local h=term.getSize(); if y>=5 and y<h-2 then local idx=math.floor((y-5)/2)+1; if ctx.apps and ctx.apps[idx] then s.selected=idx; return true end end; return false
 end
 return obj
end
return app
