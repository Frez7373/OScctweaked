local ui=dofile("ui.lua")
local path="/"
local function draw()
  local W,H=term.getSize(); ui.clear(colors.black); ui.header("File Explorer",true)
  ui.rect(2,3,W-1,4,colors.lightGray,colors.black); ui.text(3,3,path,colors.black,colors.lightGray)
  local list=fs.list(path); local bottom=H-3
  for i,name in ipairs(list) do
    local y=4+i
    if y<=bottom then
      local dir=fs.isDir(fs.combine(path,name))
      local label=(dir and "DIR  " or "FILE ")..name
      ui.button(2,y,W-7,y+1,label,dir and colors.blue or colors.gray)
      ui.button(W-6,y,W-2,y+1,"OPEN",colors.cyan)
    end
  end
  ui.button(2,H-2,12,H-1,"UP",colors.blue)
  ui.button(14,H-2,28,H-1,"HOME",colors.blue)
end
draw()
while true do
  local e,_,x,y=os.pullEvent()
  if e=="mouse_click" or e=="monitor_touch" then
    local W,H=term.getSize()
    if ui.hit(x,y,W-9,1,W,2) then return end
    if ui.hit(x,y,2,H-2,12,H-1) then
      local p=path:gsub("/$","")
      if p=="" then path="/" else
        local parent=p:match("^(.+)/[^/]+$")
        path=parent and (parent.."/") or "/"
      end
      draw()
    elseif ui.hit(x,y,14,H-2,28,H-1) then path="/"; draw()
    elseif y>=5 and y<=H-4 and x>=W-6 then
      local idx=y-4; local list=fs.list(path); local name=list[idx]
      if name and fs.isDir(fs.combine(path,name)) then path=fs.combine(path,name).."/"; draw() end
    end
  elseif e=="key" and _==keys.q then return end
end
