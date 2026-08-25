local ui = dofile("ui.lua")
local expr=""
local result=""
local buttons={
 {"7",1,6},{"8",9,6},{"9",17,6},{"/",25,6},
 {"4",1,9},{"5",9,9},{"6",17,9},{"*",25,9},
 {"1",1,12},{"2",9,12},{"3",17,12},{"-",25,12},
 {"0",1,15},{".",9,15},{"=",17,15},{"+",25,15}
}
local W,H=term.getSize()
local function draw()
  W,H=term.getSize(); ui.clear(colors.black); ui.header("Calculator",true)
  ui.rect(2,3,W-1,5,colors.lightGray,colors.black)
  ui.text(3,3,expr,colors.black,colors.lightGray)
  ui.text(3,5,result,colors.blue,colors.lightGray)
  for _,b in ipairs(buttons) do
    local x,y=b[2],b[3]
    if x+6<=W then ui.button(x,y,x+6,y+2,b[1],b[1]=="=" and colors.green or colors.blue) end
  end
  ui.button(25,15,W,17,"CLEAR",colors.red)
end
local function calc()
  if expr=="" then result="" return end
  local fn=load("return "..expr)
  if not fn then result="Invalid expression" return end
  local ok,v=pcall(fn)
  result=ok and tostring(v) or "Error"
end
draw()
while true do
  local e,_,x,y=os.pullEvent()
  if e=="mouse_click" or e=="monitor_touch" then
    if ui.hit(x,y,W-9,1,W,2) then return end
    if ui.hit(x,y,25,15,W,17) then expr="" result="" draw()
    else
      for _,b in ipairs(buttons) do
        if ui.hit(x,y,b[2],b[3],b[2]+6,b[3]+2) then
          local v=b[1]
          if v=="=" then calc() else expr=expr..v; result="" end
          draw(); break
        end
      end
    end
  elseif e=="key" and _==keys.q then return end
end
