local ui=dofile("core/ui.lua")
local app={}
function app.new()
 local c={selected=1}
 local messages={{from="System",subject="Welcome to OScctweaked",body="Your computer is ready for RP use."},{from="Admin",subject="No messages",body="Your inbox is empty."}}
 local obj={ctx=c}
 function obj.draw(win,s)
  local w,h=win.getSize(); ui.clear(colors.white,colors.black); ui.header("Mail",w)
  ui.fill(2,2,20,h-1,colors.lightGray,colors.black); ui.text(3,3,"Inbox",colors.blue,colors.lightGray)
  for i,m in ipairs(messages) do local y=5+(i-1)*3; ui.button(3,y,19,y+1,m.subject:sub(1,15),(s.selected==i and colors.blue or colors.gray)); ui.text(3,y+2,"From: "..m.from:sub(1,12),colors.black,colors.lightGray) end
  local m=messages[s.selected] or messages[1]; ui.fill(22,3,w-2,h-2,colors.white,colors.black); ui.text(24,5,m.subject,colors.blue,colors.white); ui.text(24,7,"From: "..m.from,colors.gray,colors.white); local lines=ui.wrap(m.body,w-26); for i=1,math.min(#lines,h-10) do ui.text(24,9+i,lines[i],colors.black,colors.white) end
 end
 function obj.handle(ev,x,y,s)
  if ev~="click" then return false end
  if x<=20 and y>=5 then local idx=math.floor((y-5)/3)+1; if messages[idx] then s.selected=idx; return true end end
  return false
 end
 return obj
end
return app
