local ui=dofile("ui.lua")
local path="/"
local function draw()
  local W,H=term.getSize(); ui.clear(colors.black); ui.header("File Explorer",true)
  ui.rect(2,3,W-1,4,colors.lightGray,colors.black); ui.text(3,3,path,colors.black,colors.lightGray)
  local list=fs.list(path); local perPage=math.max(1,H-6); local page=1
  for i,name in ipairs(list) do
    if i<=perPage then
      local y=5+i; local dir=fs.isDir(fs.combine(path,name));
      ui.button(2,y,W-7,y+1,dir and ("DIR  "+name) or name,dir and colors.blue or colors.gray)
      ui.button(W-6,y,W-2,y+1,"OPEN",colors.accent2)
    end
  end
  ui.button(2,H-1,12,H,"UP",colors.blue); ui.button(14,H-1,26,H,"HOME",colors.blue)
end
draw()
while true do
  local e,_,x,y=os.pullEvent()
  if e=="mouse_click" or e=="monitor_touch" then
    local W,H=term.getSize()
    if ui.hit(x,y,W-9,1,W,2) then return end
    if ui.hit(x,y,2,H-1,12,H) then
      local p=path:gsub("/$",""); local parent=p:match("^(.+)/[^/]+$"); path=parent and parent.."/" or "/"; draw()
    elseif ui.hit(x,y,14,H-1,26,H) then path="/"; draw()
    elseif y>=6 and y<=H-7 and x>=W-6 then
      local idx=y-5; local list=fs.list(path); local name=list[idx]
      if name and fs.isDir(fs.combine(path,name)) then path=fs.combine(path,name).."/"; draw() end
    end
  elseif e=="key" and _==keys.q then return end
end
