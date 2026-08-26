local ui=dofile("core/ui.lua")
local pm=dofile("core/peripherals.lua")
local app={}
function app.new()
 local c={notice=""}; local obj={ctx=c}
 local function drives() local o={}; for _,p in ipairs(pm.scan()) do for _,t in ipairs(p.types) do if t=="drive" then table.insert(o,p); break end end end; return o end
 function obj.draw(win,s) local w,h=win.getSize(); ui.clear(colors.white,colors.black); ui.header("Disk Manager",w); local ds=drives(); if #ds==0 then ui.text(2,5,"No disk drive connected.",colors.gray,colors.white) else local y=5; for _,p in ipairs(ds) do ui.fill(2,y,w-1,y,colors.lightBlue,colors.black); ui.text(3,y,p.name,colors.black,colors.lightBlue); y=y+1; local disk=peripheral.wrap(p.name); local has=false; local ok=disk and pcall(function() has=disk.isDiskPresent() end); if ok and has then local label="(disk inserted)"; local ok2,l=pcall(function() return disk.getDiskLabel() end); if ok2 and l then label=label.." "..tostring(l) end; ui.text(4,y,label,colors.gray,colors.white) else ui.text(4,y,"(empty)",colors.gray,colors.white) end; y=y+2 end; ui.text(2,h-4,s.notice,colors.orange,colors.white) end; ui.button(2,h-2,14,h,"REFRESH",colors.cyan) end
 function obj.handle(ev,x,y,s) if ev~="click" then return false end; local w,h=term.getSize(); if ui.hit(x,y,2,h-2,14,h) then s.notice="Disk list refreshed"; return true end; return false end
 return obj
end
return app
