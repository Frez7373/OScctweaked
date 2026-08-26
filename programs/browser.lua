local ui=dofile("core/ui.lua")
local app={}
function app.new()
 local c={message="Choose a site",body={}}
 local links={{"GitHub","https://github.com"},{"OpenAI","https://openai.com"},{"Example","https://example.com"}}
 local obj={ctx=c}
 local function fetch(url)
  if not http then c.message="HTTP is disabled"; c.body={"Enable HTTP in CC:Tweaked settings."}; return end
  local h,err=http.get(url,nil,true); if not h then c.message="Request failed"; c.body={tostring(err)}; return end
  local text=h.readAll() or ""; h.close(); c.message=url; c.body=ui.wrap(text,math.max(10,term.getSize()-6))
 end
 function obj.draw(win,s)
  local w,h=win.getSize(); ui.clear(colors.white,colors.black); ui.header("Web",w)
  ui.fill(2,2,w-1,3,colors.lightBlue,colors.black); ui.text(3,3,"Quick links",colors.black,colors.lightBlue)
  local cell=math.max(8,math.floor((w-5)/3)); for i,l in ipairs(links) do local x=2+(i-1)*(cell+1); ui.button(x,5,x+cell-1,6,l[1],colors.blue) end
  ui.fill(2,8,w-1,h-1,colors.white,colors.black); ui.text(3,8,s.message:sub(1,math.max(1,w-6)),colors.blue,colors.white)
  for i=1,math.min(#s.body,h-10) do ui.text(3,8+i,s.body[i]:sub(1,math.max(1,w-6)),colors.black,colors.white) end
 end
 function obj.handle(ev,x,y,s)
  if ev~="click" then return false end
  local w=term.getSize(); local cell=math.max(8,math.floor((w-5)/3))
  for i,l in ipairs(links) do local bx=2+(i-1)*(cell+1); if ui.hit(x,y,bx,5,bx+cell-1,6) then fetch(l[2]); return true end end
  return false
 end
 return obj
end
return app
