local expr=""
local function draw()
 term.setBackgroundColor(colors.black); term.clear(); term.setTextColor(colors.white); term.setCursorPos(2,2); print("Calculator")
 term.setCursorPos(2,4); write(expr)
 print("")
 print("Type an expression, e.g. 12*5+2")
 print("Enter = calculate | Backspace | Q = exit")
end
draw()
while true do
 local e,k=os.pullEvent("key")
 if k==keys.q then return
 elseif k==keys.enter then
  local fn=load("return "..expr)
  if fn then local ok,res=pcall(fn); expr=ok and tostring(res) or "Error" else expr="Error" end
  draw()
 elseif k==keys.backspace then expr=expr:sub(1,-2); draw()
 end
end
