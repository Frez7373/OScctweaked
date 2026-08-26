local ui=dofile("core/ui.lua")
local pm=dofile("core/peripherals.lua")
local app={}
function app.new()
 local c={text="OScctweaked print test",notice=""}; local obj={ctx=c}
 local function printers() local o={}; for _,p in ipairs(pm.scan()) do for _,t in ipairs(p.types) do if t=="printer" then table.insert(o,p); break end end end; return o end
 function obj.draw(win,s) local w,h=win.getSize(); ui.clear(colors.white,colors.black); ui.header("Printer",w); local ps=printers(); if #ps==0 then ui.text(2,5,"No printer connected.",colors.gray,colors.white) else ui.text(2,4,"Printer: "..ps[1].name,colors.blue,colors.white); ui.text(2,6,"Text: "..s.text:sub(1,math.max(1,w-9)),colors.black,colors.white); ui.button(2,8,14,9,"NEW PAGE",colors.gray); ui.button(16,8,28,9,"PRINT",colors.green); ui.text(2,11,s.notice,colors.orange,colors.white) end end
 function obj.handle(ev,x,y,s) if ev~="click" then return false end; local ps=printers(); if #ps==0 then s.notice="Connect a printer first"; return true end; local p=ps[1].name; if ui.hit(x,y,2,8,14,9) then local ok,err=pm.safeCall(p,"newPage"); s.notice=ok and "New page ready" or err; return true elseif ui.hit(x,y,16,8,28,9) then local ok,err=pm.safeCall(p,"newPage"); if ok then pm.safeCall(p,"write",s.text); local e,e2=pm.safeCall(p,"endPage"); s.notice=e and "Page printed" or e2 else s.notice=err end; return true end; return false end
 return obj
end
return app
