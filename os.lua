local registry=dofile("core/apps.lua")
local W,H=term.getSize()
local startOpen=false
local search=""
local selected=nil
local lastTap=0
local notice=""
local noticeUntil=0

local function say(text,seconds)
 notice=text
 noticeUntil=os.clock()+(seconds or 3)
end

local function clearDesktop()
 term.setBackgroundColor(colors.blue)
 term.setTextColor(colors.white)
 term.clear()
end

local function button(x1,y1,x2,y2,text,bg,fg)
 bg=bg or colors.gray; fg=fg or colors.white
 term.setBackgroundColor(bg); term.setTextColor(fg)
 for y=y1,y2 do term.setCursorPos(x1,y); write(string.rep(" ",math.max(0,x2-x1+1))) end
 local tx=x1+math.max(0,math.floor(((x2-x1+1)-#text)/2))
 local ty=y1+math.floor((y2-y1)/2)
 term.setCursorPos(tx,ty); write(text)
end

local function hit(x,y,x1,y1,x2,y2)
 return x>=x1 and x<=x2 and y>=y1 and y<=y2
end

local function drawTaskbar()
 term.setBackgroundColor(colors.gray); term.setTextColor(colors.white)
 for y=H-1,H do term.setCursorPos(1,y); write(string.rep(" ",W)) end
 button(1,H-1,9,H,"START",colors.blue)
 local clock=os.date("%H:%M")
 term.setCursorPos(math.max(1,W-7),H); write(clock)
end

local function drawDesktop()
 clearDesktop()
 term.setBackgroundColor(colors.blue); term.setTextColor(colors.white)
 term.setCursorPos(2,1); write("OScctweaked")
 term.setCursorPos(2,2); write("Desktop")
 local cols=4
 local cellW=math.max(11,math.floor(W/5))
 local cellH=4
 for i,a in ipairs(registry) do
  local n=i-1
  local col=n%cols
  local row=math.floor(n/cols)
  local x=2+col*cellW
  local y=4+row*cellH
  if y+2<H-2 and x<W-8 then
   if selected==i then
    term.setBackgroundColor(colors.lightBlue); term.setTextColor(colors.black)
    term.setCursorPos(x,y); write(string.rep(" ",math.min(9,W-x)))
   else
    term.setBackgroundColor(colors.blue); term.setTextColor(colors.white)
   end
   term.setCursorPos(x+1,y); write("["..a.icon.."]")
   term.setCursorPos(x,y+1); write(a.title:sub(1,9))
  end
 end
 if W>=30 then
  term.setBackgroundColor(colors.blue); term.setTextColor(colors.lightGray)
  term.setCursorPos(2,H-4); write("Touch START for applications")
 end
 drawTaskbar()
 if os.clock()<noticeUntil and W>=24 then
  term.setBackgroundColor(colors.gray); term.setTextColor(colors.white)
  local w=math.min(30,W-4); local x=W-w-1
  for y=3,5 do term.setCursorPos(x,y); write(string.rep(" ",w)) end
  term.setCursorPos(x+1,4); write(notice:sub(1,w-2))
 end
 if startOpen then drawStart() end
end

function drawStart()
 local mw=math.min(42,W-2)
 local mh=math.min(20,H-3)
 local x=2
 local y=H-mh-2
 term.setBackgroundColor(colors.lightGray); term.setTextColor(colors.black)
 for yy=y,y+mh do term.setCursorPos(x,yy); write(string.rep(" ",mw)) end
 term.setBackgroundColor(colors.blue); term.setTextColor(colors.white)
 for yy=y,y+2 do term.setCursorPos(x,yy); write(string.rep(" ",mw)) end
 term.setCursorPos(x+2,y+1); write("OScctweaked")
 term.setBackgroundColor(colors.white); term.setTextColor(colors.gray)
 term.setCursorPos(x+1,y+4); write(string.rep(" ",mw-2))
 term.setCursorPos(x+2,y+4); write(search=="" and "Search applications" or search)
 local list={}
 for _,a in ipairs(registry) do
  if search=="" or a.title:lower():find(search:lower(),1,true) then table.insert(list,a) end
 end
 local cw=math.max(14,math.floor((mw-4)/2))
 for i,a in ipairs(list) do
  local n=i-1; local bx=x+1+(n%2)*cw; local by=y+6+math.floor(n/2)*2
  if by+1<y+mh-2 then button(bx,by,bx+cw-2,by+1,a.icon.." "..a.title,colors.gray) end
 end
 button(x+1,y+mh-1,x+12,y+mh,"CLOSE",colors.red)
end

local function appPath(meta)
 return meta.file
end

local function launch(meta)
 if not fs.exists(appPath(meta)) then
  say("Application missing: "..meta.title,5)
  drawDesktop()
  return
 end
 term.setCursorBlink(false)
 term.setBackgroundColor(colors.white)
 term.setTextColor(colors.black)
 term.clear()
 term.setCursorPos(1,1)
 local ok,err=pcall(function() shell.run(appPath(meta)) end)
 if not ok then
  term.setBackgroundColor(colors.black); term.setTextColor(colors.red); term.clear(); term.setCursorPos(2,2); print("Application error")
  term.setTextColor(colors.white); print(""); print(tostring(err)); print(""); print("Touch to return to desktop")
  while true do
   local e=os.pullEvent()
   if e=="mouse_click" or e=="monitor_touch" or e=="key" then break end
  end
 else
  say(meta.title.." closed",2)
 end
 drawDesktop()
end

drawDesktop()
while true do
 local e,p1,p2=os.pullEvent()
 if e=="term_resize" then W,H=term.getSize(); drawDesktop()
 elseif e=="timer" then drawDesktop(); os.startTimer(1)
 elseif e=="mouse_click" or e=="monitor_touch" then
  local x,y=p1,p2
  if startOpen then
   local mw=math.min(42,W-2); local mh=math.min(20,H-3); local sx=2; local sy=H-mh-2
   if hit(x,y,sx+1,sy+mh-1,sx+12,sy+mh) then startOpen=false; search=""; drawDesktop()
   elseif y>=sy+6 then
    local cw=math.max(14,math.floor((mw-4)/2)); local col=math.floor((x-(sx+1))/cw); local row=math.floor((y-(sy+6))/2); local idx=row*2+col+1
    local list={}
    for _,a in ipairs(registry) do if search=="" or a.title:lower():find(search:lower(),1,true) then table.insert(list,a) end end
    if idx>=1 and idx<=#list then startOpen=false; search=""; launch(list[idx]) else startOpen=false; drawDesktop() end
   else startOpen=false; drawDesktop() end
  elseif hit(x,y,1,H-1,9,H) then
   startOpen=true; search=""; drawDesktop()
  else
   local cols=4; local cellW=math.max(11,math.floor(W/5)); local cellH=4
   for i,a in ipairs(registry) do
    local n=i-1; local bx=2+(n%cols)*cellW; local by=4+math.floor(n/cols)*cellH
    if hit(x,y,bx,by,bx+9,by+2) then
     if selected==i and os.clock()-lastTap<0.55 then selected=nil; launch(a) else selected=i; lastTap=os.clock(); drawDesktop() end
     break
    end
   end
  end
 elseif e=="char" and startOpen then search=search..p1; drawDesktop()
 elseif e=="key" and startOpen and p1==keys.backspace then search=search:sub(1,-2); drawDesktop()
 elseif e=="key" and p1==keys.escape then startOpen=false; search=""; drawDesktop()
 elseif e=="peripheral" or e=="peripheral_detach" then say("Device connection changed",3); drawDesktop()
 end
end
