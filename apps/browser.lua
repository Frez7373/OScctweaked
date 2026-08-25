local ui=dofile("ui.lua")
local W,H=term.getSize()
local message="Select a quick link"
local body={}
local function fetch(url)
 if not http then message="HTTP is disabled"; body={"Enable HTTP in CC:Tweaked config"}; return end
 local h,err=http.get(url,nil,true)
 if not h then message="Request failed"; body={tostring(err)}; return end
 local text=h.readAll() or ""; h.close(); message=url; body=ui.wrap(text,math.max(10,W-6))
end
local links={{"GitHub","https://github.com"},{"OpenAI","https://openai.com"},{"Example","https://example.com"}}
local function draw()
 W,H=term.getSize(); ui.clear(colors.black); ui.header("Browser",true)
 ui.card(2,4,W-1,7,"NOVA WEB","Simple touchscreen HTTP browser",colors.cyan)
 local y=9
 for i,l in ipairs(links) do ui.button(2+(i-1)*math.floor((W-4)/#links),y,1+i*math.floor((W-4)/#links),y+2,l[1],i==1 and colors.blue or (i==2 and colors.purple or colors.gray)) end
 ui.rect(2,12,W-1,H-3,colors.lightGray,colors.black)
 ui.text(3,13,message:sub(1,math.max(1,W-6)),colors.blue,colors.lightGray)
 for i=1,math.min(#body,H-15) do ui.text(3,14+i,body[i]:sub(1,math.max(1,W-6)),colors.black,colors.lightGray) end
 ui.button(2,H-2,W-2,H,"BACK",colors.blue)
end
draw()
while true do
 local e,_,x,y=os.pullEvent()
 if e=="mouse_click" or e=="monitor_touch" then
  if ui.hit(x,y,W-9,1,W,2) or ui.hit(x,y,2,H-2,W-2,H) then return end
  local yb=9; local cell=math.floor((W-4)/#links)
  for i,l in ipairs(links) do if ui.hit(x,y,2+(i-1)*cell,yb,1+i*cell,yb+2) then fetch(l[2]); draw() end end
 elseif e=="key" and _==keys.q then return end
 end
end
