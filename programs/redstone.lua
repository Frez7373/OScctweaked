local ui=dofile("core/ui.lua")
local pm=dofile("core/peripherals.lua")
local app={}
function app.new()
 local c={side="left",on=false,notice=""}; local obj={ctx=c}
 local sides={"left","right","top","bottom","front","back"}
 local function available() local out={}; for _,p in ipairs(pm.scan()) do for _,t in ipairs(p.types) do if t=="redstone_relay" then table.insert(out,p); break end end end; return out end
 function obj.draw(win,s) local w,h=win.getSize(); ui.clear(colors.black,colors.white); ui.header("Redstone Control",w); local rs=available(); ui.text(2,4,#rs>0 and ("Relay: "..rs[1].name) or "Direct computer redstone",colors.cyan,colors.black); ui.text(2,6,"Side: "..s.side,colors.white,colors.black); ui.button(2,8,12,9,"LEFT",colors.gray); ui.button(14,8,24,9,"RIGHT",colors.gray); ui.button(2,11,12,12,"TOP",colors.gray); ui.button(14,11,24,12,"FRONT",colors.gray); ui.button(2,14,14,15,s.on and "TURN OFF" or "TURN ON",s.on and colors.red or colors.green); ui.text(2,17,s.notice,colors.orange,colors.black) end
 function obj.handle(ev,x,y,s) if ev~="click" then return false end; local rs=available(); local target=rs[1] and rs[1].name; if ui.hit(x,y,2,8,12,9) then s.side="left" elseif ui.hit(x,y,14,8,24,9) then s.side="right" elseif ui.hit(x,y,2,11,12,12) then s.side="top" elseif ui.hit(x,y,14,11,24,12) then s.side="front" elseif ui.hit(x,y,2,14,14,15) then s.on=not s.on; if target then local ok,err=pm.safeCall(target,"setOutput",s.side,s.on); s.notice=ok and "Output updated" or err else redstone.setOutput(s.side,s.on); s.notice="Output updated" end else return false end; return true end
 return obj
end
return app
