-- OScctweaked main desktop
local W, H = term.getSize()
local running = true
local startOpen = false
local theme = {bg=colors.black, panel=colors.gray, accent=colors.blue, text=colors.white}

local apps = {
  {name="Files", icon="▣", file="apps/files.lua"},
  {name="Calculator", icon="#", file="apps/calculator.lua"},
  {name="Notepad", icon="N", file="apps/notepad.lua"},
  {name="Settings", icon="⚙", file="apps/settings.lua"},
  {name="About", icon="i", file="apps/about.lua"}
}

local function fill(x1,y1,x2,y2,bg,fg,ch)
  term.setBackgroundColor(bg); term.setTextColor(fg)
  for y=y1,y2 do term.setCursorPos(x1,y); write(string.rep(ch or " ", x2-x1+1)) end
end

local function draw()
  W,H=term.getSize()
  term.setBackgroundColor(theme.bg); term.clear()
  -- wallpaper
  fill(1,1,W,H,colors.black,colors.white," ")
  term.setTextColor(colors.cyan); term.setCursorPos(2,1); write("OScctweaked")
  term.setTextColor(colors.lightGray); term.setCursorPos(W-17,1); write(os.date("%H:%M"))
  local cols = math.max(1, math.floor(W/12))
  for i,a in ipairs(apps) do
    local col=(i-1)%cols; local row=math.floor((i-1)/cols)
    local x=2+col*12; local y=4+row*5
    fill(x,y,x+8,y+3,colors.gray,colors.white," ")
    term.setCursorPos(x+4,y); write(a.icon)
    term.setCursorPos(x+1,y+2); write(a.name)
  end
  fill(1,H,W,H,colors.gray,colors.white," ")
  term.setCursorPos(2,H); term.setTextColor(colors.white); write("[MENU]")
  if startOpen then
    local mw=math.min(30,W-2); local mh=math.min(12,H-2); local x=2; local y=H-mh
    fill(x,y,x+mw,y+mh-1,colors.lightGray,colors.black," ")
    term.setBackgroundColor(colors.blue); term.setTextColor(colors.white); term.setCursorPos(x+1,y+1); write("OScctweaked")
    for i,a in ipairs(apps) do
      term.setBackgroundColor(colors.lightGray); term.setTextColor(colors.black)
      term.setCursorPos(x+2,y+2+i); write(a.icon.."  "..a.name)
    end
  end
end

local function launch(a)
  if fs.exists(a.file) then shell.run(a.file) end
end

draw()
while running do
  local e,p1,p2,p3 = os.pullEvent()
  if e=="term_resize" then draw()
  elseif e=="key" and p1==keys.q then running=false
  elseif e=="mouse_click" or e=="monitor_touch" then
    local x,y=p2,p3
    if y==H then startOpen=not startOpen; draw()
    elseif startOpen then
      local sy=H-math.min(12,H-2)
      local idx=y-sy-2
      if idx>=1 and idx<=#apps then startOpen=false; draw(); launch(apps[idx]); draw() end
    else
      local cols=math.max(1,math.floor(W/12)); local col=math.floor((x-2)/12); local row=math.floor((y-4)/5)
      local idx=row*cols+col+1
      if x>=2 and y>=4 and idx>=1 and idx<=#apps then launch(apps[idx]); draw() end
    end
  end
end
