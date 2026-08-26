local ui = {}

ui.c = {
  bg=colors.black, panel=colors.gray, panel2=colors.lightGray,
  blue=colors.blue, cyan=colors.cyan, white=colors.white,
  black=colors.black, green=colors.lime, red=colors.red,
  yellow=colors.yellow, orange=colors.orange, purple=colors.purple
}

function ui.clear(bg, fg)
  term.setBackgroundColor(bg or ui.c.bg)
  term.setTextColor(fg or ui.c.white)
  term.clear()
  term.setCursorPos(1,1)
end

function ui.fill(x1,y1,x2,y2,bg,fg,ch)
  if x2<x1 or y2<y1 then return end
  term.setBackgroundColor(bg or ui.c.panel)
  term.setTextColor(fg or ui.c.white)
  local s=string.rep(ch or " ", math.max(0,x2-x1+1))
  for y=y1,y2 do term.setCursorPos(x1,y); write(s) end
end

function ui.text(x,y,s,fg,bg)
  s=tostring(s or "")
  if bg then term.setBackgroundColor(bg) end
  if fg then term.setTextColor(fg) end
  term.setCursorPos(math.max(1,x),math.max(1,y))
  write(s)
end

function ui.center(x1,x2,y,s,fg,bg)
  s=tostring(s or "")
  local x=x1+math.floor(((x2-x1+1)-#s)/2)
  ui.text(x,y,s,fg,bg)
end

function ui.button(x1,y1,x2,y2,label,bg,fg)
  bg=bg or ui.c.blue; fg=fg or ui.c.white
  ui.fill(x1,y1,x2,y2,bg,fg)
  local w=x2-x1+1; local h=y2-y1+1
  local x=x1+math.max(0,math.floor((w-#label)/2))
  local y=y1+math.floor((h-1)/2)
  ui.text(x,y,label,fg,bg)
end

function ui.outline(x1,y1,x2,y2,fg,bg)
  fg=fg or ui.c.white; bg=bg or ui.c.panel
  term.setBackgroundColor(bg); term.setTextColor(fg)
  ui.text(x1,y1,"+"..string.rep("-",math.max(0,x2-x1-1)).."+",fg,bg)
  for y=y1+1,y2-1 do ui.text(x1,y,"|",fg,bg); ui.text(x2,y,"|",fg,bg) end
  if y2>y1 then ui.text(x1,y2,"+"..string.rep("-",math.max(0,x2-x1-1)).."+",fg,bg) end
end

function ui.hit(x,y,x1,y1,x2,y2)
  return x>=x1 and x<=x2 and y>=y1 and y<=y2
end

function ui.wrap(text,width)
  local out={}
  width=math.max(1,width)
  for line in (tostring(text).."\n"):gmatch("(.-)\n") do
    if line=="" then table.insert(out,"") else
      while #line>width do table.insert(out,line:sub(1,width)); line=line:sub(width+1) end
      table.insert(out,line)
    end
  end
  return out
end

function ui.header(title,w)
  ui.fill(1,1,w,1,ui.c.panel2,ui.c.black)
  ui.text(2,1,title,ui.c.black,ui.c.panel2)
end

return ui
