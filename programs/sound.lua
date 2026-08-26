local ui=dofile("core/ui.lua")
local pm=dofile("core/peripherals.lua")
local app={}
function app.new()
 local c={note="harp",pitch=1,volume=1,notice=""}; local obj={ctx=c}
 local function speakers() local o={}; for _,p in ipairs(pm.scan()) do for _,t in ipairs(p.types) do if t=="speaker" then table.insert(o,p); break end end end; return o end
 function obj.draw(win,s) local w,h=win.getSize(); ui.clear(colors.black,colors.white); ui.header("Sound Center",w); local sp=speakers(); if #sp==0 then ui.text(2,5,"No speaker connected.",colors.gray,colors.black) else ui.text(2,4,"Speaker: "..sp[1].name,colors.cyan,colors.black); ui.button(2,7,13,8,"HARP",colors.blue); ui.button(15,7,26,8,"BASS",colors.purple); ui.button(28,7,39,8,"BELL",colors.orange); ui.button(2,10,15,11,"QUIET",colors.gray); ui.button(17,10,30,11,"LOUD",colors.green); ui.text(2,14,s.notice,colors.lightGray,colors.black) end end
 function obj.handle(ev,x,y,s) if ev~="click" then return false end; local sp=speakers(); if #sp==0 then s.notice="Connect a speaker first"; return true end; local p=sp[1].name; local note="harp"; if ui.hit(x,y,15,7,26,8) then note="bass" elseif ui.hit(x,y,28,7,39,8) then note="bell" elseif not ui.hit(x,y,2,7,13,8) and not ui.hit(x,y,2,10,15,11) and not ui.hit(x,y,17,10,30,11) then return false end; if ui.hit(x,y,2,10,15,11) then s.volume=0.2 elseif ui.hit(x,y,17,10,30,11) then s.volume=1 end; if y>=7 and y<=8 then local ok,err=pm.safeCall(p,"playNote",note,s.volume,1); s.notice=ok and "Sound played" or err end; return true end
 return obj
end
return app
