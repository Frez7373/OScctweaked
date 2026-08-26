local ui=dofile("core/ui.lua")
local pm=dofile("core/peripherals.lua")
local app={}
function app.new()
 local c={message="Hello from OScctweaked",channel="42",notice=""}; local obj={ctx=c}
 local function modems() local o={}; for _,p in ipairs(pm.scan()) do for _,t in ipairs(p.types) do if t=="modem" then table.insert(o,p); break end end end; return o end
 function obj.draw(win,s) local w,h=win.getSize(); ui.clear(colors.black,colors.white); ui.header("Network Center",w); local ms=modems(); if #ms==0 then ui.text(2,5,"No modem connected.",colors.gray,colors.black) else ui.text(2,4,"Modem: "..ms[1].name,colors.cyan,colors.black); ui.text(2,6,"Channel: "..s.channel,colors.white,colors.black); ui.text(2,7,"Message: "..s.message:sub(1,math.max(1,w-11)),colors.white,colors.black); ui.button(2,9,15,10,"OPEN",colors.blue); ui.button(17,9,31,10,"SEND",colors.green); ui.button(2,12,15,13,"CLOSE",colors.gray); ui.text(2,15,s.notice,colors.orange,colors.black) end end
 function obj.handle(ev,x,y,s) if ev~="click" then return false end; local ms=modems(); if #ms==0 then s.notice="Connect a modem first"; return true end; local p=ms[1].name; local ch=tonumber(s.channel) or 42; if ui.hit(x,y,2,9,15,10) then local ok,err=pm.safeCall(p,"open",ch); s.notice=ok and "Channel opened" or err elseif ui.hit(x,y,17,9,31,10) then local ok,err=pm.safeCall(p,"transmit",ch,ch,s.message); s.notice=ok and "Message sent" or err elseif ui.hit(x,y,2,12,15,13) then local ok,err=pm.safeCall(p,"close",ch); s.notice=ok and "Channel closed" or err else return false end; return true end
 return obj
end
return app
