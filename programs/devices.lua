local ui=dofile("core/ui.lua")
local pm=dofile("core/peripherals.lua")
local app={}

function app.new()
  local c={list=pm.scan(), selected=1, info=nil, notice=""}
  local obj={ctx=c}

  local function refresh(s)
    s.list=pm.scan()
    if #s.list==0 then s.selected=1 end
    if s.selected>#s.list then s.selected=#s.list end
  end

  function obj.draw(win,s)
    local w,h=win.getSize(); ui.clear(colors.white,colors.black); ui.header("Devices",w)
    ui.fill(2,3,w-1,4,colors.lightBlue,colors.black)
    ui.text(3,3,"Connected peripherals",colors.black,colors.lightBlue)
    ui.text(3,4,(#s.list).." device(s)",colors.gray,colors.lightBlue)
    local listW=math.max(16,math.floor(w*0.42))
    for i,p in ipairs(s.list) do
      local y=6+i-1
      if y<h-4 then
        local bg=(i==s.selected and colors.blue or colors.white)
        local fg=(i==s.selected and colors.white or colors.black)
        ui.fill(2,y,listW,y,bg,fg)
        ui.text(3,y,p.label.."  ["..p.name.."]",fg,bg)
      end
    end
    local infoX=listW+2
    ui.fill(infoX,6,w-1,h-4,colors.lightGray,colors.black)
    local p=s.list[s.selected]
    if p then
      ui.text(infoX+2,7,p.label,colors.blue,colors.lightGray)
      ui.text(infoX+2,8,"Name: "..p.name,colors.black,colors.lightGray)
      ui.text(infoX+2,9,"Type: "..pm.typeLabel(p.types),colors.black,colors.lightGray)
      local methods=peripheral.getMethods(p.name) or {}
      ui.text(infoX+2,11,"Methods:",colors.blue,colors.lightGray)
      for i,m in ipairs(methods) do
        if 12+i < h-4 then ui.text(infoX+3,11+i,m,colors.black,colors.lightGray) end
      end
    else
      ui.text(infoX+2,8,"No peripherals connected.",colors.gray,colors.lightGray)
      ui.text(infoX+2,9,"Connect a device and press refresh.",colors.gray,colors.lightGray)
    end
    ui.button(2,h-2,12,h,"REFRESH",colors.cyan)
    ui.button(14,h-2,25,h,"TEST",colors.green)
  end

  function obj.handle(ev,x,y,s)
    if ev~="click" then return false end
    local w,h=term.getSize(); local listW=math.max(16,math.floor(w*0.42))
    if ui.hit(x,y,2,h-2,12,h) then refresh(s); return true end
    if y>=6 and y<h-4 and x>=2 and x<=listW then local idx=y-5; if s.list[idx] then s.selected=idx; return true end end
    if ui.hit(x,y,14,h-2,25,h) then
      local p=s.list[s.selected]
      if not p then s.notice="No device selected"; return true end
      local ty=p.types[1]
      if ty=="speaker" then local ok,err=pm.safeCall(p.name,"playNote","harp",1,1); s.notice=ok and "Speaker test sent" or err
      elseif ty=="monitor" then local ok,err=pm.safeCall(p.name,"write","OScctweaked device test"); s.notice=ok and "Monitor test sent" or err
      elseif ty=="printer" then local ok,err=pm.safeCall(p.name,"newPage"); if ok then pm.safeCall(p.name,"write","OScctweaked test page"); pm.safeCall(p.name,"endPage"); s.notice="Printer test sent" else s.notice=err end
      elseif ty=="modem" then s.notice="Modem ready"
      elseif ty=="drive" then s.notice="Disk drive ready"
      else s.notice="Device detected"
      end
      return true
    end
    return false
  end
  return obj
end
return app
